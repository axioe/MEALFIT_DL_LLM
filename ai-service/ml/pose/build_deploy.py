r"""운영 배포용 자세 판별 모델 폴더 만들기.
모델 폴더에서 서비스가 실제로 읽는 파일만 복사하고, manifest 운동 항목마다 sha256 {파일 이름: 값} 을 넣는다.
- cnn: model.onnx / hgb: onnx 파일들 / logreg: logreg_c*.json  (학습용 .keras·가중치 npz·joblib·검증용 파일은 넣지 않는다)
- 운동마다 manifest 의 accuracy(조건별 {cv, external}) 가 있어야 한다 (서비스가 화면에 보여 준다).
결과: <out>/<버전>/ , <out>/<버전>.tar.gz , <out>/<버전>_files.tsv (파일·크기·SHA-256), 압축 파일 SHA-256 출력.
ai-service 는 POSE_MODEL_DIR=<out>/<버전>, POSE_MODEL_VERSION=<버전> 으로 읽는다.

사용: build_deploy.py --src <모델 폴더> --version pose-20261123-41 --out <배포 폴더>
"""
import argparse
import hashlib
import json
import os
import shutil
import tarfile


def sha(p):
    h = hashlib.sha256()
    with open(p, 'rb') as f:
        for c in iter(lambda: f.read(1 << 20), b''):
            h.update(c)
    return h.hexdigest()


def main(a):
    out = os.path.join(a.out, a.version)
    man = json.load(open(os.path.join(a.src, 'manifest.json'), encoding='utf-8'))
    if os.path.exists(out):
        shutil.rmtree(out)
    os.makedirs(out)
    rows = []
    for ex, m in man.items():
        if ex.startswith('_'):
            continue
        files = [m['onnx']] if m['model'] == 'cnn' else (list(m['onnx']) if m['model'] == 'hgb'
                                                         else [f.replace('.joblib', '.json') for f in m['files']])
        os.makedirs(os.path.join(out, m['dir']), exist_ok=True)
        m['sha256'] = {}
        for f in files:
            src = os.path.join(a.src, m['dir'], f); dst = os.path.join(out, m['dir'], f)
            shutil.copy2(src, dst)
            m['sha256'][f] = sha(dst)
            rows.append((f"{m['dir']}/{f}", ex, m['model'], os.path.getsize(dst), m['sha256'][f]))
        assert 'accuracy' in m and len(m['accuracy']) == len(m['conditions']), ex
    json.dump(man, open(os.path.join(out, 'manifest.json'), 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
    rows.insert(0, ('manifest.json', '-', '-', os.path.getsize(os.path.join(out, 'manifest.json')),
                    sha(os.path.join(out, 'manifest.json'))))
    with open(out + '_files.tsv', 'w', encoding='utf-8') as f:
        f.write('경로\t운동\t모델\t크기(바이트)\tSHA-256\n')
        for r in rows:
            f.write('\t'.join(map(str, r)) + '\n')
    tgz = out + '.tar.gz'
    with tarfile.open(tgz, 'w:gz', format=tarfile.PAX_FORMAT) as t:
        def clean(ti):
            ti.uid = ti.gid = 0; ti.uname = ti.gname = ''; ti.mode = 0o755 if ti.isdir() else 0o644
            return ti
        t.add(out, arcname=a.version, filter=clean)
    n_ex = len([k for k in man if not k.startswith('_')])
    print(f'운동 {n_ex}종, 파일 {len(rows)}개(manifest 포함), 합계 {sum(r[3] for r in rows) / 2 ** 20:.1f} MB')
    print(f'압축 {os.path.basename(tgz)} {os.path.getsize(tgz) / 2 ** 20:.1f} MB  SHA-256 {sha(tgz)}')


if __name__ == '__main__':
    ap = argparse.ArgumentParser()
    ap.add_argument('--src', required=True, help='모델 폴더 (manifest.json + export_onnx.py 결과)')
    ap.add_argument('--version', required=True, help='배포 버전 이름 (예: pose-20261123-41)')
    ap.add_argument('--out', required=True, help='배포 결과를 둘 폴더')
    main(ap.parse_args())
