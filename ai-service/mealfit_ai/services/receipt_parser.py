"""영수증 원문을 보관하지 않고 상품 행만 보수적으로 구조화함."""
import math
import re
import unicodedata
from datetime import date
from decimal import Decimal

from mealfit_ai.services.label_ingredient_service import extract_label_candidates

VERSION = 'receipt-rules-v2-ppocr3'
EXCLUDED = re.compile(r'합계|합산|총액|결제|승인|카드|현금|거스름|할인|쿠폰|포인트|부가세|과세|면세|취소|반품|회원|전화|사업자|대표|주소|고객|영수증|감사|적립|카카오|네이버|매장|매출|바코드|TOTAL|TAX|CASH|VISA|MASTERCARD', re.I)
NONFOOD = re.compile(r'세제|샴푸|휴지|봉투|수세미|치약|칫솔|건전지|물티슈|주방세정|비누')
NUMBER = r'\d[\d,]*(?:\.\d+)?'
TRIPLE = re.compile(rf'^(.*?)\s+({NUMBER})\s+({NUMBER})\s+({NUMBER})\s*원?$')
COUNT = re.compile(rf'(?<![\d.])({NUMBER})\s*(개|팩|봉지|봉|망|모|마리)(?![가-힣])')
WEIGHT = re.compile(rf'(?<![\d.])({NUMBER})\s*(kg|g|ml|mL|L|리터)(?![A-Za-z])', re.I)
DATE = re.compile(r'(?<!\d)(20\d{2})[./-](\d{1,2})[./-](\d{1,2})(?!\d)')


# 위치가 있는 문자 조각은 같은 높이의 행으로 묶고 중복 검출만 제거함
def ordered_rows(lines):
    fragments, plain, seen = [], [], set()
    for index, line in enumerate(lines[:512]):
        if not isinstance(line, dict):
            continue
        text, confidence = line.get('text'), line.get('confidence')
        if (not isinstance(text, str) or len(text) > 256 or isinstance(confidence, bool)
                or not isinstance(confidence, (float, int)) or not math.isfinite(confidence)
                or not 0 <= confidence <= 1):
            continue
        text = ' '.join(unicodedata.normalize('NFKC', text).split())
        box = line.get('box')
        if (isinstance(box, list) and len(box) == 4 and all(isinstance(p, list) and len(p) == 2
                and all(isinstance(v, (int, float)) and math.isfinite(v) for v in p) for p in box)):
            xs, ys = [p[0] for p in box], [p[1] for p in box]
            key = (text, tuple(round(v) for p in box for v in p))
            if key in seen:
                continue
            seen.add(key)
            fragments.append((min(xs), (min(ys) + max(ys)) / 2, max(1, max(ys) - min(ys)), text, confidence))
        elif text:
            plain.append((text, confidence))
    rows = []
    for fragment in sorted(fragments, key=lambda item: (item[1], item[0])):
        match = next((row for row in reversed(rows) if abs(row[0][1] - fragment[1]) <= min(row[0][2], fragment[2]) * .45), None)
        if match is None:
            rows.append([fragment])
        else:
            match.append(fragment)
    return [(' '.join(p[3] for p in sorted(row)), min(p[4] for p in row)) for row in rows] + plain


# 상품 유형을 먼저 판별해 맛·원재료 단어를 재고명으로 오인하지 않음
def receipt_ingredient(product, confidence):
    if re.search(r'라면|신라면|불닭볶음면', product):
        return '라면'
    if re.search(r'딸기\s*(?:맛\s*)?우유', product):
        return '딸기우유'
    if re.search(r'우유(?:\s|$)', product):
        flavored = re.search(r'(흰|딸기|초코|바나나)\s*(?:맛\s*)?우유', product)
        return flavored.group(1) + '우유' if flavored else '우유'
    candidates = extract_label_candidates([{'text': product, 'confidence': confidence}])
    return candidates[0]['ingredientName'] if len(candidates) == 1 else None


# 양수·저장 정밀도를 만족하는 수량만 문자열로 반환함
def inventory_number(value):
    if value <= 0 or value > Decimal('999999999.999') or value != value.quantize(Decimal('.001')):
        return None
    return format(value.normalize(), 'f')


# 규격·구매 묶음·금액을 분리하고 확인 가능한 조합만 실제 재고로 환산함
def parse_product(text, confidence):
    if EXCLUDED.search(text) or NONFOOD.search(text) or re.search(r'(?:^|\s)-\s*\d', text) or confidence < .5:
        return None
    verified_table = False
    quantity, unit, price = None, None, None
    purchase, purchase_unit, package = None, None, None
    product = re.sub(r'^\s*\d{1,3}[.)]?\s+', '', text)
    match = TRIPLE.fullmatch(product)
    if match:
        product, raw_each, raw_count, raw_total = match.groups()
        each, count, total = (Decimal(v.replace(',', '')) for v in (raw_each, raw_count, raw_total))
        if 0 < count <= 999 and each >= 0 and each * count == total:
            verified_table = True
            purchase, purchase_unit, price = count, '개', str(total)
    # 곱셈 표기가 없는 포장 규격은 구매한 묶음 수로 추정하지 않음
    multiply = re.search(rf'[×xX*]\s*({NUMBER})\s*(개|팩|봉지|봉|판|망|모|마리)(?![가-힣])', product)
    if multiply:
        if purchase is not None:
            return None  # 표 수량과 명시된 곱셈의 관계가 불명확하면 자동 제안하지 않음
        purchase = Decimal(multiply.group(1).replace(',', ''))
        purchase_unit = multiply.group(2)
        product = product[:multiply.start()] + product[multiply.end():]
    package_match = re.search(rf'({NUMBER})\s*(?:개입|구)(?![가-힣])', product)
    if package_match:
        package = Decimal(package_match.group(1).replace(',', ''))
        product = product[:package_match.start()] + product[package_match.end():]
    weights = list(WEIGHT.finditer(product))
    weight = weights[0] if len(weights) == 1 else None
    net_quantity = weight.group(1).replace(',', '') if weight else None
    net_unit = ({'kg': 'kg', 'g': 'g', 'ml': 'mL', 'l': 'L', '리터': 'L'}.get(weight.group(2).lower())) if weight else None
    product = WEIGHT.sub(' ', product)
    counts = list(COUNT.finditer(product))
    if len(counts) == 1:
        count = counts[0]
        if purchase is None and not package_match and not weights:
            quantity, unit = count.group(1).replace(',', ''), count.group(2)
        # "1kg 2팩"처럼 곱셈이 없는 표현은 총중량인지 팩당 중량인지 미확정임
        product = COUNT.sub(' ', product)
    if purchase is not None and not counts and len(weights) <= 1:
        if package is not None and weight is None:
            quantity, unit = inventory_number(package * purchase), '개'
        elif weight and package is None:
            quantity, unit = inventory_number(Decimal(net_quantity) * purchase), net_unit
        elif package is None and not weights:
            quantity, unit = inventory_number(purchase), purchase_unit
    elif weight and not counts and not package_match and purchase is None:
        quantity, unit = inventory_number(Decimal(net_quantity)), net_unit
    unresolved_spec = bool(multiply and not (weight or package_match) and re.search(r'\d', product))
    if price is None:
        tail = re.search(rf'\s+({NUMBER})\s*원?$', product)
        if tail and not unresolved_spec:
            price = tail.group(1).replace(',', '')
            product = product[:tail.start()]
    product = ' '.join(product.split())
    if not product or len(product) > 100 or re.search(r'\d{7,}', product):
        return None
    ingredient = receipt_ingredient(product, confidence)
    if ingredient is None:
        if not verified_table or not re.search(r'[가-힣]{2,}', product):
            return None
        ingredient = ''
    if unresolved_spec or re.search(r'[×xX*]', product) or re.search(r'-\s*\d', product):
        quantity = None
    if quantity is not None:
        quantity = inventory_number(Decimal(quantity))
    if quantity is None:
        unit = None
    return {'productName': product, 'ingredientName': ingredient,
            'quantity': quantity, 'unit': unit, 'netQuantity': inventory_number(Decimal(net_quantity)) if net_quantity else None, 'netUnit': net_unit,
            'packageCount': inventory_number(package) if package is not None else None,
            'purchaseQuantity': inventory_number(purchase) if purchase is not None else None,
            'purchaseUnit': purchase_unit, 'quantityStatus': 'PROPOSED' if quantity else 'UNCERTAIN',
            'price': price, 'textConfidence': confidence,
            'parsingStatus': 'CHECK_REQUIRED', 'requiresConfirmation': True, 'mappingStatus': 'UNMAPPED'}


# 날짜는 유효한 구매일 후보만 반환하고 매장·개인정보와 원문 전체는 반환하지 않음
def parse_receipt(lines, diagnostics=None):
    if not isinstance(lines, list) or len(lines) > 512:
        raise ValueError('문자 인식 결과 형식 오류')
    rows = ordered_rows(lines)
    if diagnostics is not None:
        diagnostics.update(fragments=len(lines), rows=len(rows), excluded_private_or_financial=0,
                           excluded_nonfood=0, excluded_low_confidence=0, unmatched_rows=0)
        for text, confidence in rows:
            if EXCLUDED.search(text):
                diagnostics['excluded_private_or_financial'] += 1
            elif NONFOOD.search(text):
                diagnostics['excluded_nonfood'] += 1
            elif confidence < .5:
                diagnostics['excluded_low_confidence'] += 1
            elif parse_product(text, confidence) is None:
                diagnostics['unmatched_rows'] += 1
    dates, items, pending = set(), [], None
    for text, confidence in rows:
        for match in DATE.finditer(text):
            try:
                dates.add(date(*map(int, match.groups())).isoformat())
            except ValueError:
                pass
        item = parse_product(text, confidence)
        # 줄바꿈된 상품명 다음에 가격 표가 오는 경우만 제한적으로 결합함
        if item and not any(char.isdigit() for char in text):
            if pending:
                previous = parse_product(*pending)
                if previous:
                    items.append(previous)
            pending = (text, confidence)
            continue
        if pending and re.fullmatch(rf'{NUMBER}\s+{NUMBER}\s+{NUMBER}', text):
            item = parse_product(pending[0] + ' ' + text, min(confidence, pending[1]))
        elif pending:
            previous = parse_product(*pending)
            if previous:
                items.append(previous)
        pending = None
        if item:
            items.append(item)
        if len(items) >= 50:
            break
    if pending and len(items) < 50:
        item = parse_product(*pending)
        if item:
            items.append(item)
    return {'modelVersion': VERSION, 'status': 'SUCCESS' if items else 'NO_ITEMS' if rows else 'NO_TEXT',
            'purchaseDate': next(iter(dates)) if len(dates) == 1 else None, 'items': items,
            'warnings': ['수량·단위·소비기한을 직접 확인해 주세요. 알려진 식재료명만 추출하며 누락 품목은 직접 추가할 수 있습니다.']}
