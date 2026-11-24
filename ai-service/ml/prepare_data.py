"""원본을 보존하고 데이터 검사·EDA·승인된 파생 데이터 생성을 수행함."""

import argparse
import ast
import csv
import hashlib
import io
import json
import math
import re
import statistics
import shutil
from collections import Counter, defaultdict
from contextlib import contextmanager
from pathlib import Path
from zipfile import ZipFile

SPLITS = ('train', 'valid', 'test')
IMAGE_SUFFIXES = {'.jpg', '.jpeg', '.png', '.bmp', '.webp'}


# 압축 해제 없이 ZIP 또는 데이터셋 폴더 읽기 함수를 제공함.
@contextmanager
def open_dataset(path):
    path = Path(path).resolve()
    if path.is_file() and path.suffix.lower() == '.zip':
        with ZipFile(path) as archive:
            names = [name for name in archive.namelist() if not name.endswith('/')]
            yield names, archive.read
    elif path.is_dir():
        names = [file.relative_to(path).as_posix() for file in path.rglob('*') if file.is_file()]

        # 원본 폴더 내부 파일만 안전하게 읽어 반환함.
        def read(name):
            target = (path / name).resolve()
            if not target.is_relative_to(path):
                raise ValueError('데이터셋 외부 경로임')
            return target.read_bytes()

        yield names, read
    else:
        raise ValueError('데이터셋 폴더 또는 ZIP 경로가 필요함')


# data.yaml의 클래스 이름과 선언 개수 일치 여부 검사함.
def parse_classes(text):
    fields = {}
    for line in text.splitlines():
        if line.startswith(('nc:', 'names:')):
            key, value = line.split(':', 1)
            fields[key] = ast.literal_eval(value.strip())
    names = fields.get('names')
    if not isinstance(names, list) or not names or not all(isinstance(name, str) for name in names):
        raise ValueError('한 줄 names 목록이 있는 data.yaml이 필요함')
    if fields.get('nc') != len(names) or len(set(names)) != len(names):
        raise ValueError('클래스 개수 또는 이름이 유효하지 않음')
    return names


# 라벨 한 행의 형식·좌표를 검사하고 객체 정보를 반환함.
def parse_annotation(row, class_count):
    tokens = row.split()
    if not tokens:
        return None
    try:
        class_id = int(tokens[0])
        coords = [float(value) for value in tokens[1:]]
    except ValueError:
        raise ValueError('클래스 ID 또는 좌표 형식 오류임') from None
    if not 0 <= class_id < class_count:
        raise ValueError('클래스 ID 범위 오류임')
    if not all(math.isfinite(value) and 0 <= value <= 1 for value in coords):
        raise ValueError('좌표 범위 오류임')
    if len(coords) == 4:
        x, y, width, height = coords
        if width <= 0 or height <= 0:
            raise ValueError('너비 또는 높이가 0임')
        bounds = (x - width / 2, y - height / 2, x + width / 2, y + height / 2)
        shape = 'detection'
        area = width * height
    elif len(coords) >= 6 and len(coords) % 2 == 0:
        xs, ys = coords[::2], coords[1::2]
        # 좌표가 정상 범위여도 면적 없는 다각형은 제외함.
        area = abs(sum(xs[i] * ys[(i + 1) % len(ys)] - xs[(i + 1) % len(xs)] * ys[i] for i in range(len(xs)))) / 2
        if area <= 0:
            raise ValueError('다각형 면적이 0임')
        bounds = (min(xs), min(ys), max(xs), max(ys))
        shape = 'segmentation'
    else:
        raise ValueError('라벨 열 개수 오류임')
    return {'class_id': class_id, 'format': shape, 'bounds': bounds, 'area': area, 'coordinates': coords}


# 동일 해시 이미지와 데이터 분할 간 중복을 집계함.
def duplicate_summary(groups):
    repeated = [names for names in groups.values() if len(names) > 1]
    cross = [names for names in repeated if len({name.split('/')[0] for name in names}) > 1]
    return {'groups': len(repeated), 'images': sum(map(len, repeated)), 'cross_split_groups': len(cross), 'cross_split_images': sum(map(len, cross)), 'cross_split_files': cross}


# 객체 크기 분포를 확인할 분위수와 범위를 반환함.
def quantiles(values):
    if not values:
        return None
    values = sorted(values)

    # 표본 수에 관계없이 인접 값을 보간해 백분위수를 반환함.
    def percentile(fraction):
        index = (len(values) - 1) * fraction
        lower = math.floor(index)
        return values[lower] + (values[math.ceil(index)] - values[lower]) * (index - lower)

    return {'min': values[0], 'p25': percentile(.25), 'median': percentile(.5), 'p75': percentile(.75), 'p95': percentile(.95), 'max': values[-1]}


# 원본 변경 없이 전체 파일·라벨·중복·클래스 분포 검사함.
def inspect_dataset(path, verify_images=False):
    # 이미지 완전 디코딩은 설치된 Pillow가 있을 때만 수행함.
    if verify_images:
        try:
            from PIL import Image, ImageOps
        except ImportError:
            raise RuntimeError('이미지 완전 검사는 Pillow가 필요함. 설치 전 사용자 확인 필요함') from None
    path = Path(path).resolve()
    result = {'dataset': str(path), 'image_decode_verified': verify_images, 'preprocessing_performed': False}
    if path.is_file():
        with path.open('rb') as source:
            result['sha256'] = hashlib.file_digest(source, 'sha256').hexdigest()
    issues = defaultdict(list)
    byte_hashes, pixel_hashes, flip_hashes = defaultdict(list), defaultdict(list), defaultdict(list)
    dhashes = []
    sizes, formats, areas, box_areas, object_hist, class_hist = Counter(), Counter(), [], [], Counter(), Counter()
    with open_dataset(path) as (files, read):
        names = set(files)
        result['duplicate_archive_entries'] = [name for name, count in Counter(files).items() if count > 1]
        yaml = read('data.yaml').decode('utf-8-sig')
        classes = parse_classes(yaml)
        result['data_yaml'] = yaml
        result['classes'] = [{'id': i, 'name': name, 'images': {}, 'objects': {}} for i, name in enumerate(classes)]
        result['splits'] = {}
        decoded, processed = 0, {'data.yaml'}
        for split in SPLITS:
            images = sorted(name for name in files if name.startswith(split + '/images/') and Path(name).suffix.lower() in IMAGE_SUFFIXES)
            labels = sorted(name for name in files if name.startswith(split + '/labels/') and name.endswith('.txt'))
            image_stems = Counter(Path(name).stem for name in images)
            label_stems = Counter(Path(name).stem for name in labels)
            issues['missing_labels'].extend(f'{split}/{stem}' for stem in image_stems.keys() - label_stems.keys())
            issues['orphan_labels'].extend(f'{split}/{stem}' for stem in label_stems.keys() - image_stems.keys())
            issues['duplicate_image_stems'].extend(f'{split}/{stem}' for stem, count in image_stems.items() if count > 1)
            objects, image_counts, split_formats = Counter(), Counter(), Counter()
            empty, single_object, single_class, multi_class, mixed = 0, 0, 0, 0, 0
            for index, name in enumerate(images, 1):
                processed.add(name)
                try:
                    raw = read(name)
                    byte_hashes[hashlib.sha256(raw).hexdigest()].append(name)
                    if verify_images:
                        with Image.open(io.BytesIO(raw)) as image:
                            image.verify()
                        with Image.open(io.BytesIO(raw)) as image:
                            image.load()
                            sizes[str(image.size)] += 1
                            rgb = image.convert('RGB')
                            prefix = str(rgb.size).encode()
                            fingerprint = hashlib.sha256(prefix + rgb.tobytes()).hexdigest()
                            pixel_hashes[fingerprint].append(name)
                            # 반전 증강본을 독립 원본으로 오인하지 않도록 같은 해시로 묶음.
                            variants = [rgb, ImageOps.mirror(rgb), ImageOps.flip(rgb), rgb.transpose(Image.Transpose.ROTATE_180)]
                            flip_hashes[min(hashlib.sha256(prefix + variant.tobytes()).hexdigest() for variant in variants)].append(name)
                            gray = rgb.convert('L').resize((9, 8)).tobytes()
                            dhash = 0
                            for y in range(8):
                                for x in range(8):
                                    dhash = (dhash << 1) | (gray[y * 9 + x + 1] > gray[y * 9 + x])
                            dhashes.append((dhash, name))
                            decoded += 1
                except Exception as error:
                    issues['unreadable_images'].append({'file': name, 'error': type(error).__name__})
                label = f'{split}/labels/{Path(name).stem}.txt'
                if label not in names:
                    continue
                processed.add(label)
                seen, rows_seen, image_formats = set(), set(), set()
                count = 0
                try:
                    rows = read(label).decode('utf-8-sig').splitlines()
                except Exception as error:
                    issues['unreadable_labels'].append({'file': label, 'error': type(error).__name__})
                    continue
                for line_no, row in enumerate(rows, 1):
                    try:
                        annotation = parse_annotation(row, len(classes))
                        if annotation is None:
                            continue
                        if row.strip() in rows_seen:
                            issues['duplicate_annotation_rows'].append({'file': label, 'line': line_no})
                        rows_seen.add(row.strip())
                        bounds = annotation['bounds']
                        if min(bounds) < -1e-6 or max(bounds) > 1 + 1e-6:
                            issues['box_exceeds_image'].append({'file': label, 'line': line_no})
                        class_id, shape = annotation['class_id'], annotation['format']
                        objects[class_id] += 1
                        formats[shape] += 1
                        split_formats[shape] += 1
                        image_formats.add(shape)
                        areas.append(annotation['area'])
                        box_areas.append((bounds[2] - bounds[0]) * (bounds[3] - bounds[1]))
                        seen.add(class_id)
                        count += 1
                    except ValueError as error:
                        issues['invalid_rows'].append({'file': label, 'line': line_no, 'reason': str(error)})
                # 같은 클래스 객체가 여러 개여도 이미지 수는 한 번만 집계함.
                image_counts.update(seen)
                object_hist[count] += 1
                class_hist[len(seen)] += 1
                empty += count == 0
                single_object += count == 1
                single_class += len(seen) == 1
                multi_class += len(seen) > 1
                mixed += len(image_formats) > 1
                if index % 2000 == 0:
                    print(f'{split}: {index}/{len(images)}', flush=True)
            result['splits'][split] = {'images': len(images), 'labels': len(labels), 'objects': sum(objects.values()), 'empty_labels': empty, 'single_object_images': single_object, 'single_class_images': single_class, 'multi_class_images': multi_class, 'mixed_format_images': mixed, 'formats': dict(split_formats)}
            for record in result['classes']:
                record['images'][split] = image_counts[record['id']]
                record['objects'][split] = objects[record['id']]
        # 이미지·라벨 외 파일도 읽어 압축 CRC 오류를 놓치지 않도록 함.
        for name in files:
            if name not in processed:
                try:
                    read(name)
                except Exception as error:
                    issues['unreadable_other_files'].append({'file': name, 'error': type(error).__name__})
        result['checked_files'] = len(files)
        result['decoded_images'] = decoded
    result['issues'] = dict(issues)
    result['formats'] = dict(formats)
    result['image_sizes'] = dict(sizes)
    result['objects_per_image'] = dict(sorted(object_hist.items()))
    result['classes_per_image'] = dict(sorted(class_hist.items()))
    result['annotation_area_ratio'] = quantiles(areas)
    result['bounding_box_area_ratio'] = quantiles(box_areas)
    result['bounding_boxes_below_1_percent'] = sum(area < .01 for area in box_areas)
    result['duplicates'] = {'bytes': duplicate_summary(byte_hashes)}
    if verify_images:
        result['duplicates']['pixels'] = duplicate_summary(pixel_hashes)
        result['duplicates']['flip_invariant_pixels'] = duplicate_summary(flip_hashes)
        buckets, near = defaultdict(set), []
        # 유사 해시는 중복 확정이 아닌 시각 검토 후보임.
        for index, (value, name) in enumerate(dhashes):
            candidates = set()
            # 해시 구간이 같은 후보만 비교해 불필요한 전수 비교를 줄임.
            keys = [(shift, (value >> shift) & ((1 << min(12, 64 - shift)) - 1)) for shift in range(0, 64, 12)]
            for key in keys:
                candidates.update(buckets[key])
            for previous in sorted(candidates):
                other, other_name = dhashes[previous]
                distance = (value ^ other).bit_count()
                if name.split('/')[0] != other_name.split('/')[0] and distance <= 4:
                    near.append({'files': [other_name, name], 'hamming_distance': distance})
            for key in keys:
                buckets[key].add(index)
        result['near_duplicate_candidates'] = {'method': 'dHash64, Hamming <= 4', 'pairs': len(near), 'files': near}
    for record in result['classes']:
        record['total_images'] = sum(record['images'].values())
        record['total_objects'] = sum(record['objects'].values())
    train_counts = [record['images']['train'] for record in result['classes']]
    result['train_image_imbalance'] = {'min': min(train_counts), 'max': max(train_counts), 'median': statistics.median(train_counts), 'max_min_ratio': max(train_counts) / min(train_counts) if min(train_counts) else None}
    result['classes_missing_in_split'] = {split: [record['name'] for record in result['classes'] if record['images'][split] == 0] for split in SPLITS}
    return result


# 원본과 저장소 외부에 JSON·클래스별 CSV 결과를 저장함.
def write_report(result, output_dir):
    output = Path(output_dir).resolve()
    repository = Path(__file__).resolve().parents[2]
    dataset = Path(result['dataset']).resolve()
    if output.is_relative_to(repository) or output == dataset or (dataset.is_dir() and output.is_relative_to(dataset)):
        raise ValueError('검사 결과는 저장소 및 원본 데이터셋 외부에 저장해야 함')
    output.mkdir(parents=True, exist_ok=True)
    (output / 'audit.json').write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding='utf-8')
    columns = ['id', 'name', 'train_images', 'valid_images', 'test_images', 'total_images', 'train_objects', 'valid_objects', 'test_objects', 'total_objects']
    with (output / 'class_counts.csv').open('w', newline='', encoding='utf-8-sig') as target:
        writer = csv.DictWriter(target, fieldnames=columns)
        writer.writeheader()
        for record in result['classes']:
            row = {key: record[key] for key in ['id', 'name', 'total_images', 'total_objects']}
            row.update({f'{split}_images': record['images'][split] for split in SPLITS})
            row.update({f'{split}_objects': record['objects'][split] for split in SPLITS})
            writer.writerow(row)


# 파생 데이터가 저장소나 원본 경로를 덮어쓰지 않는지 검사함.
def validate_output_path(dataset, output_dir):
    dataset, output = Path(dataset).resolve(), Path(output_dir).resolve()
    repository = Path(__file__).resolve().parents[2]
    if (output.is_relative_to(repository) or output == dataset
            or (dataset.is_dir() and output.is_relative_to(dataset))):
        raise ValueError('파생 데이터는 저장소와 원본 경로 외부에 생성해야 함')
    if output.exists():
        raise ValueError('기존 결과를 덮어쓰지 않도록 새 출력 폴더가 필요함')
    if output.drive.upper() != dataset.drive.upper():
        raise ValueError('원본과 같은 드라이브의 별도 출력 폴더가 필요함')
    return output


# 승인된 전체 클래스 매핑을 검증하고 연속된 대상 ID를 반환함.
def resolve_mapping(classes, policy):
    mapping = policy['class_mapping']
    if len(mapping) != len(classes):
        raise ValueError('모든 원본 클래스의 명시적 매핑이 필요함')
    targets, ids = [], {}
    for index, record in enumerate(mapping):
        if record['source_id'] != index or record['source_name'] != classes[index]:
            raise ValueError('원본 클래스 순서·이름이 매핑과 다름')
        target = record['target_name']
        if not re.fullmatch('[a-z][a-z0-9_]*', target) or not record.get('reason'):
            raise ValueError('대상 클래스 이름 또는 통합 근거가 유효하지 않음')
        if target not in targets:
            targets.append(target)
        ids[index] = targets.index(target)
    return targets, ids


# 폴리곤 외접 범위를 정규화된 YOLO 탐지 좌표로 변환함.
def detection_values(annotation, target_id):
    left, top, right, bottom = annotation['bounds']
    if min(left, top) < -1e-9 or max(right, bottom) > 1 + 1e-9:
        raise ValueError('외접 박스가 이미지 범위를 벗어남')
    # 부동소수점 계산에서 생긴 경계 오차만 보정함.
    left, top = max(0., left), max(0., top)
    right, bottom = min(1., right), min(1., bottom)
    if right <= left or bottom <= top:
        raise ValueError('유효한 크기의 박스가 아님')
    return target_id, (left + right) / 2, (top + bottom) / 2, right - left, bottom - top


# 동일 원본·반전 증강본 그룹의 대표 경로를 찾음.
def find_parent(parents, name):
    while parents[name] != name:
        parents[name] = parents[parents[name]]
        name = parents[name]
    return name


# 확인된 동일 원본 이미지들을 하나의 그룹으로 연결함.
def join_parents(parents, left, right):
    left, right = find_parent(parents, left), find_parent(parents, right)
    parents[max(left, right)] = min(left, right)


# 원본 분할을 유지하면서 평가 분할과 겹치는 하위 우선순위 이미지를 제외함.
def leakage_exclusions(parents):
    priority = {'train': 0, 'valid': 1, 'test': 2}
    groups = defaultdict(list)
    for name in parents:
        groups[find_parent(parents, name)].append(name)
    excluded = {}
    for members in groups.values():
        keep_priority = max(priority[name.split('/')[0]] for name in members)
        if len({name.split('/')[0] for name in members}) < 2:
            continue
        for name in members:
            if priority[name.split('/')[0]] < keep_priority:
                excluded[name] = '평가 분할과 동일 원본인 이미지·반전 증강본 격리함'
    return excluded


# 파일 추적 정보와 클래스별 집계 레코드를 CSV로 저장함.
def write_csv(path, rows, columns):
    with Path(path).open('w', newline='', encoding='utf-8-sig') as target:
        writer = csv.DictWriter(target, fieldnames=columns)
        writer.writeheader()
        writer.writerows(rows)


# 모델별 클래스 인덱스 차이를 명시해 같은 식재료로 비교하도록 함.
def write_class_indices(output_dir, classes):
    indices = {'yolo': {name: index for index, name in enumerate(classes)},
               'efficientnet_imagefolder': {name: index for index, name in enumerate(sorted(classes))}}
    (Path(output_dir) / 'class_indices.json').write_text(
        json.dumps(indices, ensure_ascii=False, indent=2), encoding='utf-8')


# 원본 해시와 검토 정책을 확인하고 두 모델용 파생 데이터를 생성함.
def prepare_dataset(dataset, output_dir, policy_path):
    from PIL import Image, ImageDraw, ImageOps

    dataset = Path(dataset).resolve()
    output = validate_output_path(dataset, output_dir)
    policy = json.loads(Path(policy_path).read_text(encoding='utf-8'))
    with dataset.open('rb') as source:
        source_hash = hashlib.file_digest(source, 'sha256').hexdigest()
    if source_hash != policy['source_sha256']:
        raise ValueError('검토한 원본 ZIP의 해시와 다름')

    with open_dataset(dataset) as (files, read):
        classes = parse_classes(read('data.yaml').decode('utf-8-sig'))
        targets, mapping = resolve_mapping(classes, policy)
        images = sorted(name for name in files
                        if len(name.split('/')) == 3
                        and name.split('/')[0] in SPLITS
                        and name.split('/')[1] == 'images'
                        and Path(name).suffix.lower() in IMAGE_SUFFIXES)
        if len(images) != len(set(images)):
            raise ValueError('ZIP에 같은 이미지 경로가 중복됨')
        names = set(files)
        records, parents, hashes = {}, {name: name for name in images}, {}
        removed_rows, invalid = [], []
        blank = set()
        for index, name in enumerate(images, 1):
            label = name.replace('/images/', '/labels/').rsplit('.', 1)[0] + '.txt'
            if label not in names:
                invalid.append({'image': name, 'reason': '라벨 누락됨'})
                continue
            rows, seen = [], set()
            for line_no, row in enumerate(read(label).decode('utf-8-sig').splitlines(), 1):
                try:
                    annotation = parse_annotation(row, len(classes))
                    if annotation is None:
                        continue
                    values = detection_values(annotation, mapping[annotation['class_id']])
                    signature = (annotation['class_id'], tuple(annotation['coordinates']))
                    if signature in seen and policy['remove_exact_annotation_duplicates']:
                        removed_rows.append({'image': name, 'line': line_no})
                        continue
                    seen.add(signature)
                    rows.append({'source_line': line_no, 'annotation': annotation, 'detection': values})
                except ValueError as error:
                    invalid.append({'image': name, 'line': line_no, 'reason': str(error)})
            if not rows:
                blank.add(name)
            with Image.open(io.BytesIO(read(name))) as image:
                image.load()
                rgb = image.convert('RGB')
                variants = [rgb, ImageOps.mirror(rgb), ImageOps.flip(rgb), rgb.transpose(Image.Transpose.ROTATE_180)]
                key = min(hashlib.sha256(str(rgb.size).encode() + variant.tobytes()).hexdigest()
                          for variant in variants)
                if key in hashes:
                    join_parents(parents, name, hashes[key])
                else:
                    hashes[key] = name
                records[name] = {'rows': rows, 'size': rgb.size, 'group_hash': key}
            if index % 2000 == 0:
                print(f'preflight: {index}/{len(images)}', flush=True)

        # 판단이 필요한 오류는 자동 삭제하지 않고 생성 전에 중단함.
        if invalid:
            raise ValueError('잘못된 라벨 발견됨: ' + json.dumps(invalid, ensure_ascii=False))
        reviewed_empty = set(policy['exclude_unannotated_images'])
        if blank != reviewed_empty:
            raise ValueError('빈 라벨 목록이 검토 정책과 다름')
        for review in policy['near_duplicate_reviews']:
            left, right = review['images']
            if left not in parents or right not in parents or not review.get('reason'):
                raise ValueError('유사 중복 검토 경로 또는 근거가 유효하지 않음')
            if review['decision'] == 'same_source':
                join_parents(parents, left, right)
            elif review['decision'] != 'different':
                raise ValueError('유사 중복 검토 결과가 유효하지 않음')

        excluded = leakage_exclusions(parents)
        excluded.update({name: '식재료가 보이는 미표기 사진으로 확인되어 격리함' for name in blank})
        output.mkdir(parents=True)
        (output / 'policy.json').write_text(json.dumps(policy, ensure_ascii=False, indent=2), encoding='utf-8')
        for name in sorted(excluded):
            relative = Path('quarantine') / Path(name)
            target = output / relative
            target.parent.mkdir(parents=True, exist_ok=True)
            target.write_bytes(read(name))
            original_label = name.replace('/images/', '/labels/').rsplit('.', 1)[0] + '.txt'
            target_label = output / 'quarantine' / original_label
            target_label.parent.mkdir(parents=True, exist_ok=True)
            target_label.write_bytes(read(original_label))
        yolo, classification = output / 'yolo', output / 'efficientnet'
        for split in SPLITS:
            (yolo / split / 'images').mkdir(parents=True)
            (yolo / split / 'labels').mkdir()
            for target in targets:
                (classification / split / target).mkdir(parents=True)
        yaml = (f'path: {json.dumps(yolo.as_posix(), ensure_ascii=False)}\n'
                'train: train/images\nval: valid/images\ntest: test/images\n'
                f'nc: {len(targets)}\nnames: {json.dumps(targets, ensure_ascii=False)}\n')
        (yolo / 'data.yaml').write_text(yaml, encoding='utf-8')
        write_class_indices(output, targets)
        counts = {split: Counter() for split in SPLITS}
        image_counts = {split: Counter() for split in SPLITS}
        image_manifest, crop_manifest, crop_hashes = [], [], defaultdict(list)
        crop_quality, multi_objects, multi_classes = [], Counter(), Counter()
        combinations = {split: Counter() for split in SPLITS}
        samples = Image.new('RGB', (1440, 960), 'white')
        sample_count = 0
        kept = [name for name in images if name not in excluded]
        for index, name in enumerate(kept, 1):
            record = records[name]
            split = name.split('/')[0]
            raw = read(name)
            relative_image = Path(split) / 'images' / Path(name).name
            (yolo / relative_image).write_bytes(raw)
            label = yolo / split / 'labels' / (Path(name).stem + '.txt')
            label.write_text('\n'.join(' '.join([str(values[0]), *[format(value, '.12g') for value in values[1:]]])
                                       for values in [row['detection'] for row in record['rows']]) + '\n', encoding='utf-8')
            class_ids = {row['detection'][0] for row in record['rows']}
            image_counts[split].update(class_ids)
            multi_objects[split] += len(record['rows']) > 1
            multi_classes[split] += len(class_ids) > 1
            if len(class_ids) > 1:
                combinations[split][' + '.join(targets[class_id] for class_id in sorted(class_ids))] += 1
            group_id = find_parent(parents, name)
            image_manifest.append({'image': name, 'split': split, 'group': group_id,
                                   'sha256': hashlib.sha256(raw).hexdigest(), 'objects': len(record['rows'])})
            with Image.open(io.BytesIO(raw)) as image:
                rgb = image.convert('RGB')
                width, height = rgb.size
                for object_index, row in enumerate(record['rows']):
                    target_id = row['detection'][0]
                    left, top, right, bottom = row['annotation']['bounds']
                    box = (max(0, math.floor(left * width)), max(0, math.floor(top * height)),
                           min(width, math.ceil(right * width)), min(height, math.ceil(bottom * height)))
                    crop = rgb.crop(box)
                    if crop.width <= 0 or crop.height <= 0:
                        raise ValueError('크롭 크기가 0임: ' + name)
                    crop_name = f'{hashlib.sha256(name.encode()).hexdigest()[:24]}__{object_index:03d}.png'
                    relative = Path(split) / targets[target_id] / crop_name
                    crop.save(classification / relative)
                    fingerprint = hashlib.sha256(str(crop.size).encode() + crop.tobytes()).hexdigest()
                    crop_hashes[fingerprint].append(relative.as_posix())
                    crop_record = {'crop': relative.as_posix(), 'source_image': name,
                                   'source_line': row['source_line'], 'split': split, 'class_id': target_id,
                                   'width': crop.width, 'height': crop.height, 'box': json.dumps(box),
                                   'pixel_sha256': fingerprint}
                    crop_manifest.append(crop_record)
                    counts[split][target_id] += 1
                    # 작은 크롭은 임의 삭제하지 않고 품질 검토 대상으로 남김.
                    if min(crop.size) < 8:
                        crop_quality.append(crop_record)
                if sample_count < 12 and (len(class_ids) > 1 or sample_count < 3):
                    painter = ImageDraw.Draw(rgb)
                    for row in record['rows']:
                        left, top, right, bottom = row['annotation']['bounds']
                        painter.rectangle((left*width, top*height, right*width, bottom*height), outline='red', width=2)
                        painter.text((left*width, top*height), targets[row['detection'][0]], fill='red')
                    rgb.thumbnail((350, 290))
                    x, y = sample_count % 4 * 360, sample_count // 4 * 320
                    samples.paste(rgb, (x, y+20))
                    ImageDraw.Draw(samples).text((x, y), f'{split}: {len(record["rows"])} objects', fill='black')
                    sample_count += 1
            if index % 2000 == 0:
                print(f'export: {index}/{len(kept)}', flush=True)

        write_csv(output / 'images.csv', image_manifest, ['image', 'split', 'group', 'sha256', 'objects'])
        write_csv(output / 'crops.csv', crop_manifest,
                  ['crop', 'source_image', 'source_line', 'split', 'class_id', 'width', 'height', 'box', 'pixel_sha256'])
        write_csv(output / 'excluded_images.csv', [{'image': name, 'split': name.split('/')[0], 'reason': reason}
                                                 for name, reason in sorted(excluded.items())], ['image', 'split', 'reason'])
        class_rows = []
        for target_id, target in enumerate(targets):
            row = {'class_id': target_id, 'class_name': target}
            row.update({f'{split}_images': image_counts[split][target_id] for split in SPLITS})
            row.update({f'{split}_objects': counts[split][target_id] for split in SPLITS})
            class_rows.append(row)
        write_csv(output / 'class_counts.csv', class_rows,
                  ['class_id', 'class_name', 'train_images', 'valid_images', 'test_images',
                   'train_objects', 'valid_objects', 'test_objects'])
        write_csv(output / 'class_mapping.csv', [{**row, 'target_id': mapping[row['source_id']]}
                                               for row in policy['class_mapping']],
                  ['source_id', 'source_name', 'target_name', 'reason', 'target_id'])
        samples.save(output / 'detection_samples.png')
        report = {'source_sha256': source_hash, 'source_classes': len(classes), 'target_classes': len(targets),
                  'original_images': len(images), 'excluded_images': len(excluded),
                  'unannotated_images': len(blank), 'duplicate_annotation_rows_removed': removed_rows,
                  'yolo_images': dict(Counter(row['split'] for row in image_manifest)),
                  'efficientnet_crops': {split: sum(counts[split].values()) for split in SPLITS},
                  'multi_object_images': dict(multi_objects), 'multi_class_images': dict(multi_classes),
                  'multi_class_combinations': {split: dict(value.most_common()) for split, value in combinations.items()},
                  'small_crops_review_only': crop_quality,
                  'cross_split_exact_crop_duplicates': duplicate_summary(crop_hashes)['cross_split_files'],
                  'models_trained': False}
        with dataset.open('rb') as source:
            report['source_unchanged'] = source_hash == hashlib.file_digest(source, 'sha256').hexdigest()
        if not report['source_unchanged']:
            raise ValueError('처리 중 원본 ZIP이 변경됨')
        (output / 'processing_report.json').write_text(json.dumps(report, ensure_ascii=False, indent=2), encoding='utf-8')
        if policy.get('excluded_classification_crops'):
            quarantine_classification_crops(output, policy['excluded_classification_crops'])
            report = json.loads((output / 'processing_report.json').read_text(encoding='utf-8'))
        return report


# 승인한 분류 크롭만 격리하고 YOLO 라벨 검토 상태와 수량 변화를 기록함.
def quarantine_classification_crops(output_dir, crop_names):
    output = Path(output_dir).resolve()
    repository = Path(__file__).resolve().parents[2]
    if output.is_relative_to(repository):
        raise ValueError('저장소 내부 데이터는 처리하지 않음')
    requested = set(crop_names)
    if not requested or len(requested) != len(crop_names):
        raise ValueError('중복 없는 명시적 크롭 목록이 필요함')
    report_path = output / 'classification_quarantine_report.json'
    if report_path.exists():
        prior = json.loads(report_path.read_text(encoding='utf-8'))
        if requested != {record['crop'] for record in prior['quarantined_crops']}:
            raise ValueError('기존 승인 목록과 다른 추가 격리는 별도 검토가 필요함')
        for record in prior['quarantined_crops']:
            source = output / 'efficientnet' / record['crop']
            target = output / record['quarantine_path']
            if source.exists() or not target.is_file():
                raise ValueError('기존 격리 파일 상태가 기록과 다름')
            if hashlib.sha256(target.read_bytes()).hexdigest() != record['file_sha256']:
                raise ValueError('격리 파일 내용이 변경됨')
        return prior
    processing = json.loads((output / 'processing_report.json').read_text(encoding='utf-8'))
    reviewed = {record['crop'] for record in processing['small_crops_review_only']}
    if not requested.issubset(reviewed):
        raise ValueError('시각 검토한 작은 크롭만 격리할 수 있음')
    with (output / 'crops.csv').open(encoding='utf-8-sig', newline='') as source:
        reader = csv.DictReader(source)
        columns, crops = reader.fieldnames, list(reader)
    by_name = {record['crop']: record for record in crops}
    if not requested.issubset(by_name):
        raise ValueError('활성 크롭 목록에 없는 파일이 포함됨')
    plans, quarantined = [], []
    for name in sorted(requested):
        record = by_name[name]
        source = (output / 'efficientnet' / name).resolve()
        relative = Path('quarantine') / 'efficientnet' / name
        target = (output / relative).resolve()
        if (not source.is_relative_to(output / 'efficientnet')
                or not target.is_relative_to(output / 'quarantine' / 'efficientnet')
                or record['split'] != 'train' or not source.is_file() or target.exists()):
            raise ValueError('격리 경로·분할·파일 상태가 유효하지 않음')
        quarantined.append({**record, 'quarantine_path': relative.as_posix(),
                            'file_sha256': hashlib.sha256(source.read_bytes()).hexdigest(),
                            'reason': '사용자가 확인한 소형 크롭을 분류 학습에서만 격리함',
                            'yolo_label_review': 'PENDING_MANUAL_REVIEW'})
        plans.append((source, target))

    # YOLO 라벨 원문을 해시로 남겨 격리 후 바이트 단위 불변을 확인함.
    label_hash = hashlib.sha256()
    with (output / 'images.csv').open(encoding='utf-8-sig', newline='') as source:
        for record in csv.DictReader(source):
            name = record['image']
            label = (output / 'yolo' / name.replace('/images/', '/labels/')).with_suffix('.txt')
            label_hash.update(name.encode() + b'\0' + label.read_bytes())
    remaining = [record for record in crops if record['crop'] not in requested]
    before = Counter(record['split'] for record in crops)
    after = Counter(record['split'] for record in remaining)
    changes = []
    with (output / 'class_counts.csv').open(encoding='utf-8-sig', newline='') as source:
        classes = list(csv.DictReader(source))
    for row in classes:
        class_id = int(row['class_id'])
        change = {'class_id': class_id, 'class_name': row['class_name']}
        for split in SPLITS:
            count_before = sum(record['split'] == split and int(record['class_id']) == class_id for record in crops)
            count_after = sum(record['split'] == split and int(record['class_id']) == class_id for record in remaining)
            change.update({f'{split}_before': count_before, f'{split}_after': count_after,
                           f'{split}_quarantined': count_before - count_after})
        changes.append(change)
    for source, target in plans:
        target.parent.mkdir(parents=True, exist_ok=True)
        source.rename(target)
    write_csv(output / 'crops.csv', remaining, columns)
    write_csv(output / 'quarantined_crops.csv', quarantined, list(quarantined[0]))
    write_csv(output / 'efficientnet_class_changes.csv', changes, list(changes[0]))
    policy_path = output / 'policy.json'
    policy = json.loads(policy_path.read_text(encoding='utf-8'))
    policy['excluded_classification_crops'] = sorted(requested)
    policy_path.write_text(json.dumps(policy, ensure_ascii=False, indent=2), encoding='utf-8')
    processing['efficientnet_crops'] = {split: after[split] for split in SPLITS}
    processing['classification_crops_quarantined'] = len(quarantined)
    (output / 'processing_report.json').write_text(json.dumps(processing, ensure_ascii=False, indent=2), encoding='utf-8')
    result = {'before': {split: before[split] for split in SPLITS},
              'after': {split: after[split] for split in SPLITS},
              'quarantined_crops': quarantined, 'class_changes': changes,
              'yolo_label_tree_sha256': label_hash.hexdigest(),
              'yolo_labels_modified': False}
    report_path.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding='utf-8')
    return result


# 생성된 이미지·라벨·크롭과 원본 분할 추적 정보의 일치 여부 검사함.
def validate_prepared(output_dir, dataset=None):
    from PIL import Image, ImageDraw

    output = Path(output_dir).resolve()
    report = json.loads((output / 'processing_report.json').read_text(encoding='utf-8'))
    with (output / 'images.csv').open(encoding='utf-8-sig', newline='') as source:
        images = list(csv.DictReader(source))
    with (output / 'crops.csv').open(encoding='utf-8-sig', newline='') as source:
        crops = list(csv.DictReader(source))
    quarantine_path = output / 'quarantined_crops.csv'
    quarantined = []
    if quarantine_path.exists():
        with quarantine_path.open(encoding='utf-8-sig', newline='') as source:
            quarantined = list(csv.DictReader(source))
    classes = parse_classes((output / 'yolo/data.yaml').read_text(encoding='utf-8'))
    source_paths = {record['image']: record for record in images}
    image_hashes, crop_hashes, groups = defaultdict(set), defaultdict(set), defaultdict(set)
    image_counts, crop_counts, object_counts = Counter(), Counter(), Counter()
    duplicate_rows = 0
    preview_crops = {}
    label_hash = hashlib.sha256()
    for record in images:
        name, split = record['image'], record['split']
        if split != name.split('/')[0]:
            raise ValueError('원본 이미지 분할이 변경됨')
        path = output / 'yolo' / name
        raw = path.read_bytes()
        if hashlib.sha256(raw).hexdigest() != record['sha256']:
            raise ValueError('탐지 이미지가 원본과 다름')
        label = output / 'yolo' / name.replace('/images/', '/labels/')
        label = label.with_suffix('.txt')
        label_bytes = label.read_bytes()
        label_hash.update(name.encode() + b'\0' + label_bytes)
        count, seen_rows = 0, set()
        for row in label_bytes.decode('utf-8').splitlines():
            annotation = parse_annotation(row, len(classes))
            if annotation is None or annotation['format'] != 'detection':
                raise ValueError('생성 라벨이 탐지 형식이 아님')
            detection_values(annotation, annotation['class_id'])
            signature = (annotation['class_id'], tuple(annotation['coordinates']))
            duplicate_rows += signature in seen_rows
            seen_rows.add(signature)
            count += 1
        if count != int(record['objects']):
            raise ValueError('객체 수와 라벨 행 개수가 다름')
        image_counts[split] += 1
        object_counts[split] += count
        image_hashes[record['sha256']].add(split)
        groups[record['group']].add(split)
    cached_source, cached_rgb = None, None
    for index, record in enumerate(crops, 1):
        split = record['split']
        if record['source_image'] not in source_paths or record['source_image'].split('/')[0] != split:
            raise ValueError('크롭 원본 또는 분할 추적이 유효하지 않음')
        with Image.open(output / 'efficientnet' / record['crop']) as image:
            image.load()
            rgb = image.convert('RGB')
            if rgb.size != (int(record['width']), int(record['height'])):
                raise ValueError('크롭 크기가 기록과 다름')
            key = hashlib.sha256(str(rgb.size).encode() + rgb.tobytes()).hexdigest()
            if key != record['pixel_sha256']:
                raise ValueError('크롭 픽셀이 기록과 다름')
            crop_hashes[key].add(split)
        # 같은 원본을 한 번만 읽고 실제 원본 영역과 크롭 픽셀을 대조함.
        if cached_source != record['source_image']:
            with Image.open(output / 'yolo' / record['source_image']) as image:
                cached_rgb = image.convert('RGB')
            cached_source = record['source_image']
        expected_crop = cached_rgb.crop(json.loads(record['box']))
        expected_hash = hashlib.sha256(str(expected_crop.size).encode() + expected_crop.tobytes()).hexdigest()
        if expected_hash != record['pixel_sha256']:
            raise ValueError('크롭이 실제 원본 영역과 다름')
        if Path(record['crop']).parts[1] != classes[int(record['class_id'])]:
            raise ValueError('크롭 폴더와 클래스 ID가 다름')
        crop_counts[split] += 1
        if int(record['class_id']) not in preview_crops and min(int(record['width']), int(record['height'])) >= 8:
            preview_crops[int(record['class_id'])] = record['crop']
        if index % 4000 == 0:
            print(f'validate crops: {index}/{len(crops)}', flush=True)
    quarantine_counts, retained_yolo_quarantine = Counter(), Counter()
    for record in quarantined:
        path = (output / record['quarantine_path']).resolve()
        if not path.is_relative_to(output / 'quarantine' / 'efficientnet'):
            raise ValueError('격리 파일 경로가 유효하지 않음')
        if (output / 'efficientnet' / record['crop']).exists():
            raise ValueError('격리한 크롭이 학습 폴더에 남아 있음')
        if hashlib.sha256(path.read_bytes()).hexdigest() != record['file_sha256']:
            raise ValueError('격리 파일 내용이 변경됨')
        quarantine_counts[record['split']] += 1
        if record.get('yolo_label_kept', 'true') == 'true':
            retained_yolo_quarantine[record['split']] += 1
    for split in SPLITS:
        actual_images = list((output / 'yolo' / split / 'images').glob('*'))
        actual_labels = list((output / 'yolo' / split / 'labels').glob('*.txt'))
        actual_crops = list((output / 'efficientnet' / split).glob('*/*.png'))
        if len(actual_images) != image_counts[split] or len(actual_labels) != image_counts[split]:
            raise ValueError('탐지 이미지·라벨 파일 수가 다름')
        if (len(actual_crops) != crop_counts[split]
                or crop_counts[split] + retained_yolo_quarantine[split] != object_counts[split]):
            raise ValueError('분류 크롭 수가 객체 수와 다름')
    result = {'yolo_images': dict(image_counts), 'yolo_objects': dict(object_counts),
              'efficientnet_crops': dict(crop_counts),
              'cross_split_image_hash_groups': sum(len(value) > 1 for value in image_hashes.values()),
              'cross_split_source_groups': sum(len(value) > 1 for value in groups.values()),
              'cross_split_crop_hash_groups': sum(len(value) > 1 for value in crop_hashes.values()),
              'class_count': len(classes), 'duplicate_detection_rows': duplicate_rows,
              'source_unchanged': report['source_unchanged'],
              'classification_crops_quarantined': dict(quarantine_counts)}
    if quarantined:
        quarantine_report = json.loads((output / 'classification_quarantine_report.json').read_text(encoding='utf-8'))
        if label_hash.hexdigest() != quarantine_report['yolo_label_tree_sha256']:
            raise ValueError('YOLO 라벨 원문이 격리 전과 다름')
        result['yolo_labels_match_revision' if report.get('label_revision') else 'yolo_labels_unchanged'] = True
    if dataset is not None:
        with Path(dataset).open('rb') as source:
            result['source_unchanged'] = report['source_sha256'] == hashlib.file_digest(source, 'sha256').hexdigest()
        if not result['source_unchanged']:
            raise ValueError('원본 ZIP 해시가 변경됨')
        metadata = output / 'source_metadata'
        metadata.mkdir(exist_ok=True)
        with open_dataset(dataset) as (files, read):
            for name in ['data.yaml', 'README.dataset.txt', 'README.roboflow.txt']:
                if name in files:
                    (metadata / name).write_bytes(read(name))
            original_classes = parse_classes(read('data.yaml').decode('utf-8-sig'))
            policy = json.loads((output / 'policy.json').read_text(encoding='utf-8'))
            targets, mapping = resolve_mapping(original_classes, policy)
            if targets != classes:
                raise ValueError('승인 정책과 생성된 클래스 순서가 다름')
            before_images = {split: Counter() for split in SPLITS}
            before_objects = {split: Counter() for split in SPLITS}
            for name in files:
                split = name.split('/')[0]
                if split in SPLITS and '/labels/' in name and name.endswith('.txt'):
                    annotations = [parse_annotation(row, len(original_classes))
                                   for row in read(name).decode('utf-8-sig').splitlines() if row.strip()]
                    ids = [mapping[row['class_id']] for row in annotations]
                    # 통합 전 클래스들이 한 사진에 있어도 이미지 수는 한 번만 셈.
                    before_images[split].update(set(ids))
                    before_objects[split].update(ids)
            with (output / 'class_counts.csv').open(encoding='utf-8-sig', newline='') as source:
                after = list(csv.DictReader(source))
            comparison = []
            for row in after:
                class_id = int(row['class_id'])
                compared = {'class_id': class_id, 'class_name': row['class_name']}
                for split in SPLITS:
                    compared[f'{split}_images_before'] = before_images[split][class_id]
                    compared[f'{split}_images_after'] = int(row[f'{split}_images'])
                    compared[f'{split}_objects_before'] = before_objects[split][class_id]
                    compared[f'{split}_objects_after'] = int(row[f'{split}_objects'])
                comparison.append(compared)
            write_csv(output / 'distribution_comparison.csv', comparison, list(comparison[0]))
    preview = Image.new('RGB', (1280, math.ceil(len(classes) / 8) * 180), 'white')
    painter = ImageDraw.Draw(preview)
    for class_id, name in enumerate(classes):
        x, y = class_id % 8 * 160, class_id // 8 * 180
        painter.text((x+3, y+3), f'{class_id}: {name[:22]}', fill='black')
        if class_id in preview_crops:
            with Image.open(output / 'efficientnet' / preview_crops[class_id]) as image:
                thumbnail = image.convert('RGB')
                thumbnail.thumbnail((154, 150))
                preview.paste(thumbnail, (x+3, y+23))
    preview.save(output / 'crop_samples.png')
    write_class_indices(output, classes)
    (output / 'validation_report.json').write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding='utf-8')
    return result


# 기존 산출물을 보존하고 승인된 라벨 변경만 별도 데이터 버전에 반영함.
def create_training_revision(source_dir, output_dir, review_path):
    source = Path(source_dir).resolve()
    output = validate_output_path(source, output_dir)
    review = json.loads(Path(review_path).read_text(encoding='utf-8'))
    prior_validation = source / 'validation_report.json'
    if hashlib.sha256(prior_validation.read_bytes()).hexdigest() != review['parent_validation_sha256']:
        raise ValueError('검토 기준이 된 기존 검증 결과가 변경됨')
    with (source / 'images.csv').open(encoding='utf-8-sig', newline='') as stream:
        image_rows = list(csv.DictReader(stream))
    with (source / 'crops.csv').open(encoding='utf-8-sig', newline='') as stream:
        reader = csv.DictReader(stream)
        crop_columns, crop_rows = reader.fieldnames, list(reader)
    with (source / 'quarantined_crops.csv').open(encoding='utf-8-sig', newline='') as stream:
        prior_quarantine = list(csv.DictReader(stream))
    policy = json.loads((source / 'policy.json').read_text(encoding='utf-8'))
    processing = json.loads((source / 'processing_report.json').read_text(encoding='utf-8'))
    if processing['source_sha256'] != review['source_zip_sha256']:
        raise ValueError('검토 정책의 원본 ZIP 해시가 다름')
    classes = parse_classes((source / 'yolo/data.yaml').read_text(encoding='utf-8'))
    known = {record['image'] for record in image_rows}
    removals = defaultdict(dict)
    for record in review['remove_objects']:
        if record['image'] not in known or not record.get('reason'):
            raise ValueError('알 수 없는 이미지 또는 검토 근거가 누락됨')
        removals[record['image']][int(record['source_line'])] = record
    excluded_images = set(review['exclude_yolo_images'])
    if not excluded_images.issubset(removals):
        raise ValueError('격리 이미지의 라벨 검토가 누락됨')
    new_labels, before_objects, after_objects = {}, Counter(), Counter()
    for record in image_rows:
        name = record['image']
        label = Path(name.replace('/images/', '/labels/')).with_suffix('.txt')
        raw = (source / 'yolo' / label).read_bytes()
        rows = raw.decode('utf-8').splitlines()
        for line, decision in removals.get(name, {}).items():
            if not 1 <= line <= len(rows) or rows[line-1] != decision['expected_detection_row']:
                raise ValueError('검토한 라벨 행의 원문이 변경됨')
        kept = []
        for line, row in enumerate(rows, 1):
            annotation = parse_annotation(row, len(classes))
            before_objects[annotation['class_id']] += 1
            if name not in excluded_images and line not in removals.get(name, {}):
                kept.append(row)
                after_objects[annotation['class_id']] += 1
        if not kept and name not in excluded_images:
            raise ValueError('빈 배경 사진으로 바꾸지 않도록 이미지 격리 승인이 필요함')
        new_labels[name] = (label, raw, kept)
    removed_pairs = {(name, line) for name, rows in removals.items() for line in rows}
    active_crops, newly_quarantined = [], []
    for row in crop_rows:
        if (row['source_image'], int(row['source_line'])) in removed_pairs or row['source_image'] in excluded_images:
            newly_quarantined.append(row)
        else:
            active_crops.append(row)
    output.mkdir(parents=True)
    for split in SPLITS:
        (output / 'yolo' / split / 'images').mkdir(parents=True)
        (output / 'yolo' / split / 'labels').mkdir()
        for name in classes:
            (output / 'efficientnet' / split / name).mkdir(parents=True)
    snapshots = output / 'parent_validation'
    snapshots.mkdir()
    for filename in ['validation_report.json', 'processing_report.json', 'policy.json',
                     'classification_quarantine_report.json', 'efficientnet_class_changes.csv']:
        shutil.copyfile(source / filename, snapshots / filename)
    (output / 'label_review_policy.json').write_text(json.dumps(review, ensure_ascii=False, indent=2), encoding='utf-8')
    new_images, counts, image_counts = [], {split: Counter() for split in SPLITS}, {split: Counter() for split in SPLITS}
    multi_objects, multi_classes, combinations = Counter(), Counter(), {split: Counter() for split in SPLITS}
    label_hash = hashlib.sha256()
    for index, record in enumerate(image_rows, 1):
        name, split = record['image'], record['split']
        label, original, rows = new_labels[name]
        if name in removals:
            backup = output / 'reviewed_labels_before' / label
            backup.parent.mkdir(parents=True, exist_ok=True)
            backup.write_bytes(original)
        if name in excluded_images:
            target = output / 'quarantine/yolo' / name
            target.parent.mkdir(parents=True, exist_ok=True)
            shutil.copyfile(source / 'yolo' / name, target)
            continue
        shutil.copyfile(source / 'yolo' / name, output / 'yolo' / name)
        raw = ('\n'.join(rows) + '\n').encode()
        (output / 'yolo' / label).write_bytes(raw)
        label_hash.update(name.encode() + b'\0' + raw)
        ids = [parse_annotation(row, len(classes))['class_id'] for row in rows]
        counts[split].update(ids)
        image_counts[split].update(set(ids))
        multi_objects[split] += len(ids) > 1
        multi_classes[split] += len(set(ids)) > 1
        if len(set(ids)) > 1:
            combinations[split][' + '.join(classes[class_id] for class_id in sorted(set(ids)))] += 1
        new_images.append({**record, 'objects': len(rows)})
        if index % 2000 == 0:
            print(f'revision images: {index}/{len(image_rows)}', flush=True)
    for index, record in enumerate(active_crops, 1):
        shutil.copyfile(source / 'efficientnet' / record['crop'], output / 'efficientnet' / record['crop'])
        if index % 4000 == 0:
            print(f'revision crops: {index}/{len(active_crops)}', flush=True)
    quarantine_rows = []
    for record in prior_quarantine + newly_quarantined:
        is_new = record in newly_quarantined
        old_path = source / 'efficientnet' / record['crop'] if is_new else source / record['quarantine_path']
        relative = Path('quarantine/efficientnet') / record['crop']
        target = output / relative
        target.parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(old_path, target)
        kept = ((record['source_image'], int(record['source_line'])) not in removed_pairs
                and record['source_image'] not in excluded_images)
        quarantine_rows.append({**record, 'quarantine_path': relative.as_posix(),
                                'file_sha256': hashlib.sha256(target.read_bytes()).hexdigest(),
                                'yolo_label_kept': 'true' if kept else 'false',
                                'yolo_label_review': 'PENDING_MANUAL_REVIEW' if kept else 'REVIEWED_REMOVED_IN_REVISION',
                                'reason': '기존 소형 크롭 격리 유지함' if not is_new else '동일 객체의 중복 크롭을 격리함'})
    with (source / 'excluded_images.csv').open(encoding='utf-8-sig', newline='') as stream:
        excluded_rows = list(csv.DictReader(stream))
    excluded_rows.extend({'image': name, 'split': name.split('/')[0],
                          'reason': '유일한 라벨이 부분 영역이라 재라벨링 전까지 학습에서 격리함'} for name in sorted(excluded_images))
    write_csv(output / 'images.csv', new_images, list(new_images[0]))
    write_csv(output / 'crops.csv', active_crops, crop_columns)
    quarantine_columns = list(dict.fromkeys(key for row in quarantine_rows for key in row))
    write_csv(output / 'quarantined_crops.csv', quarantine_rows, quarantine_columns)
    write_csv(output / 'excluded_images.csv', excluded_rows, ['image', 'split', 'reason'])
    rows = []
    for class_id, name in enumerate(classes):
        row = {'class_id': class_id, 'class_name': name}
        row.update({f'{split}_images': image_counts[split][class_id] for split in SPLITS})
        row.update({f'{split}_objects': counts[split][class_id] for split in SPLITS})
        rows.append(row)
    write_csv(output / 'class_counts.csv', rows, list(rows[0]))
    changes = [{'class_id': index, 'class_name': name, 'objects_before': before_objects[index],
                'objects_after': after_objects[index], 'removed': before_objects[index]-after_objects[index]}
               for index, name in enumerate(classes)]
    write_csv(output / 'label_object_changes.csv', changes, list(changes[0]))
    shutil.copyfile(source / 'class_mapping.csv', output / 'class_mapping.csv')
    write_class_indices(output, classes)
    yaml = (f'path: {json.dumps((output / "yolo").as_posix())}\ntrain: train/images\nval: valid/images\n'
            f'test: test/images\nnc: {len(classes)}\nnames: {json.dumps(classes)}\n')
    (output / 'yolo/data.yaml').write_text(yaml, encoding='utf-8')
    crop_counts = Counter(row['split'] for row in active_crops)
    processing.update({'label_revision': True, 'parent_dataset': str(source),
                       'excluded_images': len(excluded_rows),
                       'yolo_images': dict(Counter(row['split'] for row in new_images)),
                       'efficientnet_crops': {split: crop_counts[split] for split in SPLITS},
                       'classification_crops_quarantined': len(quarantine_rows),
                       'multi_object_images': dict(multi_objects), 'multi_class_images': dict(multi_classes),
                       'multi_class_combinations': {split: dict(value) for split, value in combinations.items()}})
    processing['prior_small_crops_reviewed'] = processing['small_crops_review_only']
    processing['small_crops_review_only'] = [row for row in processing['small_crops_review_only']
                                           if (row['source_image'], int(row['source_line'])) not in removed_pairs]
    policy['label_review_revision'] = review
    (output / 'processing_report.json').write_text(json.dumps(processing, ensure_ascii=False, indent=2), encoding='utf-8')
    (output / 'policy.json').write_text(json.dumps(policy, ensure_ascii=False, indent=2), encoding='utf-8')
    quarantine_report = {'quarantined_crops': quarantine_rows, 'yolo_label_tree_sha256': label_hash.hexdigest(),
                         'revision_before': json.loads((source/'processing_report.json').read_text(encoding='utf-8'))['efficientnet_crops'],
                         'revision_after': processing['efficientnet_crops']}
    (output / 'classification_quarantine_report.json').write_text(json.dumps(quarantine_report, ensure_ascii=False, indent=2), encoding='utf-8')
    if hashlib.sha256(prior_validation.read_bytes()).hexdigest() != review['parent_validation_sha256']:
        raise ValueError('기존 검증 보고서가 처리 중 변경됨')
    return {'yolo_images': processing['yolo_images'], 'efficientnet_crops': processing['efficientnet_crops'],
            'removed_yolo_objects': sum(before_objects.values())-sum(after_objects.values()),
            'newly_quarantined_crops': len(newly_quarantined)}


# 실행 인자에 따라 검사·전처리·파생 데이터 재검증을 수행함.
def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--dataset', required=True, type=Path)
    parser.add_argument('--output-dir', required=True, type=Path)
    parser.add_argument('--verify-images', action='store_true', help='Pillow로 전체 디코딩 및 픽셀 중복 검사 수행함')
    parser.add_argument('--prepare', action='store_true', help='승인된 정책으로 파생 데이터만 생성함')
    parser.add_argument('--policy', type=Path, help='원본 해시·클래스·시각 검토 결정이 담긴 JSON 경로임')
    parser.add_argument('--validate-prepared', action='store_true', help='생성한 파생 데이터만 재검증함')
    parser.add_argument('--quarantine-crops', type=Path, help='사용자가 승인한 분류 크롭 경로 목록 JSON임')
    parser.add_argument('--revise-labels', type=Path, help='승인된 라벨 검토 정책으로 별도 버전을 생성함')
    args = parser.parse_args()
    if args.revise_labels:
        print(json.dumps(create_training_revision(args.dataset, args.output_dir, args.revise_labels), ensure_ascii=False))
        return
    if args.quarantine_crops:
        names = json.loads(args.quarantine_crops.read_text(encoding='utf-8'))
        result = quarantine_classification_crops(args.output_dir, names)
        print(json.dumps({'before': result['before'], 'after': result['after'],
                          'quarantined': len(result['quarantined_crops'])}, ensure_ascii=False))
        return
    if args.validate_prepared:
        print(json.dumps(validate_prepared(args.output_dir, args.dataset), ensure_ascii=False))
        return
    if args.prepare:
        if args.policy is None:
            parser.error('--prepare에는 --policy가 필요함')
        report = prepare_dataset(args.dataset, args.output_dir, args.policy)
        print(json.dumps({key: value for key, value in report.items()
                          if key not in ['small_crops_review_only', 'multi_class_combinations']}, ensure_ascii=False))
        return
    result = inspect_dataset(args.dataset, args.verify_images)
    write_report(result, args.output_dir)
    print(json.dumps({'splits': result['splits'], 'formats': result['formats'], 'issues': {key: len(value) for key, value in result['issues'].items()}, 'output': str(args.output_dir)}, ensure_ascii=False))


if __name__ == '__main__':
    main()
