import json
import sys
import tempfile
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'ml'))
from config import GpuConfig
from train import classifier_mapping, classification_metrics


class FinetunePreparationTest(unittest.TestCase):
    # 고정 인덱스 검증에 필요한 작은 매핑 폴더를 준비함.
    def mapping_folder(self, root, count=56):
        mapping = {f'old_{i}': i for i in range(51)}
        if count == 56:
            mapping.update(zip(('apple','pear','banana','strawberry','mandarin'),range(51,56)))
        (root/'class_indices.json').write_text(json.dumps({'efficientnet_imagefolder':mapping}))
        return mapping

    # 알파벳 순서와 무관하게 기존 인덱스와 신규 인덱스를 유지함.
    def test_explicit_mapping(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            mapping = self.mapping_folder(root)
            self.assertEqual(classifier_mapping(root),mapping)
            self.assertEqual(mapping['apple'],51)
            self.assertEqual(mapping['old_0'],0)

    # 신규 이름이 올바르더라도 인덱스 순서가 바뀌면 거부함.
    def test_reordered_new_indices(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            mapping = self.mapping_folder(root)
            mapping['apple'],mapping['pear']=52,51
            (root/'class_indices.json').write_text(json.dumps({'efficientnet_imagefolder':mapping}))
            with self.assertRaises(ValueError): classifier_mapping(root)

    # 기존 51클래스 학습 설정도 그대로 허용함.
    def test_baseline_mapping(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            self.mapping_folder(root,51)
            self.assertEqual(len(classifier_mapping(root)),51)

    # 출력층 변경을 기존 학습 재개로 처리하지 못하게 차단함.
    def test_expansion_rejects_resume(self):
        with tempfile.TemporaryDirectory() as directory:
            root=Path(directory); checkpoint=root/'best.pt'; checkpoint.touch()
            config=GpuConfig('efficientnet',dataset=root/'data',weights=root/'weights',output=root/'runs',
                             resume=checkpoint,init_checkpoint=checkpoint,init_sha256='a'*64)
            with self.assertRaises(ValueError): config.validate()

    # 초기 파일 해시가 없으면 체크포인트 확장을 차단함.
    def test_expansion_requires_sha(self):
        with tempfile.TemporaryDirectory() as directory:
            root=Path(directory); checkpoint=root/'best.pt'; checkpoint.touch()
            config=GpuConfig('efficientnet',dataset=root/'data',weights=root/'weights',output=root/'runs',init_checkpoint=checkpoint)
            with self.assertRaises(ValueError): config.validate()

    # 학습 결과가 기존 서비스 가중치 폴더를 덮어쓰지 못하게 차단함.
    def test_protected_checkpoint_output(self):
        with tempfile.TemporaryDirectory() as directory:
            root=Path(directory); checkpoint=root/'service'/'best.pt'; checkpoint.parent.mkdir(); checkpoint.touch()
            config=GpuConfig('efficientnet',dataset=root/'data',weights=root/'weights',output=root/'service'/'runs',
                             init_checkpoint=checkpoint,init_sha256='a'*64)
            with self.assertRaises(ValueError): config.validate()

    # 56개 전체 출력과 신규 클래스 오분류를 지표에 포함함.
    def test_metrics_include_new_classes(self):
        result=classification_metrics([0,51,55],[0,52,55],[[0,1,2],[52,51,0],[55,51,0]],56)
        self.assertAlmostEqual(result['top1'],2/3)
        self.assertEqual(result['top3'],1)
        self.assertEqual(len(result['per_class_f1']),56)
        self.assertEqual(result['per_class_f1'][51],0)
        self.assertEqual(result['old_macro_f1'],1)
        self.assertEqual(result['new_macro_f1'],0.5)
        self.assertEqual(result['per_class_support'][55],1)


class StageSixPreparationTest(unittest.TestCase):
    # 기존 클래스 감시에 사용할 작은 Validation 기준을 준비함.
    def baseline(self):
        return {'split': 'valid', 'class_count': 51, 'checkpoint_sha256': 'a'*64,
                'selection_allowed': True, 'old_top1': .81, 'old_macro_f1': .80,
                'per_class_recall': [.8]*51, 'per_class_support': [20]*51}

    # 예비 확장 설정에 필요한 파일만 임시 폴더에 준비함.
    def preliminary_config(self, root, **overrides):
        checkpoint = root/'service'/'best.pt'; checkpoint.parent.mkdir(); checkpoint.touch()
        baseline = root/'baseline.json'; baseline.write_text(json.dumps(self.baseline()))
        values = dict(model='efficientnet', dataset=root/'data', weights=root/'weights',
                      output=root/'runs', init_checkpoint=checkpoint, init_sha256='a'*64,
                      baseline_report=baseline, preliminary=True, epochs=3)
        values.update(overrides)
        return GpuConfig(**values)

    # 예비 설정은 최대 3에포크의 새 확장 실험으로만 허용함.
    def test_preliminary_config_and_epoch_cap(self):
        from dataclasses import replace
        with tempfile.TemporaryDirectory() as directory:
            config = self.preliminary_config(Path(directory))
            self.assertTrue(config.validate().preliminary)
            with self.assertRaises(ValueError): replace(config, epochs=4).validate()
            with self.assertRaises(ValueError): replace(config, init_checkpoint=None).validate()

    # 신규 독립 검증이 없어도 명시한 예비 준비만 통과함.
    def test_preliminary_readiness_keeps_formal_gate_closed(self):
        from dataclasses import replace
        from train import validate_training_readiness
        with tempfile.TemporaryDirectory() as directory:
            config = self.preliminary_config(Path(directory))
            validation = dict(class_count=56, cross_split_image_hash_groups=0,
                              cross_split_source_groups=0, cross_split_crop_hash_groups=0,
                              training_ready=False, new_independent_validation=0)
            result = validate_training_readiness(config, validation)
            self.assertEqual(result['mode'], 'PRELIMINARY_NOT_DEPLOYABLE')
            self.assertFalse(result['dataset_training_ready'])
            with self.assertRaises(ValueError): validate_training_readiness(replace(config, preliminary=False), validation)
            validation['cross_split_source_groups'] = 1
            with self.assertRaises(ValueError): validate_training_readiness(config, validation)

    # Holdout 지표를 기존 성능 기준으로 재사용하지 못하게 차단함.
    def test_retention_baseline_rejects_holdout(self):
        from train import load_retention_baseline
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory)/'baseline.json'
            baseline = self.baseline(); baseline['split'] = 'holdout'
            path.write_text(json.dumps(baseline))
            with self.assertRaises(ValueError): load_retention_baseline(path, 'a'*64)

    # 기존 모델과 다른 체크포인트 기준을 차단함.
    def test_retention_baseline_checkpoint_binding(self):
        from train import load_retention_baseline
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory)/'baseline.json'; path.write_text(json.dumps(self.baseline()))
            self.assertEqual(load_retention_baseline(path, 'a'*64)['class_count'], 51)
            with self.assertRaises(ValueError): load_retention_baseline(path, 'b'*64)

    # 신규 검증 표본이 없는 클래스를 성능 0점으로 확정하지 않음.
    def test_missing_new_validation_is_not_measured(self):
        result = classification_metrics([0,1], [0,1], [[0,2,3],[1,2,3]], 56)
        self.assertEqual(result['new_class_evaluation_status'], 'NOT_MEASURED')
        self.assertIsNone(result['new_macro_f1'])
        self.assertIsNone(result['per_class_recall'][51])
        self.assertEqual(result['missing_new_validation_indices'], list(range(51,56)))

    # 일부 신규 클래스만 있으면 전체 신규 평가와 구분함.
    def test_partial_new_class_coverage(self):
        result = classification_metrics([51], [51], [[51,1,2]], 56)
        self.assertEqual(result['new_class_evaluation_status'], 'PARTIAL_COVERAGE')
        self.assertEqual(result['per_class_precision'][51], 1)
        self.assertEqual(result['per_class_recall'][51], 1)

    # 기존 클래스 Top-1과 Macro-F1 하락을 동시에 감시함.
    def test_retention_guard_rejects_aggregate_drop(self):
        from train import retention_guard
        metrics = dict(old_top1=.80, old_macro_f1=.79,
                       per_class_recall=[.8]*51, per_class_support=[20]*51)
        self.assertTrue(retention_guard(metrics, self.baseline())['eligible'])
        metrics['old_top1'] = .78
        self.assertIn('old_top1', retention_guard(metrics, self.baseline())['reasons'])

    # 전체 지표가 유지돼도 표본이 충분한 특정 클래스 하락을 차단함.
    def test_retention_guard_rejects_recall_drop(self):
        from train import retention_guard
        metrics = dict(old_top1=.81, old_macro_f1=.80,
                       per_class_recall=[.8]*51, per_class_support=[20]*51)
        metrics['per_class_recall'][4] = .69
        self.assertIn('old_recall_4', retention_guard(metrics, self.baseline())['reasons'])

    # 검증 표본이 사라진 기존 클래스를 정상 성능으로 간주하지 않음.
    def test_retention_guard_rejects_missing_support(self):
        from train import retention_guard
        metrics = dict(old_top1=.81, old_macro_f1=.80,
                       per_class_recall=[.8]*51, per_class_support=[20]*51)
        metrics['per_class_support'][4] = 0
        self.assertFalse(retention_guard(metrics, self.baseline())['eligible'])

    # EXIF 회전을 Flask와 같은 방향으로 보정하고 원본 해시를 유지함.
    def test_exif_orientation_matches_service(self):
        import hashlib
        from PIL import Image
        from train import classification_image_loader
        from mealfit_ai.services.ingredient_classifier import read_image
        with tempfile.TemporaryDirectory() as directory:
            for orientation in (2,3,6,8):
                image = Image.new('RGB', (24,12), 'red'); image.paste('blue',(0,0,12,6))
                exif = Image.Exif(); exif[274] = orientation
                path = Path(directory)/f'image_{orientation}.jpg'; image.save(path,exif=exif)
                raw = path.read_bytes(); expected = hashlib.sha256(raw).hexdigest()
                loaded = classification_image_loader(path); service = read_image(raw)
                self.assertEqual(loaded.mode, 'RGB')
                self.assertEqual(loaded.size, service.size)
                self.assertEqual(loaded.tobytes(), service.tobytes())
                self.assertEqual(hashlib.sha256(path.read_bytes()).hexdigest(), expected)
                self.assertNotIn(274, loaded.getexif())

    # 방향 정보가 없는 RGB 이미지는 크기와 픽셀을 유지함.
    def test_no_exif_preserves_rgb(self):
        from PIL import Image
        from train import classification_image_loader
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory)/'plain.png'; image = Image.new('RGB',(31,17),(3,9,27)); image.save(path)
            loaded = classification_image_loader(path)
            self.assertEqual(loaded.size, image.size)
            self.assertEqual(loaded.tobytes(), image.tobytes())

    # 흑백과 투명 PNG도 기존 3채널 입력 규칙으로 읽음.
    def test_grayscale_and_rgba_become_rgb(self):
        from PIL import Image
        from train import classification_image_loader
        with tempfile.TemporaryDirectory() as directory:
            for mode, value in [('L',70),('RGBA',(10,20,30,0))]:
                path = Path(directory)/(mode+'.png'); image=Image.new(mode,(9,13),value); image.save(path)
                loaded=classification_image_loader(path)
                self.assertEqual(loaded.mode,'RGB'); self.assertEqual(loaded.size,(9,13))
                self.assertEqual(loaded.tobytes(),image.convert('RGB').tobytes())

    # 이미지 폴더가 고정 인덱스와 공통 EXIF 로더를 사용함을 검사함.
    def test_imagefolder_uses_shared_loader(self):
        from types import ModuleType
        from unittest.mock import patch
        from train import mapped_imagefolder, classification_image_loader
        class FakeImageFolder:
            # 실제 프레임워크 없이 로더 인자와 클래스 탐색만 기록함.
            def __init__(self,path,transform,loader,allow_empty):
                self.loader=loader; self.class_to_idx=self.find_classes(path)[1]
        datasets=ModuleType('torchvision.datasets'); datasets.ImageFolder=FakeImageFolder
        with tempfile.TemporaryDirectory() as directory, patch.dict(sys.modules,{'torchvision.datasets':datasets}):
            root=Path(directory); (root/'apple').mkdir()
            dataset=mapped_imagefolder(root,{'apple':51})
            self.assertIs(dataset.loader,classification_image_loader)
            self.assertEqual(dataset.class_to_idx,{'apple':51})

    # Holdout이 없으면 모델 라이브러리를 읽기 전에 실행을 차단함.
    def test_holdout_missing_manifest_blocks(self):
        from types import SimpleNamespace
        from evaluate import validate_evaluation_request
        args=SimpleNamespace(model='efficientnet',split='holdout',manifest=None)
        with self.assertRaises(ValueError): validate_evaluation_request(args)

    # 기존 Validation에 외부 진단 파일을 혼합하지 못하게 차단함.
    def test_validation_rejects_external_manifest(self):
        from types import SimpleNamespace
        from evaluate import validate_evaluation_request
        with self.assertRaises(ValueError):
            validate_evaluation_request(SimpleNamespace(model='efficientnet',split='valid',manifest=Path('external.csv')))

    # 외부 진단 결과는 모델 선정·최종 성능 확정에 사용하지 않음.
    def test_diagnostic_is_not_final_holdout(self):
        from types import SimpleNamespace
        from evaluate import validate_evaluation_request
        with tempfile.TemporaryDirectory() as directory:
            manifest=Path(directory)/'diagnostic.csv';manifest.touch()
            result=validate_evaluation_request(SimpleNamespace(model='efficientnet',split='diagnostic',manifest=manifest))
            self.assertFalse(result['selection_allowed'])
            self.assertFalse(result['final_performance_claim_allowed'])

    # 승인된 Holdout도 파일과 모델 지문이 바뀌면 차단함.
    def test_holdout_approval_binds_manifest_checkpoint_and_ledger(self):
        from types import SimpleNamespace
        from evaluate import digest,validate_evaluation_request
        with tempfile.TemporaryDirectory() as directory:
            root=Path(directory); manifest=root/'holdout.csv';manifest.write_text('fixture')
            checkpoint=root/'selected.pt';checkpoint.write_bytes(b'fixture-only')
            approval=root/'approval.json'
            approval.write_text(json.dumps(dict(approved=True,purpose='final_holdout',independence_review_complete=True,
                not_for_model_selection=True,manifest_sha256=digest(manifest),checkpoint_sha256=digest(checkpoint))))
            args=SimpleNamespace(model='efficientnet',split='holdout',manifest=manifest,checkpoint=checkpoint,
                                 holdout_approval=approval,holdout_ledger=root/'ledger')
            result=validate_evaluation_request(args);self.assertFalse(result['selection_allowed'])
            marker=Path(result['ledger_marker']);marker.parent.mkdir();marker.touch()
            with self.assertRaises(ValueError):validate_evaluation_request(args)
            marker.unlink();checkpoint.write_bytes(b'changed')
            with self.assertRaises(ValueError):validate_evaluation_request(args)

    # 외부 이미지 목록과 실제 파일을 작은 시험 이미지로 준비함.
    def external_fixture(self,root,split='diagnostic',**overrides):
        import csv,hashlib
        from PIL import Image
        from types import SimpleNamespace
        image=root/'image.png';Image.new('RGB',(8,9),'red').save(image)
        row=dict(path=str(image),class_name='apple',source='Fixture',specimen_group='item_1',
                 capture_group='session_1',split=split,sha256=hashlib.sha256(image.read_bytes()).hexdigest(),
                 license='CC BY 4.0',independence_status='CONDITIONAL',previously_diagnosed='true',condition='fresh')
        row.update(overrides)
        manifest=root/'external.csv'
        with manifest.open('w',newline='',encoding='utf-8') as stream:
            writer=csv.DictWriter(stream,fieldnames=list(row));writer.writeheader();writer.writerow(row)
        return SimpleNamespace(dataset=root/'base',manifest=manifest,split=split)

    # 외부 진단은 조건부 출처·실물·촬영 그룹을 유지함.
    def test_external_diagnostic_preserves_groups(self):
        from evaluate import external_evaluation_records
        with tempfile.TemporaryDirectory() as directory:
            args=self.external_fixture(Path(directory))
            rows=external_evaluation_records(args,{'apple':51})
            self.assertEqual(rows[0]['specimen_group'],'item_1')
            self.assertEqual(rows[0]['capture_group'],'session_1')

    # 반복 진단 사진과 조건부 독립성 자료를 Holdout으로 승격하지 않음.
    def test_holdout_rejects_diagnostic_photos(self):
        from evaluate import external_evaluation_records
        with tempfile.TemporaryDirectory() as directory:
            args=self.external_fixture(Path(directory),'holdout')
            with self.assertRaises(ValueError):external_evaluation_records(args,{'apple':51})

    # 파일이 바뀌거나 미지원 클래스가 있으면 외부 평가를 차단함.
    def test_external_manifest_rejects_wrong_hash_and_class(self):
        from evaluate import external_evaluation_records
        with tempfile.TemporaryDirectory() as directory:
            args=self.external_fixture(Path(directory),sha256='b'*64)
            with self.assertRaises(ValueError):external_evaluation_records(args,{'apple':51})
            args=self.external_fixture(Path(directory),class_name='unknown')
            with self.assertRaises(ValueError):external_evaluation_records(args,{'apple':51})

    # 출처별·실물별·촬영 그룹별 지표를 구분해 계산함.
    def test_classification_slice_reports(self):
        from evaluate import classification_slices
        names=[f'old_{i}' for i in range(51)]+['apple','pear','banana','strawberry','mandarin']
        rows=[dict(actual='apple',predicted='apple',top3=json.dumps(['apple','pear','old_0']),
                   source='FruitLife',specimen_group='apple_01',capture_group='FruitLife_block',condition='fresh'),
              dict(actual='apple',predicted='pear',top3=json.dumps(['pear','apple','old_0']),
                   source='FruitLife',specimen_group='apple_01',capture_group='FruitLife_block',condition='browning')]
        result=classification_slices(rows,names)
        self.assertEqual(result['source']['FruitLife']['samples'],2)
        self.assertEqual(result['source']['FruitLife']['specimen_groups'],1)
        self.assertEqual(result['specimen_group']['apple_01']['top1'],.5)
        self.assertEqual(result['capture_group']['FruitLife_block']['capture_groups'],1)
        self.assertIn('browning',result['condition'])


    # 유한하지 않은 지표가 성능 감시를 통과하지 못하게 차단함.
    def test_retention_guard_rejects_nonfinite_metrics(self):
        from train import retention_guard
        metrics=dict(old_top1=float('nan'),old_macro_f1=.8,
                     per_class_recall=[.8]*51,per_class_support=[20]*51)
        self.assertFalse(retention_guard(metrics,self.baseline())['eligible'])

    # 헤더만 있고 실제 사진이 없는 외부 평가 목록을 차단함.
    def test_empty_external_manifest_blocks(self):
        from types import SimpleNamespace
        from evaluate import external_evaluation_records
        with tempfile.TemporaryDirectory() as directory:
            root=Path(directory);manifest=root/'empty.csv';manifest.write_text('path,class_name')
            args=SimpleNamespace(dataset=root/'base',manifest=manifest,split='holdout')
            with self.assertRaises(ValueError):external_evaluation_records(args,{'apple':51})


    # 경로만 다른 동일 사진을 외부 평가에서 중복 집계하지 않음.
    def test_external_manifest_rejects_duplicate_image_bytes(self):
        import csv
        from evaluate import external_evaluation_records
        with tempfile.TemporaryDirectory() as directory:
            root=Path(directory);args=self.external_fixture(root)
            with args.manifest.open(encoding='utf-8-sig',newline='') as stream:rows=list(csv.DictReader(stream))
            other=root/'same_image.png';other.write_bytes((root/'image.png').read_bytes())
            rows.append(dict(rows[0],path=str(other),specimen_group='incorrect_second_id'))
            with args.manifest.open('w',newline='',encoding='utf-8') as stream:
                writer=csv.DictWriter(stream,fieldnames=list(rows[0]));writer.writeheader();writer.writerows(rows)
            with self.assertRaises(ValueError):external_evaluation_records(args,{'apple':51})

    # 큰 EXIF 이미지도 방향과 RGB를 맞추되 기존 크기 제한 방식을 유지함.
    def test_large_exif_preserves_each_loader_resize_policy(self):
        from PIL import Image
        from train import classification_image_loader
        from mealfit_ai.services.ingredient_classifier import read_image
        with tempfile.TemporaryDirectory() as directory:
            path=Path(directory)/'large.jpg';exif=Image.Exif();exif[274]=6
            Image.new('RGB',(1200,1800),(10,20,30)).save(path,exif=exif)
            ml=classification_image_loader(path);service=read_image(path.read_bytes())
            self.assertEqual(ml.size,(1800,1200))
            self.assertEqual(max(service.size),1024)
            self.assertGreater(service.width,service.height)
            self.assertEqual(ml.mode,service.mode)



class PartialFinetunePolicyTest(unittest.TestCase):
    # 기존 시험용 설정을 재사용해 새 실험 정책을 준비함.
    def fixture(self, root, **values):
        return StageSixPreparationTest().preliminary_config(root, **values)

    # 기존 예비 실행의 기본값을 유지함.
    def test_legacy_defaults_preserved(self):
        with tempfile.TemporaryDirectory() as directory:
            config = self.fixture(Path(directory))
            self.assertEqual(config.finetune_scope, 'head')
            self.assertEqual(config.class_sampling, 'shuffle')
            self.assertEqual(config.class_loss, 'inverse_sqrt')
            self.assertIsNone(config.early_stopping_patience)
            config.validate()

    # 부분 학습률이 출력층보다 작을 때만 허용함.
    def test_partial_learning_rate_constraints(self):
        from dataclasses import replace
        with tempfile.TemporaryDirectory() as directory:
            config = self.fixture(Path(directory), finetune_scope='last_block',
                                  learning_rate=1e-4, backbone_learning_rate=1e-5)
            config.validate()
            for rate in (None, 0, -1, 1e-4, float('nan'), float('inf')):
                with self.subTest(rate=rate), self.assertRaises(ValueError):
                    replace(config, backbone_learning_rate=rate).validate()

    # 균형 샘플링과 손실 가중치의 중복 보정을 차단함.
    def test_sampling_rejects_double_weighting(self):
        from dataclasses import replace
        with tempfile.TemporaryDirectory() as directory:
            config = self.fixture(Path(directory), class_sampling='balanced')
            with self.assertRaises(ValueError): config.validate()
            replace(config, class_loss='none').validate()

    # 정의하지 않은 정책과 조기 종료 설정을 거부함.
    def test_invalid_experiment_policies(self):
        from dataclasses import replace
        with tempfile.TemporaryDirectory() as directory:
            config = self.fixture(Path(directory))
            for values in ({'finetune_scope':'all'}, {'class_sampling':'source_guess'},
                           {'class_loss':'unknown'}, {'selection_metric':'diagnostic_accuracy'},
                           {'backbone_learning_rate':1e-5}, {'early_stopping_patience':0},
                           {'early_stopping_patience':4}, {'early_stopping_patience':True},
                           {'early_stopping_min_delta':float('nan')}, {'early_stopping_min_delta':-1}):
                with self.subTest(values=values), self.assertRaises(ValueError):
                    replace(config, **values).validate()

    # 신규 검증이 없으면 복합 점수 선정을 차단함.
    def test_joint_selection_requires_independent_validation(self):
        from train import validate_training_readiness
        with tempfile.TemporaryDirectory() as directory:
            config = self.fixture(Path(directory), selection_metric='balanced_old_new_macro_f1')
            validation = dict(class_count=56, cross_split_image_hash_groups=0,
                cross_split_source_groups=0, cross_split_crop_hash_groups=0, new_independent_validation=0)
            with self.assertRaises(ValueError): validate_training_readiness(config, validation)

    # 실제 표본이 모두 있을 때만 기존·신규 점수를 균등 집계함.
    def test_joint_selection_requires_complete_class_coverage(self):
        from dataclasses import replace
        from train import classifier_selection_score
        with tempfile.TemporaryDirectory() as directory:
            config = self.fixture(Path(directory), selection_metric='balanced_old_new_macro_f1')
            metrics = dict(new_class_evaluation_status='MEASURED',per_class_support=[20]*56,
                           old_macro_f1=.8,new_macro_f1=.4)
            name, score = classifier_selection_score(config, metrics, 'old_macro_f1')
            self.assertEqual(name,'balanced_old_new_macro_f1')
            self.assertAlmostEqual(score,.6)
            for values in ({'new_class_evaluation_status':'PARTIAL_COVERAGE'},
                           {'per_class_support':[20]*55+[0]}, {'new_macro_f1':None}):
                with self.subTest(values=values), self.assertRaises(ValueError):
                    classifier_selection_score(config,dict(metrics,**values),'old_macro_f1')
            self.assertEqual(classifier_selection_score(replace(config,selection_metric='old_macro_f1'),
                metrics,'old_macro_f1'),('old_macro_f1',.8))


import importlib.util


@unittest.skipUnless(importlib.util.find_spec('torch') is not None, '학습 전용 환경에서 실행하는 텐서 검사임')
class PartialFinetuneTensorTest(unittest.TestCase):
    # 다운로드 없이 작은 합성 모델로 블록·정규화 동작을 검증함.
    def tiny_model(self):
        import torch
        from torch import nn

        class Tiny(nn.Module):
            # 앞 블록·마지막 블록·출력층을 구분해 구성함.
            def __init__(self):
                super().__init__()
                self.stem = nn.Conv2d(3,4,1)
                self.blocks = nn.Sequential(nn.Sequential(nn.Conv2d(4,4,1),nn.BatchNorm2d(4)),
                    nn.Sequential(nn.Conv2d(4,4,1),nn.BatchNorm2d(4),nn.Dropout(.2)))
                self.conv_head = nn.Conv2d(4,4,1)
                self.classifier = nn.Linear(4,56)

            # 출력층만 반환함.
            def get_classifier(self):
                return self.classifier

            # 합성 입력을 분류 로짓으로 변환함.
            def forward(self, x):
                return self.classifier(self.conv_head(self.blocks(self.stem(x))).mean((2,3)))

        with torch.random.fork_rng(devices=[]):
            torch.manual_seed(42)
            return Tiny()

    # 마지막 블록과 출력층만 서로 다른 학습률로 준비함.
    def test_partial_parameter_groups(self):
        from train import classifier_parameter_groups
        with tempfile.TemporaryDirectory() as directory:
            config = StageSixPreparationTest().preliminary_config(Path(directory),
                finetune_scope='last_block',learning_rate=1e-4,backbone_learning_rate=1e-5)
            model = self.tiny_model()
            groups = classifier_parameter_groups(model, config)
            self.assertEqual([g['lr'] for g in groups],[1e-4,1e-5])
            expected = {'blocks.1.0.weight','blocks.1.0.bias','classifier.weight','classifier.bias'}
            self.assertEqual({n for n,p in model.named_parameters() if p.requires_grad},expected)
            self.assertEqual(len({id(p) for g in groups for p in g['params']}),4)

    # 출력층 기본 정책은 특징 추출층을 모두 고정함.
    def test_head_only_policy(self):
        from train import classifier_parameter_groups,classifier_training_mode
        with tempfile.TemporaryDirectory() as directory:
            config = StageSixPreparationTest().preliminary_config(Path(directory))
            model = self.tiny_model()
            classifier_parameter_groups(model,config);classifier_training_mode(model,config)
            self.assertEqual({n for n,p in model.named_parameters() if p.requires_grad},
                             {'classifier.weight','classifier.bias'})
            self.assertFalse(model.blocks[-1].training)
            self.assertTrue(model.classifier.training)

    # 부분 학습의 역전파 경로와 BatchNorm 보존을 가중치 갱신 없이 검증함.
    def test_partial_gradients_and_batchnorm_preservation(self):
        import torch
        from train import classifier_parameter_groups,classifier_training_mode
        with tempfile.TemporaryDirectory() as directory:
            config = StageSixPreparationTest().preliminary_config(Path(directory),
                finetune_scope='last_block',learning_rate=1e-4,backbone_learning_rate=1e-5)
            model = self.tiny_model()
            classifier_parameter_groups(model,config);classifier_training_mode(model,config)
            saved = {n:t.clone() for n,t in model.state_dict().items()}
            self.assertTrue(model.blocks[-1].training)
            self.assertFalse(model.blocks[-1][1].training)
            model(torch.ones(2,3,8,8)).sum().backward()
            self.assertIsNotNone(model.blocks[-1][0].weight.grad)
            self.assertIsNone(model.stem.weight.grad)
            self.assertIsNone(model.blocks[-1][1].weight.grad)
            self.assertTrue(all(torch.equal(saved[n],t) for n,t in model.state_dict().items()))

    # 균형 샘플러의 클래스 질량과 고정 시드 재현성을 확인함.
    def test_balanced_sampling_and_determinism(self):
        import torch
        from train import classification_sampling
        with tempfile.TemporaryDirectory() as directory:
            config = StageSixPreparationTest().preliminary_config(Path(directory),
                class_sampling='balanced',class_loss='none')
            targets = [0]*100+[1]*10
            sampler,criterion = classification_sampling(config,targets,2,torch.Generator().manual_seed(42))
            again,_ = classification_sampling(config,targets,2,torch.Generator().manual_seed(42))
            self.assertAlmostEqual(float(sampler.weights[:100].sum()),float(sampler.weights[100:].sum()))
            self.assertEqual(list(sampler),list(again))
            self.assertEqual(sampler.num_samples,len(targets))
            self.assertIsNone(criterion.weight)

    # 메타데이터와 달리 실제 신규 검증 표본이 빠졌으면 학습 준비에서 차단함.
    def test_joint_loader_checks_actual_targets_before_training(self):
        from types import SimpleNamespace
        from unittest.mock import patch
        from train import full_classification_loaders
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root/'data').mkdir()
            FinetunePreparationTest().mapping_folder(root/'data')
            config = StageSixPreparationTest().preliminary_config(root,
                selection_metric='balanced_old_new_macro_f1')
            fake_train = SimpleNamespace(targets=list(range(56)))
            incomplete_valid = SimpleNamespace(targets=list(range(55)))
            with patch('train.mapped_imagefolder',side_effect=[fake_train,incomplete_valid]):
                with self.assertRaisesRegex(ValueError,'실제 Validation'):
                    full_classification_loaders(config,self.tiny_model())

    # 기존 손실 가중치 정책과 빈 클래스 차단을 유지함.
    def test_default_loss_weights_and_empty_class(self):
        import torch
        from train import classification_sampling
        with tempfile.TemporaryDirectory() as directory:
            config = StageSixPreparationTest().preliminary_config(Path(directory))
            sampler,criterion = classification_sampling(config,[0]*9+[1],2,torch.Generator())
            self.assertIsNone(sampler)
            self.assertAlmostEqual(float(criterion.weight[1]/criterion.weight[0]),3.)
            with self.assertRaises(ValueError):classification_sampling(config,[0],2,torch.Generator())



class ClassifierSelectionSafetyTest(unittest.TestCase):
    # 안전성 탈락 모델은 점수가 높아도 선정하지 않음.
    def test_guard_failure_cannot_win_and_counts_toward_stop(self):
        from train import classifier_selection_decision
        with tempfile.TemporaryDirectory() as directory:
            config = StageSixPreparationTest().preliminary_config(Path(directory),early_stopping_patience=2)
            result = classifier_selection_decision(config,dict(old_macro_f1=.99),
                dict(eligible=False,selection_metric='old_macro_f1'),.8,1)
            self.assertFalse(result['improved'])
            self.assertEqual(result['best_score'],.8)
            self.assertTrue(result['should_stop'])

    # 최소 개선량과 대기 횟수 초기화를 실제 선정 점수에 적용함.
    def test_min_delta_and_patience_reset(self):
        from train import classifier_selection_decision
        with tempfile.TemporaryDirectory() as directory:
            config = StageSixPreparationTest().preliminary_config(Path(directory),
                early_stopping_patience=2,early_stopping_min_delta=.001)
            guard = dict(eligible=True,selection_metric='old_macro_f1')
            small = classifier_selection_decision(config,dict(old_macro_f1=.8005),guard,.8,0)
            self.assertFalse(small['improved']);self.assertFalse(small['should_stop'])
            better = classifier_selection_decision(config,dict(old_macro_f1=.802),guard,.8,1)
            self.assertTrue(better['improved']);self.assertEqual(better['stale_epochs'],0)
            self.assertFalse(better['should_stop'])

    # 기존 설정은 개선이 없더라도 새 조기 종료를 적용하지 않음.
    def test_default_selection_does_not_stop_legacy_run(self):
        from train import classifier_selection_decision
        with tempfile.TemporaryDirectory() as directory:
            config = StageSixPreparationTest().preliminary_config(Path(directory))
            result = classifier_selection_decision(config,dict(old_macro_f1=.7),
                dict(eligible=True,selection_metric='old_macro_f1'),.8,10)
            self.assertFalse(result['should_stop'])
