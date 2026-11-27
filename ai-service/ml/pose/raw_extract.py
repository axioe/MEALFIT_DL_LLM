#!/usr/bin/env python3
r"""AI Hub 「피트니스 자세 이미지」 원시 이미지 tar 읽기 공용 함수 (좌표 추출은 raw_extract_par.py).

  inspect : 내부 tar 의 앞부분 경로를 보여 주고 촬영일(Day)을 집계한다 (압축 해제 없음)

사용
  python -X utf8 -I raw_extract.py --tar <AI Hub 원시 tar>
raw_extract_par.py 가 만드는 npz: key(str, 프레임 상대경로), clip(int, cache 사용 가능 목록 기준 인덱스), view(int 0~4), frame(int, 파일 번호),
           labeled_t(int, 라벨 16프레임 중 몇 번째인지, 아니면 -1), img(N,33,5: x,y,z,visibility,presence),
           world(N,33,3), ok(bool), hw(N,2: 원본 높이·너비)
"""
import argparse, json, os, re, tarfile, time
from collections import Counter

VIEWS = ["view1", "view2", "view3", "view4", "view5"]


class Chain:
    """여러 조각(part)을 이어 붙인 읽기 전용 스트림"""
    def __init__(self, fs):
        self.fs, self.i = fs, 0

    def read(self, n=-1):
        out = b""
        while self.i < len(self.fs) and (n < 0 or len(out) < n):
            b = self.fs[self.i].read(-1 if n < 0 else n - len(out))
            if not b:
                self.i += 1
            else:
                out += b
        return out


def open_inner(path):
    outer = tarfile.open(path)
    members = outer.getmembers()
    parts = [m for m in members if ".part" in m.name]
    if parts:
        parts.sort(key=lambda m: int(m.name.rsplit("part", 1)[1]))
        return tarfile.open(fileobj=Chain([outer.extractfile(m) for m in parts]), mode="r|"), [m.name for m in parts]
    outer.close()
    return tarfile.open(path, mode="r|"), []


def rel_key(name):
    return name[name.find("Day"):] if "Day" in name else name


def inspect(a):
    inner, parts = open_inner(a.tar)
    print(f"조각(part) {len(parts)}개" + (f": {parts[0]} ... {parts[-1]}" if parts else " (일반 tar)"))
    days, n, shown = Counter(), 0, 0
    t0 = time.time()
    for m in inner:
        if not m.isfile():
            continue
        k = rel_key(m.name)
        if shown < 5:
            print("  예:", k); shown += 1
        days[k.split("/")[0][:5]] += 1
        n += 1
        if n >= a.max_files or time.time() - t0 > a.max_seconds:
            break
    print(f"확인한 파일 {n}개, 촬영일 집계: {dict(days)}")


def load_targets(project, zipsel):
    """cache 사용 가능 목록(기구→맨몸운동→바벨,덤벨, ok2d&ok3d&!outlier&z) 기준 인덱스와 img_key 를 모은다"""
    order = ["기구", "맨몸운동", "바벨,덤벨"]
    usable_idx, targets = 0, []
    zname, zno = zipsel.split("/")
    for name in order:
        with open(os.path.join(project, "cache", name + ".json"), encoding="utf-8") as f:
            metas = json.load(f)
        for r in metas:
            use3d = r["ok2d"] and r["ok3d"] and not r["outlier3d"] and bool(r.get("z"))
            parts = re.split(r"[\\/]", r["path"])
            if parts[0] == zname and parts[1] == zno and r["ok2d"] and r.get("z"):
                targets.append((usable_idx if use3d else -1, r))
            if use3d:
                usable_idx += 1
    return targets


if __name__ == "__main__":
    ap = argparse.ArgumentParser()
    ap.add_argument("--tar", required=True)
    ap.add_argument("--max-files", type=int, default=3000)
    ap.add_argument("--max-seconds", type=int, default=120)
    inspect(ap.parse_args())
