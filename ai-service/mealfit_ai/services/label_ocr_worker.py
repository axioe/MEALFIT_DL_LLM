"""로컬 OCR 모델을 한 번 불러와 메모리 이미지의 텍스트만 부모 프로세스로 반환함."""
import base64
import contextlib
import io
import json
import os
import sys
from pathlib import Path


# 다운로드 없이 지정된 검출·한국어 인식 모델만 불러옴.
def load_engine():
    directories = [os.environ.get('MEALFIT_OCR_DET_DIR', ''), os.environ.get('MEALFIT_OCR_REC_DIR', '')]
    if any(not directory or not all((Path(directory) / filename).is_file()
           for filename in ('inference.json', 'inference.pdiparams', 'inference.yml')) for directory in directories):
        raise FileNotFoundError('로컬 OCR 모델 파일이 없음')
    from paddleocr import PaddleOCR

    return PaddleOCR(
        text_detection_model_name='PP-OCRv3_mobile_det',
        text_detection_model_dir=os.environ['MEALFIT_OCR_DET_DIR'],
        text_recognition_model_name='korean_PP-OCRv3_mobile_rec',
        text_recognition_model_dir=os.environ['MEALFIT_OCR_REC_DIR'],
        use_doc_orientation_classify=False, use_doc_unwarping=False,
        use_textline_orientation=False, device='cpu', cpu_threads=2,
        enable_mkldnn=False, text_det_limit_side_len=960, text_det_limit_type='max')


# OCR 결과에서 제한된 텍스트와 문자 신뢰도만 추출함.
def read_lines(engine, encoded):
    import numpy as np
    from PIL import Image

    with Image.open(io.BytesIO(base64.b64decode(encoded, validate=True))) as image:
        pixels = np.asarray(image.convert('RGB'))[:, :, ::-1].copy()
    lines = []
    text_length = 0
    for result in engine.predict(input=pixels):
        texts, scores = result.get('rec_texts', []), result.get('rec_scores', [])
        for text, score in zip(texts, scores):
            if not isinstance(text, str) or not text.strip():
                continue
            text = text[:256]
            if len(lines) >= 128 or text_length + len(text) > 8192:
                return lines
            text_length += len(text)
            lines.append({'text': text, 'confidence': float(score)})
    return lines


# 라이브러리 출력과 오류 원문을 프로토콜 및 서비스 로그에서 분리함.
def main():
    output = sys.stdout
    try:
        with contextlib.redirect_stdout(sys.stderr):
            engine = load_engine()
        output.write(json.dumps({'status': 'READY'}) + '\n')
        output.flush()
    except Exception:
        output.write(json.dumps({'status': 'UNAVAILABLE'}) + '\n')
        output.flush()
        return
    for raw in sys.stdin:
        response = {'status': 'ERROR'}
        try:
            payload = json.loads(raw)
            with contextlib.redirect_stdout(sys.stderr):
                lines = read_lines(engine, payload['image'])
            response = {'status': 'SUCCESS', 'lines': lines}
        except (ImportError, ModuleNotFoundError, FileNotFoundError):
            response = {'status': 'UNAVAILABLE'}
        except Exception:
            response = {'status': 'ERROR'}
        output.write(json.dumps(response, ensure_ascii=True) + '\n')
        output.flush()


if __name__ == '__main__':
    main()

