r"""운동별 학습 데이터 촬영 방향 범위 만들기 (운동 자세 판별 각도 검사·촬영 가이드용).

입력: MediaPipe heavy 로 추출한 AI Hub 「피트니스 자세 이미지」 좌표 (npz + _clips.json, git 에 없음)
출력:
  1) ai-service/mealfit_ai/services/pose_camera_ranges.json : 운동 → 시점(A~E)별 촬영 방향 범위 (각도 검사용)
  2) frontend/src/lib/poseCameraGuide.js 의 POSE_CAMERA_SECTORS : 운동 → 촬영 가능한 방향 구역 (가이드 문구용)

촬영 방향(yaw): 카메라 기준 엉덩이 선(오른쪽 → 왼쪽 엉덩이) world 좌표의 수평 각도 atan2(z, x).
|yaw| 0° = 카메라가 사람 정면, 90° = 옆, 180° = 뒤. 클립·시점마다 검출 프레임의 원형 평균을 쓰고,
시점별로 5~95% 범위를 남긴다. 서비스는 같은 방식으로 영상의 방향을 계산해 범위와 비교한다(pose_camera.py).

사용 (heavy 좌표가 있는 PC 에서):
  python -X utf8 ml/pose/camera_ranges.py --heavy E:\aihub_raw\pose\heavy
"""
import argparse
import glob
import json
import os
from collections import defaultdict

import numpy as np

L_HIP, R_HIP = 23, 24
MIN_OK_RATIO = 0.75  # 학습과 같은 기준: 검출 프레임이 75% 미만인 클립은 제외
HERE = os.path.dirname(os.path.abspath(__file__))
SERVICE_JSON = os.path.join(HERE, '..', '..', 'mealfit_ai', 'services', 'pose_camera_ranges.json')
FRONT_JS = os.path.join(HERE, '..', '..', '..', 'frontend', 'src', 'lib', 'poseCameraGuide.js')
# 방향 구역: |yaw| 기준 (가이드 문구용)
SECTORS = [('FRONT', 0, 30), ('FRONT_DIAGONAL', 30, 70), ('SIDE', 70, 110), ('BACK_DIAGONAL', 110, 150), ('BACK', 150, 181)]


def circular_mean(deg):
    r = np.radians(deg)
    return float(np.degrees(np.arctan2(np.sin(r).mean(), np.cos(r).mean())))


def clip_yaws(heavy_dir):
    """운동 → 시점 → [클립별 촬영 방향]"""
    out = defaultdict(lambda: defaultdict(list))
    for npz in sorted(glob.glob(os.path.join(heavy_dir, '*.npz'))):
        clips = json.load(open(npz[:-4] + '_clips.json', encoding='utf-8'))
        z = np.load(npz)
        key = z['clip'].astype(np.int64) * 5 + z['view']
        order = np.argsort(key, kind='stable')
        key, ok = key[order], z['ok'][order]
        hip = z['world'][order][:, L_HIP] - z['world'][order][:, R_HIP]
        ang = np.degrees(np.arctan2(hip[:, 2], hip[:, 0]))
        starts = np.r_[0, np.where(np.diff(key) != 0)[0] + 1, len(key)]
        for s, e in zip(starts[:-1], starts[1:]):
            good = ok[s:e]
            if good.mean() < MIN_OK_RATIO:
                continue
            exercise = clips[int(key[s] // 5)]['exercise']
            out[exercise][int(key[s] % 5)].append(circular_mean(ang[s:e][good]))
        print(os.path.basename(npz), flush=True)
    return out


def view_ranges(yaws):
    """시점별 중심과 5~95% 범위 (중심 기준으로 펼친 각도)"""
    ranges = {}
    for view, values in sorted(yaws.items()):
        values = np.array(values)
        center = circular_mean(values)
        spread = (values - center + 180) % 360 - 180
        lo, hi = np.percentile(spread, [5, 95])
        ranges['ABCDE'[view]] = {'center': round(center, 1), 'lo': round(float(lo), 1), 'hi': round(float(hi), 1),
                                 'clips': int(len(values))}
    return ranges


def sectors(ranges):
    """시점 중심이 속한 방향 구역 (중복 제거, 정면 → 뒤 순서)"""
    found = {name for v in ranges.values() for name, a, b in SECTORS if a <= abs(v['center']) < b}
    return [name for name, _, _ in SECTORS if name in found]


def write_front(path, sector_map):
    lines = ['// [자세판별] 운동별 촬영 가이드 (FR-WORK-05). 학습 데이터에 있는 촬영 방향 구역.',
             '// ai-service/ml/pose/camera_ranges.py 가 만든 파일이다. 직접 고치지 말고 스크립트를 다시 실행한다.',
             '// 구역: FRONT 정면 · FRONT_DIAGONAL 앞쪽 대각선 · SIDE 옆 · BACK_DIAGONAL 뒤쪽 대각선 · BACK 뒤',
             'export const POSE_CAMERA_SECTORS = Object.freeze({']
    lines += [f"  {json.dumps(ex, ensure_ascii=False)}: {json.dumps(sec)}," for ex, sec in sorted(sector_map.items())]
    lines.append('})')
    with open(path, encoding='utf-8') as f:
        old = f.read()
    start = old.index('// [자세판별] 운동별 촬영 가이드')
    end = old.index('})', old.index('export const POSE_CAMERA_SECTORS')) + 2
    with open(path, 'w', encoding='utf-8', newline='\n') as f:
        f.write(old[:start] + '\n'.join(lines) + old[end:])


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--heavy', required=True, help='heavy 좌표 폴더 (npz + _clips.json)')
    ap.add_argument('--service-json', default=SERVICE_JSON)
    ap.add_argument('--front-js', default=FRONT_JS, help='있으면 POSE_CAMERA_SECTORS 부분만 바꾼다')
    a = ap.parse_args()
    data = {ex: view_ranges(v) for ex, v in sorted(clip_yaws(a.heavy).items())}
    with open(a.service_json, 'w', encoding='utf-8', newline='\n') as f:
        json.dump({'source': 'AI Hub 피트니스 자세 이미지, MediaPipe heavy world 좌표, 클립·시점별 5~95%',
                   'exercises': data}, f, ensure_ascii=False, indent=1)
        f.write('\n')
    if os.path.exists(a.front_js):
        write_front(a.front_js, {ex: sectors(r) for ex, r in data.items()})
    for ex, r in data.items():
        print(ex, sectors(r), ' | '.join(f"{v} {d['center'] + d['lo']:.0f}~{d['center'] + d['hi']:.0f}" for v, d in r.items()))


if __name__ == '__main__':
    main()
