"""시간 제한과 별도 프로세스로 OCR 장애를 이미지 분류에서 분리함."""
import atexit
import base64
import io
import json
import os
import queue
import subprocess
import sys
import threading
import time
from pathlib import Path

from mealfit_ai.services.label_ingredient_service import extract_label_candidates


class LabelOcrService:
    # OCR 전용 실행 환경과 로컬 모델 경로를 보관함.
    def __init__(self, config):
        self.python = config.get('OCR_PYTHON', sys.executable)
        self.det_dir = config.get('OCR_DET_MODEL_DIR', '')
        self.rec_dir = config.get('OCR_REC_MODEL_DIR', '')
        self.timeout = min(10.0, max(.1, float(config.get('OCR_TIMEOUT_SECONDS', 8))))
        self.lock = threading.Lock()
        self.process = None
        self.responses = None
        self.ready = False
        self.warming = False
        self.retry_after = 0
        self.warmup_lock = threading.Lock()
        self.cleanup_registered = False

    # stdout의 제한된 프로토콜만 읽고 OCR 원문은 로그로 남기지 않음.
    @staticmethod
    def _read_responses(process, responses):
        try:
            while True:
                line = process.stdout.readline(65537)
                if not line or len(line) > 65536:
                    responses.put(None)
                    return
                responses.put(json.loads(line))
        except (OSError, ValueError):
            responses.put(None)

    # 명시한 로컬 모델만 사용하는 재사용 워커를 실행함.
    def _start(self):
        if self.process is not None and self.process.poll() is None:
            return
        environment = os.environ.copy()
        environment['PADDLE_PDX_DISABLE_MODEL_SOURCE_CHECK'] = 'True'
        environment['DISABLE_MODEL_SOURCE_CHECK'] = 'True'
        environment['OMP_NUM_THREADS'] = '2'
        environment['MKL_NUM_THREADS'] = '2'
        environment['CUDA_VISIBLE_DEVICES'] = ''
        environment['MEALFIT_OCR_DET_DIR'] = self.det_dir
        environment['MEALFIT_OCR_REC_DIR'] = self.rec_dir
        self.process = subprocess.Popen(
            [self.python, '-u', str(Path(__file__).with_name('label_ocr_worker.py'))],
            cwd=Path(__file__).resolve().parents[2], env=environment,
            stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.DEVNULL,
            text=True, encoding='utf-8', creationflags=getattr(subprocess, 'CREATE_NO_WINDOW', 0))
        if not self.cleanup_registered:
            atexit.register(self.close)
            self.cleanup_registered = True
        self.responses = queue.Queue(maxsize=2)
        threading.Thread(target=self._read_responses, args=(self.process, self.responses), daemon=True).start()

    # 종료한 워커를 정리해 시간 초과 후 계속 연산하는 프로세스를 남기지 않음.
    def close(self):
        self.ready = False
        process, self.process = self.process, None
        if process is not None:
            if process.poll() is None:
                process.kill()
            try:
                process.wait(timeout=1)
            except subprocess.TimeoutExpired:
                pass
            for stream in (process.stdin, process.stdout):
                if stream is not None:
                    stream.close()

    # 최초 모델 로딩은 요청 밖에서 준비해 20초 읽기 제한을 소모하지 않음.
    def warmup(self):
        if not self.det_dir or not self.rec_dir or not Path(self.det_dir).is_dir() or not Path(self.rec_dir).is_dir():
            return
        with self.warmup_lock:
            if self.ready or self.warming or time.monotonic() < self.retry_after:
                return
            self.warming = True
        threading.Thread(target=self._warm, daemon=True).start()

    # 제한 시간 안에 로컬 OCR 모델 준비가 끝났을 때만 요청을 허용함.
    def _warm(self):
        with self.lock:
            try:
                self._start()
                message = self.responses.get(timeout=45)
                self.ready = isinstance(message, dict) and message.get('status') == 'READY'
                if not self.ready:
                    self.close()
            except (OSError, ValueError, queue.Empty):
                self.close()
            finally:
                self.retry_after = time.monotonic() + 30
                self.warming = False

    # 문자 신뢰도와 분류 확률을 결합하지 않고 OCR 후보만 반환함.
    def recognize(self, image):
        started = time.perf_counter()
        result = {'status': 'UNAVAILABLE', 'candidates': [], 'elapsedMs': 0}
        if not self.det_dir or not self.rec_dir or not Path(self.det_dir).is_dir() or not Path(self.rec_dir).is_dir():
            return result
        if not self.ready:
            self.warmup()
            return result
        if not self.lock.acquire(blocking=False):
            return {**result, 'status': 'TIMEOUT'}
        try:
            if self.process is None or self.process.poll() is not None:
                self.close()
                return result
            buffer = io.BytesIO()
            image.save(buffer, format='PNG')
            payload = {'image': base64.b64encode(buffer.getvalue()).decode('ascii')}
            self.process.stdin.write(json.dumps(payload) + '\n')
            self.process.stdin.flush()
            remaining = max(.001, self.timeout - (time.perf_counter() - started))
            message = self.responses.get(timeout=remaining)
            if not isinstance(message, dict):
                self.close()
                result['status'] = 'ERROR'
            elif message.get('status') == 'UNAVAILABLE':
                result['status'] = 'UNAVAILABLE'
            elif message.get('status') != 'SUCCESS' or not isinstance(message.get('lines'), list):
                result['status'] = 'ERROR'
            else:
                result['candidates'] = extract_label_candidates(message['lines'])[:20]
                result['status'] = ('SUCCESS' if result['candidates'] else 'NO_MATCH') if message['lines'] else 'NO_TEXT'
        except queue.Empty:
            self.close()
            result['status'] = 'TIMEOUT'
        except (OSError, ValueError, BrokenPipeError):
            self.close()
            result['status'] = 'ERROR'
        finally:
            result['elapsedMs'] = round((time.perf_counter() - started) * 1000)
            self.lock.release()
        return result

