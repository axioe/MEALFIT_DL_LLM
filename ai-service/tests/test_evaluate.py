import importlib.util
import unittest
from pathlib import Path, PurePosixPath

SOURCE=Path(__file__).resolve().parents[1]/'ml/evaluate.py'
spec=importlib.util.spec_from_file_location('validation_evaluate',SOURCE)
audit=importlib.util.module_from_spec(spec)
spec.loader.exec_module(audit)


class ValidationEvaluationTest(unittest.TestCase):
    # Python 버전별 경로 메타데이터 호환을 검사함.
    def test_path_compatibility(self):
        import io
        loader=audit.CompatibleUnpickler(io.BytesIO())
        self.assertIs(loader.find_class('pathlib._local','PosixPath'),PurePosixPath)
        self.assertIs(loader.find_class('pathlib','PosixPath'),PurePosixPath)

    # 위치가 같은 타 클래스 예측을 혼동으로 연결함.
    def test_class_confusion(self):
        matches,missing,extra=audit.match_objects([{'class':0,'box':[0,0,10,10]}],
                                                  [{'class':1,'box':[0,0,10,10]}])
        self.assertEqual(matches,[(0,0,1.0)])
        self.assertEqual((missing,extra),([],[]))

    # 같은 객체의 중복 탐지는 하나만 정답에 연결함.
    def test_duplicate_detection(self):
        gt=[{'box':[0,0,10,10]}]
        matches,missing,extra=audit.match_objects(gt,[{'box':[0,0,10,10]},{'box':[0,0,10,10]}])
        self.assertEqual(len(matches),1)
        self.assertEqual(len(extra),1)
        self.assertFalse(missing)

    # 겹치지 않는 객체를 미탐과 오탐으로 구분함.
    def test_unmatched(self):
        matches,missing,extra=audit.match_objects([{'box':[0,0,10,10]}],[{'box':[20,20,30,30]}])
        self.assertEqual((matches,missing,extra),([],[0],[0]))

    # 예측과 정답이 없는 경계값을 검사함.
    def test_empty(self):
        self.assertEqual(audit.match_objects([],[]),([],[],[]))


if __name__=='__main__':
    unittest.main()
