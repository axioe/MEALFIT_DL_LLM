"""상품 라벨의 명시적인 재료명만 후보로 제안하며 표준 재료 ID를 만들지 않음."""
import math
import re
import unicodedata

# 공용 정규화 사전과 독립적인 사진 라벨 후보이며 부분 문자열 추측을 피함.
_LABEL_NAMES = (
    '멸치', '콩나물', '소고기', '도라지', '청경채', '고사리', '브로콜리', '우엉',
    '양송이버섯', '양배추', '당근', '닭고기', '부추', '오이', '건새우', '만두',
    '달걀', '가지', '팽이버섯', '마늘', '생강', '대파', '햄', '김치', '새송이버섯',
    '상추', '고등어', '바지락', '홍합', '배추', '양파', '느타리버섯', '파프리카',
    '고추', '깻잎', '돼지고기', '감자', '호박', '무', '연어', '소시지', '냉이',
    '표고버섯', '새우', '낙지', '오징어', '고구마', '두부', '토마토', '미나리', '애호박',
    '우유', '치즈', '요거트', '시금치', '바나나', '사과', '블루베리', '아스파라거스',
)
_ALIASES = {name: name for name in _LABEL_NAMES}
_ALIASES.update({'방울토마토': '토마토', '대추방울토마토': '토마토',
                 '계란': '달걀', '쇠고기': '소고기', '돈육': '돼지고기',
                 '양송이': '양송이버섯', '새송이': '새송이버섯',
                 '팽이': '팽이버섯', '표고': '표고버섯', '느타리': '느타리버섯'})
_ORIGIN_PREFIX = r'(?:(?:국내산|국산|유기농|무농약|친환경|수입산)\s*)*'
_ALIAS_PATTERN = re.compile(
    r'(?<![가-힣A-Za-z0-9])' + _ORIGIN_PREFIX + '('
    + '|'.join(re.escape(name) for name in sorted(_ALIASES, key=len, reverse=True))
    + r')(?![가-힣A-Za-z])')
# 원재료·광고 문장은 상품명과 구분하며 텍스트 전체를 반환하지 않음.
_NON_PRODUCT_LINE = re.compile(r'원재료|원료명|알레르기|함유|추출물|향료|맛있|브랜드|상표|증정|구매시|구매 시')


# OCR 텍스트와 문자 신뢰도에서 독립적인 식재료 후보를 추출함.
def extract_label_candidates(lines):
    if not isinstance(lines, (list, tuple)) or len(lines) > 128:
        return []
    candidates = {}
    total_length = 0
    for line in lines:
        if not isinstance(line, dict):
            continue
        text, confidence = line.get('text'), line.get('confidence')
        if not isinstance(text, str) or len(text) > 256:
            continue
        total_length += len(text)
        if total_length > 8192:
            break
        if (isinstance(confidence, bool) or not isinstance(confidence, (int, float))
                or not math.isfinite(confidence) or not 0 <= confidence <= 1):
            continue
        text = unicodedata.normalize('NFKC', text).strip()
        if _NON_PRODUCT_LINE.search(text):
            continue
        for match in _ALIAS_PATTERN.finditer(text):
            name = _ALIASES[match.group(1)]
            previous = candidates.get(name)
            if previous is None or confidence > previous['textConfidence']:
                candidates[name] = {'ingredientName': name, 'textConfidence': float(confidence)}
    return list(candidates.values())

