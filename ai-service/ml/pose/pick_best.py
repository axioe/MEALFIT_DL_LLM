"""학습 결과 CSV(train_pose.py) → 운동별 최고 모델(교차검증 평균 기준) JSON. 외부 평가셋 수행자가 학습과 겹치는지도 함께 기록한다.
GRU 가 최고면 같은 시퀀스 입력의 CNN 으로 바꾼다 (배포 경로는 CNN 만 지원).
사용: pick_best.py --results <결과 폴더> --heavy <heavy 폴더> --runs wheel_s0,wheel_seq_s0 --train wheel_01,... --test valid_wheel --out best.json"""
import argparse, json, os
import pandas as pd

ap = argparse.ArgumentParser()
ap.add_argument('--results', required=True, help='train_pose.py 결과(*_metrics.csv) 폴더')
ap.add_argument('--heavy', required=True, help='heavy 좌표 폴더 (npz + _clips.json)')
ap.add_argument('--runs', required=True); ap.add_argument('--train', required=True); ap.add_argument('--test', default='')
ap.add_argument('--out', required=True)
a = ap.parse_args()
R, H = a.results, a.heavy
d = pd.concat([pd.read_csv(os.path.join(R, r + '_metrics.csv')) for r in a.runs.split(',') if os.path.exists(os.path.join(R, r + '_metrics.csv'))])
cv = d[d.split == 'cv'].groupby(['exercise', 'model']).bal_acc.mean().unstack()
ext = d[d.split == 'external'].groupby(['exercise', 'model']).bal_acc.mean().unstack()
perf = lambda files: {ex: set(v) for ex, v in pd.DataFrame([dict(ex=c['exercise'], z=c['z']) for f in files for c in json.load(open(os.path.join(H, f + '_clips.json'), encoding='utf-8'))]).groupby('ex').z}
tr = perf(a.train.split(',')); te = perf(a.test.split(',')) if a.test else {}
best, report = {}, {}
for ex in cv.index:
    row = cv.loc[ex].dropna(); m = row.idxmax()
    best[ex] = 'cnn' if m == 'gru' else m
    overlap = len(tr.get(ex, set()) & te.get(ex, set()))
    report[ex] = dict(best=m, cv={k: round(v, 4) for k, v in row.items()},
                      external={k: round(v, 4) for k, v in ext.loc[ex].dropna().items()} if ex in ext.index else {},
                      test_performers=len(te.get(ex, set())), overlap_with_train=overlap)
    print(ex, '| 최고', m, '| CV', report[ex]['cv'], '| 외부', report[ex]['external'], '| 외부 수행자', report[ex]['test_performers'], '(학습과 겹침', overlap, ')')
json.dump(best, open(a.out, 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
json.dump(report, open(a.out.replace('.json', '_report.json'), 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
