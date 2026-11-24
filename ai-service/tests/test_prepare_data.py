import importlib.util
import json
import tempfile
import unittest
from pathlib import Path
from zipfile import ZipFile

MODULE_PATH = Path(__file__).resolve().parents[1] / 'ml' / 'prepare_data.py'
SPEC = importlib.util.spec_from_file_location('ingredient_data_audit', MODULE_PATH)
audit = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(audit)


class IngredientDatasetAuditTest(unittest.TestCase):
    # 탐지 좌표의 클래스·형식·면적 계산 검사함.
    def test_detection_coordinates(self):
        row = audit.parse_annotation('1 0.5 0.5 0.4 0.2', 2)
        self.assertEqual(row['class_id'], 1)
        self.assertEqual(row['format'], 'detection')
        self.assertAlmostEqual(row['area'], .08)

    # 분할 다각형의 면적과 외접 범위 반환 검사함.
    def test_polygon_coordinates(self):
        row = audit.parse_annotation('0 0 0 1 0 0 1', 2)
        self.assertEqual(row['format'], 'segmentation')
        self.assertEqual(row['area'], .5)
        self.assertEqual(row['bounds'], (0, 0, 1, 1))

    # 잘못된 클래스·좌표·라벨 열 개수 거부 검사함.
    def test_invalid_annotations(self):
        rows = ['-1 .5 .5 .2 .2', '2 .5 .5 .2 .2', '0.5 .5 .5 .2 .2', '0 nan .5 .2 .2', '0 inf .5 .2 .2', '0 1.1 .5 .2 .2', '0 .5 .5 0 .2', '0 .5 .5', '0 0 0 0 0 0 0', '0 0 0 1 0 1']
        for row in rows:
            with self.subTest(row=row), self.assertRaises(ValueError):
                audit.parse_annotation(row, 2)

    # 빈 라벨 행을 객체로 집계하지 않는지 검사함.
    def test_empty_annotation(self):
        self.assertIsNone(audit.parse_annotation('  ', 2))

    # 클래스 선언 개수와 이름 중복 검증 검사함.
    def test_class_configuration(self):
        self.assertEqual(audit.parse_classes("nc: 2\nnames: ['egg', 'Egg_b']"), ['egg', 'Egg_b'])
        for text in ["nc: 3\nnames: ['egg']", "nc: 2\nnames: ['egg', 'egg']"]:
            with self.assertRaises(ValueError):
                audit.parse_classes(text)

    # 분할 내부 중복과 분할 간 중복 구분 검사함.
    def test_cross_split_duplicates(self):
        result = audit.duplicate_summary({'a': ['train/images/a.jpg', 'valid/images/b.jpg'], 'b': ['train/images/c.jpg', 'train/images/d.jpg']})
        self.assertEqual(result['groups'], 2)
        self.assertEqual(result['cross_split_groups'], 1)
        self.assertEqual(result['cross_split_images'], 2)

    # 혼합 라벨·누락·빈 라벨 집계와 원본 불변 검사함.
    def test_full_metadata_audit_keeps_original(self):
        with tempfile.TemporaryDirectory() as folder:
            source = Path(folder) / 'data.zip'
            with ZipFile(source, 'w') as archive:
                archive.writestr('data.yaml', "nc: 2\nnames: ['egg', 'Egg_b']")
                archive.writestr('train/images/a.jpg', b'original image')
                archive.writestr('train/labels/a.txt', '0 .5 .5 .4 .4\n1 0 0 1 0 0 1\n')
                archive.writestr('valid/images/b.jpg', b'original image')
                archive.writestr('valid/labels/b.txt', '')
                archive.writestr('test/images/c.jpg', b'missing label')
                archive.writestr('test/labels/orphan.txt', '')
            original = source.read_bytes()
            result = audit.inspect_dataset(source)
            self.assertEqual(source.read_bytes(), original)
            self.assertFalse(result['preprocessing_performed'])
            self.assertFalse(result['image_decode_verified'])
            self.assertEqual(result['splits']['train']['objects'], 2)
            self.assertEqual(result['splits']['train']['mixed_format_images'], 1)
            self.assertEqual(result['splits']['valid']['empty_labels'], 1)
            self.assertEqual(result['issues']['missing_labels'], ['test/c'])
            self.assertEqual(result['issues']['orphan_labels'], ['test/orphan'])
            self.assertEqual(result['duplicates']['bytes']['cross_split_groups'], 1)
            self.assertEqual(result['classes'][1]['images']['train'], 1)
            self.assertEqual(result['classes_missing_in_split']['test'], ['egg', 'Egg_b'])
            output = Path(folder) / 'report'
            audit.write_report(result, output)
            self.assertEqual(json.loads((output / 'audit.json').read_text(encoding='utf-8'))['sha256'], result['sha256'])
            self.assertTrue((output / 'class_counts.csv').exists())

    # 압축하지 않은 폴더 입력과 빈 분포 처리 검사함.
    def test_folder_dataset(self):
        with tempfile.TemporaryDirectory() as folder:
            source = Path(folder)
            (source / 'data.yaml').write_text("nc: 1\nnames: ['egg']", encoding='utf-8')
            result = audit.inspect_dataset(source)
            self.assertEqual(result['splits']['train']['images'], 0)
            self.assertIsNone(result['bounding_box_area_ratio'])

    # 원본 데이터와 저장소 내부 결과 저장 차단 검사함.
    def test_report_cannot_overwrite_source_or_repository(self):
        repository = MODULE_PATH.resolve().parents[2]
        result = {'dataset': str(repository), 'classes': []}
        with self.assertRaises(ValueError):
            audit.write_report(result, repository / 'must-not-exist-audit-output')
        with tempfile.TemporaryDirectory() as folder:
            result['dataset'] = folder
            with self.assertRaises(ValueError):
                audit.write_report(result, Path(folder) / 'outputs')

    # 백분위수 보간과 빈 입력 반환 검사함.
    def test_quantiles(self):
        self.assertEqual(audit.quantiles([1, 3])['median'], 2)
        self.assertIsNone(audit.quantiles([]))

    # 승인된 클래스만 통합하고 대상 ID를 연속 부여하는지 검사함.
    def test_explicit_class_mapping(self):
        policy = {'class_mapping': [
            {'source_id': 0, 'source_name': 'Egg_b', 'target_name': 'egg', 'reason': '같은 달걀임'},
            {'source_id': 1, 'source_name': 'egg', 'target_name': 'egg', 'reason': '같은 달걀임'},
            {'source_id': 2, 'source_name': 'garlic', 'target_name': 'garlic', 'reason': '별도 식재료임'},
        ]}
        names, mapping = audit.resolve_mapping(['Egg_b', 'egg', 'garlic'], policy)
        self.assertEqual(names, ['egg', 'garlic'])
        self.assertEqual(mapping, {0: 0, 1: 0, 2: 1})

    # 누락된 매핑과 임의 폴더 경로가 포함된 클래스 이름 거부 검사함.
    def test_invalid_class_mapping(self):
        with self.assertRaises(ValueError):
            audit.resolve_mapping(['egg'], {'class_mapping': []})
        for name in ['../egg', 'Egg', 'egg/garlic', '']:
            with self.subTest(name=name), self.assertRaises(ValueError):
                audit.resolve_mapping(['egg'], {'class_mapping': [
                    {'source_id': 0, 'source_name': 'egg', 'target_name': name, 'reason': '검사함'}]})

    # 폴리곤을 외접 바운딩박스로 바꾸는 좌표 계산 검사함.
    def test_polygon_to_detection(self):
        annotation = audit.parse_annotation('0 .2 .3 .8 .3 .8 .9 .2 .9', 1)
        values = audit.detection_values(annotation, 4)
        self.assertEqual(values[0], 4)
        for actual, expected in zip(values[1:], [.5, .6, .6, .6]):
            self.assertAlmostEqual(actual, expected)

    # 범위를 벗어난 박스를 자르거나 삭제하지 않고 거부하는지 검사함.
    def test_detection_outside_image_rejected(self):
        annotation = audit.parse_annotation('0 .1 .5 .8 .2', 1)
        with self.assertRaises(ValueError):
            audit.detection_values(annotation, 0)

    # test·valid를 보존하고 연결된 train 증강본까지 제외하는지 검사함.
    def test_source_group_leakage_policy(self):
        names = ['train/a.jpg', 'train/a_flip.jpg', 'valid/a.jpg', 'test/b.jpg', 'valid/b.jpg']
        parents = {name: name for name in names}
        audit.join_parents(parents, names[0], names[1])
        audit.join_parents(parents, names[0], names[2])
        audit.join_parents(parents, names[3], names[4])
        excluded = audit.leakage_exclusions(parents)
        self.assertEqual(set(excluded), {names[0], names[1], names[4]})
        self.assertNotIn(names[2], excluded)
        self.assertNotIn(names[3], excluded)

    # 같은 분할의 원본·증강본은 재분할하거나 임의 제거하지 않는지 검사함.
    def test_same_split_variants_retained(self):
        parents = {'train/a.jpg': 'train/a.jpg', 'train/b.jpg': 'train/b.jpg'}
        audit.join_parents(parents, 'train/a.jpg', 'train/b.jpg')
        self.assertEqual(audit.leakage_exclusions(parents), {})

    # 기존 출력 폴더와 저장소 내부 생성을 차단하는지 검사함.
    def test_preparation_output_guard(self):
        with tempfile.TemporaryDirectory() as folder:
            dataset = Path(folder) / 'source.zip'
            with self.assertRaises(ValueError):
                audit.validate_output_path(dataset, Path(folder))
            with self.assertRaises(ValueError):
                audit.validate_output_path(dataset, MODULE_PATH.resolve().parents[2] / 'dataset')

    # ImageFolder 정렬 순서와 YOLO 클래스 순서의 연결 정보 저장 검사함.
    def test_model_class_indices(self):
        with tempfile.TemporaryDirectory() as folder:
            audit.write_class_indices(folder, ['zucchini', 'egg'])
            indices = json.loads((Path(folder) / 'class_indices.json').read_text(encoding='utf-8'))
            self.assertEqual(indices['yolo'], {'zucchini': 0, 'egg': 1})
            self.assertEqual(indices['efficientnet_imagefolder'], {'egg': 0, 'zucchini': 1})

    # 격리 검증에 필요한 최소 파일과 추적 정보를 구성함.
    def create_quarantine_fixture(self, folder):
        root = Path(folder)
        directory = root / 'efficientnet/train/egg'
        directory.mkdir(parents=True)
        (directory / 'small.png').write_bytes(b'small crop bytes')
        (directory / 'normal.png').write_bytes(b'normal crop bytes')
        rows = [{'crop': 'train/egg/small.png', 'split': 'train', 'class_id': 0},
                {'crop': 'train/egg/normal.png', 'split': 'train', 'class_id': 0}]
        audit.write_csv(root / 'crops.csv', rows, ['crop', 'split', 'class_id'])
        audit.write_csv(root / 'class_counts.csv', [{'class_id': 0, 'class_name': 'egg'}], ['class_id', 'class_name'])
        audit.write_csv(root / 'images.csv', [{'image': 'train/images/a.jpg'}], ['image'])
        label = root / 'yolo/train/labels/a.txt'
        label.parent.mkdir(parents=True)
        label.write_text('0 .5 .5 .5 .5\n', encoding='utf-8')
        (root / 'policy.json').write_text('{}', encoding='utf-8')
        report = {'small_crops_review_only': [rows[0]], 'efficientnet_crops': {'train': 2}}
        (root / 'processing_report.json').write_text(json.dumps(report), encoding='utf-8')
        return root, label

    # 승인한 크롭만 격리하고 YOLO 원문·나머지 크롭을 보존하는지 검사함.
    def test_classification_only_quarantine(self):
        with tempfile.TemporaryDirectory() as folder:
            root, label = self.create_quarantine_fixture(folder)
            label_before = label.read_bytes()
            result = audit.quarantine_classification_crops(root, ['train/egg/small.png'])
            self.assertEqual(result['before']['train'], 2)
            self.assertEqual(result['after']['train'], 1)
            self.assertFalse((root / 'efficientnet/train/egg/small.png').exists())
            self.assertEqual((root / 'quarantine/efficientnet/train/egg/small.png').read_bytes(), b'small crop bytes')
            self.assertEqual(label.read_bytes(), label_before)
            self.assertEqual((root / 'efficientnet/train/egg/normal.png').read_bytes(), b'normal crop bytes')
            self.assertEqual(result['quarantined_crops'][0]['yolo_label_review'], 'PENDING_MANUAL_REVIEW')
            self.assertEqual(result['class_changes'][0]['train_quarantined'], 1)
            repeated = audit.quarantine_classification_crops(root, ['train/egg/small.png'])
            self.assertEqual(repeated['after']['train'], 1)

    # 승인 목록에 없는 크롭 요청은 파일 이동 전에 거부하는지 검사함.
    def test_unreviewed_crop_quarantine_rejected(self):
        with tempfile.TemporaryDirectory() as folder:
            root, label = self.create_quarantine_fixture(folder)
            with self.assertRaises(ValueError):
                audit.quarantine_classification_crops(root, ['train/egg/normal.png'])
            self.assertTrue((root / 'efficientnet/train/egg/small.png').exists())
            self.assertTrue((root / 'efficientnet/train/egg/normal.png').exists())

    # 승인된 라벨 변경을 원본과 분리된 버전에만 반영하는지 검사함.
    def test_separate_label_revision_preserves_parent(self):
        import hashlib
        with tempfile.TemporaryDirectory() as folder:
            parent = Path(folder) / 'parent'
            parent.mkdir()
            image_rows, crop_rows, quarantine_rows = [], [], []
            for split, name, rows in [('train', 'a', ['0 .1 .1 .01 .01', '0 .5 .5 .5 .5']),
                                      ('train', 'b', ['0 .1 .1 .01 .01']),
                                      ('valid', 'c', ['0 .5 .5 .5 .5']),
                                      ('test', 'd', ['0 .5 .5 .5 .5'])]:
                image = f'{split}/images/{name}.jpg'
                image_path = parent / 'yolo' / image
                image_path.parent.mkdir(parents=True, exist_ok=True)
                image_path.write_bytes(name.encode())
                label_path = parent / 'yolo' / split / 'labels' / f'{name}.txt'
                label_path.parent.mkdir(parents=True, exist_ok=True)
                label_path.write_text('\n'.join(rows)+'\n', encoding='utf-8')
                image_rows.append({'image': image, 'split': split, 'group': name,
                                   'sha256': hashlib.sha256(name.encode()).hexdigest(), 'objects': len(rows)})
                for line, row in enumerate(rows, 1):
                    crop = f'{split}/egg/{name}_{line}.png'
                    record = {'crop': crop, 'source_image': image, 'source_line': line, 'split': split,
                              'class_id': 0, 'width': 1, 'height': 1, 'box': '[0,0,1,1]', 'pixel_sha256': 'fixture'}
                    if line == 1 and split == 'train':
                        relative = f'quarantine/efficientnet/{crop}'
                        path = parent / relative
                        record.update(quarantine_path=relative, file_sha256=hashlib.sha256(b'crop').hexdigest())
                        quarantine_rows.append(record)
                    else:
                        path = parent / 'efficientnet' / crop
                        crop_rows.append(record)
                    path.parent.mkdir(parents=True, exist_ok=True)
                    path.write_bytes(b'crop')
            audit.write_csv(parent/'images.csv', image_rows, list(image_rows[0]))
            audit.write_csv(parent/'crops.csv', crop_rows, list(crop_rows[0]))
            audit.write_csv(parent/'quarantined_crops.csv', quarantine_rows, list(quarantine_rows[0]))
            audit.write_csv(parent/'excluded_images.csv', [], ['image','split','reason'])
            audit.write_csv(parent/'class_mapping.csv', [], ['source_id','source_name','target_name','reason','target_id'])
            audit.write_csv(parent/'efficientnet_class_changes.csv', [], ['class_id'])
            (parent/'yolo/data.yaml').write_text("nc: 1\nnames: ['egg']", encoding='utf-8')
            for filename, data in [('validation_report.json', {'valid': True}), ('policy.json', {}),
                                   ('classification_quarantine_report.json', {}),
                                   ('processing_report.json', {'source_sha256': 'original',
                                    'small_crops_review_only': quarantine_rows, 'efficientnet_crops': {'train':1,'valid':1,'test':1}})]:
                (parent/filename).write_text(json.dumps(data), encoding='utf-8')
            originals = {path.relative_to(parent): path.read_bytes() for path in parent.rglob('*') if path.is_file()}
            review = {'parent_validation_sha256':hashlib.sha256((parent/'validation_report.json').read_bytes()).hexdigest(),
                      'source_zip_sha256':'original','exclude_yolo_images':['train/images/b.jpg'],
                      'remove_objects':[{'image':f'train/images/{name}.jpg','source_line':1,
                                         'expected_detection_row':'0 .1 .1 .01 .01','reason':'부분 영역 검토함'} for name in ['a','b']]}
            policy_path = Path(folder)/'review.json'
            policy_path.write_text(json.dumps(review), encoding='utf-8')
            output = Path(folder)/'revision'
            result = audit.create_training_revision(parent, output, policy_path)
            self.assertEqual(result['removed_yolo_objects'], 2)
            self.assertEqual(result['yolo_images']['train'], 1)
            self.assertEqual((output/'yolo/train/labels/a.txt').read_text(), '0 .5 .5 .5 .5\n')
            self.assertFalse((output/'yolo/train/images/b.jpg').exists())
            self.assertEqual((output/'quarantine/yolo/train/images/b.jpg').read_bytes(), b'b')
            for name, contents in originals.items():
                self.assertEqual((parent/name).read_bytes(), contents)


if __name__ == '__main__':
    unittest.main()
