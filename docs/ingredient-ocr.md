# 상품 라벨 OCR 보조 인식

기존 EfficientNet Top-3는 유지하고 사진 인식 응답의 선택 필드 `ocr`로 라벨 후보를 분리함.
문자 신뢰도는 분류 확률과 합산하지 않으며, 사용자 확인 후 기존 입고 API로만 저장함.
공용 재료 정규화 사전·표준 식재료 ID·영수증 품목 추출·바코드는 이번 구현에서 제외함.

## 실행 환경

Python 3.12, PaddleOCR 3.3.2, PaddlePaddle 3.2.2, PaddleX 3.3.13을 별도 OCR 환경에서 검증함.
Flask의 기존 실행 환경과 EfficientNet 의존성은 유지함.

```powershell
cd D:\MEALFIT_DL_LLM\ai-service
$env:OCR_PYTHON='D:\MealFit_ocr_env\Scripts\python.exe'
$env:OCR_DET_MODEL_DIR='D:\MealFit_ocr_models\ppocr_v3\det'
$env:OCR_REC_MODEL_DIR='D:\MealFit_ocr_models\ppocr_v3\rec'
D:\MealFit_ml_env\Scripts\python.exe app.py
```

다른 PC는 승인 후 `requirements-ocr.txt`로 별도 환경을 설치하고 아래 공식 모델을 별도 저장함.
서비스는 지정한 로컬 모델만 사용하며 요청 중 자동 다운로드하지 않음.
설정이 없거나 초기 로딩 중이면 `UNAVAILABLE`로 반환하고 기존 Top-3를 유지함.
초기 로딩은 요청 밖에서 최대 45초, 준비 후 OCR 처리는 최대 8초로 제한함.
시간 초과 시 OCR 워커를 종료하며 다음 준비 재시도에는 30초 간격을 둠.
Spring 연결 3초·읽기 20초는 유지함. DL 초기 로딩·CPU 부하에 따른 전체 지연은 별도로 확인해야 함.

## 응답

`POST /ai/vision/ingredients`, `POST /api/v1/inventory/recognitions/photo`의 기존 필드를 유지함.

```json
{
  "modelVersion": "efficientnet-b0-stage3-epoch19",
  "candidates": [
    {"className": "paprika", "confidence": 0.837, "mappingStatus": "UNMAPPED"},
    {"className": "pork", "confidence": 0.039, "mappingStatus": "UNMAPPED"},
    {"className": "squid", "confidence": 0.032, "mappingStatus": "UNMAPPED"}
  ],
  "ocr": {
    "status": "SUCCESS",
    "candidates": [{"ingredientName": "토마토", "textConfidence": 0.9998}],
    "elapsedMs": 4385
  }
}
```

DL 후보는 기존대로 세 개이며 `mappingStatus`는 Spring 응답에서만 추가함.
OCR 상태: SUCCESS, NO_TEXT, NO_MATCH, TIMEOUT, UNAVAILABLE, ERROR.
OCR 필드가 없는 이전 응답도 허용함. 손상된 OCR 필드만 ERROR로 처리하고 검증된 DL 결과는 보존함.
동일 식재료가 두 출처에 있어도 각 출처에서 표시하며 확률을 합치지 않음.

## 검증과 한계

제공된 저해상도 사진 중 비닐 포장 토마토는 라벨 후보 추출에 성공함.
플라스틱 토마토·포장 당근·상추/깻잎 사진은 글자를 일부 읽었지만 재료명 추출에는 실패함.
비포장 토마토는 NO_TEXT이며 기존 분류 결과를 유지함.
실제 브라우저에서 OCR 후보 선택·이름 수정·기존 등록 폼 연결 후 승인된 검증 재료 1개를 로컬 PostgreSQL에 저장하고 새로고침 후 유지됨을 확인함.
375×812 모바일 화면의 줄바꿈·내부 스크롤·취소 동작도 확인함.
합성 텍스트의 복수 재료 추출은 테스트했지만 실제 혼합 포장 사진의 복수 재료 추출은 성공하지 못함.
작은 글자·장식 글꼴·반사광에 대한 성능 개선과 공용 정규화 사전 연계는 후속 검토 사항임.
이미지 및 OCR 원문은 서비스 로그·파일·DB에 저장하지 않음. 처리 시간만 기록함.

## 모델 출처·라이선스

- [PaddleOCR](https://github.com/PaddlePaddle/PaddleOCR): Apache-2.0.
- [PP-OCRv3_mobile_det](https://huggingface.co/PaddlePaddle/PP-OCRv3_mobile_det):
  Apache-2.0, revision `58f4e5b132e34e516486fb0d0266c662feb48ca1`.
- [korean_PP-OCRv3_mobile_rec](https://huggingface.co/PaddlePaddle/korean_PP-OCRv3_mobile_rec):
  Apache-2.0, revision `02b8bcc0041d794ecc5cf3cd8aa40fc23626ec87`.

승인된 모델 두 개만 다운로드했으며 파일별 출처·SHA-256은 외부 모델 폴더의 `manifest.json`에 기록함.
모델 파일은 저장소에 포함하지 않음.

