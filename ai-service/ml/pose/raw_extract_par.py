#!/usr/bin/env python3
r"""AI Hub 원시 이미지 → MediaPipe Pose Landmarker 관절 좌표 (npz + _clips.json, 선택: 축소 이미지).
tar 를 압축 해제하지 않고 스트리밍으로 읽는다. 읽기(메인 프로세스) 1개 + MediaPipe 일꾼 N개.
서비스와 같은 조건: heavy 모델, IMAGE 모드, 사람 1명, 긴 변 960px(INTER_AREA 축소).

라벨 출처 (셋 중 하나)
  --zip 맨몸운동/04 : 라벨 캐시(--project 의 cache/*.json + data/ 의 2D JSON) 기준 묶음
  --labels-dir     : 캐시에 없는 라벨 폴더 (AI Hub 검증셋 등)
  --serial-labels  : 2D 라벨 없이 3D JSON 만 있는 묶음 (파일명 serial 로 라벨 복원)

사용
  python -X utf8 -I raw_extract_par.py --tar <원시 tar> --project <라벨 캐시 폴더> --zip 맨몸운동/04 \
         --model <pose_landmarker_heavy.task> --out <heavy 폴더>/body_04.npz --workers 4 [--thumbs <폴더>] [--limit-clips 60]
"""
import argparse, json, os, re, sys, threading, time
import multiprocessing as mp
import numpy as np

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from raw_extract import open_inner, rel_key, load_targets, VIEWS  # noqa: E402

_lm = None
_cfg = None


def _init(model, thumbs, max_side):
    global _lm, _cfg
    import mediapipe as mpipe  # noqa: F401
    from mediapipe.tasks.python import vision, BaseOptions
    opts = vision.PoseLandmarkerOptions(base_options=BaseOptions(model_asset_path=model),
                                        running_mode=vision.RunningMode.IMAGE, num_poses=1)
    _lm = vision.PoseLandmarker.create_from_options(opts)
    _cfg = (thumbs, max_side)


def _work(task):
    import cv2, mediapipe as mpipe
    k, data = task
    thumbs, max_side = _cfg
    img = cv2.imdecode(np.frombuffer(data, np.uint8), cv2.IMREAD_COLOR)
    if img is None:
        return k, False, None, None, (0, 0), 0
    h, w = img.shape[:2]
    s = max_side / max(h, w)
    small = cv2.resize(img, (int(w * s), int(h * s)), interpolation=cv2.INTER_AREA) if s < 1 else img
    res = _lm.detect(mpipe.Image(image_format=mpipe.ImageFormat.SRGB,
                                 data=np.ascontiguousarray(cv2.cvtColor(small, cv2.COLOR_BGR2RGB))))
    ok = bool(res.pose_landmarks)
    im = wd = None
    if ok:
        im = np.array([[p.x, p.y, p.z, p.visibility or 0.0, p.presence or 0.0] for p in res.pose_landmarks[0]], np.float32)
        wd = np.array([[p.x, p.y, p.z] for p in res.pose_world_landmarks[0]], np.float32)
    tb = 0
    if thumbs:
        tp = os.path.join(thumbs, k.replace("/", os.sep))
        os.makedirs(os.path.dirname(tp), exist_ok=True)
        ts = 640 / max(h, w)
        th = cv2.resize(img, (int(w * ts), int(h * ts)), interpolation=cv2.INTER_AREA) if ts < 1 else img
        cv2.imwrite(tp, th, [cv2.IMWRITE_JPEG_QUALITY, 90])
        tb = os.path.getsize(tp)
    return k, ok, im, wd, (h, w), tb


def _worker(q_in, q_out, model, thumbs, max_side):
    _init(model, thumbs, max_side)
    while True:
        t = q_in.get()
        if t is None:
            break
        try:
            q_out.put(_work(t))
        except Exception as e:  # 한 장 실패가 전체를 멈추지 않게
            q_out.put((t[0], False, None, None, (0, 0), 0, repr(e)))
    q_out.put("__done__")


FOLDER_RE = re.compile(r"^Day(\d+)_[^/]*/(\d+)/([A-E])/(\d+)-\d+-\d+-\d+-(Z\d+)_[A-E]/")


def serial_lookup(project):
    """라벨 있는 클립 전체에서 파일명 serial → (운동, 조건명, 조건값). 34,468개 클립에서 serial 이 라벨을 100% 결정함을 확인함."""
    lut = {}
    for name in ["기구", "맨몸운동", "바벨,덤벨"]:
        with open(os.path.join(project, "cache", name + ".json"), encoding="utf-8") as f:
            for r in json.load(f):
                m = re.search(r"D\d+-\d+-(\d+)\.json$", r["path"])
                if m and r.get("names"):
                    lut.setdefault(int(m.group(1)), (r["exercise"], r["names"], r["vals"]))
    return lut


def load_serial_targets(project, zipsel):
    """2D 라벨 없이 3D JSON 만 있는 묶음(맨몸 11·12): 파일명 D{일}-{슬롯}-{serial}-3d.json 과 serial 표로 라벨 복원"""
    zname, zno = zipsel.split("/")
    lut, targets = serial_lookup(project), []
    base = os.path.join(project, "data", zname, zno)
    for dp, _, fs in os.walk(base):
        for fn in sorted(fs):
            m = re.match(r"D(\d+)-(\d+)-(\d+)-3d\.json$", fn)
            if not m:
                continue
            day, slot, serial = int(m.group(1)), int(m.group(2)), int(m.group(3))
            if serial not in lut:
                continue
            ex, names, vals = lut[serial]
            rel = os.path.relpath(os.path.join(dp, fn), os.path.join(project, "data"))
            targets.append(((day, slot, serial), dict(path=rel, exercise=ex, names=names, vals=vals, z=None)))
    return targets


def load_dir_targets(labels_dir):
    """검증용처럼 cache 에 없는 라벨 폴더: 2D JSON(type_info·frames)을 직접 읽어 대상 클립을 만든다"""
    targets = []
    for dp, _, fs in os.walk(labels_dir):
        for fn in sorted(fs):
            if not fn.endswith(".json") or fn.endswith("-3d.json"):
                continue
            p = os.path.join(dp, fn)
            with open(p, encoding="utf-8") as f:
                j = json.load(f)
            ti, fr = j.get("type_info") or {}, j.get("frames") or []
            if len(fr) != 16 or not ti.get("conditions"):
                continue
            m = re.search(r"-(Z\d+)_", fr[0]["view1"]["img_key"])
            targets.append((-1, dict(path=p, exercise=(ti.get("exercise") or "").strip(),
                                     names=[c["condition"].strip() for c in ti["conditions"]],
                                     vals=[int(bool(c["value"])) for c in ti["conditions"]],
                                     z=m.group(1) if m else None, frames=fr)))
    return targets


def main(a):
    folder2, labeled, meta_out = {}, {}, []
    if a.labels_dir:
        targets = load_dir_targets(a.labels_dir)
        if a.limit_clips:
            rng = np.random.default_rng(0)
            targets = [targets[i] for i in sorted(rng.choice(len(targets), min(a.limit_clips, len(targets)), replace=False))]
        for c, (uidx, r) in enumerate(targets):
            fr = r["frames"]
            for t in range(len(fr)):
                for v, vn in enumerate(VIEWS):
                    k = fr[t][vn]["img_key"]
                    labeled[k] = t
                    folder2[os.path.dirname(k)] = (c, v)
            meta_out.append(dict(cache_idx=-1, path=r["path"], exercise=r["exercise"], z=r["z"],
                                 names=r["names"], vals=r["vals"], label_source="labels_dir"))

        def resolve(k):
            cv = folder2.get(os.path.dirname(k))
            return None if cv is None else (cv[0], cv[1], labeled.get(k, -1))
        n_expected_labeled = len(labeled)
    elif a.serial_labels:
        # 3D 전용 묶음: (촬영일, 슬롯, serial) 로 클립을 찾고, 라벨 프레임은 홀수 번호(1,3,…,31) 관례로 추정
        targets = load_serial_targets(a.project, a.zip)
        if a.limit_clips:
            rng = np.random.default_rng(0)
            targets = [targets[i] for i in sorted(rng.choice(len(targets), min(a.limit_clips, len(targets)), replace=False))]
        skey = {key: c for c, (key, _) in enumerate(targets)}
        for key, r in targets:
            meta_out.append(dict(cache_idx=-1, path=r["path"], exercise=r["exercise"], z=None,
                                 names=r["names"], vals=r["vals"], label_source="serial"))

        def resolve(k):
            m = FOLDER_RE.match(k)
            if not m:
                return None
            c = skey.get((int(m.group(1)), int(m.group(2)), int(m.group(4))))
            if c is None:
                return None
            if meta_out[c]["z"] is None:
                meta_out[c]["z"] = m.group(5)
            fm = re.search(r"(\d+)\.\w+$", k)
            fno = int(fm.group(1)) if fm else -1
            return c, "ABCDE".index(m.group(3)), ((fno - 1) // 2 if fno % 2 == 1 and fno <= 31 else -1)
        n_expected_labeled = len(targets) * 5 * 16
    else:
        targets = load_targets(a.project, a.zip)
        if a.limit_clips:
            rng = np.random.default_rng(0)
            targets = [targets[i] for i in sorted(rng.choice(len(targets), min(a.limit_clips, len(targets)), replace=False))]
        for c, (uidx, r) in enumerate(targets):
            with open(os.path.join(a.project, "data", r["path"]), encoding="utf-8") as f:
                fr = json.load(f)["frames"]
            for t in range(len(fr)):
                for v, vn in enumerate(VIEWS):
                    k = fr[t][vn]["img_key"]
                    labeled[k] = t
                    folder2[os.path.dirname(k)] = (c, v)
            meta_out.append(dict(cache_idx=uidx, path=r["path"], exercise=r["exercise"], z=r["z"],
                                 names=r["names"], vals=r["vals"], label_source="json"))

        def resolve(k):
            cv = folder2.get(os.path.dirname(k))
            return None if cv is None else (cv[0], cv[1], labeled.get(k, -1))
        n_expected_labeled = len(labeled)
    model = a.model
    print(f"대상 클립 {len(targets)}개, 라벨 프레임 {n_expected_labeled}개, 모델 {os.path.basename(model)}, 일꾼 {a.workers}", flush=True)

    q_in, q_out = mp.Queue(maxsize=a.workers * 16), mp.Queue()
    procs = [mp.Process(target=_worker, args=(q_in, q_out, model, a.thumbs, a.max_side), daemon=True) for _ in range(a.workers)]
    for p in procs:
        p.start()
    results, errors, state = [], [], {"tb": 0}
    t0 = time.time()

    def collect():
        done = 0
        while done < a.workers:
            r = q_out.get()
            if r == "__done__":
                done += 1
                continue
            if len(r) == 7:
                errors.append(r[6]); r = r[:6]
            results.append(r)
            state["tb"] += r[5]
            n = len(results)
            if n % 5000 == 0:
                el = time.time() - t0
                print(f"처리 {n}장, {el/60:.1f}분, 장당 {el/n*1000:.0f}ms(전체 기준), 검출률 {np.mean([x[1] for x in results]):.3f}", flush=True)

    th = threading.Thread(target=collect, daemon=True)
    th.start()
    inner, _ = open_inner(a.tar)
    seen = sent = 0
    info = {}
    for m in inner:
        if not m.isfile():
            continue
        seen += 1
        k = rel_key(m.name)
        res = resolve(k)
        if res is None or (a.labeled_only and res[2] < 0):
            continue
        info[k] = res
        q_in.put((k, inner.extractfile(m).read()))
        sent += 1
    for _ in procs:
        q_in.put(None)
    th.join()
    for p in procs:
        p.join(timeout=30)
    el = time.time() - t0

    keys = [r[0] for r in results]
    cv = np.array([info[k][:2] for k in keys]).reshape(-1, 2)
    lt = np.array([info[k][2] for k in keys])
    fno = np.array([int(m.group(1)) if (m := re.search(r"(\d+)\.\w+$", k)) else -1 for k in keys])
    ok = np.array([r[1] for r in results])
    img = np.stack([r[2] if r[1] else np.full((33, 5), np.nan, np.float32) for r in results]) if results else np.zeros((0, 33, 5))
    world = np.stack([r[3] if r[1] else np.full((33, 3), np.nan, np.float32) for r in results]) if results else np.zeros((0, 33, 3))
    order = np.lexsort((fno, cv[:, 1], cv[:, 0])) if len(keys) else np.array([], int)
    os.makedirs(os.path.dirname(a.out), exist_ok=True)
    np.savez_compressed(a.out, key=np.array(keys)[order], clip=cv[order, 0], view=cv[order, 1], frame=fno[order],
                        labeled_t=lt[order] if len(keys) else lt, img=img[order], world=world[order],
                        ok=ok[order], hw=np.array([r[4] for r in results]).reshape(-1, 2)[order], model=os.path.basename(model))
    with open(os.path.splitext(a.out)[0] + "_clips.json", "w", encoding="utf-8") as f:
        json.dump(meta_out, f, ensure_ascii=False)
    lab = int((lt >= 0).sum())
    expected = n_expected_labeled * 2 if not a.labeled_only else n_expected_labeled
    missing_z = sum(1 for c in meta_out if not c["z"])
    print(f"완료: {len(results)}장(보낸 {sent}, 예상 약 {expected}) / {el/60:.1f}분 / 장당 {el/max(len(results),1)*1000:.0f}ms"
          f" / 검출률 {ok.mean() if len(ok) else 0:.3f} / 라벨 프레임 {lab}/{n_expected_labeled} / Z 미확인 클립 {missing_z} / tar 파일 {seen}개"
          f" / 오류 {len(errors)} / 결과 {os.path.getsize(a.out)/2**20:.1f}MB / 축소 이미지 {state['tb']/2**30:.2f}GB", flush=True)
    if errors:
        print("오류 예:", errors[:3], flush=True)


if __name__ == "__main__":
    mp.freeze_support()
    ap = argparse.ArgumentParser()
    ap.add_argument("--tar", required=True)
    ap.add_argument("--project", help="라벨 캐시 폴더 (cache/*.json, data/). --labels-dir 를 쓰면 생략")
    ap.add_argument("--zip", default="", help="cache 기준 묶음 (예: 맨몸운동/04). --labels-dir 를 쓰면 생략")
    ap.add_argument("--labels-dir", help="cache 에 없는 라벨 폴더(검증용 등)")
    ap.add_argument("--out", required=True)
    ap.add_argument("--thumbs")
    ap.add_argument("--model", required=True, help="MediaPipe pose_landmarker_heavy.task 경로")
    ap.add_argument("--max-side", type=int, default=960)
    ap.add_argument("--workers", type=int, default=4)
    ap.add_argument("--limit-clips", type=int, default=0)
    ap.add_argument("--labeled-only", action="store_true")
    ap.add_argument("--serial-labels", action="store_true", help="3D 전용 묶음: 파일명 serial 로 라벨 복원")
    main(ap.parse_args())
