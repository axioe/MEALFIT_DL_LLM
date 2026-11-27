-- PostgreSQL 버전 (H2 MODE=PostgreSQL 호환)
-- 검수 레시피 양념 바로잡기 (V18). V15 레시피 중 양념 조합이 말이 안 되는 440개의 양념·이름·재료·단계·영양 추정치를 고친다.
-- A. '깻잎+레몬즙을 섞어 양념'(300): 깻잎은 채 썰어 고명으로, 양념은 한식=들기름+간장 / 양식=레몬즙+올리브유
-- B. 오트죽에 신맛·바질 양념(100, A와 겹치는 20 제외): 들기름간장·들기름소금·마늘간장·파참기름·김들기름
-- C. 토스트·샌드위치에 식초 양념(40): 후추올리브·마늘올리브
-- D. 이름 바꾸기(정제본 2,390): '주재료 채소·채소 양념 요리' 나열형 → '맛 주재료 요리' (예: 파간장 참치 덮밥, 레몬 연어 구이)
--    채소·양념은 설명(description)과 재료 목록에 남긴다. 이름은 겹칠 수 있고, 추천은 같은 이름도 같은 요리로 보고 반복을 피한다.
--    LLM 아침 레시피(Q) 91개는 원래 자연스러운 이름이라 그대로 둔다.
-- 레시피 id는 그대로 두므로 기존 식단(meal_plans)의 참조는 유지된다.
-- 변경 내역: 레시피검증/양념수정내역_20261127.csv, 이름변경내역_20261127.csv

UPDATE recipes SET name = '레몬 달걀 토스트', description = '통밀 식빵에 달걀, 양배추, 당근을 곁들인 1인분 토스트. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0001';
UPDATE recipes SET name = '후추 달걀 토스트', description = '통밀 식빵에 달걀, 양배추, 당근을 곁들인 1인분 토스트. 후추올리브 양념.', calories = 436.0, protein_g = 21.5, carbs_g = 39.4, fat_g = 21.6, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0002';
UPDATE recipes SET name = '마늘 달걀 토스트', description = '통밀 식빵에 달걀, 양배추, 당근을 곁들인 1인분 토스트. 마늘올리브 양념.', calories = 438.0, protein_g = 21.6, carbs_g = 39.7, fat_g = 21.6, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0004';
UPDATE recipes SET name = '깻잎 달걀 토스트', description = '통밀 식빵에 달걀, 양배추, 당근을 곁들인 1인분 토스트. 레몬올리브 양념, 깻잎 고명.', calories = 439.0, protein_g = 21.6, carbs_g = 39.6, fat_g = 21.6, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0007';
UPDATE recipes SET name = '바질 달걀 토스트', description = '통밀 식빵에 달걀, 양배추, 당근을 곁들인 1인분 토스트. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0008';
UPDATE recipes SET name = '허브 달걀 토스트', description = '통밀 식빵에 달걀, 양배추, 당근을 곁들인 1인분 토스트. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0010';
UPDATE recipes SET name = '레몬 달걀 토스트', description = '통밀 식빵에 달걀, 브로콜리, 양파를 곁들인 1인분 토스트. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0011';
UPDATE recipes SET name = '후추 달걀 토스트', description = '통밀 식빵에 달걀, 브로콜리, 양파를 곁들인 1인분 토스트. 후추올리브 양념.', calories = 444.0, protein_g = 23.2, carbs_g = 39.6, fat_g = 21.6, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0012';
UPDATE recipes SET name = '마늘 달걀 토스트', description = '통밀 식빵에 달걀, 브로콜리, 양파를 곁들인 1인분 토스트. 마늘올리브 양념.', calories = 446.0, protein_g = 23.3, carbs_g = 39.9, fat_g = 21.6, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0014';
UPDATE recipes SET name = '깻잎 달걀 토스트', description = '통밀 식빵에 달걀, 브로콜리, 양파를 곁들인 1인분 토스트. 레몬올리브 양념, 깻잎 고명.', calories = 446.0, protein_g = 23.3, carbs_g = 39.8, fat_g = 21.6, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0017';
UPDATE recipes SET name = '바질 달걀 토스트', description = '통밀 식빵에 달걀, 브로콜리, 양파를 곁들인 1인분 토스트. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0018';
UPDATE recipes SET name = '허브 달걀 토스트', description = '통밀 식빵에 달걀, 브로콜리, 양파를 곁들인 1인분 토스트. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0020';
UPDATE recipes SET name = '레몬 달걀 토스트', description = '통밀 식빵에 달걀, 애호박, 파프리카를 곁들인 1인분 토스트. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0021';
UPDATE recipes SET name = '후추 달걀 토스트', description = '통밀 식빵에 달걀, 애호박, 파프리카를 곁들인 1인분 토스트. 후추올리브 양념.', calories = 421.0, protein_g = 21.7, carbs_g = 35.5, fat_g = 21.6, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0022';
UPDATE recipes SET name = '마늘 달걀 토스트', description = '통밀 식빵에 달걀, 애호박, 파프리카를 곁들인 1인분 토스트. 마늘올리브 양념.', calories = 423.0, protein_g = 21.7, carbs_g = 35.8, fat_g = 21.6, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0024';
UPDATE recipes SET name = '깻잎 달걀 토스트', description = '통밀 식빵에 달걀, 애호박, 파프리카를 곁들인 1인분 토스트. 레몬올리브 양념, 깻잎 고명.', calories = 423.0, protein_g = 21.7, carbs_g = 35.6, fat_g = 21.6, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0027';
UPDATE recipes SET name = '바질 달걀 토스트', description = '통밀 식빵에 달걀, 애호박, 파프리카를 곁들인 1인분 토스트. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0028';
UPDATE recipes SET name = '허브 달걀 토스트', description = '통밀 식빵에 달걀, 애호박, 파프리카를 곁들인 1인분 토스트. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0030';
UPDATE recipes SET name = '레몬 달걀 토스트', description = '통밀 식빵에 달걀, 시금치, 느타리버섯을 곁들인 1인분 토스트. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0031';
UPDATE recipes SET name = '후추 달걀 토스트', description = '통밀 식빵에 달걀, 시금치, 느타리버섯을 곁들인 1인분 토스트. 후추올리브 양념.', calories = 437.0, protein_g = 24.5, carbs_g = 36.7, fat_g = 21.6, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0032';
UPDATE recipes SET name = '마늘 달걀 토스트', description = '통밀 식빵에 달걀, 시금치, 느타리버섯을 곁들인 1인분 토스트. 마늘올리브 양념.', calories = 439.0, protein_g = 24.5, carbs_g = 37.0, fat_g = 21.6, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0034';
UPDATE recipes SET name = '깻잎 달걀 토스트', description = '통밀 식빵에 달걀, 시금치, 느타리버섯을 곁들인 1인분 토스트. 레몬올리브 양념, 깻잎 고명.', calories = 439.0, protein_g = 24.5, carbs_g = 36.9, fat_g = 21.6, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0037';
UPDATE recipes SET name = '바질 달걀 토스트', description = '통밀 식빵에 달걀, 시금치, 느타리버섯을 곁들인 1인분 토스트. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0038';
UPDATE recipes SET name = '허브 달걀 토스트', description = '통밀 식빵에 달걀, 시금치, 느타리버섯을 곁들인 1인분 토스트. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0040';
UPDATE recipes SET name = '레몬 달걀 토스트', description = '통밀 식빵에 달걀, 청경채, 양송이버섯을 곁들인 1인분 토스트. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0041';
UPDATE recipes SET name = '후추 달걀 토스트', description = '통밀 식빵에 달걀, 청경채, 양송이버섯을 곁들인 1인분 토스트. 후추올리브 양념.', calories = 423.0, protein_g = 23.7, carbs_g = 33.8, fat_g = 21.6, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0042';
UPDATE recipes SET name = '마늘 달걀 토스트', description = '통밀 식빵에 달걀, 청경채, 양송이버섯을 곁들인 1인분 토스트. 마늘올리브 양념.', calories = 424.0, protein_g = 23.8, carbs_g = 34.1, fat_g = 21.6, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0044';
UPDATE recipes SET name = '깻잎 달걀 토스트', description = '통밀 식빵에 달걀, 청경채, 양송이버섯을 곁들인 1인분 토스트. 레몬올리브 양념, 깻잎 고명.', calories = 425.0, protein_g = 23.8, carbs_g = 34.0, fat_g = 21.6, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0047';
UPDATE recipes SET name = '바질 달걀 토스트', description = '통밀 식빵에 달걀, 청경채, 양송이버섯을 곁들인 1인분 토스트. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0048';
UPDATE recipes SET name = '허브 달걀 토스트', description = '통밀 식빵에 달걀, 청경채, 양송이버섯을 곁들인 1인분 토스트. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0050';
UPDATE recipes SET name = '레몬 달걀 토스트', description = '통밀 식빵에 달걀, 가지, 토마토를 곁들인 1인분 토스트. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0051';
UPDATE recipes SET name = '후추 달걀 토스트', description = '통밀 식빵에 달걀, 가지, 토마토를 곁들인 1인분 토스트. 후추올리브 양념.', calories = 429.0, protein_g = 21.8, carbs_g = 37.4, fat_g = 21.6, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0052';
UPDATE recipes SET name = '마늘 달걀 토스트', description = '통밀 식빵에 달걀, 가지, 토마토를 곁들인 1인분 토스트. 마늘올리브 양념.', calories = 431.0, protein_g = 21.9, carbs_g = 37.7, fat_g = 21.6, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0054';
UPDATE recipes SET name = '깻잎 달걀 토스트', description = '통밀 식빵에 달걀, 가지, 토마토를 곁들인 1인분 토스트. 레몬올리브 양념, 깻잎 고명.', calories = 432.0, protein_g = 21.9, carbs_g = 37.6, fat_g = 21.6, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0057';
UPDATE recipes SET name = '바질 달걀 토스트', description = '통밀 식빵에 달걀, 가지, 토마토를 곁들인 1인분 토스트. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0058';
UPDATE recipes SET name = '허브 달걀 토스트', description = '통밀 식빵에 달걀, 가지, 토마토를 곁들인 1인분 토스트. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0060';
UPDATE recipes SET name = '레몬 달걀 토스트', description = '통밀 식빵에 달걀, 양배추, 파프리카를 곁들인 1인분 토스트. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0061';
UPDATE recipes SET name = '후추 달걀 토스트', description = '통밀 식빵에 달걀, 양배추, 파프리카를 곁들인 1인분 토스트. 후추올리브 양념.', calories = 431.0, protein_g = 21.7, carbs_g = 38.0, fat_g = 21.6, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0062';
UPDATE recipes SET name = '마늘 달걀 토스트', description = '통밀 식빵에 달걀, 양배추, 파프리카를 곁들인 1인분 토스트. 마늘올리브 양념.', calories = 433.0, protein_g = 21.7, carbs_g = 38.3, fat_g = 21.6, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0064';
UPDATE recipes SET name = '깻잎 달걀 토스트', description = '통밀 식빵에 달걀, 양배추, 파프리카를 곁들인 1인분 토스트. 레몬올리브 양념, 깻잎 고명.', calories = 433.0, protein_g = 21.7, carbs_g = 38.2, fat_g = 21.6, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0067';
UPDATE recipes SET name = '바질 달걀 토스트', description = '통밀 식빵에 달걀, 양배추, 파프리카를 곁들인 1인분 토스트. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0068';
UPDATE recipes SET name = '허브 달걀 토스트', description = '통밀 식빵에 달걀, 양배추, 파프리카를 곁들인 1인분 토스트. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0070';
UPDATE recipes SET name = '레몬 달걀 토스트', description = '통밀 식빵에 달걀, 브로콜리, 당근을 곁들인 1인분 토스트. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0071';
UPDATE recipes SET name = '후추 달걀 토스트', description = '통밀 식빵에 달걀, 브로콜리, 당근을 곁들인 1인분 토스트. 후추올리브 양념.', calories = 448.0, protein_g = 23.3, carbs_g = 40.6, fat_g = 21.6, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0072';
UPDATE recipes SET name = '마늘 달걀 토스트', description = '통밀 식빵에 달걀, 브로콜리, 당근을 곁들인 1인분 토스트. 마늘올리브 양념.', calories = 450.0, protein_g = 23.4, carbs_g = 40.9, fat_g = 21.6, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0074';
UPDATE recipes SET name = '깻잎 달걀 토스트', description = '통밀 식빵에 달걀, 브로콜리, 당근을 곁들인 1인분 토스트. 레몬올리브 양념, 깻잎 고명.', calories = 450.0, protein_g = 23.4, carbs_g = 40.7, fat_g = 21.6, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0077';
UPDATE recipes SET name = '바질 달걀 토스트', description = '통밀 식빵에 달걀, 브로콜리, 당근을 곁들인 1인분 토스트. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0078';
UPDATE recipes SET name = '허브 달걀 토스트', description = '통밀 식빵에 달걀, 브로콜리, 당근을 곁들인 1인분 토스트. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0080';
UPDATE recipes SET name = '레몬 달걀 토스트', description = '통밀 식빵에 달걀, 애호박, 양송이버섯을 곁들인 1인분 토스트. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0081';
UPDATE recipes SET name = '후추 달걀 토스트', description = '통밀 식빵에 달걀, 애호박, 양송이버섯을 곁들인 1인분 토스트. 후추올리브 양념.', calories = 420.0, protein_g = 23.0, carbs_g = 33.8, fat_g = 21.6, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0082';
UPDATE recipes SET name = '마늘 달걀 토스트', description = '통밀 식빵에 달걀, 애호박, 양송이버섯을 곁들인 1인분 토스트. 마늘올리브 양념.', calories = 421.0, protein_g = 23.0, carbs_g = 34.1, fat_g = 21.6, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0084';
UPDATE recipes SET name = '깻잎 달걀 토스트', description = '통밀 식빵에 달걀, 애호박, 양송이버섯을 곁들인 1인분 토스트. 레몬올리브 양념, 깻잎 고명.', calories = 422.0, protein_g = 23.0, carbs_g = 34.0, fat_g = 21.6, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0087';
UPDATE recipes SET name = '바질 달걀 토스트', description = '통밀 식빵에 달걀, 애호박, 양송이버섯을 곁들인 1인분 토스트. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0088';
UPDATE recipes SET name = '허브 달걀 토스트', description = '통밀 식빵에 달걀, 애호박, 양송이버섯을 곁들인 1인분 토스트. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0090';
UPDATE recipes SET name = '레몬 달걀 토스트', description = '통밀 식빵에 달걀, 시금치, 토마토를 곁들인 1인분 토스트. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0091';
UPDATE recipes SET name = '후추 달걀 토스트', description = '통밀 식빵에 달걀, 시금치, 토마토를 곁들인 1인분 토스트. 후추올리브 양념.', calories = 425.0, protein_g = 22.9, carbs_g = 35.2, fat_g = 21.6, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0092';
UPDATE recipes SET name = '마늘 달걀 토스트', description = '통밀 식빵에 달걀, 시금치, 토마토를 곁들인 1인분 토스트. 마늘올리브 양념.', calories = 427.0, protein_g = 22.9, carbs_g = 35.5, fat_g = 21.6, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0094';
UPDATE recipes SET name = '깻잎 달걀 토스트', description = '통밀 식빵에 달걀, 시금치, 토마토를 곁들인 1인분 토스트. 레몬올리브 양념, 깻잎 고명.', calories = 427.0, protein_g = 22.9, carbs_g = 35.4, fat_g = 21.6, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0097';
UPDATE recipes SET name = '바질 달걀 토스트', description = '통밀 식빵에 달걀, 시금치, 토마토를 곁들인 1인분 토스트. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0098';
UPDATE recipes SET name = '허브 달걀 토스트', description = '통밀 식빵에 달걀, 시금치, 토마토를 곁들인 1인분 토스트. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0100';
UPDATE recipes SET name = '들기름간장 두부 오트밀죽', description = '오트밀에 두부, 양배추, 당근을 곁들인 1인분 오트죽. 들기름간장 양념.', calories = 436.0, protein_g = 19.8, carbs_g = 46.1, fat_g = 19.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0101';
UPDATE recipes SET name = '들기름 두부 오트밀죽', description = '오트밀에 두부, 양배추, 당근을 곁들인 1인분 오트죽. 들기름소금 양념.', calories = 432.0, protein_g = 19.5, carbs_g = 45.9, fat_g = 19.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0102';
UPDATE recipes SET name = '간장 두부 오트밀죽', description = '오트밀에 두부, 양배추, 당근을 곁들인 1인분 오트죽. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0103';
UPDATE recipes SET name = '마늘간장 두부 오트밀죽', description = '오트밀에 두부, 양배추, 당근을 곁들인 1인분 오트죽. 마늘간장 양념.', calories = 404.0, protein_g = 20.0, carbs_g = 47.2, fat_g = 15.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0104';
UPDATE recipes SET name = '생강간장 두부 오트밀죽', description = '오트밀에 두부, 양배추, 당근을 곁들인 1인분 오트죽. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0105';
UPDATE recipes SET name = '파간장 두부 오트밀죽', description = '오트밀에 두부, 양배추, 당근을 곁들인 1인분 오트죽. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0106';
UPDATE recipes SET name = '깻잎 두부 오트밀죽', description = '오트밀에 두부, 양배추, 당근을 곁들인 1인분 오트죽. 들기름간장 양념, 깻잎 고명.', calories = 438.0, protein_g = 20.0, carbs_g = 46.4, fat_g = 19.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0107';
UPDATE recipes SET name = '파기름 두부 오트밀죽', description = '오트밀에 두부, 양배추, 당근을 곁들인 1인분 오트죽. 파참기름 양념.', calories = 436.0, protein_g = 19.7, carbs_g = 46.5, fat_g = 19.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0108';
UPDATE recipes SET name = '김 두부 오트밀죽', description = '오트밀에 두부, 양배추, 당근을 곁들인 1인분 오트죽. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0109';
UPDATE recipes SET name = '김 두부 오트밀죽', description = '오트밀에 두부, 양배추, 당근을 곁들인 1인분 오트죽. 김들기름 양념.', calories = 440.0, protein_g = 20.2, carbs_g = 46.7, fat_g = 19.1, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0110';
UPDATE recipes SET name = '들기름간장 두부 오트밀죽', description = '오트밀에 두부, 브로콜리, 양파를 곁들인 1인분 오트죽. 들기름간장 양념.', calories = 444.0, protein_g = 21.5, carbs_g = 46.3, fat_g = 19.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0111';
UPDATE recipes SET name = '들기름 두부 오트밀죽', description = '오트밀에 두부, 브로콜리, 양파를 곁들인 1인분 오트죽. 들기름소금 양념.', calories = 439.0, protein_g = 21.2, carbs_g = 46.1, fat_g = 19.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0112';
UPDATE recipes SET name = '간장 두부 오트밀죽', description = '오트밀에 두부, 브로콜리, 양파를 곁들인 1인분 오트죽. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0113';
UPDATE recipes SET name = '마늘간장 두부 오트밀죽', description = '오트밀에 두부, 브로콜리, 양파를 곁들인 1인분 오트죽. 마늘간장 양념.', calories = 411.0, protein_g = 21.7, carbs_g = 47.4, fat_g = 15.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0114';
UPDATE recipes SET name = '생강간장 두부 오트밀죽', description = '오트밀에 두부, 브로콜리, 양파를 곁들인 1인분 오트죽. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0115';
UPDATE recipes SET name = '파간장 두부 오트밀죽', description = '오트밀에 두부, 브로콜리, 양파를 곁들인 1인분 오트죽. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0116';
UPDATE recipes SET name = '깻잎 두부 오트밀죽', description = '오트밀에 두부, 브로콜리, 양파를 곁들인 1인분 오트죽. 들기름간장 양념, 깻잎 고명.', calories = 446.0, protein_g = 21.7, carbs_g = 46.6, fat_g = 19.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0117';
UPDATE recipes SET name = '파기름 두부 오트밀죽', description = '오트밀에 두부, 브로콜리, 양파를 곁들인 1인분 오트죽. 파참기름 양념.', calories = 443.0, protein_g = 21.4, carbs_g = 46.7, fat_g = 19.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0118';
UPDATE recipes SET name = '김 두부 오트밀죽', description = '오트밀에 두부, 브로콜리, 양파를 곁들인 1인분 오트죽. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0119';
UPDATE recipes SET name = '김 두부 오트밀죽', description = '오트밀에 두부, 브로콜리, 양파를 곁들인 1인분 오트죽. 김들기름 양념.', calories = 447.0, protein_g = 21.9, carbs_g = 46.9, fat_g = 19.1, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0120';
UPDATE recipes SET name = '들기름간장 두부 오트밀죽', description = '오트밀에 두부, 애호박, 파프리카를 곁들인 1인분 오트죽. 들기름간장 양념.', calories = 421.0, protein_g = 19.9, carbs_g = 42.1, fat_g = 19.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0121';
UPDATE recipes SET name = '들기름 두부 오트밀죽', description = '오트밀에 두부, 애호박, 파프리카를 곁들인 1인분 오트죽. 들기름소금 양념.', calories = 416.0, protein_g = 19.6, carbs_g = 41.9, fat_g = 19.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0122';
UPDATE recipes SET name = '간장 두부 오트밀죽', description = '오트밀에 두부, 애호박, 파프리카를 곁들인 1인분 오트죽. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0123';
UPDATE recipes SET name = '마늘간장 두부 오트밀죽', description = '오트밀에 두부, 애호박, 파프리카를 곁들인 1인분 오트죽. 마늘간장 양념.', calories = 388.0, protein_g = 20.1, carbs_g = 43.2, fat_g = 15.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0124';
UPDATE recipes SET name = '생강간장 두부 오트밀죽', description = '오트밀에 두부, 애호박, 파프리카를 곁들인 1인분 오트죽. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0125';
UPDATE recipes SET name = '파간장 두부 오트밀죽', description = '오트밀에 두부, 애호박, 파프리카를 곁들인 1인분 오트죽. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0126';
UPDATE recipes SET name = '깻잎 두부 오트밀죽', description = '오트밀에 두부, 애호박, 파프리카를 곁들인 1인분 오트죽. 들기름간장 양념, 깻잎 고명.', calories = 423.0, protein_g = 20.1, carbs_g = 42.5, fat_g = 19.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0127';
UPDATE recipes SET name = '파기름 두부 오트밀죽', description = '오트밀에 두부, 애호박, 파프리카를 곁들인 1인분 오트죽. 파참기름 양념.', calories = 420.0, protein_g = 19.8, carbs_g = 42.5, fat_g = 19.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0128';
UPDATE recipes SET name = '김 두부 오트밀죽', description = '오트밀에 두부, 애호박, 파프리카를 곁들인 1인분 오트죽. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0129';
UPDATE recipes SET name = '김 두부 오트밀죽', description = '오트밀에 두부, 애호박, 파프리카를 곁들인 1인분 오트죽. 김들기름 양념.', calories = 424.0, protein_g = 20.3, carbs_g = 42.8, fat_g = 19.1, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0130';
UPDATE recipes SET name = '들기름간장 두부 오트밀죽', description = '오트밀에 두부, 시금치, 느타리버섯을 곁들인 1인분 오트죽. 들기름간장 양념.', calories = 437.0, protein_g = 22.7, carbs_g = 43.4, fat_g = 19.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0131';
UPDATE recipes SET name = '들기름 두부 오트밀죽', description = '오트밀에 두부, 시금치, 느타리버섯을 곁들인 1인분 오트죽. 들기름소금 양념.', calories = 433.0, protein_g = 22.4, carbs_g = 43.2, fat_g = 19.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0132';
UPDATE recipes SET name = '간장 두부 오트밀죽', description = '오트밀에 두부, 시금치, 느타리버섯을 곁들인 1인분 오트죽. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0133';
UPDATE recipes SET name = '마늘간장 두부 오트밀죽', description = '오트밀에 두부, 시금치, 느타리버섯을 곁들인 1인분 오트죽. 마늘간장 양념.', calories = 404.0, protein_g = 22.9, carbs_g = 44.5, fat_g = 15.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0134';
UPDATE recipes SET name = '생강간장 두부 오트밀죽', description = '오트밀에 두부, 시금치, 느타리버섯을 곁들인 1인분 오트죽. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0135';
UPDATE recipes SET name = '파간장 두부 오트밀죽', description = '오트밀에 두부, 시금치, 느타리버섯을 곁들인 1인분 오트죽. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0136';
UPDATE recipes SET name = '깻잎 두부 오트밀죽', description = '오트밀에 두부, 시금치, 느타리버섯을 곁들인 1인분 오트죽. 들기름간장 양념, 깻잎 고명.', calories = 439.0, protein_g = 22.9, carbs_g = 43.7, fat_g = 19.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0137';
UPDATE recipes SET name = '파기름 두부 오트밀죽', description = '오트밀에 두부, 시금치, 느타리버섯을 곁들인 1인분 오트죽. 파참기름 양념.', calories = 436.0, protein_g = 22.6, carbs_g = 43.8, fat_g = 19.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0138';
UPDATE recipes SET name = '김 두부 오트밀죽', description = '오트밀에 두부, 시금치, 느타리버섯을 곁들인 1인분 오트죽. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0139';
UPDATE recipes SET name = '김 두부 오트밀죽', description = '오트밀에 두부, 시금치, 느타리버섯을 곁들인 1인분 오트죽. 김들기름 양념.', calories = 441.0, protein_g = 23.1, carbs_g = 44.0, fat_g = 19.1, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0140';
UPDATE recipes SET name = '들기름간장 두부 오트밀죽', description = '오트밀에 두부, 청경채, 양송이버섯을 곁들인 1인분 오트죽. 들기름간장 양념.', calories = 423.0, protein_g = 21.9, carbs_g = 40.5, fat_g = 19.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0141';
UPDATE recipes SET name = '들기름 두부 오트밀죽', description = '오트밀에 두부, 청경채, 양송이버섯을 곁들인 1인분 오트죽. 들기름소금 양념.', calories = 418.0, protein_g = 21.6, carbs_g = 40.3, fat_g = 19.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0142';
UPDATE recipes SET name = '간장 두부 오트밀죽', description = '오트밀에 두부, 청경채, 양송이버섯을 곁들인 1인분 오트죽. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0143';
UPDATE recipes SET name = '마늘간장 두부 오트밀죽', description = '오트밀에 두부, 청경채, 양송이버섯을 곁들인 1인분 오트죽. 마늘간장 양념.', calories = 390.0, protein_g = 22.1, carbs_g = 41.6, fat_g = 15.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0144';
UPDATE recipes SET name = '생강간장 두부 오트밀죽', description = '오트밀에 두부, 청경채, 양송이버섯을 곁들인 1인분 오트죽. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0145';
UPDATE recipes SET name = '파간장 두부 오트밀죽', description = '오트밀에 두부, 청경채, 양송이버섯을 곁들인 1인분 오트죽. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0146';
UPDATE recipes SET name = '깻잎 두부 오트밀죽', description = '오트밀에 두부, 청경채, 양송이버섯을 곁들인 1인분 오트죽. 들기름간장 양념, 깻잎 고명.', calories = 424.0, protein_g = 22.1, carbs_g = 40.8, fat_g = 19.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0147';
UPDATE recipes SET name = '파기름 두부 오트밀죽', description = '오트밀에 두부, 청경채, 양송이버섯을 곁들인 1인분 오트죽. 파참기름 양념.', calories = 422.0, protein_g = 21.8, carbs_g = 40.9, fat_g = 19.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0148';
UPDATE recipes SET name = '김 두부 오트밀죽', description = '오트밀에 두부, 청경채, 양송이버섯을 곁들인 1인분 오트죽. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0149';
UPDATE recipes SET name = '김 두부 오트밀죽', description = '오트밀에 두부, 청경채, 양송이버섯을 곁들인 1인분 오트죽. 김들기름 양념.', calories = 426.0, protein_g = 22.4, carbs_g = 41.1, fat_g = 19.1, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0150';
UPDATE recipes SET name = '들기름간장 두부 오트밀죽', description = '오트밀에 두부, 가지, 토마토를 곁들인 1인분 오트죽. 들기름간장 양념.', calories = 429.0, protein_g = 20.1, carbs_g = 44.1, fat_g = 19.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0151';
UPDATE recipes SET name = '들기름 두부 오트밀죽', description = '오트밀에 두부, 가지, 토마토를 곁들인 1인분 오트죽. 들기름소금 양념.', calories = 425.0, protein_g = 19.8, carbs_g = 43.9, fat_g = 19.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0152';
UPDATE recipes SET name = '간장 두부 오트밀죽', description = '오트밀에 두부, 가지, 토마토를 곁들인 1인분 오트죽. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0153';
UPDATE recipes SET name = '마늘간장 두부 오트밀죽', description = '오트밀에 두부, 가지, 토마토를 곁들인 1인분 오트죽. 마늘간장 양념.', calories = 397.0, protein_g = 20.2, carbs_g = 45.2, fat_g = 15.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0154';
UPDATE recipes SET name = '생강간장 두부 오트밀죽', description = '오트밀에 두부, 가지, 토마토를 곁들인 1인분 오트죽. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0155';
UPDATE recipes SET name = '파간장 두부 오트밀죽', description = '오트밀에 두부, 가지, 토마토를 곁들인 1인분 오트죽. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0156';
UPDATE recipes SET name = '깻잎 두부 오트밀죽', description = '오트밀에 두부, 가지, 토마토를 곁들인 1인분 오트죽. 들기름간장 양념, 깻잎 고명.', calories = 431.0, protein_g = 20.2, carbs_g = 44.4, fat_g = 19.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0157';
UPDATE recipes SET name = '파기름 두부 오트밀죽', description = '오트밀에 두부, 가지, 토마토를 곁들인 1인분 오트죽. 파참기름 양념.', calories = 429.0, protein_g = 19.9, carbs_g = 44.5, fat_g = 19.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0158';
UPDATE recipes SET name = '김 두부 오트밀죽', description = '오트밀에 두부, 가지, 토마토를 곁들인 1인분 오트죽. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0159';
UPDATE recipes SET name = '김 두부 오트밀죽', description = '오트밀에 두부, 가지, 토마토를 곁들인 1인분 오트죽. 김들기름 양념.', calories = 433.0, protein_g = 20.5, carbs_g = 44.7, fat_g = 19.1, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0160';
UPDATE recipes SET name = '들기름간장 두부 오트밀죽', description = '오트밀에 두부, 양배추, 파프리카를 곁들인 1인분 오트죽. 들기름간장 양념.', calories = 431.0, protein_g = 19.9, carbs_g = 44.8, fat_g = 19.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0161';
UPDATE recipes SET name = '들기름 두부 오트밀죽', description = '오트밀에 두부, 양배추, 파프리카를 곁들인 1인분 오트죽. 들기름소금 양념.', calories = 427.0, protein_g = 19.6, carbs_g = 44.5, fat_g = 19.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0162';
UPDATE recipes SET name = '간장 두부 오트밀죽', description = '오트밀에 두부, 양배추, 파프리카를 곁들인 1인분 오트죽. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0163';
UPDATE recipes SET name = '마늘간장 두부 오트밀죽', description = '오트밀에 두부, 양배추, 파프리카를 곁들인 1인분 오트죽. 마늘간장 양념.', calories = 398.0, protein_g = 20.1, carbs_g = 45.8, fat_g = 15.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0164';
UPDATE recipes SET name = '생강간장 두부 오트밀죽', description = '오트밀에 두부, 양배추, 파프리카를 곁들인 1인분 오트죽. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0165';
UPDATE recipes SET name = '파간장 두부 오트밀죽', description = '오트밀에 두부, 양배추, 파프리카를 곁들인 1인분 오트죽. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0166';
UPDATE recipes SET name = '깻잎 두부 오트밀죽', description = '오트밀에 두부, 양배추, 파프리카를 곁들인 1인분 오트죽. 들기름간장 양념, 깻잎 고명.', calories = 433.0, protein_g = 20.1, carbs_g = 45.0, fat_g = 19.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0167';
UPDATE recipes SET name = '파기름 두부 오트밀죽', description = '오트밀에 두부, 양배추, 파프리카를 곁들인 1인분 오트죽. 파참기름 양념.', calories = 430.0, protein_g = 19.8, carbs_g = 45.1, fat_g = 19.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0168';
UPDATE recipes SET name = '김 두부 오트밀죽', description = '오트밀에 두부, 양배추, 파프리카를 곁들인 1인분 오트죽. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0169';
UPDATE recipes SET name = '김 두부 오트밀죽', description = '오트밀에 두부, 양배추, 파프리카를 곁들인 1인분 오트죽. 김들기름 양념.', calories = 435.0, protein_g = 20.3, carbs_g = 45.3, fat_g = 19.1, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0170';
UPDATE recipes SET name = '들기름간장 두부 오트밀죽', description = '오트밀에 두부, 브로콜리, 당근을 곁들인 1인분 오트죽. 들기름간장 양념.', calories = 448.0, protein_g = 21.5, carbs_g = 47.3, fat_g = 19.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0171';
UPDATE recipes SET name = '들기름 두부 오트밀죽', description = '오트밀에 두부, 브로콜리, 당근을 곁들인 1인분 오트죽. 들기름소금 양념.', calories = 443.0, protein_g = 21.2, carbs_g = 47.0, fat_g = 19.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0172';
UPDATE recipes SET name = '간장 두부 오트밀죽', description = '오트밀에 두부, 브로콜리, 당근을 곁들인 1인분 오트죽. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0173';
UPDATE recipes SET name = '마늘간장 두부 오트밀죽', description = '오트밀에 두부, 브로콜리, 당근을 곁들인 1인분 오트죽. 마늘간장 양념.', calories = 415.0, protein_g = 21.7, carbs_g = 48.3, fat_g = 15.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0174';
UPDATE recipes SET name = '생강간장 두부 오트밀죽', description = '오트밀에 두부, 브로콜리, 당근을 곁들인 1인분 오트죽. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0175';
UPDATE recipes SET name = '파간장 두부 오트밀죽', description = '오트밀에 두부, 브로콜리, 당근을 곁들인 1인분 오트죽. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0176';
UPDATE recipes SET name = '깻잎 두부 오트밀죽', description = '오트밀에 두부, 브로콜리, 당근을 곁들인 1인분 오트죽. 들기름간장 양념, 깻잎 고명.', calories = 450.0, protein_g = 21.7, carbs_g = 47.6, fat_g = 19.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0177';
UPDATE recipes SET name = '파기름 두부 오트밀죽', description = '오트밀에 두부, 브로콜리, 당근을 곁들인 1인분 오트죽. 파참기름 양념.', calories = 447.0, protein_g = 21.4, carbs_g = 47.6, fat_g = 19.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0178';
UPDATE recipes SET name = '김 두부 오트밀죽', description = '오트밀에 두부, 브로콜리, 당근을 곁들인 1인분 오트죽. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0179';
UPDATE recipes SET name = '김 두부 오트밀죽', description = '오트밀에 두부, 브로콜리, 당근을 곁들인 1인분 오트죽. 김들기름 양념.', calories = 451.0, protein_g = 22.0, carbs_g = 47.9, fat_g = 19.1, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0180';
UPDATE recipes SET name = '들기름간장 두부 오트밀죽', description = '오트밀에 두부, 애호박, 양송이버섯을 곁들인 1인분 오트죽. 들기름간장 양념.', calories = 420.0, protein_g = 21.2, carbs_g = 40.5, fat_g = 19.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0181';
UPDATE recipes SET name = '들기름 두부 오트밀죽', description = '오트밀에 두부, 애호박, 양송이버섯을 곁들인 1인분 오트죽. 들기름소금 양념.', calories = 415.0, protein_g = 20.9, carbs_g = 40.3, fat_g = 19.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0182';
UPDATE recipes SET name = '간장 두부 오트밀죽', description = '오트밀에 두부, 애호박, 양송이버섯을 곁들인 1인분 오트죽. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0183';
UPDATE recipes SET name = '마늘간장 두부 오트밀죽', description = '오트밀에 두부, 애호박, 양송이버섯을 곁들인 1인분 오트죽. 마늘간장 양념.', calories = 387.0, protein_g = 21.4, carbs_g = 41.6, fat_g = 15.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0184';
UPDATE recipes SET name = '생강간장 두부 오트밀죽', description = '오트밀에 두부, 애호박, 양송이버섯을 곁들인 1인분 오트죽. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0185';
UPDATE recipes SET name = '파간장 두부 오트밀죽', description = '오트밀에 두부, 애호박, 양송이버섯을 곁들인 1인분 오트죽. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0186';
UPDATE recipes SET name = '깻잎 두부 오트밀죽', description = '오트밀에 두부, 애호박, 양송이버섯을 곁들인 1인분 오트죽. 들기름간장 양념, 깻잎 고명.', calories = 421.0, protein_g = 21.4, carbs_g = 40.8, fat_g = 19.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0187';
UPDATE recipes SET name = '파기름 두부 오트밀죽', description = '오트밀에 두부, 애호박, 양송이버섯을 곁들인 1인분 오트죽. 파참기름 양념.', calories = 419.0, protein_g = 21.1, carbs_g = 40.9, fat_g = 19.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0188';
UPDATE recipes SET name = '김 두부 오트밀죽', description = '오트밀에 두부, 애호박, 양송이버섯을 곁들인 1인분 오트죽. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0189';
UPDATE recipes SET name = '김 두부 오트밀죽', description = '오트밀에 두부, 애호박, 양송이버섯을 곁들인 1인분 오트죽. 김들기름 양념.', calories = 423.0, protein_g = 21.6, carbs_g = 41.1, fat_g = 19.1, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0190';
UPDATE recipes SET name = '들기름간장 두부 오트밀죽', description = '오트밀에 두부, 시금치, 토마토를 곁들인 1인분 오트죽. 들기름간장 양념.', calories = 425.0, protein_g = 21.1, carbs_g = 41.9, fat_g = 19.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0191';
UPDATE recipes SET name = '들기름 두부 오트밀죽', description = '오트밀에 두부, 시금치, 토마토를 곁들인 1인분 오트죽. 들기름소금 양념.', calories = 420.0, protein_g = 20.8, carbs_g = 41.7, fat_g = 19.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0192';
UPDATE recipes SET name = '간장 두부 오트밀죽', description = '오트밀에 두부, 시금치, 토마토를 곁들인 1인분 오트죽. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0193';
UPDATE recipes SET name = '마늘간장 두부 오트밀죽', description = '오트밀에 두부, 시금치, 토마토를 곁들인 1인분 오트죽. 마늘간장 양념.', calories = 392.0, protein_g = 21.3, carbs_g = 43.0, fat_g = 15.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0194';
UPDATE recipes SET name = '생강간장 두부 오트밀죽', description = '오트밀에 두부, 시금치, 토마토를 곁들인 1인분 오트죽. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0195';
UPDATE recipes SET name = '파간장 두부 오트밀죽', description = '오트밀에 두부, 시금치, 토마토를 곁들인 1인분 오트죽. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0196';
UPDATE recipes SET name = '깻잎 두부 오트밀죽', description = '오트밀에 두부, 시금치, 토마토를 곁들인 1인분 오트죽. 들기름간장 양념, 깻잎 고명.', calories = 426.0, protein_g = 21.3, carbs_g = 42.2, fat_g = 19.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0197';
UPDATE recipes SET name = '파기름 두부 오트밀죽', description = '오트밀에 두부, 시금치, 토마토를 곁들인 1인분 오트죽. 파참기름 양념.', calories = 424.0, protein_g = 21.0, carbs_g = 42.3, fat_g = 19.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0198';
UPDATE recipes SET name = '김 두부 오트밀죽', description = '오트밀에 두부, 시금치, 토마토를 곁들인 1인분 오트죽. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0199';
UPDATE recipes SET name = '김 두부 오트밀죽', description = '오트밀에 두부, 시금치, 토마토를 곁들인 1인분 오트죽. 김들기름 양념.', calories = 428.0, protein_g = 21.5, carbs_g = 42.5, fat_g = 19.1, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0200';
UPDATE recipes SET name = '레몬 달걀 고구마 플레이트', description = '고구마에 달걀, 양배추, 당근을 곁들인 1인분 한 접시. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0201';
UPDATE recipes SET name = '들깨 달걀 고구마 플레이트', description = '고구마에 달걀, 양배추, 당근을 곁들인 1인분 한 접시. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0202';
UPDATE recipes SET name = '간장 달걀 고구마 플레이트', description = '고구마에 달걀, 양배추, 당근을 곁들인 1인분 한 접시. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0203';
UPDATE recipes SET name = '마늘 달걀 고구마 플레이트', description = '고구마에 달걀, 양배추, 당근을 곁들인 1인분 한 접시. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0204';
UPDATE recipes SET name = '생강간장 달걀 고구마 플레이트', description = '고구마에 달걀, 양배추, 당근을 곁들인 1인분 한 접시. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0205';
UPDATE recipes SET name = '파간장 달걀 고구마 플레이트', description = '고구마에 달걀, 양배추, 당근을 곁들인 1인분 한 접시. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0206';
UPDATE recipes SET name = '깻잎 달걀 고구마 플레이트', description = '고구마에 달걀, 양배추, 당근을 곁들인 1인분 한 접시. 레몬올리브 양념, 깻잎 고명.', calories = 431.0, protein_g = 17.9, carbs_g = 47.3, fat_g = 19.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0207';
UPDATE recipes SET name = '바질 달걀 고구마 플레이트', description = '고구마에 달걀, 양배추, 당근을 곁들인 1인분 한 접시. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0208';
UPDATE recipes SET name = '김 달걀 고구마 플레이트', description = '고구마에 달걀, 양배추, 당근을 곁들인 1인분 한 접시. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0209';
UPDATE recipes SET name = '허브 달걀 고구마 플레이트', description = '고구마에 달걀, 양배추, 당근을 곁들인 1인분 한 접시. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0210';
UPDATE recipes SET name = '레몬 달걀 고구마 플레이트', description = '고구마에 달걀, 브로콜리, 양파를 곁들인 1인분 한 접시. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0211';
UPDATE recipes SET name = '들깨 달걀 고구마 플레이트', description = '고구마에 달걀, 브로콜리, 양파를 곁들인 1인분 한 접시. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0212';
UPDATE recipes SET name = '간장 달걀 고구마 플레이트', description = '고구마에 달걀, 브로콜리, 양파를 곁들인 1인분 한 접시. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0213';
UPDATE recipes SET name = '마늘 달걀 고구마 플레이트', description = '고구마에 달걀, 브로콜리, 양파를 곁들인 1인분 한 접시. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0214';
UPDATE recipes SET name = '생강간장 달걀 고구마 플레이트', description = '고구마에 달걀, 브로콜리, 양파를 곁들인 1인분 한 접시. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0215';
UPDATE recipes SET name = '파간장 달걀 고구마 플레이트', description = '고구마에 달걀, 브로콜리, 양파를 곁들인 1인분 한 접시. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0216';
UPDATE recipes SET name = '깻잎 달걀 고구마 플레이트', description = '고구마에 달걀, 브로콜리, 양파를 곁들인 1인분 한 접시. 레몬올리브 양념, 깻잎 고명.', calories = 439.0, protein_g = 19.6, carbs_g = 47.5, fat_g = 19.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0217';
UPDATE recipes SET name = '바질 달걀 고구마 플레이트', description = '고구마에 달걀, 브로콜리, 양파를 곁들인 1인분 한 접시. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0218';
UPDATE recipes SET name = '김 달걀 고구마 플레이트', description = '고구마에 달걀, 브로콜리, 양파를 곁들인 1인분 한 접시. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0219';
UPDATE recipes SET name = '허브 달걀 고구마 플레이트', description = '고구마에 달걀, 브로콜리, 양파를 곁들인 1인분 한 접시. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0220';
UPDATE recipes SET name = '레몬 달걀 고구마 플레이트', description = '고구마에 달걀, 애호박, 파프리카를 곁들인 1인분 한 접시. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0221';
UPDATE recipes SET name = '들깨 달걀 고구마 플레이트', description = '고구마에 달걀, 애호박, 파프리카를 곁들인 1인분 한 접시. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0222';
UPDATE recipes SET name = '간장 달걀 고구마 플레이트', description = '고구마에 달걀, 애호박, 파프리카를 곁들인 1인분 한 접시. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0223';
UPDATE recipes SET name = '마늘 달걀 고구마 플레이트', description = '고구마에 달걀, 애호박, 파프리카를 곁들인 1인분 한 접시. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0224';
UPDATE recipes SET name = '생강간장 달걀 고구마 플레이트', description = '고구마에 달걀, 애호박, 파프리카를 곁들인 1인분 한 접시. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0225';
UPDATE recipes SET name = '파간장 달걀 고구마 플레이트', description = '고구마에 달걀, 애호박, 파프리카를 곁들인 1인분 한 접시. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0226';
UPDATE recipes SET name = '깻잎 달걀 고구마 플레이트', description = '고구마에 달걀, 애호박, 파프리카를 곁들인 1인분 한 접시. 레몬올리브 양념, 깻잎 고명.', calories = 416.0, protein_g = 18.0, carbs_g = 43.4, fat_g = 19.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0227';
UPDATE recipes SET name = '바질 달걀 고구마 플레이트', description = '고구마에 달걀, 애호박, 파프리카를 곁들인 1인분 한 접시. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0228';
UPDATE recipes SET name = '김 달걀 고구마 플레이트', description = '고구마에 달걀, 애호박, 파프리카를 곁들인 1인분 한 접시. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0229';
UPDATE recipes SET name = '허브 달걀 고구마 플레이트', description = '고구마에 달걀, 애호박, 파프리카를 곁들인 1인분 한 접시. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0230';
UPDATE recipes SET name = '레몬 달걀 고구마 플레이트', description = '고구마에 달걀, 시금치, 느타리버섯을 곁들인 1인분 한 접시. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0231';
UPDATE recipes SET name = '들깨 달걀 고구마 플레이트', description = '고구마에 달걀, 시금치, 느타리버섯을 곁들인 1인분 한 접시. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0232';
UPDATE recipes SET name = '간장 달걀 고구마 플레이트', description = '고구마에 달걀, 시금치, 느타리버섯을 곁들인 1인분 한 접시. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0233';
UPDATE recipes SET name = '마늘 달걀 고구마 플레이트', description = '고구마에 달걀, 시금치, 느타리버섯을 곁들인 1인분 한 접시. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0234';
UPDATE recipes SET name = '생강간장 달걀 고구마 플레이트', description = '고구마에 달걀, 시금치, 느타리버섯을 곁들인 1인분 한 접시. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0235';
UPDATE recipes SET name = '파간장 달걀 고구마 플레이트', description = '고구마에 달걀, 시금치, 느타리버섯을 곁들인 1인분 한 접시. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0236';
UPDATE recipes SET name = '깻잎 달걀 고구마 플레이트', description = '고구마에 달걀, 시금치, 느타리버섯을 곁들인 1인분 한 접시. 레몬올리브 양념, 깻잎 고명.', calories = 432.0, protein_g = 20.8, carbs_g = 44.6, fat_g = 19.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0237';
UPDATE recipes SET name = '바질 달걀 고구마 플레이트', description = '고구마에 달걀, 시금치, 느타리버섯을 곁들인 1인분 한 접시. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0238';
UPDATE recipes SET name = '김 달걀 고구마 플레이트', description = '고구마에 달걀, 시금치, 느타리버섯을 곁들인 1인분 한 접시. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0239';
UPDATE recipes SET name = '허브 달걀 고구마 플레이트', description = '고구마에 달걀, 시금치, 느타리버섯을 곁들인 1인분 한 접시. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0240';
UPDATE recipes SET name = '레몬 달걀 고구마 플레이트', description = '고구마에 달걀, 청경채, 양송이버섯을 곁들인 1인분 한 접시. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0241';
UPDATE recipes SET name = '들깨 달걀 고구마 플레이트', description = '고구마에 달걀, 청경채, 양송이버섯을 곁들인 1인분 한 접시. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0242';
UPDATE recipes SET name = '간장 달걀 고구마 플레이트', description = '고구마에 달걀, 청경채, 양송이버섯을 곁들인 1인분 한 접시. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0243';
UPDATE recipes SET name = '마늘 달걀 고구마 플레이트', description = '고구마에 달걀, 청경채, 양송이버섯을 곁들인 1인분 한 접시. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0244';
UPDATE recipes SET name = '생강간장 달걀 고구마 플레이트', description = '고구마에 달걀, 청경채, 양송이버섯을 곁들인 1인분 한 접시. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0245';
UPDATE recipes SET name = '파간장 달걀 고구마 플레이트', description = '고구마에 달걀, 청경채, 양송이버섯을 곁들인 1인분 한 접시. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0246';
UPDATE recipes SET name = '깻잎 달걀 고구마 플레이트', description = '고구마에 달걀, 청경채, 양송이버섯을 곁들인 1인분 한 접시. 레몬올리브 양념, 깻잎 고명.', calories = 417.0, protein_g = 20.0, carbs_g = 41.7, fat_g = 19.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0247';
UPDATE recipes SET name = '바질 달걀 고구마 플레이트', description = '고구마에 달걀, 청경채, 양송이버섯을 곁들인 1인분 한 접시. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0248';
UPDATE recipes SET name = '김 달걀 고구마 플레이트', description = '고구마에 달걀, 청경채, 양송이버섯을 곁들인 1인분 한 접시. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0249';
UPDATE recipes SET name = '허브 달걀 고구마 플레이트', description = '고구마에 달걀, 청경채, 양송이버섯을 곁들인 1인분 한 접시. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0250';
UPDATE recipes SET name = '레몬 달걀 고구마 플레이트', description = '고구마에 달걀, 가지, 토마토를 곁들인 1인분 한 접시. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0251';
UPDATE recipes SET name = '들깨 달걀 고구마 플레이트', description = '고구마에 달걀, 가지, 토마토를 곁들인 1인분 한 접시. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0252';
UPDATE recipes SET name = '간장 달걀 고구마 플레이트', description = '고구마에 달걀, 가지, 토마토를 곁들인 1인분 한 접시. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0253';
UPDATE recipes SET name = '마늘 달걀 고구마 플레이트', description = '고구마에 달걀, 가지, 토마토를 곁들인 1인분 한 접시. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0254';
UPDATE recipes SET name = '생강간장 달걀 고구마 플레이트', description = '고구마에 달걀, 가지, 토마토를 곁들인 1인분 한 접시. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0255';
UPDATE recipes SET name = '파간장 달걀 고구마 플레이트', description = '고구마에 달걀, 가지, 토마토를 곁들인 1인분 한 접시. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0256';
UPDATE recipes SET name = '깻잎 달걀 고구마 플레이트', description = '고구마에 달걀, 가지, 토마토를 곁들인 1인분 한 접시. 레몬올리브 양념, 깻잎 고명.', calories = 424.0, protein_g = 18.1, carbs_g = 45.3, fat_g = 19.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0257';
UPDATE recipes SET name = '바질 달걀 고구마 플레이트', description = '고구마에 달걀, 가지, 토마토를 곁들인 1인분 한 접시. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0258';
UPDATE recipes SET name = '김 달걀 고구마 플레이트', description = '고구마에 달걀, 가지, 토마토를 곁들인 1인분 한 접시. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0259';
UPDATE recipes SET name = '허브 달걀 고구마 플레이트', description = '고구마에 달걀, 가지, 토마토를 곁들인 1인분 한 접시. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0260';
UPDATE recipes SET name = '레몬 달걀 고구마 플레이트', description = '고구마에 달걀, 양배추, 파프리카를 곁들인 1인분 한 접시. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0261';
UPDATE recipes SET name = '들깨 달걀 고구마 플레이트', description = '고구마에 달걀, 양배추, 파프리카를 곁들인 1인분 한 접시. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0262';
UPDATE recipes SET name = '간장 달걀 고구마 플레이트', description = '고구마에 달걀, 양배추, 파프리카를 곁들인 1인분 한 접시. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0263';
UPDATE recipes SET name = '마늘 달걀 고구마 플레이트', description = '고구마에 달걀, 양배추, 파프리카를 곁들인 1인분 한 접시. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0264';
UPDATE recipes SET name = '생강간장 달걀 고구마 플레이트', description = '고구마에 달걀, 양배추, 파프리카를 곁들인 1인분 한 접시. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0265';
UPDATE recipes SET name = '파간장 달걀 고구마 플레이트', description = '고구마에 달걀, 양배추, 파프리카를 곁들인 1인분 한 접시. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0266';
UPDATE recipes SET name = '깻잎 달걀 고구마 플레이트', description = '고구마에 달걀, 양배추, 파프리카를 곁들인 1인분 한 접시. 레몬올리브 양념, 깻잎 고명.', calories = 426.0, protein_g = 18.0, carbs_g = 45.9, fat_g = 19.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0267';
UPDATE recipes SET name = '바질 달걀 고구마 플레이트', description = '고구마에 달걀, 양배추, 파프리카를 곁들인 1인분 한 접시. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0268';
UPDATE recipes SET name = '김 달걀 고구마 플레이트', description = '고구마에 달걀, 양배추, 파프리카를 곁들인 1인분 한 접시. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0269';
UPDATE recipes SET name = '허브 달걀 고구마 플레이트', description = '고구마에 달걀, 양배추, 파프리카를 곁들인 1인분 한 접시. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0270';
UPDATE recipes SET name = '레몬 달걀 고구마 플레이트', description = '고구마에 달걀, 브로콜리, 당근을 곁들인 1인분 한 접시. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0271';
UPDATE recipes SET name = '들깨 달걀 고구마 플레이트', description = '고구마에 달걀, 브로콜리, 당근을 곁들인 1인분 한 접시. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0272';
UPDATE recipes SET name = '간장 달걀 고구마 플레이트', description = '고구마에 달걀, 브로콜리, 당근을 곁들인 1인분 한 접시. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0273';
UPDATE recipes SET name = '마늘 달걀 고구마 플레이트', description = '고구마에 달걀, 브로콜리, 당근을 곁들인 1인분 한 접시. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0274';
UPDATE recipes SET name = '생강간장 달걀 고구마 플레이트', description = '고구마에 달걀, 브로콜리, 당근을 곁들인 1인분 한 접시. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0275';
UPDATE recipes SET name = '파간장 달걀 고구마 플레이트', description = '고구마에 달걀, 브로콜리, 당근을 곁들인 1인분 한 접시. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0276';
UPDATE recipes SET name = '깻잎 달걀 고구마 플레이트', description = '고구마에 달걀, 브로콜리, 당근을 곁들인 1인분 한 접시. 레몬올리브 양념, 깻잎 고명.', calories = 443.0, protein_g = 19.6, carbs_g = 48.5, fat_g = 19.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0277';
UPDATE recipes SET name = '바질 달걀 고구마 플레이트', description = '고구마에 달걀, 브로콜리, 당근을 곁들인 1인분 한 접시. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0278';
UPDATE recipes SET name = '김 달걀 고구마 플레이트', description = '고구마에 달걀, 브로콜리, 당근을 곁들인 1인분 한 접시. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0279';
UPDATE recipes SET name = '허브 달걀 고구마 플레이트', description = '고구마에 달걀, 브로콜리, 당근을 곁들인 1인분 한 접시. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0280';
UPDATE recipes SET name = '레몬 달걀 고구마 플레이트', description = '고구마에 달걀, 애호박, 양송이버섯을 곁들인 1인분 한 접시. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0281';
UPDATE recipes SET name = '들깨 달걀 고구마 플레이트', description = '고구마에 달걀, 애호박, 양송이버섯을 곁들인 1인분 한 접시. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0282';
UPDATE recipes SET name = '간장 달걀 고구마 플레이트', description = '고구마에 달걀, 애호박, 양송이버섯을 곁들인 1인분 한 접시. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0283';
UPDATE recipes SET name = '마늘 달걀 고구마 플레이트', description = '고구마에 달걀, 애호박, 양송이버섯을 곁들인 1인분 한 접시. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0284';
UPDATE recipes SET name = '생강간장 달걀 고구마 플레이트', description = '고구마에 달걀, 애호박, 양송이버섯을 곁들인 1인분 한 접시. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0285';
UPDATE recipes SET name = '파간장 달걀 고구마 플레이트', description = '고구마에 달걀, 애호박, 양송이버섯을 곁들인 1인분 한 접시. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0286';
UPDATE recipes SET name = '깻잎 달걀 고구마 플레이트', description = '고구마에 달걀, 애호박, 양송이버섯을 곁들인 1인분 한 접시. 레몬올리브 양념, 깻잎 고명.', calories = 414.0, protein_g = 19.3, carbs_g = 41.7, fat_g = 19.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0287';
UPDATE recipes SET name = '바질 달걀 고구마 플레이트', description = '고구마에 달걀, 애호박, 양송이버섯을 곁들인 1인분 한 접시. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0288';
UPDATE recipes SET name = '김 달걀 고구마 플레이트', description = '고구마에 달걀, 애호박, 양송이버섯을 곁들인 1인분 한 접시. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0289';
UPDATE recipes SET name = '허브 달걀 고구마 플레이트', description = '고구마에 달걀, 애호박, 양송이버섯을 곁들인 1인분 한 접시. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0290';
UPDATE recipes SET name = '레몬 달걀 고구마 플레이트', description = '고구마에 달걀, 시금치, 토마토를 곁들인 1인분 한 접시. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0291';
UPDATE recipes SET name = '들깨 달걀 고구마 플레이트', description = '고구마에 달걀, 시금치, 토마토를 곁들인 1인분 한 접시. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0292';
UPDATE recipes SET name = '간장 달걀 고구마 플레이트', description = '고구마에 달걀, 시금치, 토마토를 곁들인 1인분 한 접시. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0293';
UPDATE recipes SET name = '마늘 달걀 고구마 플레이트', description = '고구마에 달걀, 시금치, 토마토를 곁들인 1인분 한 접시. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0294';
UPDATE recipes SET name = '생강간장 달걀 고구마 플레이트', description = '고구마에 달걀, 시금치, 토마토를 곁들인 1인분 한 접시. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0295';
UPDATE recipes SET name = '파간장 달걀 고구마 플레이트', description = '고구마에 달걀, 시금치, 토마토를 곁들인 1인분 한 접시. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0296';
UPDATE recipes SET name = '깻잎 달걀 고구마 플레이트', description = '고구마에 달걀, 시금치, 토마토를 곁들인 1인분 한 접시. 레몬올리브 양념, 깻잎 고명.', calories = 420.0, protein_g = 19.2, carbs_g = 43.1, fat_g = 19.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0297';
UPDATE recipes SET name = '바질 달걀 고구마 플레이트', description = '고구마에 달걀, 시금치, 토마토를 곁들인 1인분 한 접시. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0298';
UPDATE recipes SET name = '김 달걀 고구마 플레이트', description = '고구마에 달걀, 시금치, 토마토를 곁들인 1인분 한 접시. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0299';
UPDATE recipes SET name = '허브 달걀 고구마 플레이트', description = '고구마에 달걀, 시금치, 토마토를 곁들인 1인분 한 접시. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0300';
UPDATE recipes SET name = '레몬 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 양배추, 당근을 곁들인 1인분 한 접시. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0301';
UPDATE recipes SET name = '들깨 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 양배추, 당근을 곁들인 1인분 한 접시. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0302';
UPDATE recipes SET name = '간장 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 양배추, 당근을 곁들인 1인분 한 접시. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0303';
UPDATE recipes SET name = '마늘 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 양배추, 당근을 곁들인 1인분 한 접시. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0304';
UPDATE recipes SET name = '생강간장 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 양배추, 당근을 곁들인 1인분 한 접시. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0305';
UPDATE recipes SET name = '파간장 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 양배추, 당근을 곁들인 1인분 한 접시. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0306';
UPDATE recipes SET name = '깻잎 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 양배추, 당근을 곁들인 1인분 한 접시. 레몬올리브 양념, 깻잎 고명.', calories = 376.0, protein_g = 28.1, carbs_g = 41.2, fat_g = 11.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0307';
UPDATE recipes SET name = '바질 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 양배추, 당근을 곁들인 1인분 한 접시. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0308';
UPDATE recipes SET name = '김 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 양배추, 당근을 곁들인 1인분 한 접시. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0309';
UPDATE recipes SET name = '허브 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 양배추, 당근을 곁들인 1인분 한 접시. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0310';
UPDATE recipes SET name = '레몬 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 브로콜리, 양파를 곁들인 1인분 한 접시. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0311';
UPDATE recipes SET name = '들깨 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 브로콜리, 양파를 곁들인 1인분 한 접시. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0312';
UPDATE recipes SET name = '간장 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 브로콜리, 양파를 곁들인 1인분 한 접시. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0313';
UPDATE recipes SET name = '마늘 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 브로콜리, 양파를 곁들인 1인분 한 접시. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0314';
UPDATE recipes SET name = '생강간장 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 브로콜리, 양파를 곁들인 1인분 한 접시. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0315';
UPDATE recipes SET name = '파간장 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 브로콜리, 양파를 곁들인 1인분 한 접시. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0316';
UPDATE recipes SET name = '깻잎 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 브로콜리, 양파를 곁들인 1인분 한 접시. 레몬올리브 양념, 깻잎 고명.', calories = 383.0, protein_g = 29.8, carbs_g = 41.4, fat_g = 11.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0317';
UPDATE recipes SET name = '바질 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 브로콜리, 양파를 곁들인 1인분 한 접시. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0318';
UPDATE recipes SET name = '김 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 브로콜리, 양파를 곁들인 1인분 한 접시. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0319';
UPDATE recipes SET name = '허브 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 브로콜리, 양파를 곁들인 1인분 한 접시. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0320';
UPDATE recipes SET name = '레몬 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 애호박, 파프리카를 곁들인 1인분 한 접시. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0321';
UPDATE recipes SET name = '들깨 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 애호박, 파프리카를 곁들인 1인분 한 접시. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0322';
UPDATE recipes SET name = '간장 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 애호박, 파프리카를 곁들인 1인분 한 접시. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0323';
UPDATE recipes SET name = '마늘 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 애호박, 파프리카를 곁들인 1인분 한 접시. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0324';
UPDATE recipes SET name = '생강간장 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 애호박, 파프리카를 곁들인 1인분 한 접시. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0325';
UPDATE recipes SET name = '파간장 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 애호박, 파프리카를 곁들인 1인분 한 접시. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0326';
UPDATE recipes SET name = '깻잎 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 애호박, 파프리카를 곁들인 1인분 한 접시. 레몬올리브 양념, 깻잎 고명.', calories = 360.0, protein_g = 28.2, carbs_g = 37.3, fat_g = 11.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0327';
UPDATE recipes SET name = '바질 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 애호박, 파프리카를 곁들인 1인분 한 접시. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0328';
UPDATE recipes SET name = '김 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 애호박, 파프리카를 곁들인 1인분 한 접시. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0329';
UPDATE recipes SET name = '허브 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 애호박, 파프리카를 곁들인 1인분 한 접시. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0330';
UPDATE recipes SET name = '레몬 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 시금치, 느타리버섯을 곁들인 1인분 한 접시. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0331';
UPDATE recipes SET name = '들깨 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 시금치, 느타리버섯을 곁들인 1인분 한 접시. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0332';
UPDATE recipes SET name = '간장 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 시금치, 느타리버섯을 곁들인 1인분 한 접시. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0333';
UPDATE recipes SET name = '마늘 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 시금치, 느타리버섯을 곁들인 1인분 한 접시. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0334';
UPDATE recipes SET name = '생강간장 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 시금치, 느타리버섯을 곁들인 1인분 한 접시. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0335';
UPDATE recipes SET name = '파간장 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 시금치, 느타리버섯을 곁들인 1인분 한 접시. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0336';
UPDATE recipes SET name = '깻잎 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 시금치, 느타리버섯을 곁들인 1인분 한 접시. 레몬올리브 양념, 깻잎 고명.', calories = 376.0, protein_g = 31.0, carbs_g = 38.5, fat_g = 11.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0337';
UPDATE recipes SET name = '바질 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 시금치, 느타리버섯을 곁들인 1인분 한 접시. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0338';
UPDATE recipes SET name = '김 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 시금치, 느타리버섯을 곁들인 1인분 한 접시. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0339';
UPDATE recipes SET name = '허브 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 시금치, 느타리버섯을 곁들인 1인분 한 접시. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0340';
UPDATE recipes SET name = '레몬 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 청경채, 양송이버섯을 곁들인 1인분 한 접시. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0341';
UPDATE recipes SET name = '들깨 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 청경채, 양송이버섯을 곁들인 1인분 한 접시. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0342';
UPDATE recipes SET name = '간장 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 청경채, 양송이버섯을 곁들인 1인분 한 접시. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0343';
UPDATE recipes SET name = '마늘 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 청경채, 양송이버섯을 곁들인 1인분 한 접시. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0344';
UPDATE recipes SET name = '생강간장 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 청경채, 양송이버섯을 곁들인 1인분 한 접시. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0345';
UPDATE recipes SET name = '파간장 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 청경채, 양송이버섯을 곁들인 1인분 한 접시. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0346';
UPDATE recipes SET name = '깻잎 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 청경채, 양송이버섯을 곁들인 1인분 한 접시. 레몬올리브 양념, 깻잎 고명.', calories = 362.0, protein_g = 30.2, carbs_g = 35.6, fat_g = 11.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0347';
UPDATE recipes SET name = '바질 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 청경채, 양송이버섯을 곁들인 1인분 한 접시. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0348';
UPDATE recipes SET name = '김 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 청경채, 양송이버섯을 곁들인 1인분 한 접시. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0349';
UPDATE recipes SET name = '허브 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 청경채, 양송이버섯을 곁들인 1인분 한 접시. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0350';
UPDATE recipes SET name = '레몬 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 가지, 토마토를 곁들인 1인분 한 접시. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0351';
UPDATE recipes SET name = '들깨 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 가지, 토마토를 곁들인 1인분 한 접시. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0352';
UPDATE recipes SET name = '간장 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 가지, 토마토를 곁들인 1인분 한 접시. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0353';
UPDATE recipes SET name = '마늘 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 가지, 토마토를 곁들인 1인분 한 접시. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0354';
UPDATE recipes SET name = '생강간장 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 가지, 토마토를 곁들인 1인분 한 접시. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0355';
UPDATE recipes SET name = '파간장 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 가지, 토마토를 곁들인 1인분 한 접시. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0356';
UPDATE recipes SET name = '깻잎 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 가지, 토마토를 곁들인 1인분 한 접시. 레몬올리브 양념, 깻잎 고명.', calories = 369.0, protein_g = 28.3, carbs_g = 39.2, fat_g = 11.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0357';
UPDATE recipes SET name = '바질 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 가지, 토마토를 곁들인 1인분 한 접시. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0358';
UPDATE recipes SET name = '김 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 가지, 토마토를 곁들인 1인분 한 접시. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0359';
UPDATE recipes SET name = '허브 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 가지, 토마토를 곁들인 1인분 한 접시. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0360';
UPDATE recipes SET name = '레몬 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 양배추, 파프리카를 곁들인 1인분 한 접시. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0361';
UPDATE recipes SET name = '들깨 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 양배추, 파프리카를 곁들인 1인분 한 접시. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0362';
UPDATE recipes SET name = '간장 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 양배추, 파프리카를 곁들인 1인분 한 접시. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0363';
UPDATE recipes SET name = '마늘 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 양배추, 파프리카를 곁들인 1인분 한 접시. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0364';
UPDATE recipes SET name = '생강간장 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 양배추, 파프리카를 곁들인 1인분 한 접시. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0365';
UPDATE recipes SET name = '파간장 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 양배추, 파프리카를 곁들인 1인분 한 접시. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0366';
UPDATE recipes SET name = '깻잎 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 양배추, 파프리카를 곁들인 1인분 한 접시. 레몬올리브 양념, 깻잎 고명.', calories = 370.0, protein_g = 28.2, carbs_g = 39.8, fat_g = 11.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0367';
UPDATE recipes SET name = '바질 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 양배추, 파프리카를 곁들인 1인분 한 접시. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0368';
UPDATE recipes SET name = '김 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 양배추, 파프리카를 곁들인 1인분 한 접시. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0369';
UPDATE recipes SET name = '허브 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 양배추, 파프리카를 곁들인 1인분 한 접시. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0370';
UPDATE recipes SET name = '레몬 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 브로콜리, 당근을 곁들인 1인분 한 접시. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0371';
UPDATE recipes SET name = '들깨 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 브로콜리, 당근을 곁들인 1인분 한 접시. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0372';
UPDATE recipes SET name = '간장 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 브로콜리, 당근을 곁들인 1인분 한 접시. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0373';
UPDATE recipes SET name = '마늘 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 브로콜리, 당근을 곁들인 1인분 한 접시. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0374';
UPDATE recipes SET name = '생강간장 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 브로콜리, 당근을 곁들인 1인분 한 접시. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0375';
UPDATE recipes SET name = '파간장 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 브로콜리, 당근을 곁들인 1인분 한 접시. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0376';
UPDATE recipes SET name = '깻잎 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 브로콜리, 당근을 곁들인 1인분 한 접시. 레몬올리브 양념, 깻잎 고명.', calories = 387.0, protein_g = 29.8, carbs_g = 42.4, fat_g = 11.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0377';
UPDATE recipes SET name = '바질 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 브로콜리, 당근을 곁들인 1인분 한 접시. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0378';
UPDATE recipes SET name = '김 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 브로콜리, 당근을 곁들인 1인분 한 접시. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0379';
UPDATE recipes SET name = '허브 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 브로콜리, 당근을 곁들인 1인분 한 접시. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0380';
UPDATE recipes SET name = '레몬 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 애호박, 양송이버섯을 곁들인 1인분 한 접시. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0381';
UPDATE recipes SET name = '들깨 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 애호박, 양송이버섯을 곁들인 1인분 한 접시. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0382';
UPDATE recipes SET name = '간장 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 애호박, 양송이버섯을 곁들인 1인분 한 접시. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0383';
UPDATE recipes SET name = '마늘 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 애호박, 양송이버섯을 곁들인 1인분 한 접시. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0384';
UPDATE recipes SET name = '생강간장 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 애호박, 양송이버섯을 곁들인 1인분 한 접시. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0385';
UPDATE recipes SET name = '파간장 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 애호박, 양송이버섯을 곁들인 1인분 한 접시. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0386';
UPDATE recipes SET name = '깻잎 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 애호박, 양송이버섯을 곁들인 1인분 한 접시. 레몬올리브 양념, 깻잎 고명.', calories = 359.0, protein_g = 29.5, carbs_g = 35.6, fat_g = 11.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0387';
UPDATE recipes SET name = '바질 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 애호박, 양송이버섯을 곁들인 1인분 한 접시. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0388';
UPDATE recipes SET name = '김 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 애호박, 양송이버섯을 곁들인 1인분 한 접시. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0389';
UPDATE recipes SET name = '허브 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 애호박, 양송이버섯을 곁들인 1인분 한 접시. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0390';
UPDATE recipes SET name = '레몬 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 시금치, 토마토를 곁들인 1인분 한 접시. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0391';
UPDATE recipes SET name = '들깨 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 시금치, 토마토를 곁들인 1인분 한 접시. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0392';
UPDATE recipes SET name = '간장 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 시금치, 토마토를 곁들인 1인분 한 접시. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0393';
UPDATE recipes SET name = '마늘 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 시금치, 토마토를 곁들인 1인분 한 접시. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0394';
UPDATE recipes SET name = '생강간장 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 시금치, 토마토를 곁들인 1인분 한 접시. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0395';
UPDATE recipes SET name = '파간장 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 시금치, 토마토를 곁들인 1인분 한 접시. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0396';
UPDATE recipes SET name = '깻잎 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 시금치, 토마토를 곁들인 1인분 한 접시. 레몬올리브 양념, 깻잎 고명.', calories = 364.0, protein_g = 29.4, carbs_g = 37.0, fat_g = 11.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0397';
UPDATE recipes SET name = '바질 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 시금치, 토마토를 곁들인 1인분 한 접시. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0398';
UPDATE recipes SET name = '김 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 시금치, 토마토를 곁들인 1인분 한 접시. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0399';
UPDATE recipes SET name = '허브 닭가슴살 감자 플레이트', description = '감자에 닭가슴살, 시금치, 토마토를 곁들인 1인분 한 접시. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0400';
UPDATE recipes SET name = '들깨 두부 덮밥', description = '잡곡밥에 두부, 양배추, 당근을 곁들인 1인분 잡곡 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0402';
UPDATE recipes SET name = '간장 두부 덮밥', description = '잡곡밥에 두부, 양배추, 당근을 곁들인 1인분 잡곡 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0403';
UPDATE recipes SET name = '마늘 두부 덮밥', description = '잡곡밥에 두부, 양배추, 당근을 곁들인 1인분 잡곡 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0404';
UPDATE recipes SET name = '생강간장 두부 덮밥', description = '잡곡밥에 두부, 양배추, 당근을 곁들인 1인분 잡곡 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0405';
UPDATE recipes SET name = '파간장 두부 덮밥', description = '잡곡밥에 두부, 양배추, 당근을 곁들인 1인분 잡곡 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0406';
UPDATE recipes SET name = '깻잎 두부 덮밥', description = '잡곡밥에 두부, 양배추, 당근을 곁들인 1인분 잡곡 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 454.0, protein_g = 20.2, carbs_g = 53.7, fat_g = 17.5, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0407';
UPDATE recipes SET name = '김 두부 덮밥', description = '잡곡밥에 두부, 양배추, 당근을 곁들인 1인분 잡곡 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0409';
UPDATE recipes SET name = '들깨 두부 덮밥', description = '잡곡밥에 두부, 브로콜리, 양파를 곁들인 1인분 잡곡 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0412';
UPDATE recipes SET name = '간장 두부 덮밥', description = '잡곡밥에 두부, 브로콜리, 양파를 곁들인 1인분 잡곡 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0413';
UPDATE recipes SET name = '마늘 두부 덮밥', description = '잡곡밥에 두부, 브로콜리, 양파를 곁들인 1인분 잡곡 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0414';
UPDATE recipes SET name = '생강간장 두부 덮밥', description = '잡곡밥에 두부, 브로콜리, 양파를 곁들인 1인분 잡곡 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0415';
UPDATE recipes SET name = '파간장 두부 덮밥', description = '잡곡밥에 두부, 브로콜리, 양파를 곁들인 1인분 잡곡 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0416';
UPDATE recipes SET name = '깻잎 두부 덮밥', description = '잡곡밥에 두부, 브로콜리, 양파를 곁들인 1인분 잡곡 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 462.0, protein_g = 21.9, carbs_g = 53.9, fat_g = 17.5, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0417';
UPDATE recipes SET name = '김 두부 덮밥', description = '잡곡밥에 두부, 브로콜리, 양파를 곁들인 1인분 잡곡 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0419';
UPDATE recipes SET name = '들깨 두부 덮밥', description = '잡곡밥에 두부, 애호박, 파프리카를 곁들인 1인분 잡곡 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0422';
UPDATE recipes SET name = '간장 두부 덮밥', description = '잡곡밥에 두부, 애호박, 파프리카를 곁들인 1인분 잡곡 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0423';
UPDATE recipes SET name = '마늘 두부 덮밥', description = '잡곡밥에 두부, 애호박, 파프리카를 곁들인 1인분 잡곡 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0424';
UPDATE recipes SET name = '생강간장 두부 덮밥', description = '잡곡밥에 두부, 애호박, 파프리카를 곁들인 1인분 잡곡 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0425';
UPDATE recipes SET name = '파간장 두부 덮밥', description = '잡곡밥에 두부, 애호박, 파프리카를 곁들인 1인분 잡곡 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0426';
UPDATE recipes SET name = '깻잎 두부 덮밥', description = '잡곡밥에 두부, 애호박, 파프리카를 곁들인 1인분 잡곡 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 439.0, protein_g = 20.3, carbs_g = 49.8, fat_g = 17.5, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0427';
UPDATE recipes SET name = '김 두부 덮밥', description = '잡곡밥에 두부, 애호박, 파프리카를 곁들인 1인분 잡곡 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0429';
UPDATE recipes SET name = '들깨 두부 덮밥', description = '잡곡밥에 두부, 시금치, 느타리버섯을 곁들인 1인분 잡곡 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0432';
UPDATE recipes SET name = '간장 두부 덮밥', description = '잡곡밥에 두부, 시금치, 느타리버섯을 곁들인 1인분 잡곡 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0433';
UPDATE recipes SET name = '마늘 두부 덮밥', description = '잡곡밥에 두부, 시금치, 느타리버섯을 곁들인 1인분 잡곡 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0434';
UPDATE recipes SET name = '생강간장 두부 덮밥', description = '잡곡밥에 두부, 시금치, 느타리버섯을 곁들인 1인분 잡곡 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0435';
UPDATE recipes SET name = '파간장 두부 덮밥', description = '잡곡밥에 두부, 시금치, 느타리버섯을 곁들인 1인분 잡곡 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0436';
UPDATE recipes SET name = '깻잎 두부 덮밥', description = '잡곡밥에 두부, 시금치, 느타리버섯을 곁들인 1인분 잡곡 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 455.0, protein_g = 23.1, carbs_g = 51.0, fat_g = 17.5, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0437';
UPDATE recipes SET name = '김 두부 덮밥', description = '잡곡밥에 두부, 시금치, 느타리버섯을 곁들인 1인분 잡곡 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0439';
UPDATE recipes SET name = '들깨 두부 덮밥', description = '잡곡밥에 두부, 청경채, 양송이버섯을 곁들인 1인분 잡곡 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0442';
UPDATE recipes SET name = '간장 두부 덮밥', description = '잡곡밥에 두부, 청경채, 양송이버섯을 곁들인 1인분 잡곡 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0443';
UPDATE recipes SET name = '마늘 두부 덮밥', description = '잡곡밥에 두부, 청경채, 양송이버섯을 곁들인 1인분 잡곡 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0444';
UPDATE recipes SET name = '생강간장 두부 덮밥', description = '잡곡밥에 두부, 청경채, 양송이버섯을 곁들인 1인분 잡곡 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0445';
UPDATE recipes SET name = '파간장 두부 덮밥', description = '잡곡밥에 두부, 청경채, 양송이버섯을 곁들인 1인분 잡곡 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0446';
UPDATE recipes SET name = '깻잎 두부 덮밥', description = '잡곡밥에 두부, 청경채, 양송이버섯을 곁들인 1인분 잡곡 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 440.0, protein_g = 22.3, carbs_g = 48.1, fat_g = 17.5, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0447';
UPDATE recipes SET name = '김 두부 덮밥', description = '잡곡밥에 두부, 청경채, 양송이버섯을 곁들인 1인분 잡곡 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0449';
UPDATE recipes SET name = '들깨 두부 덮밥', description = '잡곡밥에 두부, 가지, 토마토를 곁들인 1인분 잡곡 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0452';
UPDATE recipes SET name = '간장 두부 덮밥', description = '잡곡밥에 두부, 가지, 토마토를 곁들인 1인분 잡곡 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0453';
UPDATE recipes SET name = '마늘 두부 덮밥', description = '잡곡밥에 두부, 가지, 토마토를 곁들인 1인분 잡곡 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0454';
UPDATE recipes SET name = '생강간장 두부 덮밥', description = '잡곡밥에 두부, 가지, 토마토를 곁들인 1인분 잡곡 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0455';
UPDATE recipes SET name = '파간장 두부 덮밥', description = '잡곡밥에 두부, 가지, 토마토를 곁들인 1인분 잡곡 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0456';
UPDATE recipes SET name = '깻잎 두부 덮밥', description = '잡곡밥에 두부, 가지, 토마토를 곁들인 1인분 잡곡 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 447.0, protein_g = 20.4, carbs_g = 51.7, fat_g = 17.5, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0457';
UPDATE recipes SET name = '김 두부 덮밥', description = '잡곡밥에 두부, 가지, 토마토를 곁들인 1인분 잡곡 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0459';
UPDATE recipes SET name = '들깨 두부 덮밥', description = '잡곡밥에 두부, 양배추, 파프리카를 곁들인 1인분 잡곡 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0462';
UPDATE recipes SET name = '간장 두부 덮밥', description = '잡곡밥에 두부, 양배추, 파프리카를 곁들인 1인분 잡곡 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0463';
UPDATE recipes SET name = '마늘 두부 덮밥', description = '잡곡밥에 두부, 양배추, 파프리카를 곁들인 1인분 잡곡 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0464';
UPDATE recipes SET name = '생강간장 두부 덮밥', description = '잡곡밥에 두부, 양배추, 파프리카를 곁들인 1인분 잡곡 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0465';
UPDATE recipes SET name = '파간장 두부 덮밥', description = '잡곡밥에 두부, 양배추, 파프리카를 곁들인 1인분 잡곡 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0466';
UPDATE recipes SET name = '깻잎 두부 덮밥', description = '잡곡밥에 두부, 양배추, 파프리카를 곁들인 1인분 잡곡 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 449.0, protein_g = 20.3, carbs_g = 52.3, fat_g = 17.5, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0467';
UPDATE recipes SET name = '김 두부 덮밥', description = '잡곡밥에 두부, 양배추, 파프리카를 곁들인 1인분 잡곡 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0469';
UPDATE recipes SET name = '들깨 두부 덮밥', description = '잡곡밥에 두부, 브로콜리, 당근을 곁들인 1인분 잡곡 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0472';
UPDATE recipes SET name = '간장 두부 덮밥', description = '잡곡밥에 두부, 브로콜리, 당근을 곁들인 1인분 잡곡 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0473';
UPDATE recipes SET name = '마늘 두부 덮밥', description = '잡곡밥에 두부, 브로콜리, 당근을 곁들인 1인분 잡곡 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0474';
UPDATE recipes SET name = '생강간장 두부 덮밥', description = '잡곡밥에 두부, 브로콜리, 당근을 곁들인 1인분 잡곡 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0475';
UPDATE recipes SET name = '파간장 두부 덮밥', description = '잡곡밥에 두부, 브로콜리, 당근을 곁들인 1인분 잡곡 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0476';
UPDATE recipes SET name = '깻잎 두부 덮밥', description = '잡곡밥에 두부, 브로콜리, 당근을 곁들인 1인분 잡곡 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 466.0, protein_g = 21.9, carbs_g = 54.9, fat_g = 17.5, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0477';
UPDATE recipes SET name = '김 두부 덮밥', description = '잡곡밥에 두부, 브로콜리, 당근을 곁들인 1인분 잡곡 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0479';
UPDATE recipes SET name = '들깨 두부 덮밥', description = '잡곡밥에 두부, 애호박, 양송이버섯을 곁들인 1인분 잡곡 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0482';
UPDATE recipes SET name = '간장 두부 덮밥', description = '잡곡밥에 두부, 애호박, 양송이버섯을 곁들인 1인분 잡곡 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0483';
UPDATE recipes SET name = '마늘 두부 덮밥', description = '잡곡밥에 두부, 애호박, 양송이버섯을 곁들인 1인분 잡곡 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0484';
UPDATE recipes SET name = '생강간장 두부 덮밥', description = '잡곡밥에 두부, 애호박, 양송이버섯을 곁들인 1인분 잡곡 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0485';
UPDATE recipes SET name = '파간장 두부 덮밥', description = '잡곡밥에 두부, 애호박, 양송이버섯을 곁들인 1인분 잡곡 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0486';
UPDATE recipes SET name = '깻잎 두부 덮밥', description = '잡곡밥에 두부, 애호박, 양송이버섯을 곁들인 1인분 잡곡 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 437.0, protein_g = 21.6, carbs_g = 48.1, fat_g = 17.5, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0487';
UPDATE recipes SET name = '김 두부 덮밥', description = '잡곡밥에 두부, 애호박, 양송이버섯을 곁들인 1인분 잡곡 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0489';
UPDATE recipes SET name = '들깨 두부 덮밥', description = '잡곡밥에 두부, 시금치, 토마토를 곁들인 1인분 잡곡 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0492';
UPDATE recipes SET name = '간장 두부 덮밥', description = '잡곡밥에 두부, 시금치, 토마토를 곁들인 1인분 잡곡 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0493';
UPDATE recipes SET name = '마늘 두부 덮밥', description = '잡곡밥에 두부, 시금치, 토마토를 곁들인 1인분 잡곡 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0494';
UPDATE recipes SET name = '생강간장 두부 덮밥', description = '잡곡밥에 두부, 시금치, 토마토를 곁들인 1인분 잡곡 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0495';
UPDATE recipes SET name = '파간장 두부 덮밥', description = '잡곡밥에 두부, 시금치, 토마토를 곁들인 1인분 잡곡 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0496';
UPDATE recipes SET name = '깻잎 두부 덮밥', description = '잡곡밥에 두부, 시금치, 토마토를 곁들인 1인분 잡곡 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 442.0, protein_g = 21.5, carbs_g = 49.5, fat_g = 17.5, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0497';
UPDATE recipes SET name = '김 두부 덮밥', description = '잡곡밥에 두부, 시금치, 토마토를 곁들인 1인분 잡곡 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0499';
UPDATE recipes SET name = '레몬 닭가슴살 랩', description = '통밀 또띠아에 닭가슴살, 양배추, 당근을 곁들인 1인분 랩. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0501';
UPDATE recipes SET name = '들깨 닭가슴살 랩', description = '통밀 또띠아에 닭가슴살, 양배추, 당근을 곁들인 1인분 랩. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0502';
UPDATE recipes SET name = '마늘 닭가슴살 랩', description = '통밀 또띠아에 닭가슴살, 양배추, 당근을 곁들인 1인분 랩. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0504';
UPDATE recipes SET name = '깻잎 닭가슴살 랩', description = '통밀 또띠아에 닭가슴살, 양배추, 당근을 곁들인 1인분 랩. 레몬올리브 양념, 깻잎 고명.', calories = 439.0, protein_g = 30.3, carbs_g = 43.1, fat_g = 16.2, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0507';
UPDATE recipes SET name = '바질 닭가슴살 랩', description = '통밀 또띠아에 닭가슴살, 양배추, 당근을 곁들인 1인분 랩. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0508';
UPDATE recipes SET name = '허브 닭가슴살 랩', description = '통밀 또띠아에 닭가슴살, 양배추, 당근을 곁들인 1인분 랩. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0510';
UPDATE recipes SET name = '레몬 닭가슴살 랩', description = '통밀 또띠아에 닭가슴살, 브로콜리, 양파를 곁들인 1인분 랩. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0511';
UPDATE recipes SET name = '들깨 닭가슴살 랩', description = '통밀 또띠아에 닭가슴살, 브로콜리, 양파를 곁들인 1인분 랩. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0512';
UPDATE recipes SET name = '마늘 닭가슴살 랩', description = '통밀 또띠아에 닭가슴살, 브로콜리, 양파를 곁들인 1인분 랩. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0514';
UPDATE recipes SET name = '깻잎 닭가슴살 랩', description = '통밀 또띠아에 닭가슴살, 브로콜리, 양파를 곁들인 1인분 랩. 레몬올리브 양념, 깻잎 고명.', calories = 447.0, protein_g = 32.0, carbs_g = 43.3, fat_g = 16.2, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0517';
UPDATE recipes SET name = '바질 닭가슴살 랩', description = '통밀 또띠아에 닭가슴살, 브로콜리, 양파를 곁들인 1인분 랩. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0518';
UPDATE recipes SET name = '허브 닭가슴살 랩', description = '통밀 또띠아에 닭가슴살, 브로콜리, 양파를 곁들인 1인분 랩. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0520';
UPDATE recipes SET name = '레몬 닭가슴살 랩', description = '통밀 또띠아에 닭가슴살, 애호박, 파프리카를 곁들인 1인분 랩. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0521';
UPDATE recipes SET name = '들깨 닭가슴살 랩', description = '통밀 또띠아에 닭가슴살, 애호박, 파프리카를 곁들인 1인분 랩. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0522';
UPDATE recipes SET name = '마늘 닭가슴살 랩', description = '통밀 또띠아에 닭가슴살, 애호박, 파프리카를 곁들인 1인분 랩. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0524';
UPDATE recipes SET name = '깻잎 닭가슴살 랩', description = '통밀 또띠아에 닭가슴살, 애호박, 파프리카를 곁들인 1인분 랩. 레몬올리브 양념, 깻잎 고명.', calories = 424.0, protein_g = 30.4, carbs_g = 39.2, fat_g = 16.2, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0527';
UPDATE recipes SET name = '바질 닭가슴살 랩', description = '통밀 또띠아에 닭가슴살, 애호박, 파프리카를 곁들인 1인분 랩. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0528';
UPDATE recipes SET name = '허브 닭가슴살 랩', description = '통밀 또띠아에 닭가슴살, 애호박, 파프리카를 곁들인 1인분 랩. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0530';
UPDATE recipes SET name = '레몬 닭가슴살 랩', description = '통밀 또띠아에 닭가슴살, 시금치, 느타리버섯을 곁들인 1인분 랩. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0531';
UPDATE recipes SET name = '들깨 닭가슴살 랩', description = '통밀 또띠아에 닭가슴살, 시금치, 느타리버섯을 곁들인 1인분 랩. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0532';
UPDATE recipes SET name = '마늘 닭가슴살 랩', description = '통밀 또띠아에 닭가슴살, 시금치, 느타리버섯을 곁들인 1인분 랩. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0534';
UPDATE recipes SET name = '깻잎 닭가슴살 랩', description = '통밀 또띠아에 닭가슴살, 시금치, 느타리버섯을 곁들인 1인분 랩. 레몬올리브 양념, 깻잎 고명.', calories = 440.0, protein_g = 33.2, carbs_g = 40.4, fat_g = 16.2, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0537';
UPDATE recipes SET name = '바질 닭가슴살 랩', description = '통밀 또띠아에 닭가슴살, 시금치, 느타리버섯을 곁들인 1인분 랩. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0538';
UPDATE recipes SET name = '허브 닭가슴살 랩', description = '통밀 또띠아에 닭가슴살, 시금치, 느타리버섯을 곁들인 1인분 랩. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0540';
UPDATE recipes SET name = '레몬 닭가슴살 랩', description = '통밀 또띠아에 닭가슴살, 청경채, 양송이버섯을 곁들인 1인분 랩. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0541';
UPDATE recipes SET name = '들깨 닭가슴살 랩', description = '통밀 또띠아에 닭가슴살, 청경채, 양송이버섯을 곁들인 1인분 랩. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0542';
UPDATE recipes SET name = '마늘 닭가슴살 랩', description = '통밀 또띠아에 닭가슴살, 청경채, 양송이버섯을 곁들인 1인분 랩. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0544';
UPDATE recipes SET name = '깻잎 닭가슴살 랩', description = '통밀 또띠아에 닭가슴살, 청경채, 양송이버섯을 곁들인 1인분 랩. 레몬올리브 양념, 깻잎 고명.', calories = 425.0, protein_g = 32.5, carbs_g = 37.5, fat_g = 16.2, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0547';
UPDATE recipes SET name = '바질 닭가슴살 랩', description = '통밀 또띠아에 닭가슴살, 청경채, 양송이버섯을 곁들인 1인분 랩. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0548';
UPDATE recipes SET name = '허브 닭가슴살 랩', description = '통밀 또띠아에 닭가슴살, 청경채, 양송이버섯을 곁들인 1인분 랩. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0550';
UPDATE recipes SET name = '레몬 닭가슴살 랩', description = '통밀 또띠아에 닭가슴살, 가지, 토마토를 곁들인 1인분 랩. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0551';
UPDATE recipes SET name = '들깨 닭가슴살 랩', description = '통밀 또띠아에 닭가슴살, 가지, 토마토를 곁들인 1인분 랩. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0552';
UPDATE recipes SET name = '마늘 닭가슴살 랩', description = '통밀 또띠아에 닭가슴살, 가지, 토마토를 곁들인 1인분 랩. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0554';
UPDATE recipes SET name = '깻잎 닭가슴살 랩', description = '통밀 또띠아에 닭가슴살, 가지, 토마토를 곁들인 1인분 랩. 레몬올리브 양념, 깻잎 고명.', calories = 432.0, protein_g = 30.6, carbs_g = 41.1, fat_g = 16.2, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0557';
UPDATE recipes SET name = '바질 닭가슴살 랩', description = '통밀 또띠아에 닭가슴살, 가지, 토마토를 곁들인 1인분 랩. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0558';
UPDATE recipes SET name = '허브 닭가슴살 랩', description = '통밀 또띠아에 닭가슴살, 가지, 토마토를 곁들인 1인분 랩. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0560';
UPDATE recipes SET name = '레몬 닭가슴살 랩', description = '통밀 또띠아에 닭가슴살, 양배추, 파프리카를 곁들인 1인분 랩. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0561';
UPDATE recipes SET name = '들깨 닭가슴살 랩', description = '통밀 또띠아에 닭가슴살, 양배추, 파프리카를 곁들인 1인분 랩. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0562';
UPDATE recipes SET name = '마늘 닭가슴살 랩', description = '통밀 또띠아에 닭가슴살, 양배추, 파프리카를 곁들인 1인분 랩. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0564';
UPDATE recipes SET name = '깻잎 닭가슴살 랩', description = '통밀 또띠아에 닭가슴살, 양배추, 파프리카를 곁들인 1인분 랩. 레몬올리브 양념, 깻잎 고명.', calories = 434.0, protein_g = 30.4, carbs_g = 41.7, fat_g = 16.2, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0567';
UPDATE recipes SET name = '바질 닭가슴살 랩', description = '통밀 또띠아에 닭가슴살, 양배추, 파프리카를 곁들인 1인분 랩. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0568';
UPDATE recipes SET name = '허브 닭가슴살 랩', description = '통밀 또띠아에 닭가슴살, 양배추, 파프리카를 곁들인 1인분 랩. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0570';
UPDATE recipes SET name = '레몬 닭가슴살 랩', description = '통밀 또띠아에 닭가슴살, 브로콜리, 당근을 곁들인 1인분 랩. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0571';
UPDATE recipes SET name = '들깨 닭가슴살 랩', description = '통밀 또띠아에 닭가슴살, 브로콜리, 당근을 곁들인 1인분 랩. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0572';
UPDATE recipes SET name = '마늘 닭가슴살 랩', description = '통밀 또띠아에 닭가슴살, 브로콜리, 당근을 곁들인 1인분 랩. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0574';
UPDATE recipes SET name = '깻잎 닭가슴살 랩', description = '통밀 또띠아에 닭가슴살, 브로콜리, 당근을 곁들인 1인분 랩. 레몬올리브 양념, 깻잎 고명.', calories = 451.0, protein_g = 32.1, carbs_g = 44.3, fat_g = 16.2, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0577';
UPDATE recipes SET name = '바질 닭가슴살 랩', description = '통밀 또띠아에 닭가슴살, 브로콜리, 당근을 곁들인 1인분 랩. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0578';
UPDATE recipes SET name = '허브 닭가슴살 랩', description = '통밀 또띠아에 닭가슴살, 브로콜리, 당근을 곁들인 1인분 랩. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0580';
UPDATE recipes SET name = '레몬 닭가슴살 랩', description = '통밀 또띠아에 닭가슴살, 애호박, 양송이버섯을 곁들인 1인분 랩. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0581';
UPDATE recipes SET name = '들깨 닭가슴살 랩', description = '통밀 또띠아에 닭가슴살, 애호박, 양송이버섯을 곁들인 1인분 랩. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0582';
UPDATE recipes SET name = '마늘 닭가슴살 랩', description = '통밀 또띠아에 닭가슴살, 애호박, 양송이버섯을 곁들인 1인분 랩. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0584';
UPDATE recipes SET name = '깻잎 닭가슴살 랩', description = '통밀 또띠아에 닭가슴살, 애호박, 양송이버섯을 곁들인 1인분 랩. 레몬올리브 양념, 깻잎 고명.', calories = 422.0, protein_g = 31.7, carbs_g = 37.5, fat_g = 16.2, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0587';
UPDATE recipes SET name = '바질 닭가슴살 랩', description = '통밀 또띠아에 닭가슴살, 애호박, 양송이버섯을 곁들인 1인분 랩. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0588';
UPDATE recipes SET name = '허브 닭가슴살 랩', description = '통밀 또띠아에 닭가슴살, 애호박, 양송이버섯을 곁들인 1인분 랩. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0590';
UPDATE recipes SET name = '레몬 닭가슴살 랩', description = '통밀 또띠아에 닭가슴살, 시금치, 토마토를 곁들인 1인분 랩. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0591';
UPDATE recipes SET name = '들깨 닭가슴살 랩', description = '통밀 또띠아에 닭가슴살, 시금치, 토마토를 곁들인 1인분 랩. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0592';
UPDATE recipes SET name = '마늘 닭가슴살 랩', description = '통밀 또띠아에 닭가슴살, 시금치, 토마토를 곁들인 1인분 랩. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0594';
UPDATE recipes SET name = '깻잎 닭가슴살 랩', description = '통밀 또띠아에 닭가슴살, 시금치, 토마토를 곁들인 1인분 랩. 레몬올리브 양념, 깻잎 고명.', calories = 427.0, protein_g = 31.6, carbs_g = 38.9, fat_g = 16.2, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0597';
UPDATE recipes SET name = '바질 닭가슴살 랩', description = '통밀 또띠아에 닭가슴살, 시금치, 토마토를 곁들인 1인분 랩. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0598';
UPDATE recipes SET name = '허브 닭가슴살 랩', description = '통밀 또띠아에 닭가슴살, 시금치, 토마토를 곁들인 1인분 랩. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0600';
UPDATE recipes SET name = '들깨 참치 덮밥', description = '현미밥에 참치 통조림, 양배추, 당근을 곁들인 1인분 현미 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0602';
UPDATE recipes SET name = '간장 참치 덮밥', description = '현미밥에 참치 통조림, 양배추, 당근을 곁들인 1인분 현미 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0603';
UPDATE recipes SET name = '마늘 참치 덮밥', description = '현미밥에 참치 통조림, 양배추, 당근을 곁들인 1인분 현미 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0604';
UPDATE recipes SET name = '생강간장 참치 덮밥', description = '현미밥에 참치 통조림, 양배추, 당근을 곁들인 1인분 현미 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0605';
UPDATE recipes SET name = '파간장 참치 덮밥', description = '현미밥에 참치 통조림, 양배추, 당근을 곁들인 1인분 현미 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0606';
UPDATE recipes SET name = '깻잎 참치 덮밥', description = '현미밥에 참치 통조림, 양배추, 당근을 곁들인 1인분 현미 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 377.0, protein_g = 26.5, carbs_g = 46.6, fat_g = 9.3, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0607';
UPDATE recipes SET name = '김 참치 덮밥', description = '현미밥에 참치 통조림, 양배추, 당근을 곁들인 1인분 현미 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0609';
UPDATE recipes SET name = '들깨 참치 덮밥', description = '현미밥에 참치 통조림, 브로콜리, 양파를 곁들인 1인분 현미 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0612';
UPDATE recipes SET name = '간장 참치 덮밥', description = '현미밥에 참치 통조림, 브로콜리, 양파를 곁들인 1인분 현미 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0613';
UPDATE recipes SET name = '마늘 참치 덮밥', description = '현미밥에 참치 통조림, 브로콜리, 양파를 곁들인 1인분 현미 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0614';
UPDATE recipes SET name = '생강간장 참치 덮밥', description = '현미밥에 참치 통조림, 브로콜리, 양파를 곁들인 1인분 현미 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0615';
UPDATE recipes SET name = '파간장 참치 덮밥', description = '현미밥에 참치 통조림, 브로콜리, 양파를 곁들인 1인분 현미 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0616';
UPDATE recipes SET name = '깻잎 참치 덮밥', description = '현미밥에 참치 통조림, 브로콜리, 양파를 곁들인 1인분 현미 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 385.0, protein_g = 28.2, carbs_g = 46.8, fat_g = 9.3, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0617';
UPDATE recipes SET name = '김 참치 덮밥', description = '현미밥에 참치 통조림, 브로콜리, 양파를 곁들인 1인분 현미 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0619';
UPDATE recipes SET name = '들깨 참치 덮밥', description = '현미밥에 참치 통조림, 애호박, 파프리카를 곁들인 1인분 현미 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0622';
UPDATE recipes SET name = '간장 참치 덮밥', description = '현미밥에 참치 통조림, 애호박, 파프리카를 곁들인 1인분 현미 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0623';
UPDATE recipes SET name = '마늘 참치 덮밥', description = '현미밥에 참치 통조림, 애호박, 파프리카를 곁들인 1인분 현미 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0624';
UPDATE recipes SET name = '생강간장 참치 덮밥', description = '현미밥에 참치 통조림, 애호박, 파프리카를 곁들인 1인분 현미 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0625';
UPDATE recipes SET name = '파간장 참치 덮밥', description = '현미밥에 참치 통조림, 애호박, 파프리카를 곁들인 1인분 현미 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0626';
UPDATE recipes SET name = '깻잎 참치 덮밥', description = '현미밥에 참치 통조림, 애호박, 파프리카를 곁들인 1인분 현미 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 362.0, protein_g = 26.6, carbs_g = 42.6, fat_g = 9.3, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0627';
UPDATE recipes SET name = '김 참치 덮밥', description = '현미밥에 참치 통조림, 애호박, 파프리카를 곁들인 1인분 현미 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0629';
UPDATE recipes SET name = '들깨 참치 덮밥', description = '현미밥에 참치 통조림, 시금치, 느타리버섯을 곁들인 1인분 현미 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0632';
UPDATE recipes SET name = '간장 참치 덮밥', description = '현미밥에 참치 통조림, 시금치, 느타리버섯을 곁들인 1인분 현미 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0633';
UPDATE recipes SET name = '마늘 참치 덮밥', description = '현미밥에 참치 통조림, 시금치, 느타리버섯을 곁들인 1인분 현미 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0634';
UPDATE recipes SET name = '생강간장 참치 덮밥', description = '현미밥에 참치 통조림, 시금치, 느타리버섯을 곁들인 1인분 현미 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0635';
UPDATE recipes SET name = '파간장 참치 덮밥', description = '현미밥에 참치 통조림, 시금치, 느타리버섯을 곁들인 1인분 현미 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0636';
UPDATE recipes SET name = '깻잎 참치 덮밥', description = '현미밥에 참치 통조림, 시금치, 느타리버섯을 곁들인 1인분 현미 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 378.0, protein_g = 29.4, carbs_g = 43.9, fat_g = 9.3, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0637';
UPDATE recipes SET name = '김 참치 덮밥', description = '현미밥에 참치 통조림, 시금치, 느타리버섯을 곁들인 1인분 현미 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0639';
UPDATE recipes SET name = '들깨 참치 덮밥', description = '현미밥에 참치 통조림, 청경채, 양송이버섯을 곁들인 1인분 현미 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0642';
UPDATE recipes SET name = '간장 참치 덮밥', description = '현미밥에 참치 통조림, 청경채, 양송이버섯을 곁들인 1인분 현미 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0643';
UPDATE recipes SET name = '마늘 참치 덮밥', description = '현미밥에 참치 통조림, 청경채, 양송이버섯을 곁들인 1인분 현미 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0644';
UPDATE recipes SET name = '생강간장 참치 덮밥', description = '현미밥에 참치 통조림, 청경채, 양송이버섯을 곁들인 1인분 현미 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0645';
UPDATE recipes SET name = '파간장 참치 덮밥', description = '현미밥에 참치 통조림, 청경채, 양송이버섯을 곁들인 1인분 현미 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0646';
UPDATE recipes SET name = '깻잎 참치 덮밥', description = '현미밥에 참치 통조림, 청경채, 양송이버섯을 곁들인 1인분 현미 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 364.0, protein_g = 28.7, carbs_g = 41.0, fat_g = 9.3, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0647';
UPDATE recipes SET name = '김 참치 덮밥', description = '현미밥에 참치 통조림, 청경채, 양송이버섯을 곁들인 1인분 현미 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0649';
UPDATE recipes SET name = '들깨 참치 덮밥', description = '현미밥에 참치 통조림, 가지, 토마토를 곁들인 1인분 현미 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0652';
UPDATE recipes SET name = '간장 참치 덮밥', description = '현미밥에 참치 통조림, 가지, 토마토를 곁들인 1인분 현미 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0653';
UPDATE recipes SET name = '마늘 참치 덮밥', description = '현미밥에 참치 통조림, 가지, 토마토를 곁들인 1인분 현미 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0654';
UPDATE recipes SET name = '생강간장 참치 덮밥', description = '현미밥에 참치 통조림, 가지, 토마토를 곁들인 1인분 현미 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0655';
UPDATE recipes SET name = '파간장 참치 덮밥', description = '현미밥에 참치 통조림, 가지, 토마토를 곁들인 1인분 현미 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0656';
UPDATE recipes SET name = '깻잎 참치 덮밥', description = '현미밥에 참치 통조림, 가지, 토마토를 곁들인 1인분 현미 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 370.0, protein_g = 26.8, carbs_g = 44.6, fat_g = 9.3, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0657';
UPDATE recipes SET name = '김 참치 덮밥', description = '현미밥에 참치 통조림, 가지, 토마토를 곁들인 1인분 현미 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0659';
UPDATE recipes SET name = '들깨 참치 덮밥', description = '현미밥에 참치 통조림, 양배추, 파프리카를 곁들인 1인분 현미 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0662';
UPDATE recipes SET name = '간장 참치 덮밥', description = '현미밥에 참치 통조림, 양배추, 파프리카를 곁들인 1인분 현미 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0663';
UPDATE recipes SET name = '마늘 참치 덮밥', description = '현미밥에 참치 통조림, 양배추, 파프리카를 곁들인 1인분 현미 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0664';
UPDATE recipes SET name = '생강간장 참치 덮밥', description = '현미밥에 참치 통조림, 양배추, 파프리카를 곁들인 1인분 현미 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0665';
UPDATE recipes SET name = '파간장 참치 덮밥', description = '현미밥에 참치 통조림, 양배추, 파프리카를 곁들인 1인분 현미 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0666';
UPDATE recipes SET name = '깻잎 참치 덮밥', description = '현미밥에 참치 통조림, 양배추, 파프리카를 곁들인 1인분 현미 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 372.0, protein_g = 26.6, carbs_g = 45.2, fat_g = 9.3, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0667';
UPDATE recipes SET name = '김 참치 덮밥', description = '현미밥에 참치 통조림, 양배추, 파프리카를 곁들인 1인분 현미 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0669';
UPDATE recipes SET name = '들깨 참치 덮밥', description = '현미밥에 참치 통조림, 브로콜리, 당근을 곁들인 1인분 현미 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0672';
UPDATE recipes SET name = '간장 참치 덮밥', description = '현미밥에 참치 통조림, 브로콜리, 당근을 곁들인 1인분 현미 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0673';
UPDATE recipes SET name = '마늘 참치 덮밥', description = '현미밥에 참치 통조림, 브로콜리, 당근을 곁들인 1인분 현미 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0674';
UPDATE recipes SET name = '생강간장 참치 덮밥', description = '현미밥에 참치 통조림, 브로콜리, 당근을 곁들인 1인분 현미 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0675';
UPDATE recipes SET name = '파간장 참치 덮밥', description = '현미밥에 참치 통조림, 브로콜리, 당근을 곁들인 1인분 현미 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0676';
UPDATE recipes SET name = '깻잎 참치 덮밥', description = '현미밥에 참치 통조림, 브로콜리, 당근을 곁들인 1인분 현미 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 389.0, protein_g = 28.3, carbs_g = 47.7, fat_g = 9.3, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0677';
UPDATE recipes SET name = '김 참치 덮밥', description = '현미밥에 참치 통조림, 브로콜리, 당근을 곁들인 1인분 현미 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0679';
UPDATE recipes SET name = '들깨 참치 덮밥', description = '현미밥에 참치 통조림, 애호박, 양송이버섯을 곁들인 1인분 현미 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0682';
UPDATE recipes SET name = '간장 참치 덮밥', description = '현미밥에 참치 통조림, 애호박, 양송이버섯을 곁들인 1인분 현미 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0683';
UPDATE recipes SET name = '마늘 참치 덮밥', description = '현미밥에 참치 통조림, 애호박, 양송이버섯을 곁들인 1인분 현미 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0684';
UPDATE recipes SET name = '생강간장 참치 덮밥', description = '현미밥에 참치 통조림, 애호박, 양송이버섯을 곁들인 1인분 현미 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0685';
UPDATE recipes SET name = '파간장 참치 덮밥', description = '현미밥에 참치 통조림, 애호박, 양송이버섯을 곁들인 1인분 현미 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0686';
UPDATE recipes SET name = '깻잎 참치 덮밥', description = '현미밥에 참치 통조림, 애호박, 양송이버섯을 곁들인 1인분 현미 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 361.0, protein_g = 27.9, carbs_g = 41.0, fat_g = 9.3, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0687';
UPDATE recipes SET name = '김 참치 덮밥', description = '현미밥에 참치 통조림, 애호박, 양송이버섯을 곁들인 1인분 현미 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0689';
UPDATE recipes SET name = '들깨 참치 덮밥', description = '현미밥에 참치 통조림, 시금치, 토마토를 곁들인 1인분 현미 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0692';
UPDATE recipes SET name = '간장 참치 덮밥', description = '현미밥에 참치 통조림, 시금치, 토마토를 곁들인 1인분 현미 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0693';
UPDATE recipes SET name = '마늘 참치 덮밥', description = '현미밥에 참치 통조림, 시금치, 토마토를 곁들인 1인분 현미 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0694';
UPDATE recipes SET name = '생강간장 참치 덮밥', description = '현미밥에 참치 통조림, 시금치, 토마토를 곁들인 1인분 현미 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0695';
UPDATE recipes SET name = '파간장 참치 덮밥', description = '현미밥에 참치 통조림, 시금치, 토마토를 곁들인 1인분 현미 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0696';
UPDATE recipes SET name = '깻잎 참치 덮밥', description = '현미밥에 참치 통조림, 시금치, 토마토를 곁들인 1인분 현미 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 366.0, protein_g = 27.8, carbs_g = 42.4, fat_g = 9.3, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0697';
UPDATE recipes SET name = '김 참치 덮밥', description = '현미밥에 참치 통조림, 시금치, 토마토를 곁들인 1인분 현미 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0699';
UPDATE recipes SET name = '레몬 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 양배추, 당근을 곁들인 1인분 퀴노아 볼. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0701';
UPDATE recipes SET name = '들깨 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 양배추, 당근을 곁들인 1인분 퀴노아 볼. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0702';
UPDATE recipes SET name = '간장 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 양배추, 당근을 곁들인 1인분 퀴노아 볼. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0703';
UPDATE recipes SET name = '마늘 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 양배추, 당근을 곁들인 1인분 퀴노아 볼. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0704';
UPDATE recipes SET name = '생강간장 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 양배추, 당근을 곁들인 1인분 퀴노아 볼. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0705';
UPDATE recipes SET name = '파간장 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 양배추, 당근을 곁들인 1인분 퀴노아 볼. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0706';
UPDATE recipes SET name = '깻잎 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 양배추, 당근을 곁들인 1인분 퀴노아 볼. 레몬올리브 양념, 깻잎 고명.', calories = 471.0, protein_g = 16.9, carbs_g = 71.2, fat_g = 13.2, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0707';
UPDATE recipes SET name = '바질 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 양배추, 당근을 곁들인 1인분 퀴노아 볼. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0708';
UPDATE recipes SET name = '김 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 양배추, 당근을 곁들인 1인분 퀴노아 볼. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0709';
UPDATE recipes SET name = '허브 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 양배추, 당근을 곁들인 1인분 퀴노아 볼. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0710';
UPDATE recipes SET name = '레몬 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 브로콜리, 양파를 곁들인 1인분 퀴노아 볼. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0711';
UPDATE recipes SET name = '들깨 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 브로콜리, 양파를 곁들인 1인분 퀴노아 볼. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0712';
UPDATE recipes SET name = '간장 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 브로콜리, 양파를 곁들인 1인분 퀴노아 볼. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0713';
UPDATE recipes SET name = '마늘 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 브로콜리, 양파를 곁들인 1인분 퀴노아 볼. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0714';
UPDATE recipes SET name = '생강간장 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 브로콜리, 양파를 곁들인 1인분 퀴노아 볼. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0715';
UPDATE recipes SET name = '파간장 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 브로콜리, 양파를 곁들인 1인분 퀴노아 볼. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0716';
UPDATE recipes SET name = '깻잎 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 브로콜리, 양파를 곁들인 1인분 퀴노아 볼. 레몬올리브 양념, 깻잎 고명.', calories = 478.0, protein_g = 18.6, carbs_g = 71.4, fat_g = 13.2, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0717';
UPDATE recipes SET name = '바질 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 브로콜리, 양파를 곁들인 1인분 퀴노아 볼. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0718';
UPDATE recipes SET name = '김 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 브로콜리, 양파를 곁들인 1인분 퀴노아 볼. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0719';
UPDATE recipes SET name = '허브 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 브로콜리, 양파를 곁들인 1인분 퀴노아 볼. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0720';
UPDATE recipes SET name = '레몬 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 애호박, 파프리카를 곁들인 1인분 퀴노아 볼. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0721';
UPDATE recipes SET name = '들깨 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 애호박, 파프리카를 곁들인 1인분 퀴노아 볼. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0722';
UPDATE recipes SET name = '간장 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 애호박, 파프리카를 곁들인 1인분 퀴노아 볼. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0723';
UPDATE recipes SET name = '마늘 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 애호박, 파프리카를 곁들인 1인분 퀴노아 볼. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0724';
UPDATE recipes SET name = '생강간장 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 애호박, 파프리카를 곁들인 1인분 퀴노아 볼. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0725';
UPDATE recipes SET name = '파간장 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 애호박, 파프리카를 곁들인 1인분 퀴노아 볼. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0726';
UPDATE recipes SET name = '깻잎 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 애호박, 파프리카를 곁들인 1인분 퀴노아 볼. 레몬올리브 양념, 깻잎 고명.', calories = 455.0, protein_g = 17.0, carbs_g = 67.3, fat_g = 13.2, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0727';
UPDATE recipes SET name = '바질 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 애호박, 파프리카를 곁들인 1인분 퀴노아 볼. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0728';
UPDATE recipes SET name = '김 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 애호박, 파프리카를 곁들인 1인분 퀴노아 볼. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0729';
UPDATE recipes SET name = '허브 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 애호박, 파프리카를 곁들인 1인분 퀴노아 볼. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0730';
UPDATE recipes SET name = '레몬 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 시금치, 느타리버섯을 곁들인 1인분 퀴노아 볼. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0731';
UPDATE recipes SET name = '들깨 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 시금치, 느타리버섯을 곁들인 1인분 퀴노아 볼. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0732';
UPDATE recipes SET name = '간장 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 시금치, 느타리버섯을 곁들인 1인분 퀴노아 볼. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0733';
UPDATE recipes SET name = '마늘 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 시금치, 느타리버섯을 곁들인 1인분 퀴노아 볼. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0734';
UPDATE recipes SET name = '생강간장 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 시금치, 느타리버섯을 곁들인 1인분 퀴노아 볼. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0735';
UPDATE recipes SET name = '파간장 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 시금치, 느타리버섯을 곁들인 1인분 퀴노아 볼. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0736';
UPDATE recipes SET name = '깻잎 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 시금치, 느타리버섯을 곁들인 1인분 퀴노아 볼. 레몬올리브 양념, 깻잎 고명.', calories = 471.0, protein_g = 19.8, carbs_g = 68.5, fat_g = 13.2, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0737';
UPDATE recipes SET name = '바질 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 시금치, 느타리버섯을 곁들인 1인분 퀴노아 볼. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0738';
UPDATE recipes SET name = '김 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 시금치, 느타리버섯을 곁들인 1인분 퀴노아 볼. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0739';
UPDATE recipes SET name = '허브 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 시금치, 느타리버섯을 곁들인 1인분 퀴노아 볼. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0740';
UPDATE recipes SET name = '레몬 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 청경채, 양송이버섯을 곁들인 1인분 퀴노아 볼. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0741';
UPDATE recipes SET name = '들깨 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 청경채, 양송이버섯을 곁들인 1인분 퀴노아 볼. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0742';
UPDATE recipes SET name = '간장 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 청경채, 양송이버섯을 곁들인 1인분 퀴노아 볼. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0743';
UPDATE recipes SET name = '마늘 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 청경채, 양송이버섯을 곁들인 1인분 퀴노아 볼. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0744';
UPDATE recipes SET name = '생강간장 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 청경채, 양송이버섯을 곁들인 1인분 퀴노아 볼. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0745';
UPDATE recipes SET name = '파간장 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 청경채, 양송이버섯을 곁들인 1인분 퀴노아 볼. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0746';
UPDATE recipes SET name = '깻잎 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 청경채, 양송이버섯을 곁들인 1인분 퀴노아 볼. 레몬올리브 양념, 깻잎 고명.', calories = 457.0, protein_g = 19.0, carbs_g = 65.6, fat_g = 13.2, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0747';
UPDATE recipes SET name = '바질 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 청경채, 양송이버섯을 곁들인 1인분 퀴노아 볼. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0748';
UPDATE recipes SET name = '김 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 청경채, 양송이버섯을 곁들인 1인분 퀴노아 볼. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0749';
UPDATE recipes SET name = '허브 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 청경채, 양송이버섯을 곁들인 1인분 퀴노아 볼. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0750';
UPDATE recipes SET name = '레몬 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 가지, 토마토를 곁들인 1인분 퀴노아 볼. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0751';
UPDATE recipes SET name = '들깨 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 가지, 토마토를 곁들인 1인분 퀴노아 볼. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0752';
UPDATE recipes SET name = '간장 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 가지, 토마토를 곁들인 1인분 퀴노아 볼. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0753';
UPDATE recipes SET name = '마늘 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 가지, 토마토를 곁들인 1인분 퀴노아 볼. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0754';
UPDATE recipes SET name = '생강간장 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 가지, 토마토를 곁들인 1인분 퀴노아 볼. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0755';
UPDATE recipes SET name = '파간장 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 가지, 토마토를 곁들인 1인분 퀴노아 볼. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0756';
UPDATE recipes SET name = '깻잎 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 가지, 토마토를 곁들인 1인분 퀴노아 볼. 레몬올리브 양념, 깻잎 고명.', calories = 464.0, protein_g = 17.1, carbs_g = 69.2, fat_g = 13.2, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0757';
UPDATE recipes SET name = '바질 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 가지, 토마토를 곁들인 1인분 퀴노아 볼. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0758';
UPDATE recipes SET name = '김 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 가지, 토마토를 곁들인 1인분 퀴노아 볼. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0759';
UPDATE recipes SET name = '허브 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 가지, 토마토를 곁들인 1인분 퀴노아 볼. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0760';
UPDATE recipes SET name = '레몬 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 양배추, 파프리카를 곁들인 1인분 퀴노아 볼. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0761';
UPDATE recipes SET name = '들깨 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 양배추, 파프리카를 곁들인 1인분 퀴노아 볼. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0762';
UPDATE recipes SET name = '간장 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 양배추, 파프리카를 곁들인 1인분 퀴노아 볼. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0763';
UPDATE recipes SET name = '마늘 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 양배추, 파프리카를 곁들인 1인분 퀴노아 볼. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0764';
UPDATE recipes SET name = '생강간장 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 양배추, 파프리카를 곁들인 1인분 퀴노아 볼. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0765';
UPDATE recipes SET name = '파간장 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 양배추, 파프리카를 곁들인 1인분 퀴노아 볼. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0766';
UPDATE recipes SET name = '깻잎 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 양배추, 파프리카를 곁들인 1인분 퀴노아 볼. 레몬올리브 양념, 깻잎 고명.', calories = 465.0, protein_g = 17.0, carbs_g = 69.8, fat_g = 13.2, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0767';
UPDATE recipes SET name = '바질 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 양배추, 파프리카를 곁들인 1인분 퀴노아 볼. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0768';
UPDATE recipes SET name = '김 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 양배추, 파프리카를 곁들인 1인분 퀴노아 볼. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0769';
UPDATE recipes SET name = '허브 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 양배추, 파프리카를 곁들인 1인분 퀴노아 볼. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0770';
UPDATE recipes SET name = '레몬 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 브로콜리, 당근을 곁들인 1인분 퀴노아 볼. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0771';
UPDATE recipes SET name = '들깨 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 브로콜리, 당근을 곁들인 1인분 퀴노아 볼. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0772';
UPDATE recipes SET name = '간장 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 브로콜리, 당근을 곁들인 1인분 퀴노아 볼. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0773';
UPDATE recipes SET name = '마늘 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 브로콜리, 당근을 곁들인 1인분 퀴노아 볼. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0774';
UPDATE recipes SET name = '생강간장 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 브로콜리, 당근을 곁들인 1인분 퀴노아 볼. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0775';
UPDATE recipes SET name = '파간장 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 브로콜리, 당근을 곁들인 1인분 퀴노아 볼. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0776';
UPDATE recipes SET name = '깻잎 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 브로콜리, 당근을 곁들인 1인분 퀴노아 볼. 레몬올리브 양념, 깻잎 고명.', calories = 482.0, protein_g = 18.6, carbs_g = 72.4, fat_g = 13.2, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0777';
UPDATE recipes SET name = '바질 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 브로콜리, 당근을 곁들인 1인분 퀴노아 볼. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0778';
UPDATE recipes SET name = '김 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 브로콜리, 당근을 곁들인 1인분 퀴노아 볼. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0779';
UPDATE recipes SET name = '허브 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 브로콜리, 당근을 곁들인 1인분 퀴노아 볼. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0780';
UPDATE recipes SET name = '레몬 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 애호박, 양송이버섯을 곁들인 1인분 퀴노아 볼. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0781';
UPDATE recipes SET name = '들깨 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 애호박, 양송이버섯을 곁들인 1인분 퀴노아 볼. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0782';
UPDATE recipes SET name = '간장 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 애호박, 양송이버섯을 곁들인 1인분 퀴노아 볼. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0783';
UPDATE recipes SET name = '마늘 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 애호박, 양송이버섯을 곁들인 1인분 퀴노아 볼. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0784';
UPDATE recipes SET name = '생강간장 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 애호박, 양송이버섯을 곁들인 1인분 퀴노아 볼. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0785';
UPDATE recipes SET name = '파간장 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 애호박, 양송이버섯을 곁들인 1인분 퀴노아 볼. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0786';
UPDATE recipes SET name = '깻잎 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 애호박, 양송이버섯을 곁들인 1인분 퀴노아 볼. 레몬올리브 양념, 깻잎 고명.', calories = 454.0, protein_g = 18.3, carbs_g = 65.6, fat_g = 13.2, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0787';
UPDATE recipes SET name = '바질 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 애호박, 양송이버섯을 곁들인 1인분 퀴노아 볼. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0788';
UPDATE recipes SET name = '김 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 애호박, 양송이버섯을 곁들인 1인분 퀴노아 볼. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0789';
UPDATE recipes SET name = '허브 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 애호박, 양송이버섯을 곁들인 1인분 퀴노아 볼. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0790';
UPDATE recipes SET name = '레몬 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 시금치, 토마토를 곁들인 1인분 퀴노아 볼. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0791';
UPDATE recipes SET name = '들깨 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 시금치, 토마토를 곁들인 1인분 퀴노아 볼. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0792';
UPDATE recipes SET name = '간장 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 시금치, 토마토를 곁들인 1인분 퀴노아 볼. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0793';
UPDATE recipes SET name = '마늘 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 시금치, 토마토를 곁들인 1인분 퀴노아 볼. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0794';
UPDATE recipes SET name = '생강간장 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 시금치, 토마토를 곁들인 1인분 퀴노아 볼. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0795';
UPDATE recipes SET name = '파간장 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 시금치, 토마토를 곁들인 1인분 퀴노아 볼. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0796';
UPDATE recipes SET name = '깻잎 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 시금치, 토마토를 곁들인 1인분 퀴노아 볼. 레몬올리브 양념, 깻잎 고명.', calories = 459.0, protein_g = 18.2, carbs_g = 67.0, fat_g = 13.2, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0797';
UPDATE recipes SET name = '바질 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 시금치, 토마토를 곁들인 1인분 퀴노아 볼. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0798';
UPDATE recipes SET name = '김 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 시금치, 토마토를 곁들인 1인분 퀴노아 볼. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0799';
UPDATE recipes SET name = '허브 병아리콩 퀴노아볼', description = '퀴노아에 병아리콩, 시금치, 토마토를 곁들인 1인분 퀴노아 볼. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0800';
UPDATE recipes SET name = '들깨 달걀 비빔밥', description = '보리밥에 달걀, 양배추, 당근을 곁들인 1인분 보리 비빔밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0802';
UPDATE recipes SET name = '간장 달걀 비빔밥', description = '보리밥에 달걀, 양배추, 당근을 곁들인 1인분 보리 비빔밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0803';
UPDATE recipes SET name = '마늘 달걀 비빔밥', description = '보리밥에 달걀, 양배추, 당근을 곁들인 1인분 보리 비빔밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0804';
UPDATE recipes SET name = '생강간장 달걀 비빔밥', description = '보리밥에 달걀, 양배추, 당근을 곁들인 1인분 보리 비빔밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0805';
UPDATE recipes SET name = '파간장 달걀 비빔밥', description = '보리밥에 달걀, 양배추, 당근을 곁들인 1인분 보리 비빔밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0806';
UPDATE recipes SET name = '깻잎 달걀 비빔밥', description = '보리밥에 달걀, 양배추, 당근을 곁들인 1인분 보리 비빔밥. 들기름간장 양념, 깻잎 고명.', calories = 470.0, protein_g = 17.8, carbs_g = 53.3, fat_g = 20.5, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0807';
UPDATE recipes SET name = '김 달걀 비빔밥', description = '보리밥에 달걀, 양배추, 당근을 곁들인 1인분 보리 비빔밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0809';
UPDATE recipes SET name = '들깨 달걀 비빔밥', description = '보리밥에 달걀, 브로콜리, 양파를 곁들인 1인분 보리 비빔밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0812';
UPDATE recipes SET name = '간장 달걀 비빔밥', description = '보리밥에 달걀, 브로콜리, 양파를 곁들인 1인분 보리 비빔밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0813';
UPDATE recipes SET name = '마늘 달걀 비빔밥', description = '보리밥에 달걀, 브로콜리, 양파를 곁들인 1인분 보리 비빔밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0814';
UPDATE recipes SET name = '생강간장 달걀 비빔밥', description = '보리밥에 달걀, 브로콜리, 양파를 곁들인 1인분 보리 비빔밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0815';
UPDATE recipes SET name = '파간장 달걀 비빔밥', description = '보리밥에 달걀, 브로콜리, 양파를 곁들인 1인분 보리 비빔밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0816';
UPDATE recipes SET name = '깻잎 달걀 비빔밥', description = '보리밥에 달걀, 브로콜리, 양파를 곁들인 1인분 보리 비빔밥. 들기름간장 양념, 깻잎 고명.', calories = 478.0, protein_g = 19.5, carbs_g = 53.5, fat_g = 20.5, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0817';
UPDATE recipes SET name = '김 달걀 비빔밥', description = '보리밥에 달걀, 브로콜리, 양파를 곁들인 1인분 보리 비빔밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0819';
UPDATE recipes SET name = '들깨 달걀 비빔밥', description = '보리밥에 달걀, 애호박, 파프리카를 곁들인 1인분 보리 비빔밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0822';
UPDATE recipes SET name = '간장 달걀 비빔밥', description = '보리밥에 달걀, 애호박, 파프리카를 곁들인 1인분 보리 비빔밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0823';
UPDATE recipes SET name = '마늘 달걀 비빔밥', description = '보리밥에 달걀, 애호박, 파프리카를 곁들인 1인분 보리 비빔밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0824';
UPDATE recipes SET name = '생강간장 달걀 비빔밥', description = '보리밥에 달걀, 애호박, 파프리카를 곁들인 1인분 보리 비빔밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0825';
UPDATE recipes SET name = '파간장 달걀 비빔밥', description = '보리밥에 달걀, 애호박, 파프리카를 곁들인 1인분 보리 비빔밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0826';
UPDATE recipes SET name = '깻잎 달걀 비빔밥', description = '보리밥에 달걀, 애호박, 파프리카를 곁들인 1인분 보리 비빔밥. 들기름간장 양념, 깻잎 고명.', calories = 455.0, protein_g = 17.9, carbs_g = 49.4, fat_g = 20.5, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0827';
UPDATE recipes SET name = '김 달걀 비빔밥', description = '보리밥에 달걀, 애호박, 파프리카를 곁들인 1인분 보리 비빔밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0829';
UPDATE recipes SET name = '들깨 달걀 비빔밥', description = '보리밥에 달걀, 시금치, 느타리버섯을 곁들인 1인분 보리 비빔밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0832';
UPDATE recipes SET name = '간장 달걀 비빔밥', description = '보리밥에 달걀, 시금치, 느타리버섯을 곁들인 1인분 보리 비빔밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0833';
UPDATE recipes SET name = '마늘 달걀 비빔밥', description = '보리밥에 달걀, 시금치, 느타리버섯을 곁들인 1인분 보리 비빔밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0834';
UPDATE recipes SET name = '생강간장 달걀 비빔밥', description = '보리밥에 달걀, 시금치, 느타리버섯을 곁들인 1인분 보리 비빔밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0835';
UPDATE recipes SET name = '파간장 달걀 비빔밥', description = '보리밥에 달걀, 시금치, 느타리버섯을 곁들인 1인분 보리 비빔밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0836';
UPDATE recipes SET name = '깻잎 달걀 비빔밥', description = '보리밥에 달걀, 시금치, 느타리버섯을 곁들인 1인분 보리 비빔밥. 들기름간장 양념, 깻잎 고명.', calories = 471.0, protein_g = 20.7, carbs_g = 50.6, fat_g = 20.5, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0837';
UPDATE recipes SET name = '김 달걀 비빔밥', description = '보리밥에 달걀, 시금치, 느타리버섯을 곁들인 1인분 보리 비빔밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0839';
UPDATE recipes SET name = '들깨 달걀 비빔밥', description = '보리밥에 달걀, 청경채, 양송이버섯을 곁들인 1인분 보리 비빔밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0842';
UPDATE recipes SET name = '간장 달걀 비빔밥', description = '보리밥에 달걀, 청경채, 양송이버섯을 곁들인 1인분 보리 비빔밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0843';
UPDATE recipes SET name = '마늘 달걀 비빔밥', description = '보리밥에 달걀, 청경채, 양송이버섯을 곁들인 1인분 보리 비빔밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0844';
UPDATE recipes SET name = '생강간장 달걀 비빔밥', description = '보리밥에 달걀, 청경채, 양송이버섯을 곁들인 1인분 보리 비빔밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0845';
UPDATE recipes SET name = '파간장 달걀 비빔밥', description = '보리밥에 달걀, 청경채, 양송이버섯을 곁들인 1인분 보리 비빔밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0846';
UPDATE recipes SET name = '깻잎 달걀 비빔밥', description = '보리밥에 달걀, 청경채, 양송이버섯을 곁들인 1인분 보리 비빔밥. 들기름간장 양념, 깻잎 고명.', calories = 456.0, protein_g = 19.9, carbs_g = 47.7, fat_g = 20.5, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0847';
UPDATE recipes SET name = '김 달걀 비빔밥', description = '보리밥에 달걀, 청경채, 양송이버섯을 곁들인 1인분 보리 비빔밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0849';
UPDATE recipes SET name = '들깨 달걀 비빔밥', description = '보리밥에 달걀, 가지, 토마토를 곁들인 1인분 보리 비빔밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0852';
UPDATE recipes SET name = '간장 달걀 비빔밥', description = '보리밥에 달걀, 가지, 토마토를 곁들인 1인분 보리 비빔밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0853';
UPDATE recipes SET name = '마늘 달걀 비빔밥', description = '보리밥에 달걀, 가지, 토마토를 곁들인 1인분 보리 비빔밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0854';
UPDATE recipes SET name = '생강간장 달걀 비빔밥', description = '보리밥에 달걀, 가지, 토마토를 곁들인 1인분 보리 비빔밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0855';
UPDATE recipes SET name = '파간장 달걀 비빔밥', description = '보리밥에 달걀, 가지, 토마토를 곁들인 1인분 보리 비빔밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0856';
UPDATE recipes SET name = '깻잎 달걀 비빔밥', description = '보리밥에 달걀, 가지, 토마토를 곁들인 1인분 보리 비빔밥. 들기름간장 양념, 깻잎 고명.', calories = 463.0, protein_g = 18.0, carbs_g = 51.3, fat_g = 20.5, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0857';
UPDATE recipes SET name = '김 달걀 비빔밥', description = '보리밥에 달걀, 가지, 토마토를 곁들인 1인분 보리 비빔밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0859';
UPDATE recipes SET name = '들깨 달걀 비빔밥', description = '보리밥에 달걀, 양배추, 파프리카를 곁들인 1인분 보리 비빔밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0862';
UPDATE recipes SET name = '간장 달걀 비빔밥', description = '보리밥에 달걀, 양배추, 파프리카를 곁들인 1인분 보리 비빔밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0863';
UPDATE recipes SET name = '마늘 달걀 비빔밥', description = '보리밥에 달걀, 양배추, 파프리카를 곁들인 1인분 보리 비빔밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0864';
UPDATE recipes SET name = '생강간장 달걀 비빔밥', description = '보리밥에 달걀, 양배추, 파프리카를 곁들인 1인분 보리 비빔밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0865';
UPDATE recipes SET name = '파간장 달걀 비빔밥', description = '보리밥에 달걀, 양배추, 파프리카를 곁들인 1인분 보리 비빔밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0866';
UPDATE recipes SET name = '깻잎 달걀 비빔밥', description = '보리밥에 달걀, 양배추, 파프리카를 곁들인 1인분 보리 비빔밥. 들기름간장 양념, 깻잎 고명.', calories = 465.0, protein_g = 17.9, carbs_g = 51.9, fat_g = 20.5, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0867';
UPDATE recipes SET name = '김 달걀 비빔밥', description = '보리밥에 달걀, 양배추, 파프리카를 곁들인 1인분 보리 비빔밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0869';
UPDATE recipes SET name = '들깨 달걀 비빔밥', description = '보리밥에 달걀, 브로콜리, 당근을 곁들인 1인분 보리 비빔밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0872';
UPDATE recipes SET name = '간장 달걀 비빔밥', description = '보리밥에 달걀, 브로콜리, 당근을 곁들인 1인분 보리 비빔밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0873';
UPDATE recipes SET name = '마늘 달걀 비빔밥', description = '보리밥에 달걀, 브로콜리, 당근을 곁들인 1인분 보리 비빔밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0874';
UPDATE recipes SET name = '생강간장 달걀 비빔밥', description = '보리밥에 달걀, 브로콜리, 당근을 곁들인 1인분 보리 비빔밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0875';
UPDATE recipes SET name = '파간장 달걀 비빔밥', description = '보리밥에 달걀, 브로콜리, 당근을 곁들인 1인분 보리 비빔밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0876';
UPDATE recipes SET name = '깻잎 달걀 비빔밥', description = '보리밥에 달걀, 브로콜리, 당근을 곁들인 1인분 보리 비빔밥. 들기름간장 양념, 깻잎 고명.', calories = 482.0, protein_g = 19.5, carbs_g = 54.5, fat_g = 20.5, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0877';
UPDATE recipes SET name = '김 달걀 비빔밥', description = '보리밥에 달걀, 브로콜리, 당근을 곁들인 1인분 보리 비빔밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0879';
UPDATE recipes SET name = '들깨 달걀 비빔밥', description = '보리밥에 달걀, 애호박, 양송이버섯을 곁들인 1인분 보리 비빔밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0882';
UPDATE recipes SET name = '간장 달걀 비빔밥', description = '보리밥에 달걀, 애호박, 양송이버섯을 곁들인 1인분 보리 비빔밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0883';
UPDATE recipes SET name = '마늘 달걀 비빔밥', description = '보리밥에 달걀, 애호박, 양송이버섯을 곁들인 1인분 보리 비빔밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0884';
UPDATE recipes SET name = '생강간장 달걀 비빔밥', description = '보리밥에 달걀, 애호박, 양송이버섯을 곁들인 1인분 보리 비빔밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0885';
UPDATE recipes SET name = '파간장 달걀 비빔밥', description = '보리밥에 달걀, 애호박, 양송이버섯을 곁들인 1인분 보리 비빔밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0886';
UPDATE recipes SET name = '깻잎 달걀 비빔밥', description = '보리밥에 달걀, 애호박, 양송이버섯을 곁들인 1인분 보리 비빔밥. 들기름간장 양념, 깻잎 고명.', calories = 453.0, protein_g = 19.2, carbs_g = 47.7, fat_g = 20.5, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0887';
UPDATE recipes SET name = '김 달걀 비빔밥', description = '보리밥에 달걀, 애호박, 양송이버섯을 곁들인 1인분 보리 비빔밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0889';
UPDATE recipes SET name = '들깨 달걀 비빔밥', description = '보리밥에 달걀, 시금치, 토마토를 곁들인 1인분 보리 비빔밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0892';
UPDATE recipes SET name = '간장 달걀 비빔밥', description = '보리밥에 달걀, 시금치, 토마토를 곁들인 1인분 보리 비빔밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0893';
UPDATE recipes SET name = '마늘 달걀 비빔밥', description = '보리밥에 달걀, 시금치, 토마토를 곁들인 1인분 보리 비빔밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0894';
UPDATE recipes SET name = '생강간장 달걀 비빔밥', description = '보리밥에 달걀, 시금치, 토마토를 곁들인 1인분 보리 비빔밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0895';
UPDATE recipes SET name = '파간장 달걀 비빔밥', description = '보리밥에 달걀, 시금치, 토마토를 곁들인 1인분 보리 비빔밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0896';
UPDATE recipes SET name = '깻잎 달걀 비빔밥', description = '보리밥에 달걀, 시금치, 토마토를 곁들인 1인분 보리 비빔밥. 들기름간장 양념, 깻잎 고명.', calories = 459.0, protein_g = 19.1, carbs_g = 49.1, fat_g = 20.5, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0897';
UPDATE recipes SET name = '김 달걀 비빔밥', description = '보리밥에 달걀, 시금치, 토마토를 곁들인 1인분 보리 비빔밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0899';
UPDATE recipes SET name = '들기름간장 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 양배추, 당근을 곁들인 1인분 오트죽. 들기름간장 양념.', calories = 453.0, protein_g = 18.7, carbs_g = 68.8, fat_g = 11.3, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0901';
UPDATE recipes SET name = '들기름 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 양배추, 당근을 곁들인 1인분 오트죽. 들기름소금 양념.', calories = 449.0, protein_g = 18.4, carbs_g = 68.6, fat_g = 11.3, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0902';
UPDATE recipes SET name = '간장 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 양배추, 당근을 곁들인 1인분 오트죽. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0903';
UPDATE recipes SET name = '마늘간장 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 양배추, 당근을 곁들인 1인분 오트죽. 마늘간장 양념.', calories = 421.0, protein_g = 18.8, carbs_g = 69.9, fat_g = 7.3, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0904';
UPDATE recipes SET name = '생강간장 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 양배추, 당근을 곁들인 1인분 오트죽. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0905';
UPDATE recipes SET name = '파간장 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 양배추, 당근을 곁들인 1인분 오트죽. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0906';
UPDATE recipes SET name = '깻잎 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 양배추, 당근을 곁들인 1인분 오트죽. 들기름간장 양념, 깻잎 고명.', calories = 455.0, protein_g = 18.8, carbs_g = 69.2, fat_g = 11.3, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0907';
UPDATE recipes SET name = '파기름 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 양배추, 당근을 곁들인 1인분 오트죽. 파참기름 양념.', calories = 453.0, protein_g = 18.5, carbs_g = 69.2, fat_g = 11.3, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0908';
UPDATE recipes SET name = '김 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 양배추, 당근을 곁들인 1인분 오트죽. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0909';
UPDATE recipes SET name = '김 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 양배추, 당근을 곁들인 1인분 오트죽. 김들기름 양념.', calories = 457.0, protein_g = 19.1, carbs_g = 69.5, fat_g = 11.4, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0910';
UPDATE recipes SET name = '들기름간장 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 브로콜리, 양파를 곁들인 1인분 오트죽. 들기름간장 양념.', calories = 461.0, protein_g = 20.4, carbs_g = 69.0, fat_g = 11.3, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0911';
UPDATE recipes SET name = '들기름 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 브로콜리, 양파를 곁들인 1인분 오트죽. 들기름소금 양념.', calories = 456.0, protein_g = 20.1, carbs_g = 68.8, fat_g = 11.3, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0912';
UPDATE recipes SET name = '간장 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 브로콜리, 양파를 곁들인 1인분 오트죽. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0913';
UPDATE recipes SET name = '마늘간장 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 브로콜리, 양파를 곁들인 1인분 오트죽. 마늘간장 양념.', calories = 428.0, protein_g = 20.5, carbs_g = 70.1, fat_g = 7.3, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0914';
UPDATE recipes SET name = '생강간장 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 브로콜리, 양파를 곁들인 1인분 오트죽. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0915';
UPDATE recipes SET name = '파간장 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 브로콜리, 양파를 곁들인 1인분 오트죽. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0916';
UPDATE recipes SET name = '깻잎 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 브로콜리, 양파를 곁들인 1인분 오트죽. 들기름간장 양념, 깻잎 고명.', calories = 463.0, protein_g = 20.5, carbs_g = 69.4, fat_g = 11.3, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0917';
UPDATE recipes SET name = '파기름 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 브로콜리, 양파를 곁들인 1인분 오트죽. 파참기름 양념.', calories = 460.0, protein_g = 20.2, carbs_g = 69.4, fat_g = 11.3, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0918';
UPDATE recipes SET name = '김 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 브로콜리, 양파를 곁들인 1인분 오트죽. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0919';
UPDATE recipes SET name = '김 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 브로콜리, 양파를 곁들인 1인분 오트죽. 김들기름 양념.', calories = 464.0, protein_g = 20.8, carbs_g = 69.7, fat_g = 11.4, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0920';
UPDATE recipes SET name = '들기름간장 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 애호박, 파프리카를 곁들인 1인분 오트죽. 들기름간장 양념.', calories = 438.0, protein_g = 18.7, carbs_g = 65.0, fat_g = 11.3, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0921';
UPDATE recipes SET name = '들기름 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 애호박, 파프리카를 곁들인 1인분 오트죽. 들기름소금 양념.', calories = 433.0, protein_g = 18.4, carbs_g = 64.7, fat_g = 11.3, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0922';
UPDATE recipes SET name = '간장 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 애호박, 파프리카를 곁들인 1인분 오트죽. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0923';
UPDATE recipes SET name = '마늘간장 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 애호박, 파프리카를 곁들인 1인분 오트죽. 마늘간장 양념.', calories = 405.0, protein_g = 18.9, carbs_g = 66.0, fat_g = 7.3, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0924';
UPDATE recipes SET name = '생강간장 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 애호박, 파프리카를 곁들인 1인분 오트죽. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0925';
UPDATE recipes SET name = '파간장 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 애호박, 파프리카를 곁들인 1인분 오트죽. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0926';
UPDATE recipes SET name = '깻잎 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 애호박, 파프리카를 곁들인 1인분 오트죽. 들기름간장 양념, 깻잎 고명.', calories = 440.0, protein_g = 18.9, carbs_g = 65.2, fat_g = 11.3, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0927';
UPDATE recipes SET name = '파기름 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 애호박, 파프리카를 곁들인 1인분 오트죽. 파참기름 양념.', calories = 437.0, protein_g = 18.6, carbs_g = 65.3, fat_g = 11.3, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0928';
UPDATE recipes SET name = '김 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 애호박, 파프리카를 곁들인 1인분 오트죽. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0929';
UPDATE recipes SET name = '김 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 애호박, 파프리카를 곁들인 1인분 오트죽. 김들기름 양념.', calories = 441.0, protein_g = 19.2, carbs_g = 65.5, fat_g = 11.4, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0930';
UPDATE recipes SET name = '들기름간장 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 시금치, 느타리버섯을 곁들인 1인분 오트죽. 들기름간장 양념.', calories = 454.0, protein_g = 21.5, carbs_g = 66.2, fat_g = 11.3, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0931';
UPDATE recipes SET name = '들기름 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 시금치, 느타리버섯을 곁들인 1인분 오트죽. 들기름소금 양념.', calories = 450.0, protein_g = 21.2, carbs_g = 65.9, fat_g = 11.3, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0932';
UPDATE recipes SET name = '간장 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 시금치, 느타리버섯을 곁들인 1인분 오트죽. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0933';
UPDATE recipes SET name = '마늘간장 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 시금치, 느타리버섯을 곁들인 1인분 오트죽. 마늘간장 양념.', calories = 421.0, protein_g = 21.7, carbs_g = 67.2, fat_g = 7.3, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0934';
UPDATE recipes SET name = '생강간장 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 시금치, 느타리버섯을 곁들인 1인분 오트죽. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0935';
UPDATE recipes SET name = '파간장 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 시금치, 느타리버섯을 곁들인 1인분 오트죽. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0936';
UPDATE recipes SET name = '깻잎 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 시금치, 느타리버섯을 곁들인 1인분 오트죽. 들기름간장 양념, 깻잎 고명.', calories = 456.0, protein_g = 21.7, carbs_g = 66.5, fat_g = 11.3, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0937';
UPDATE recipes SET name = '파기름 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 시금치, 느타리버섯을 곁들인 1인분 오트죽. 파참기름 양념.', calories = 453.0, protein_g = 21.4, carbs_g = 66.5, fat_g = 11.3, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0938';
UPDATE recipes SET name = '김 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 시금치, 느타리버섯을 곁들인 1인분 오트죽. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0939';
UPDATE recipes SET name = '김 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 시금치, 느타리버섯을 곁들인 1인분 오트죽. 김들기름 양념.', calories = 458.0, protein_g = 22.0, carbs_g = 66.8, fat_g = 11.4, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0940';
UPDATE recipes SET name = '들기름간장 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 청경채, 양송이버섯을 곁들인 1인분 오트죽. 들기름간장 양념.', calories = 440.0, protein_g = 20.8, carbs_g = 63.3, fat_g = 11.3, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0941';
UPDATE recipes SET name = '들기름 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 청경채, 양송이버섯을 곁들인 1인분 오트죽. 들기름소금 양념.', calories = 435.0, protein_g = 20.5, carbs_g = 63.0, fat_g = 11.3, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0942';
UPDATE recipes SET name = '간장 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 청경채, 양송이버섯을 곁들인 1인분 오트죽. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0943';
UPDATE recipes SET name = '마늘간장 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 청경채, 양송이버섯을 곁들인 1인분 오트죽. 마늘간장 양념.', calories = 407.0, protein_g = 21.0, carbs_g = 64.3, fat_g = 7.3, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0944';
UPDATE recipes SET name = '생강간장 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 청경채, 양송이버섯을 곁들인 1인분 오트죽. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0945';
UPDATE recipes SET name = '파간장 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 청경채, 양송이버섯을 곁들인 1인분 오트죽. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0946';
UPDATE recipes SET name = '깻잎 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 청경채, 양송이버섯을 곁들인 1인분 오트죽. 들기름간장 양념, 깻잎 고명.', calories = 441.0, protein_g = 21.0, carbs_g = 63.6, fat_g = 11.3, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0947';
UPDATE recipes SET name = '파기름 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 청경채, 양송이버섯을 곁들인 1인분 오트죽. 파참기름 양념.', calories = 439.0, protein_g = 20.7, carbs_g = 63.6, fat_g = 11.3, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0948';
UPDATE recipes SET name = '김 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 청경채, 양송이버섯을 곁들인 1인분 오트죽. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0949';
UPDATE recipes SET name = '김 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 청경채, 양송이버섯을 곁들인 1인분 오트죽. 김들기름 양념.', calories = 443.0, protein_g = 21.2, carbs_g = 63.9, fat_g = 11.4, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0950';
UPDATE recipes SET name = '들기름간장 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 가지, 토마토를 곁들인 1인분 오트죽. 들기름간장 양념.', calories = 446.0, protein_g = 18.9, carbs_g = 66.8, fat_g = 11.3, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0951';
UPDATE recipes SET name = '들기름 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 가지, 토마토를 곁들인 1인분 오트죽. 들기름소금 양념.', calories = 442.0, protein_g = 18.6, carbs_g = 66.6, fat_g = 11.3, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0952';
UPDATE recipes SET name = '간장 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 가지, 토마토를 곁들인 1인분 오트죽. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0953';
UPDATE recipes SET name = '마늘간장 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 가지, 토마토를 곁들인 1인분 오트죽. 마늘간장 양념.', calories = 414.0, protein_g = 19.1, carbs_g = 67.9, fat_g = 7.3, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0954';
UPDATE recipes SET name = '생강간장 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 가지, 토마토를 곁들인 1인분 오트죽. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0955';
UPDATE recipes SET name = '파간장 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 가지, 토마토를 곁들인 1인분 오트죽. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0956';
UPDATE recipes SET name = '깻잎 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 가지, 토마토를 곁들인 1인분 오트죽. 들기름간장 양념, 깻잎 고명.', calories = 448.0, protein_g = 19.1, carbs_g = 67.2, fat_g = 11.3, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0957';
UPDATE recipes SET name = '파기름 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 가지, 토마토를 곁들인 1인분 오트죽. 파참기름 양념.', calories = 446.0, protein_g = 18.8, carbs_g = 67.2, fat_g = 11.3, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0958';
UPDATE recipes SET name = '김 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 가지, 토마토를 곁들인 1인분 오트죽. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0959';
UPDATE recipes SET name = '김 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 가지, 토마토를 곁들인 1인분 오트죽. 김들기름 양념.', calories = 450.0, protein_g = 19.3, carbs_g = 67.5, fat_g = 11.4, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0960';
UPDATE recipes SET name = '들기름간장 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 양배추, 파프리카를 곁들인 1인분 오트죽. 들기름간장 양념.', calories = 448.0, protein_g = 18.7, carbs_g = 67.5, fat_g = 11.3, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0961';
UPDATE recipes SET name = '들기름 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 양배추, 파프리카를 곁들인 1인분 오트죽. 들기름소금 양념.', calories = 444.0, protein_g = 18.4, carbs_g = 67.2, fat_g = 11.3, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0962';
UPDATE recipes SET name = '간장 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 양배추, 파프리카를 곁들인 1인분 오트죽. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0963';
UPDATE recipes SET name = '마늘간장 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 양배추, 파프리카를 곁들인 1인분 오트죽. 마늘간장 양념.', calories = 415.0, protein_g = 18.9, carbs_g = 68.5, fat_g = 7.3, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0964';
UPDATE recipes SET name = '생강간장 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 양배추, 파프리카를 곁들인 1인분 오트죽. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0965';
UPDATE recipes SET name = '파간장 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 양배추, 파프리카를 곁들인 1인분 오트죽. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0966';
UPDATE recipes SET name = '깻잎 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 양배추, 파프리카를 곁들인 1인분 오트죽. 들기름간장 양념, 깻잎 고명.', calories = 450.0, protein_g = 18.9, carbs_g = 67.8, fat_g = 11.3, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0967';
UPDATE recipes SET name = '파기름 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 양배추, 파프리카를 곁들인 1인분 오트죽. 파참기름 양념.', calories = 447.0, protein_g = 18.6, carbs_g = 67.8, fat_g = 11.3, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0968';
UPDATE recipes SET name = '김 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 양배추, 파프리카를 곁들인 1인분 오트죽. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0969';
UPDATE recipes SET name = '김 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 양배추, 파프리카를 곁들인 1인분 오트죽. 김들기름 양념.', calories = 452.0, protein_g = 19.2, carbs_g = 68.1, fat_g = 11.4, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0970';
UPDATE recipes SET name = '들기름간장 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 브로콜리, 당근을 곁들인 1인분 오트죽. 들기름간장 양념.', calories = 465.0, protein_g = 20.4, carbs_g = 70.0, fat_g = 11.3, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0971';
UPDATE recipes SET name = '들기름 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 브로콜리, 당근을 곁들인 1인분 오트죽. 들기름소금 양념.', calories = 460.0, protein_g = 20.1, carbs_g = 69.8, fat_g = 11.3, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0972';
UPDATE recipes SET name = '간장 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 브로콜리, 당근을 곁들인 1인분 오트죽. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0973';
UPDATE recipes SET name = '마늘간장 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 브로콜리, 당근을 곁들인 1인분 오트죽. 마늘간장 양념.', calories = 432.0, protein_g = 20.6, carbs_g = 71.1, fat_g = 7.3, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0974';
UPDATE recipes SET name = '생강간장 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 브로콜리, 당근을 곁들인 1인분 오트죽. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0975';
UPDATE recipes SET name = '파간장 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 브로콜리, 당근을 곁들인 1인분 오트죽. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0976';
UPDATE recipes SET name = '깻잎 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 브로콜리, 당근을 곁들인 1인분 오트죽. 들기름간장 양념, 깻잎 고명.', calories = 467.0, protein_g = 20.6, carbs_g = 70.3, fat_g = 11.3, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0977';
UPDATE recipes SET name = '파기름 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 브로콜리, 당근을 곁들인 1인분 오트죽. 파참기름 양념.', calories = 464.0, protein_g = 20.3, carbs_g = 70.4, fat_g = 11.3, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0978';
UPDATE recipes SET name = '김 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 브로콜리, 당근을 곁들인 1인분 오트죽. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0979';
UPDATE recipes SET name = '김 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 브로콜리, 당근을 곁들인 1인분 오트죽. 김들기름 양념.', calories = 468.0, protein_g = 20.8, carbs_g = 70.6, fat_g = 11.4, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0980';
UPDATE recipes SET name = '들기름간장 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 애호박, 양송이버섯을 곁들인 1인분 오트죽. 들기름간장 양념.', calories = 437.0, protein_g = 20.1, carbs_g = 63.3, fat_g = 11.3, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0981';
UPDATE recipes SET name = '들기름 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 애호박, 양송이버섯을 곁들인 1인분 오트죽. 들기름소금 양념.', calories = 432.0, protein_g = 19.8, carbs_g = 63.0, fat_g = 11.3, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0982';
UPDATE recipes SET name = '간장 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 애호박, 양송이버섯을 곁들인 1인분 오트죽. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0983';
UPDATE recipes SET name = '마늘간장 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 애호박, 양송이버섯을 곁들인 1인분 오트죽. 마늘간장 양념.', calories = 404.0, protein_g = 20.2, carbs_g = 64.3, fat_g = 7.3, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0984';
UPDATE recipes SET name = '생강간장 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 애호박, 양송이버섯을 곁들인 1인분 오트죽. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0985';
UPDATE recipes SET name = '파간장 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 애호박, 양송이버섯을 곁들인 1인분 오트죽. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0986';
UPDATE recipes SET name = '깻잎 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 애호박, 양송이버섯을 곁들인 1인분 오트죽. 들기름간장 양념, 깻잎 고명.', calories = 438.0, protein_g = 20.2, carbs_g = 63.6, fat_g = 11.3, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0987';
UPDATE recipes SET name = '파기름 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 애호박, 양송이버섯을 곁들인 1인분 오트죽. 파참기름 양념.', calories = 436.0, protein_g = 19.9, carbs_g = 63.6, fat_g = 11.3, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0988';
UPDATE recipes SET name = '김 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 애호박, 양송이버섯을 곁들인 1인분 오트죽. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0989';
UPDATE recipes SET name = '김 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 애호박, 양송이버섯을 곁들인 1인분 오트죽. 김들기름 양념.', calories = 440.0, protein_g = 20.5, carbs_g = 63.9, fat_g = 11.4, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0990';
UPDATE recipes SET name = '들기름간장 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 시금치, 토마토를 곁들인 1인분 오트죽. 들기름간장 양념.', calories = 442.0, protein_g = 20.0, carbs_g = 64.8, fat_g = 11.3, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0991';
UPDATE recipes SET name = '들기름 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 시금치, 토마토를 곁들인 1인분 오트죽. 들기름소금 양념.', calories = 437.0, protein_g = 19.7, carbs_g = 64.4, fat_g = 11.3, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0992';
UPDATE recipes SET name = '간장 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 시금치, 토마토를 곁들인 1인분 오트죽. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0993';
UPDATE recipes SET name = '마늘간장 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 시금치, 토마토를 곁들인 1인분 오트죽. 마늘간장 양념.', calories = 409.0, protein_g = 20.1, carbs_g = 65.7, fat_g = 7.3, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0994';
UPDATE recipes SET name = '생강간장 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 시금치, 토마토를 곁들인 1인분 오트죽. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0995';
UPDATE recipes SET name = '파간장 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 시금치, 토마토를 곁들인 1인분 오트죽. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0996';
UPDATE recipes SET name = '깻잎 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 시금치, 토마토를 곁들인 1인분 오트죽. 들기름간장 양념, 깻잎 고명.', calories = 443.0, protein_g = 20.1, carbs_g = 65.0, fat_g = 11.3, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0997';
UPDATE recipes SET name = '파기름 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 시금치, 토마토를 곁들인 1인분 오트죽. 파참기름 양념.', calories = 441.0, protein_g = 19.8, carbs_g = 65.0, fat_g = 11.3, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0998';
UPDATE recipes SET name = '김 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 시금치, 토마토를 곁들인 1인분 오트죽. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B0999';
UPDATE recipes SET name = '김 렌틸콩 오트밀죽', description = '오트밀에 렌틸콩, 시금치, 토마토를 곁들인 1인분 오트죽. 김들기름 양념.', calories = 445.0, protein_g = 20.4, carbs_g = 65.3, fat_g = 11.4, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'B1000';
UPDATE recipes SET name = '들깨 닭가슴살 덮밥', description = '현미밥에 닭가슴살, 양배추, 당근을 곁들인 1인분 현미 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0002';
UPDATE recipes SET name = '간장 닭가슴살 덮밥', description = '현미밥에 닭가슴살, 양배추, 당근을 곁들인 1인분 현미 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0003';
UPDATE recipes SET name = '마늘 닭가슴살 덮밥', description = '현미밥에 닭가슴살, 양배추, 당근을 곁들인 1인분 현미 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0004';
UPDATE recipes SET name = '생강간장 닭가슴살 덮밥', description = '현미밥에 닭가슴살, 양배추, 당근을 곁들인 1인분 현미 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0005';
UPDATE recipes SET name = '파간장 닭가슴살 덮밥', description = '현미밥에 닭가슴살, 양배추, 당근을 곁들인 1인분 현미 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0006';
UPDATE recipes SET name = '깻잎 닭가슴살 덮밥', description = '현미밥에 닭가슴살, 양배추, 당근을 곁들인 1인분 현미 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 468.0, protein_g = 35.5, carbs_g = 51.6, fat_g = 13.2, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0007';
UPDATE recipes SET name = '김 닭가슴살 덮밥', description = '현미밥에 닭가슴살, 양배추, 당근을 곁들인 1인분 현미 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0009';
UPDATE recipes SET name = '들깨 닭가슴살 덮밥', description = '현미밥에 닭가슴살, 브로콜리, 양파를 곁들인 1인분 현미 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0012';
UPDATE recipes SET name = '간장 닭가슴살 덮밥', description = '현미밥에 닭가슴살, 브로콜리, 양파를 곁들인 1인분 현미 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0013';
UPDATE recipes SET name = '마늘 닭가슴살 덮밥', description = '현미밥에 닭가슴살, 브로콜리, 양파를 곁들인 1인분 현미 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0014';
UPDATE recipes SET name = '생강간장 닭가슴살 덮밥', description = '현미밥에 닭가슴살, 브로콜리, 양파를 곁들인 1인분 현미 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0015';
UPDATE recipes SET name = '파간장 닭가슴살 덮밥', description = '현미밥에 닭가슴살, 브로콜리, 양파를 곁들인 1인분 현미 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0016';
UPDATE recipes SET name = '깻잎 닭가슴살 덮밥', description = '현미밥에 닭가슴살, 브로콜리, 양파를 곁들인 1인분 현미 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 476.0, protein_g = 37.2, carbs_g = 51.8, fat_g = 13.2, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0017';
UPDATE recipes SET name = '김 닭가슴살 덮밥', description = '현미밥에 닭가슴살, 브로콜리, 양파를 곁들인 1인분 현미 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0019';
UPDATE recipes SET name = '들깨 닭가슴살 덮밥', description = '현미밥에 닭가슴살, 애호박, 파프리카를 곁들인 1인분 현미 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0022';
UPDATE recipes SET name = '간장 닭가슴살 덮밥', description = '현미밥에 닭가슴살, 애호박, 파프리카를 곁들인 1인분 현미 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0023';
UPDATE recipes SET name = '마늘 닭가슴살 덮밥', description = '현미밥에 닭가슴살, 애호박, 파프리카를 곁들인 1인분 현미 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0024';
UPDATE recipes SET name = '생강간장 닭가슴살 덮밥', description = '현미밥에 닭가슴살, 애호박, 파프리카를 곁들인 1인분 현미 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0025';
UPDATE recipes SET name = '파간장 닭가슴살 덮밥', description = '현미밥에 닭가슴살, 애호박, 파프리카를 곁들인 1인분 현미 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0026';
UPDATE recipes SET name = '깻잎 닭가슴살 덮밥', description = '현미밥에 닭가슴살, 애호박, 파프리카를 곁들인 1인분 현미 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 453.0, protein_g = 35.6, carbs_g = 47.6, fat_g = 13.2, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0027';
UPDATE recipes SET name = '김 닭가슴살 덮밥', description = '현미밥에 닭가슴살, 애호박, 파프리카를 곁들인 1인분 현미 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0029';
UPDATE recipes SET name = '들깨 닭가슴살 덮밥', description = '현미밥에 닭가슴살, 시금치, 느타리버섯을 곁들인 1인분 현미 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0032';
UPDATE recipes SET name = '간장 닭가슴살 덮밥', description = '현미밥에 닭가슴살, 시금치, 느타리버섯을 곁들인 1인분 현미 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0033';
UPDATE recipes SET name = '마늘 닭가슴살 덮밥', description = '현미밥에 닭가슴살, 시금치, 느타리버섯을 곁들인 1인분 현미 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0034';
UPDATE recipes SET name = '생강간장 닭가슴살 덮밥', description = '현미밥에 닭가슴살, 시금치, 느타리버섯을 곁들인 1인분 현미 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0035';
UPDATE recipes SET name = '파간장 닭가슴살 덮밥', description = '현미밥에 닭가슴살, 시금치, 느타리버섯을 곁들인 1인분 현미 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0036';
UPDATE recipes SET name = '깻잎 닭가슴살 덮밥', description = '현미밥에 닭가슴살, 시금치, 느타리버섯을 곁들인 1인분 현미 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 469.0, protein_g = 38.4, carbs_g = 48.9, fat_g = 13.2, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0037';
UPDATE recipes SET name = '김 닭가슴살 덮밥', description = '현미밥에 닭가슴살, 시금치, 느타리버섯을 곁들인 1인분 현미 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0039';
UPDATE recipes SET name = '들깨 닭가슴살 덮밥', description = '현미밥에 닭가슴살, 청경채, 양송이버섯을 곁들인 1인분 현미 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0042';
UPDATE recipes SET name = '간장 닭가슴살 덮밥', description = '현미밥에 닭가슴살, 청경채, 양송이버섯을 곁들인 1인분 현미 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0043';
UPDATE recipes SET name = '마늘 닭가슴살 덮밥', description = '현미밥에 닭가슴살, 청경채, 양송이버섯을 곁들인 1인분 현미 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0044';
UPDATE recipes SET name = '생강간장 닭가슴살 덮밥', description = '현미밥에 닭가슴살, 청경채, 양송이버섯을 곁들인 1인분 현미 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0045';
UPDATE recipes SET name = '파간장 닭가슴살 덮밥', description = '현미밥에 닭가슴살, 청경채, 양송이버섯을 곁들인 1인분 현미 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0046';
UPDATE recipes SET name = '깻잎 닭가슴살 덮밥', description = '현미밥에 닭가슴살, 청경채, 양송이버섯을 곁들인 1인분 현미 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 454.0, protein_g = 37.6, carbs_g = 46.0, fat_g = 13.2, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0047';
UPDATE recipes SET name = '김 닭가슴살 덮밥', description = '현미밥에 닭가슴살, 청경채, 양송이버섯을 곁들인 1인분 현미 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0049';
UPDATE recipes SET name = '들깨 닭가슴살 덮밥', description = '현미밥에 닭가슴살, 가지, 토마토를 곁들인 1인분 현미 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0052';
UPDATE recipes SET name = '간장 닭가슴살 덮밥', description = '현미밥에 닭가슴살, 가지, 토마토를 곁들인 1인분 현미 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0053';
UPDATE recipes SET name = '마늘 닭가슴살 덮밥', description = '현미밥에 닭가슴살, 가지, 토마토를 곁들인 1인분 현미 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0054';
UPDATE recipes SET name = '생강간장 닭가슴살 덮밥', description = '현미밥에 닭가슴살, 가지, 토마토를 곁들인 1인분 현미 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0055';
UPDATE recipes SET name = '파간장 닭가슴살 덮밥', description = '현미밥에 닭가슴살, 가지, 토마토를 곁들인 1인분 현미 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0056';
UPDATE recipes SET name = '깻잎 닭가슴살 덮밥', description = '현미밥에 닭가슴살, 가지, 토마토를 곁들인 1인분 현미 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 461.0, protein_g = 35.7, carbs_g = 49.6, fat_g = 13.2, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0057';
UPDATE recipes SET name = '김 닭가슴살 덮밥', description = '현미밥에 닭가슴살, 가지, 토마토를 곁들인 1인분 현미 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0059';
UPDATE recipes SET name = '들깨 닭가슴살 덮밥', description = '현미밥에 닭가슴살, 양배추, 파프리카를 곁들인 1인분 현미 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0062';
UPDATE recipes SET name = '간장 닭가슴살 덮밥', description = '현미밥에 닭가슴살, 양배추, 파프리카를 곁들인 1인분 현미 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0063';
UPDATE recipes SET name = '마늘 닭가슴살 덮밥', description = '현미밥에 닭가슴살, 양배추, 파프리카를 곁들인 1인분 현미 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0064';
UPDATE recipes SET name = '생강간장 닭가슴살 덮밥', description = '현미밥에 닭가슴살, 양배추, 파프리카를 곁들인 1인분 현미 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0065';
UPDATE recipes SET name = '파간장 닭가슴살 덮밥', description = '현미밥에 닭가슴살, 양배추, 파프리카를 곁들인 1인분 현미 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0066';
UPDATE recipes SET name = '깻잎 닭가슴살 덮밥', description = '현미밥에 닭가슴살, 양배추, 파프리카를 곁들인 1인분 현미 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 463.0, protein_g = 35.6, carbs_g = 50.2, fat_g = 13.2, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0067';
UPDATE recipes SET name = '김 닭가슴살 덮밥', description = '현미밥에 닭가슴살, 양배추, 파프리카를 곁들인 1인분 현미 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0069';
UPDATE recipes SET name = '들깨 닭가슴살 덮밥', description = '현미밥에 닭가슴살, 브로콜리, 당근을 곁들인 1인분 현미 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0072';
UPDATE recipes SET name = '간장 닭가슴살 덮밥', description = '현미밥에 닭가슴살, 브로콜리, 당근을 곁들인 1인분 현미 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0073';
UPDATE recipes SET name = '마늘 닭가슴살 덮밥', description = '현미밥에 닭가슴살, 브로콜리, 당근을 곁들인 1인분 현미 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0074';
UPDATE recipes SET name = '생강간장 닭가슴살 덮밥', description = '현미밥에 닭가슴살, 브로콜리, 당근을 곁들인 1인분 현미 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0075';
UPDATE recipes SET name = '파간장 닭가슴살 덮밥', description = '현미밥에 닭가슴살, 브로콜리, 당근을 곁들인 1인분 현미 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0076';
UPDATE recipes SET name = '깻잎 닭가슴살 덮밥', description = '현미밥에 닭가슴살, 브로콜리, 당근을 곁들인 1인분 현미 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 480.0, protein_g = 37.2, carbs_g = 52.7, fat_g = 13.2, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0077';
UPDATE recipes SET name = '김 닭가슴살 덮밥', description = '현미밥에 닭가슴살, 브로콜리, 당근을 곁들인 1인분 현미 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0079';
UPDATE recipes SET name = '들깨 닭가슴살 덮밥', description = '현미밥에 닭가슴살, 애호박, 양송이버섯을 곁들인 1인분 현미 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0082';
UPDATE recipes SET name = '간장 닭가슴살 덮밥', description = '현미밥에 닭가슴살, 애호박, 양송이버섯을 곁들인 1인분 현미 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0083';
UPDATE recipes SET name = '마늘 닭가슴살 덮밥', description = '현미밥에 닭가슴살, 애호박, 양송이버섯을 곁들인 1인분 현미 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0084';
UPDATE recipes SET name = '생강간장 닭가슴살 덮밥', description = '현미밥에 닭가슴살, 애호박, 양송이버섯을 곁들인 1인분 현미 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0085';
UPDATE recipes SET name = '파간장 닭가슴살 덮밥', description = '현미밥에 닭가슴살, 애호박, 양송이버섯을 곁들인 1인분 현미 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0086';
UPDATE recipes SET name = '깻잎 닭가슴살 덮밥', description = '현미밥에 닭가슴살, 애호박, 양송이버섯을 곁들인 1인분 현미 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 451.0, protein_g = 36.9, carbs_g = 46.0, fat_g = 13.2, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0087';
UPDATE recipes SET name = '김 닭가슴살 덮밥', description = '현미밥에 닭가슴살, 애호박, 양송이버섯을 곁들인 1인분 현미 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0089';
UPDATE recipes SET name = '들깨 닭가슴살 덮밥', description = '현미밥에 닭가슴살, 시금치, 토마토를 곁들인 1인분 현미 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0092';
UPDATE recipes SET name = '간장 닭가슴살 덮밥', description = '현미밥에 닭가슴살, 시금치, 토마토를 곁들인 1인분 현미 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0093';
UPDATE recipes SET name = '마늘 닭가슴살 덮밥', description = '현미밥에 닭가슴살, 시금치, 토마토를 곁들인 1인분 현미 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0094';
UPDATE recipes SET name = '생강간장 닭가슴살 덮밥', description = '현미밥에 닭가슴살, 시금치, 토마토를 곁들인 1인분 현미 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0095';
UPDATE recipes SET name = '파간장 닭가슴살 덮밥', description = '현미밥에 닭가슴살, 시금치, 토마토를 곁들인 1인분 현미 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0096';
UPDATE recipes SET name = '깻잎 닭가슴살 덮밥', description = '현미밥에 닭가슴살, 시금치, 토마토를 곁들인 1인분 현미 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 456.0, protein_g = 36.8, carbs_g = 47.4, fat_g = 13.2, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0097';
UPDATE recipes SET name = '김 닭가슴살 덮밥', description = '현미밥에 닭가슴살, 시금치, 토마토를 곁들인 1인분 현미 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0099';
UPDATE recipes SET name = '들깨 돼지 안심 덮밥', description = '잡곡밥에 돼지 안심, 양배추, 당근을 곁들인 1인분 잡곡 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0102';
UPDATE recipes SET name = '간장 돼지 안심 덮밥', description = '잡곡밥에 돼지 안심, 양배추, 당근을 곁들인 1인분 잡곡 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0103';
UPDATE recipes SET name = '마늘 돼지 안심 덮밥', description = '잡곡밥에 돼지 안심, 양배추, 당근을 곁들인 1인분 잡곡 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0104';
UPDATE recipes SET name = '생강간장 돼지 안심 덮밥', description = '잡곡밥에 돼지 안심, 양배추, 당근을 곁들인 1인분 잡곡 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0105';
UPDATE recipes SET name = '파간장 돼지 안심 덮밥', description = '잡곡밥에 돼지 안심, 양배추, 당근을 곁들인 1인분 잡곡 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0106';
UPDATE recipes SET name = '깻잎 돼지 안심 덮밥', description = '잡곡밥에 돼지 안심, 양배추, 당근을 곁들인 1인분 잡곡 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 506.0, protein_g = 34.8, carbs_g = 56.5, fat_g = 15.5, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0107';
UPDATE recipes SET name = '김 돼지 안심 덮밥', description = '잡곡밥에 돼지 안심, 양배추, 당근을 곁들인 1인분 잡곡 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0109';
UPDATE recipes SET name = '들깨 돼지 안심 덮밥', description = '잡곡밥에 돼지 안심, 브로콜리, 양파를 곁들인 1인분 잡곡 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0112';
UPDATE recipes SET name = '간장 돼지 안심 덮밥', description = '잡곡밥에 돼지 안심, 브로콜리, 양파를 곁들인 1인분 잡곡 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0113';
UPDATE recipes SET name = '마늘 돼지 안심 덮밥', description = '잡곡밥에 돼지 안심, 브로콜리, 양파를 곁들인 1인분 잡곡 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0114';
UPDATE recipes SET name = '생강간장 돼지 안심 덮밥', description = '잡곡밥에 돼지 안심, 브로콜리, 양파를 곁들인 1인분 잡곡 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0115';
UPDATE recipes SET name = '파간장 돼지 안심 덮밥', description = '잡곡밥에 돼지 안심, 브로콜리, 양파를 곁들인 1인분 잡곡 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0116';
UPDATE recipes SET name = '깻잎 돼지 안심 덮밥', description = '잡곡밥에 돼지 안심, 브로콜리, 양파를 곁들인 1인분 잡곡 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 513.0, protein_g = 36.5, carbs_g = 56.7, fat_g = 15.5, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0117';
UPDATE recipes SET name = '김 돼지 안심 덮밥', description = '잡곡밥에 돼지 안심, 브로콜리, 양파를 곁들인 1인분 잡곡 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0119';
UPDATE recipes SET name = '들깨 돼지 안심 덮밥', description = '잡곡밥에 돼지 안심, 애호박, 파프리카를 곁들인 1인분 잡곡 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0122';
UPDATE recipes SET name = '간장 돼지 안심 덮밥', description = '잡곡밥에 돼지 안심, 애호박, 파프리카를 곁들인 1인분 잡곡 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0123';
UPDATE recipes SET name = '마늘 돼지 안심 덮밥', description = '잡곡밥에 돼지 안심, 애호박, 파프리카를 곁들인 1인분 잡곡 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0124';
UPDATE recipes SET name = '생강간장 돼지 안심 덮밥', description = '잡곡밥에 돼지 안심, 애호박, 파프리카를 곁들인 1인분 잡곡 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0125';
UPDATE recipes SET name = '파간장 돼지 안심 덮밥', description = '잡곡밥에 돼지 안심, 애호박, 파프리카를 곁들인 1인분 잡곡 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0126';
UPDATE recipes SET name = '깻잎 돼지 안심 덮밥', description = '잡곡밥에 돼지 안심, 애호박, 파프리카를 곁들인 1인분 잡곡 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 490.0, protein_g = 34.9, carbs_g = 52.6, fat_g = 15.5, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0127';
UPDATE recipes SET name = '김 돼지 안심 덮밥', description = '잡곡밥에 돼지 안심, 애호박, 파프리카를 곁들인 1인분 잡곡 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0129';
UPDATE recipes SET name = '들깨 돼지 안심 덮밥', description = '잡곡밥에 돼지 안심, 시금치, 느타리버섯을 곁들인 1인분 잡곡 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0132';
UPDATE recipes SET name = '간장 돼지 안심 덮밥', description = '잡곡밥에 돼지 안심, 시금치, 느타리버섯을 곁들인 1인분 잡곡 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0133';
UPDATE recipes SET name = '마늘 돼지 안심 덮밥', description = '잡곡밥에 돼지 안심, 시금치, 느타리버섯을 곁들인 1인분 잡곡 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0134';
UPDATE recipes SET name = '생강간장 돼지 안심 덮밥', description = '잡곡밥에 돼지 안심, 시금치, 느타리버섯을 곁들인 1인분 잡곡 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0135';
UPDATE recipes SET name = '파간장 돼지 안심 덮밥', description = '잡곡밥에 돼지 안심, 시금치, 느타리버섯을 곁들인 1인분 잡곡 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0136';
UPDATE recipes SET name = '깻잎 돼지 안심 덮밥', description = '잡곡밥에 돼지 안심, 시금치, 느타리버섯을 곁들인 1인분 잡곡 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 506.0, protein_g = 37.7, carbs_g = 53.8, fat_g = 15.5, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0137';
UPDATE recipes SET name = '김 돼지 안심 덮밥', description = '잡곡밥에 돼지 안심, 시금치, 느타리버섯을 곁들인 1인분 잡곡 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0139';
UPDATE recipes SET name = '들깨 돼지 안심 덮밥', description = '잡곡밥에 돼지 안심, 청경채, 양송이버섯을 곁들인 1인분 잡곡 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0142';
UPDATE recipes SET name = '간장 돼지 안심 덮밥', description = '잡곡밥에 돼지 안심, 청경채, 양송이버섯을 곁들인 1인분 잡곡 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0143';
UPDATE recipes SET name = '마늘 돼지 안심 덮밥', description = '잡곡밥에 돼지 안심, 청경채, 양송이버섯을 곁들인 1인분 잡곡 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0144';
UPDATE recipes SET name = '생강간장 돼지 안심 덮밥', description = '잡곡밥에 돼지 안심, 청경채, 양송이버섯을 곁들인 1인분 잡곡 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0145';
UPDATE recipes SET name = '파간장 돼지 안심 덮밥', description = '잡곡밥에 돼지 안심, 청경채, 양송이버섯을 곁들인 1인분 잡곡 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0146';
UPDATE recipes SET name = '깻잎 돼지 안심 덮밥', description = '잡곡밥에 돼지 안심, 청경채, 양송이버섯을 곁들인 1인분 잡곡 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 492.0, protein_g = 36.9, carbs_g = 50.9, fat_g = 15.5, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0147';
UPDATE recipes SET name = '김 돼지 안심 덮밥', description = '잡곡밥에 돼지 안심, 청경채, 양송이버섯을 곁들인 1인분 잡곡 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0149';
UPDATE recipes SET name = '들깨 돼지 안심 덮밥', description = '잡곡밥에 돼지 안심, 가지, 토마토를 곁들인 1인분 잡곡 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0152';
UPDATE recipes SET name = '간장 돼지 안심 덮밥', description = '잡곡밥에 돼지 안심, 가지, 토마토를 곁들인 1인분 잡곡 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0153';
UPDATE recipes SET name = '마늘 돼지 안심 덮밥', description = '잡곡밥에 돼지 안심, 가지, 토마토를 곁들인 1인분 잡곡 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0154';
UPDATE recipes SET name = '생강간장 돼지 안심 덮밥', description = '잡곡밥에 돼지 안심, 가지, 토마토를 곁들인 1인분 잡곡 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0155';
UPDATE recipes SET name = '파간장 돼지 안심 덮밥', description = '잡곡밥에 돼지 안심, 가지, 토마토를 곁들인 1인분 잡곡 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0156';
UPDATE recipes SET name = '깻잎 돼지 안심 덮밥', description = '잡곡밥에 돼지 안심, 가지, 토마토를 곁들인 1인분 잡곡 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 499.0, protein_g = 35.0, carbs_g = 54.5, fat_g = 15.5, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0157';
UPDATE recipes SET name = '김 돼지 안심 덮밥', description = '잡곡밥에 돼지 안심, 가지, 토마토를 곁들인 1인분 잡곡 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0159';
UPDATE recipes SET name = '들깨 돼지 안심 덮밥', description = '잡곡밥에 돼지 안심, 양배추, 파프리카를 곁들인 1인분 잡곡 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0162';
UPDATE recipes SET name = '간장 돼지 안심 덮밥', description = '잡곡밥에 돼지 안심, 양배추, 파프리카를 곁들인 1인분 잡곡 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0163';
UPDATE recipes SET name = '마늘 돼지 안심 덮밥', description = '잡곡밥에 돼지 안심, 양배추, 파프리카를 곁들인 1인분 잡곡 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0164';
UPDATE recipes SET name = '생강간장 돼지 안심 덮밥', description = '잡곡밥에 돼지 안심, 양배추, 파프리카를 곁들인 1인분 잡곡 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0165';
UPDATE recipes SET name = '파간장 돼지 안심 덮밥', description = '잡곡밥에 돼지 안심, 양배추, 파프리카를 곁들인 1인분 잡곡 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0166';
UPDATE recipes SET name = '깻잎 돼지 안심 덮밥', description = '잡곡밥에 돼지 안심, 양배추, 파프리카를 곁들인 1인분 잡곡 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 500.0, protein_g = 34.9, carbs_g = 55.1, fat_g = 15.5, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0167';
UPDATE recipes SET name = '김 돼지 안심 덮밥', description = '잡곡밥에 돼지 안심, 양배추, 파프리카를 곁들인 1인분 잡곡 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0169';
UPDATE recipes SET name = '들깨 돼지 안심 덮밥', description = '잡곡밥에 돼지 안심, 브로콜리, 당근을 곁들인 1인분 잡곡 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0172';
UPDATE recipes SET name = '간장 돼지 안심 덮밥', description = '잡곡밥에 돼지 안심, 브로콜리, 당근을 곁들인 1인분 잡곡 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0173';
UPDATE recipes SET name = '마늘 돼지 안심 덮밥', description = '잡곡밥에 돼지 안심, 브로콜리, 당근을 곁들인 1인분 잡곡 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0174';
UPDATE recipes SET name = '생강간장 돼지 안심 덮밥', description = '잡곡밥에 돼지 안심, 브로콜리, 당근을 곁들인 1인분 잡곡 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0175';
UPDATE recipes SET name = '파간장 돼지 안심 덮밥', description = '잡곡밥에 돼지 안심, 브로콜리, 당근을 곁들인 1인분 잡곡 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0176';
UPDATE recipes SET name = '깻잎 돼지 안심 덮밥', description = '잡곡밥에 돼지 안심, 브로콜리, 당근을 곁들인 1인분 잡곡 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 517.0, protein_g = 36.5, carbs_g = 57.7, fat_g = 15.5, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0177';
UPDATE recipes SET name = '김 돼지 안심 덮밥', description = '잡곡밥에 돼지 안심, 브로콜리, 당근을 곁들인 1인분 잡곡 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0179';
UPDATE recipes SET name = '들깨 돼지 안심 덮밥', description = '잡곡밥에 돼지 안심, 애호박, 양송이버섯을 곁들인 1인분 잡곡 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0182';
UPDATE recipes SET name = '간장 돼지 안심 덮밥', description = '잡곡밥에 돼지 안심, 애호박, 양송이버섯을 곁들인 1인분 잡곡 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0183';
UPDATE recipes SET name = '마늘 돼지 안심 덮밥', description = '잡곡밥에 돼지 안심, 애호박, 양송이버섯을 곁들인 1인분 잡곡 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0184';
UPDATE recipes SET name = '생강간장 돼지 안심 덮밥', description = '잡곡밥에 돼지 안심, 애호박, 양송이버섯을 곁들인 1인분 잡곡 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0185';
UPDATE recipes SET name = '파간장 돼지 안심 덮밥', description = '잡곡밥에 돼지 안심, 애호박, 양송이버섯을 곁들인 1인분 잡곡 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0186';
UPDATE recipes SET name = '깻잎 돼지 안심 덮밥', description = '잡곡밥에 돼지 안심, 애호박, 양송이버섯을 곁들인 1인분 잡곡 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 489.0, protein_g = 36.2, carbs_g = 50.9, fat_g = 15.5, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0187';
UPDATE recipes SET name = '김 돼지 안심 덮밥', description = '잡곡밥에 돼지 안심, 애호박, 양송이버섯을 곁들인 1인분 잡곡 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0189';
UPDATE recipes SET name = '들깨 돼지 안심 덮밥', description = '잡곡밥에 돼지 안심, 시금치, 토마토를 곁들인 1인분 잡곡 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0192';
UPDATE recipes SET name = '간장 돼지 안심 덮밥', description = '잡곡밥에 돼지 안심, 시금치, 토마토를 곁들인 1인분 잡곡 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0193';
UPDATE recipes SET name = '마늘 돼지 안심 덮밥', description = '잡곡밥에 돼지 안심, 시금치, 토마토를 곁들인 1인분 잡곡 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0194';
UPDATE recipes SET name = '생강간장 돼지 안심 덮밥', description = '잡곡밥에 돼지 안심, 시금치, 토마토를 곁들인 1인분 잡곡 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0195';
UPDATE recipes SET name = '파간장 돼지 안심 덮밥', description = '잡곡밥에 돼지 안심, 시금치, 토마토를 곁들인 1인분 잡곡 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0196';
UPDATE recipes SET name = '깻잎 돼지 안심 덮밥', description = '잡곡밥에 돼지 안심, 시금치, 토마토를 곁들인 1인분 잡곡 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 494.0, protein_g = 36.1, carbs_g = 52.3, fat_g = 15.5, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0197';
UPDATE recipes SET name = '김 돼지 안심 덮밥', description = '잡곡밥에 돼지 안심, 시금치, 토마토를 곁들인 1인분 잡곡 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0199';
UPDATE recipes SET name = '레몬 두부 랩', description = '통밀 또띠아에 두부, 양배추, 당근을 곁들인 1인분 랩. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0201';
UPDATE recipes SET name = '들깨 두부 랩', description = '통밀 또띠아에 두부, 양배추, 당근을 곁들인 1인분 랩. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0202';
UPDATE recipes SET name = '마늘 두부 랩', description = '통밀 또띠아에 두부, 양배추, 당근을 곁들인 1인분 랩. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0204';
UPDATE recipes SET name = '깻잎 두부 랩', description = '통밀 또띠아에 두부, 양배추, 당근을 곁들인 1인분 랩. 레몬올리브 양념, 깻잎 고명.', calories = 493.0, protein_g = 21.7, carbs_g = 51.1, fat_g = 22.5, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0207';
UPDATE recipes SET name = '바질 두부 랩', description = '통밀 또띠아에 두부, 양배추, 당근을 곁들인 1인분 랩. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0208';
UPDATE recipes SET name = '허브 두부 랩', description = '통밀 또띠아에 두부, 양배추, 당근을 곁들인 1인분 랩. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0210';
UPDATE recipes SET name = '레몬 두부 랩', description = '통밀 또띠아에 두부, 브로콜리, 양파를 곁들인 1인분 랩. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0211';
UPDATE recipes SET name = '들깨 두부 랩', description = '통밀 또띠아에 두부, 브로콜리, 양파를 곁들인 1인분 랩. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0212';
UPDATE recipes SET name = '마늘 두부 랩', description = '통밀 또띠아에 두부, 브로콜리, 양파를 곁들인 1인분 랩. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0214';
UPDATE recipes SET name = '깻잎 두부 랩', description = '통밀 또띠아에 두부, 브로콜리, 양파를 곁들인 1인분 랩. 레몬올리브 양념, 깻잎 고명.', calories = 501.0, protein_g = 23.4, carbs_g = 51.3, fat_g = 22.5, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0217';
UPDATE recipes SET name = '바질 두부 랩', description = '통밀 또띠아에 두부, 브로콜리, 양파를 곁들인 1인분 랩. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0218';
UPDATE recipes SET name = '허브 두부 랩', description = '통밀 또띠아에 두부, 브로콜리, 양파를 곁들인 1인분 랩. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0220';
UPDATE recipes SET name = '레몬 두부 랩', description = '통밀 또띠아에 두부, 애호박, 파프리카를 곁들인 1인분 랩. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0221';
UPDATE recipes SET name = '들깨 두부 랩', description = '통밀 또띠아에 두부, 애호박, 파프리카를 곁들인 1인분 랩. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0222';
UPDATE recipes SET name = '마늘 두부 랩', description = '통밀 또띠아에 두부, 애호박, 파프리카를 곁들인 1인분 랩. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0224';
UPDATE recipes SET name = '깻잎 두부 랩', description = '통밀 또띠아에 두부, 애호박, 파프리카를 곁들인 1인분 랩. 레몬올리브 양념, 깻잎 고명.', calories = 478.0, protein_g = 21.8, carbs_g = 47.2, fat_g = 22.5, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0227';
UPDATE recipes SET name = '바질 두부 랩', description = '통밀 또띠아에 두부, 애호박, 파프리카를 곁들인 1인분 랩. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0228';
UPDATE recipes SET name = '허브 두부 랩', description = '통밀 또띠아에 두부, 애호박, 파프리카를 곁들인 1인분 랩. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0230';
UPDATE recipes SET name = '레몬 두부 랩', description = '통밀 또띠아에 두부, 시금치, 느타리버섯을 곁들인 1인분 랩. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0231';
UPDATE recipes SET name = '들깨 두부 랩', description = '통밀 또띠아에 두부, 시금치, 느타리버섯을 곁들인 1인분 랩. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0232';
UPDATE recipes SET name = '마늘 두부 랩', description = '통밀 또띠아에 두부, 시금치, 느타리버섯을 곁들인 1인분 랩. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0234';
UPDATE recipes SET name = '깻잎 두부 랩', description = '통밀 또띠아에 두부, 시금치, 느타리버섯을 곁들인 1인분 랩. 레몬올리브 양념, 깻잎 고명.', calories = 494.0, protein_g = 24.6, carbs_g = 48.4, fat_g = 22.5, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0237';
UPDATE recipes SET name = '바질 두부 랩', description = '통밀 또띠아에 두부, 시금치, 느타리버섯을 곁들인 1인분 랩. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0238';
UPDATE recipes SET name = '허브 두부 랩', description = '통밀 또띠아에 두부, 시금치, 느타리버섯을 곁들인 1인분 랩. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0240';
UPDATE recipes SET name = '레몬 두부 랩', description = '통밀 또띠아에 두부, 청경채, 양송이버섯을 곁들인 1인분 랩. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0241';
UPDATE recipes SET name = '들깨 두부 랩', description = '통밀 또띠아에 두부, 청경채, 양송이버섯을 곁들인 1인분 랩. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0242';
UPDATE recipes SET name = '마늘 두부 랩', description = '통밀 또띠아에 두부, 청경채, 양송이버섯을 곁들인 1인분 랩. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0244';
UPDATE recipes SET name = '깻잎 두부 랩', description = '통밀 또띠아에 두부, 청경채, 양송이버섯을 곁들인 1인분 랩. 레몬올리브 양념, 깻잎 고명.', calories = 479.0, protein_g = 23.9, carbs_g = 45.5, fat_g = 22.5, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0247';
UPDATE recipes SET name = '바질 두부 랩', description = '통밀 또띠아에 두부, 청경채, 양송이버섯을 곁들인 1인분 랩. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0248';
UPDATE recipes SET name = '허브 두부 랩', description = '통밀 또띠아에 두부, 청경채, 양송이버섯을 곁들인 1인분 랩. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0250';
UPDATE recipes SET name = '레몬 두부 랩', description = '통밀 또띠아에 두부, 가지, 토마토를 곁들인 1인분 랩. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0251';
UPDATE recipes SET name = '들깨 두부 랩', description = '통밀 또띠아에 두부, 가지, 토마토를 곁들인 1인분 랩. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0252';
UPDATE recipes SET name = '마늘 두부 랩', description = '통밀 또띠아에 두부, 가지, 토마토를 곁들인 1인분 랩. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0254';
UPDATE recipes SET name = '깻잎 두부 랩', description = '통밀 또띠아에 두부, 가지, 토마토를 곁들인 1인분 랩. 레몬올리브 양념, 깻잎 고명.', calories = 486.0, protein_g = 22.0, carbs_g = 49.1, fat_g = 22.5, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0257';
UPDATE recipes SET name = '바질 두부 랩', description = '통밀 또띠아에 두부, 가지, 토마토를 곁들인 1인분 랩. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0258';
UPDATE recipes SET name = '허브 두부 랩', description = '통밀 또띠아에 두부, 가지, 토마토를 곁들인 1인분 랩. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0260';
UPDATE recipes SET name = '레몬 두부 랩', description = '통밀 또띠아에 두부, 양배추, 파프리카를 곁들인 1인분 랩. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0261';
UPDATE recipes SET name = '들깨 두부 랩', description = '통밀 또띠아에 두부, 양배추, 파프리카를 곁들인 1인분 랩. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0262';
UPDATE recipes SET name = '마늘 두부 랩', description = '통밀 또띠아에 두부, 양배추, 파프리카를 곁들인 1인분 랩. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0264';
UPDATE recipes SET name = '깻잎 두부 랩', description = '통밀 또띠아에 두부, 양배추, 파프리카를 곁들인 1인분 랩. 레몬올리브 양념, 깻잎 고명.', calories = 488.0, protein_g = 21.8, carbs_g = 49.7, fat_g = 22.5, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0267';
UPDATE recipes SET name = '바질 두부 랩', description = '통밀 또띠아에 두부, 양배추, 파프리카를 곁들인 1인분 랩. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0268';
UPDATE recipes SET name = '허브 두부 랩', description = '통밀 또띠아에 두부, 양배추, 파프리카를 곁들인 1인분 랩. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0270';
UPDATE recipes SET name = '레몬 두부 랩', description = '통밀 또띠아에 두부, 브로콜리, 당근을 곁들인 1인분 랩. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0271';
UPDATE recipes SET name = '들깨 두부 랩', description = '통밀 또띠아에 두부, 브로콜리, 당근을 곁들인 1인분 랩. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0272';
UPDATE recipes SET name = '마늘 두부 랩', description = '통밀 또띠아에 두부, 브로콜리, 당근을 곁들인 1인분 랩. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0274';
UPDATE recipes SET name = '깻잎 두부 랩', description = '통밀 또띠아에 두부, 브로콜리, 당근을 곁들인 1인분 랩. 레몬올리브 양념, 깻잎 고명.', calories = 505.0, protein_g = 23.5, carbs_g = 52.3, fat_g = 22.5, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0277';
UPDATE recipes SET name = '바질 두부 랩', description = '통밀 또띠아에 두부, 브로콜리, 당근을 곁들인 1인분 랩. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0278';
UPDATE recipes SET name = '허브 두부 랩', description = '통밀 또띠아에 두부, 브로콜리, 당근을 곁들인 1인분 랩. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0280';
UPDATE recipes SET name = '레몬 두부 랩', description = '통밀 또띠아에 두부, 애호박, 양송이버섯을 곁들인 1인분 랩. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0281';
UPDATE recipes SET name = '들깨 두부 랩', description = '통밀 또띠아에 두부, 애호박, 양송이버섯을 곁들인 1인분 랩. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0282';
UPDATE recipes SET name = '마늘 두부 랩', description = '통밀 또띠아에 두부, 애호박, 양송이버섯을 곁들인 1인분 랩. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0284';
UPDATE recipes SET name = '깻잎 두부 랩', description = '통밀 또띠아에 두부, 애호박, 양송이버섯을 곁들인 1인분 랩. 레몬올리브 양념, 깻잎 고명.', calories = 476.0, protein_g = 23.1, carbs_g = 45.5, fat_g = 22.5, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0287';
UPDATE recipes SET name = '바질 두부 랩', description = '통밀 또띠아에 두부, 애호박, 양송이버섯을 곁들인 1인분 랩. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0288';
UPDATE recipes SET name = '허브 두부 랩', description = '통밀 또띠아에 두부, 애호박, 양송이버섯을 곁들인 1인분 랩. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0290';
UPDATE recipes SET name = '레몬 두부 랩', description = '통밀 또띠아에 두부, 시금치, 토마토를 곁들인 1인분 랩. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0291';
UPDATE recipes SET name = '들깨 두부 랩', description = '통밀 또띠아에 두부, 시금치, 토마토를 곁들인 1인분 랩. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0292';
UPDATE recipes SET name = '마늘 두부 랩', description = '통밀 또띠아에 두부, 시금치, 토마토를 곁들인 1인분 랩. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0294';
UPDATE recipes SET name = '깻잎 두부 랩', description = '통밀 또띠아에 두부, 시금치, 토마토를 곁들인 1인분 랩. 레몬올리브 양념, 깻잎 고명.', calories = 482.0, protein_g = 23.0, carbs_g = 46.9, fat_g = 22.5, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0297';
UPDATE recipes SET name = '바질 두부 랩', description = '통밀 또띠아에 두부, 시금치, 토마토를 곁들인 1인분 랩. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0298';
UPDATE recipes SET name = '허브 두부 랩', description = '통밀 또띠아에 두부, 시금치, 토마토를 곁들인 1인분 랩. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0300';
UPDATE recipes SET name = '들깨 새우 메밀비빔면', description = '메밀면에 새우, 양배추, 당근을 곁들인 1인분 메밀 비빔면. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0302';
UPDATE recipes SET name = '간장 새우 메밀비빔면', description = '메밀면에 새우, 양배추, 당근을 곁들인 1인분 메밀 비빔면. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0303';
UPDATE recipes SET name = '마늘 새우 메밀비빔면', description = '메밀면에 새우, 양배추, 당근을 곁들인 1인분 메밀 비빔면. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0304';
UPDATE recipes SET name = '생강간장 새우 메밀비빔면', description = '메밀면에 새우, 양배추, 당근을 곁들인 1인분 메밀 비빔면. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0305';
UPDATE recipes SET name = '파간장 새우 메밀비빔면', description = '메밀면에 새우, 양배추, 당근을 곁들인 1인분 메밀 비빔면. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0306';
UPDATE recipes SET name = '깻잎 새우 메밀비빔면', description = '메밀면에 새우, 양배추, 당근을 곁들인 1인분 메밀 비빔면. 들기름간장 양념, 깻잎 고명.', calories = 472.0, protein_g = 36.3, carbs_g = 54.0, fat_g = 12.2, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0307';
UPDATE recipes SET name = '김 새우 메밀비빔면', description = '메밀면에 새우, 양배추, 당근을 곁들인 1인분 메밀 비빔면. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0309';
UPDATE recipes SET name = '들깨 새우 메밀비빔면', description = '메밀면에 새우, 브로콜리, 양파를 곁들인 1인분 메밀 비빔면. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0312';
UPDATE recipes SET name = '간장 새우 메밀비빔면', description = '메밀면에 새우, 브로콜리, 양파를 곁들인 1인분 메밀 비빔면. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0313';
UPDATE recipes SET name = '마늘 새우 메밀비빔면', description = '메밀면에 새우, 브로콜리, 양파를 곁들인 1인분 메밀 비빔면. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0314';
UPDATE recipes SET name = '생강간장 새우 메밀비빔면', description = '메밀면에 새우, 브로콜리, 양파를 곁들인 1인분 메밀 비빔면. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0315';
UPDATE recipes SET name = '파간장 새우 메밀비빔면', description = '메밀면에 새우, 브로콜리, 양파를 곁들인 1인분 메밀 비빔면. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0316';
UPDATE recipes SET name = '깻잎 새우 메밀비빔면', description = '메밀면에 새우, 브로콜리, 양파를 곁들인 1인분 메밀 비빔면. 들기름간장 양념, 깻잎 고명.', calories = 480.0, protein_g = 38.0, carbs_g = 54.2, fat_g = 12.2, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0317';
UPDATE recipes SET name = '김 새우 메밀비빔면', description = '메밀면에 새우, 브로콜리, 양파를 곁들인 1인분 메밀 비빔면. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0319';
UPDATE recipes SET name = '들깨 새우 메밀비빔면', description = '메밀면에 새우, 애호박, 파프리카를 곁들인 1인분 메밀 비빔면. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0322';
UPDATE recipes SET name = '간장 새우 메밀비빔면', description = '메밀면에 새우, 애호박, 파프리카를 곁들인 1인분 메밀 비빔면. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0323';
UPDATE recipes SET name = '마늘 새우 메밀비빔면', description = '메밀면에 새우, 애호박, 파프리카를 곁들인 1인분 메밀 비빔면. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0324';
UPDATE recipes SET name = '생강간장 새우 메밀비빔면', description = '메밀면에 새우, 애호박, 파프리카를 곁들인 1인분 메밀 비빔면. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0325';
UPDATE recipes SET name = '파간장 새우 메밀비빔면', description = '메밀면에 새우, 애호박, 파프리카를 곁들인 1인분 메밀 비빔면. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0326';
UPDATE recipes SET name = '깻잎 새우 메밀비빔면', description = '메밀면에 새우, 애호박, 파프리카를 곁들인 1인분 메밀 비빔면. 들기름간장 양념, 깻잎 고명.', calories = 457.0, protein_g = 36.4, carbs_g = 50.1, fat_g = 12.2, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0327';
UPDATE recipes SET name = '김 새우 메밀비빔면', description = '메밀면에 새우, 애호박, 파프리카를 곁들인 1인분 메밀 비빔면. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0329';
UPDATE recipes SET name = '들깨 새우 메밀비빔면', description = '메밀면에 새우, 시금치, 느타리버섯을 곁들인 1인분 메밀 비빔면. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0332';
UPDATE recipes SET name = '간장 새우 메밀비빔면', description = '메밀면에 새우, 시금치, 느타리버섯을 곁들인 1인분 메밀 비빔면. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0333';
UPDATE recipes SET name = '마늘 새우 메밀비빔면', description = '메밀면에 새우, 시금치, 느타리버섯을 곁들인 1인분 메밀 비빔면. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0334';
UPDATE recipes SET name = '생강간장 새우 메밀비빔면', description = '메밀면에 새우, 시금치, 느타리버섯을 곁들인 1인분 메밀 비빔면. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0335';
UPDATE recipes SET name = '파간장 새우 메밀비빔면', description = '메밀면에 새우, 시금치, 느타리버섯을 곁들인 1인분 메밀 비빔면. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0336';
UPDATE recipes SET name = '깻잎 새우 메밀비빔면', description = '메밀면에 새우, 시금치, 느타리버섯을 곁들인 1인분 메밀 비빔면. 들기름간장 양념, 깻잎 고명.', calories = 473.0, protein_g = 39.2, carbs_g = 51.3, fat_g = 12.2, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0337';
UPDATE recipes SET name = '김 새우 메밀비빔면', description = '메밀면에 새우, 시금치, 느타리버섯을 곁들인 1인분 메밀 비빔면. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0339';
UPDATE recipes SET name = '들깨 새우 메밀비빔면', description = '메밀면에 새우, 청경채, 양송이버섯을 곁들인 1인분 메밀 비빔면. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0342';
UPDATE recipes SET name = '간장 새우 메밀비빔면', description = '메밀면에 새우, 청경채, 양송이버섯을 곁들인 1인분 메밀 비빔면. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0343';
UPDATE recipes SET name = '마늘 새우 메밀비빔면', description = '메밀면에 새우, 청경채, 양송이버섯을 곁들인 1인분 메밀 비빔면. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0344';
UPDATE recipes SET name = '생강간장 새우 메밀비빔면', description = '메밀면에 새우, 청경채, 양송이버섯을 곁들인 1인분 메밀 비빔면. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0345';
UPDATE recipes SET name = '파간장 새우 메밀비빔면', description = '메밀면에 새우, 청경채, 양송이버섯을 곁들인 1인분 메밀 비빔면. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0346';
UPDATE recipes SET name = '깻잎 새우 메밀비빔면', description = '메밀면에 새우, 청경채, 양송이버섯을 곁들인 1인분 메밀 비빔면. 들기름간장 양념, 깻잎 고명.', calories = 458.0, protein_g = 38.4, carbs_g = 48.4, fat_g = 12.2, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0347';
UPDATE recipes SET name = '김 새우 메밀비빔면', description = '메밀면에 새우, 청경채, 양송이버섯을 곁들인 1인분 메밀 비빔면. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0349';
UPDATE recipes SET name = '들깨 새우 메밀비빔면', description = '메밀면에 새우, 가지, 토마토를 곁들인 1인분 메밀 비빔면. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0352';
UPDATE recipes SET name = '간장 새우 메밀비빔면', description = '메밀면에 새우, 가지, 토마토를 곁들인 1인분 메밀 비빔면. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0353';
UPDATE recipes SET name = '마늘 새우 메밀비빔면', description = '메밀면에 새우, 가지, 토마토를 곁들인 1인분 메밀 비빔면. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0354';
UPDATE recipes SET name = '생강간장 새우 메밀비빔면', description = '메밀면에 새우, 가지, 토마토를 곁들인 1인분 메밀 비빔면. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0355';
UPDATE recipes SET name = '파간장 새우 메밀비빔면', description = '메밀면에 새우, 가지, 토마토를 곁들인 1인분 메밀 비빔면. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0356';
UPDATE recipes SET name = '깻잎 새우 메밀비빔면', description = '메밀면에 새우, 가지, 토마토를 곁들인 1인분 메밀 비빔면. 들기름간장 양념, 깻잎 고명.', calories = 465.0, protein_g = 36.5, carbs_g = 52.0, fat_g = 12.2, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0357';
UPDATE recipes SET name = '김 새우 메밀비빔면', description = '메밀면에 새우, 가지, 토마토를 곁들인 1인분 메밀 비빔면. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0359';
UPDATE recipes SET name = '들깨 새우 메밀비빔면', description = '메밀면에 새우, 양배추, 파프리카를 곁들인 1인분 메밀 비빔면. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0362';
UPDATE recipes SET name = '간장 새우 메밀비빔면', description = '메밀면에 새우, 양배추, 파프리카를 곁들인 1인분 메밀 비빔면. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0363';
UPDATE recipes SET name = '마늘 새우 메밀비빔면', description = '메밀면에 새우, 양배추, 파프리카를 곁들인 1인분 메밀 비빔면. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0364';
UPDATE recipes SET name = '생강간장 새우 메밀비빔면', description = '메밀면에 새우, 양배추, 파프리카를 곁들인 1인분 메밀 비빔면. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0365';
UPDATE recipes SET name = '파간장 새우 메밀비빔면', description = '메밀면에 새우, 양배추, 파프리카를 곁들인 1인분 메밀 비빔면. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0366';
UPDATE recipes SET name = '깻잎 새우 메밀비빔면', description = '메밀면에 새우, 양배추, 파프리카를 곁들인 1인분 메밀 비빔면. 들기름간장 양념, 깻잎 고명.', calories = 467.0, protein_g = 36.4, carbs_g = 52.6, fat_g = 12.2, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0367';
UPDATE recipes SET name = '김 새우 메밀비빔면', description = '메밀면에 새우, 양배추, 파프리카를 곁들인 1인분 메밀 비빔면. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0369';
UPDATE recipes SET name = '들깨 새우 메밀비빔면', description = '메밀면에 새우, 브로콜리, 당근을 곁들인 1인분 메밀 비빔면. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0372';
UPDATE recipes SET name = '간장 새우 메밀비빔면', description = '메밀면에 새우, 브로콜리, 당근을 곁들인 1인분 메밀 비빔면. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0373';
UPDATE recipes SET name = '마늘 새우 메밀비빔면', description = '메밀면에 새우, 브로콜리, 당근을 곁들인 1인분 메밀 비빔면. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0374';
UPDATE recipes SET name = '생강간장 새우 메밀비빔면', description = '메밀면에 새우, 브로콜리, 당근을 곁들인 1인분 메밀 비빔면. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0375';
UPDATE recipes SET name = '파간장 새우 메밀비빔면', description = '메밀면에 새우, 브로콜리, 당근을 곁들인 1인분 메밀 비빔면. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0376';
UPDATE recipes SET name = '깻잎 새우 메밀비빔면', description = '메밀면에 새우, 브로콜리, 당근을 곁들인 1인분 메밀 비빔면. 들기름간장 양념, 깻잎 고명.', calories = 484.0, protein_g = 38.0, carbs_g = 55.2, fat_g = 12.2, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0377';
UPDATE recipes SET name = '김 새우 메밀비빔면', description = '메밀면에 새우, 브로콜리, 당근을 곁들인 1인분 메밀 비빔면. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0379';
UPDATE recipes SET name = '들깨 새우 메밀비빔면', description = '메밀면에 새우, 애호박, 양송이버섯을 곁들인 1인분 메밀 비빔면. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0382';
UPDATE recipes SET name = '간장 새우 메밀비빔면', description = '메밀면에 새우, 애호박, 양송이버섯을 곁들인 1인분 메밀 비빔면. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0383';
UPDATE recipes SET name = '마늘 새우 메밀비빔면', description = '메밀면에 새우, 애호박, 양송이버섯을 곁들인 1인분 메밀 비빔면. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0384';
UPDATE recipes SET name = '생강간장 새우 메밀비빔면', description = '메밀면에 새우, 애호박, 양송이버섯을 곁들인 1인분 메밀 비빔면. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0385';
UPDATE recipes SET name = '파간장 새우 메밀비빔면', description = '메밀면에 새우, 애호박, 양송이버섯을 곁들인 1인분 메밀 비빔면. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0386';
UPDATE recipes SET name = '깻잎 새우 메밀비빔면', description = '메밀면에 새우, 애호박, 양송이버섯을 곁들인 1인분 메밀 비빔면. 들기름간장 양념, 깻잎 고명.', calories = 455.0, protein_g = 37.7, carbs_g = 48.4, fat_g = 12.2, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0387';
UPDATE recipes SET name = '김 새우 메밀비빔면', description = '메밀면에 새우, 애호박, 양송이버섯을 곁들인 1인분 메밀 비빔면. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0389';
UPDATE recipes SET name = '들깨 새우 메밀비빔면', description = '메밀면에 새우, 시금치, 토마토를 곁들인 1인분 메밀 비빔면. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0392';
UPDATE recipes SET name = '간장 새우 메밀비빔면', description = '메밀면에 새우, 시금치, 토마토를 곁들인 1인분 메밀 비빔면. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0393';
UPDATE recipes SET name = '마늘 새우 메밀비빔면', description = '메밀면에 새우, 시금치, 토마토를 곁들인 1인분 메밀 비빔면. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0394';
UPDATE recipes SET name = '생강간장 새우 메밀비빔면', description = '메밀면에 새우, 시금치, 토마토를 곁들인 1인분 메밀 비빔면. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0395';
UPDATE recipes SET name = '파간장 새우 메밀비빔면', description = '메밀면에 새우, 시금치, 토마토를 곁들인 1인분 메밀 비빔면. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0396';
UPDATE recipes SET name = '깻잎 새우 메밀비빔면', description = '메밀면에 새우, 시금치, 토마토를 곁들인 1인분 메밀 비빔면. 들기름간장 양념, 깻잎 고명.', calories = 460.0, protein_g = 37.6, carbs_g = 49.8, fat_g = 12.2, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0397';
UPDATE recipes SET name = '김 새우 메밀비빔면', description = '메밀면에 새우, 시금치, 토마토를 곁들인 1인분 메밀 비빔면. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0399';
UPDATE recipes SET name = '레몬 참치 감자볼', description = '감자에 참치 통조림, 양배추, 당근을 곁들인 1인분 감자 볼. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0401';
UPDATE recipes SET name = '들깨 참치 감자볼', description = '감자에 참치 통조림, 양배추, 당근을 곁들인 1인분 감자 볼. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0402';
UPDATE recipes SET name = '간장 참치 감자볼', description = '감자에 참치 통조림, 양배추, 당근을 곁들인 1인분 감자 볼. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0403';
UPDATE recipes SET name = '마늘 참치 감자볼', description = '감자에 참치 통조림, 양배추, 당근을 곁들인 1인분 감자 볼. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0404';
UPDATE recipes SET name = '생강간장 참치 감자볼', description = '감자에 참치 통조림, 양배추, 당근을 곁들인 1인분 감자 볼. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0405';
UPDATE recipes SET name = '파간장 참치 감자볼', description = '감자에 참치 통조림, 양배추, 당근을 곁들인 1인분 감자 볼. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0406';
UPDATE recipes SET name = '깻잎 참치 감자볼', description = '감자에 참치 통조림, 양배추, 당근을 곁들인 1인분 감자 볼. 레몬올리브 양념, 깻잎 고명.', calories = 371.0, protein_g = 31.7, carbs_g = 42.9, fat_g = 8.1, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0407';
UPDATE recipes SET name = '바질 참치 감자볼', description = '감자에 참치 통조림, 양배추, 당근을 곁들인 1인분 감자 볼. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0408';
UPDATE recipes SET name = '김 참치 감자볼', description = '감자에 참치 통조림, 양배추, 당근을 곁들인 1인분 감자 볼. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0409';
UPDATE recipes SET name = '허브 참치 감자볼', description = '감자에 참치 통조림, 양배추, 당근을 곁들인 1인분 감자 볼. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0410';
UPDATE recipes SET name = '레몬 참치 감자볼', description = '감자에 참치 통조림, 브로콜리, 양파를 곁들인 1인분 감자 볼. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0411';
UPDATE recipes SET name = '들깨 참치 감자볼', description = '감자에 참치 통조림, 브로콜리, 양파를 곁들인 1인분 감자 볼. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0412';
UPDATE recipes SET name = '간장 참치 감자볼', description = '감자에 참치 통조림, 브로콜리, 양파를 곁들인 1인분 감자 볼. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0413';
UPDATE recipes SET name = '마늘 참치 감자볼', description = '감자에 참치 통조림, 브로콜리, 양파를 곁들인 1인분 감자 볼. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0414';
UPDATE recipes SET name = '생강간장 참치 감자볼', description = '감자에 참치 통조림, 브로콜리, 양파를 곁들인 1인분 감자 볼. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0415';
UPDATE recipes SET name = '파간장 참치 감자볼', description = '감자에 참치 통조림, 브로콜리, 양파를 곁들인 1인분 감자 볼. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0416';
UPDATE recipes SET name = '깻잎 참치 감자볼', description = '감자에 참치 통조림, 브로콜리, 양파를 곁들인 1인분 감자 볼. 레몬올리브 양념, 깻잎 고명.', calories = 378.0, protein_g = 33.4, carbs_g = 43.1, fat_g = 8.1, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0417';
UPDATE recipes SET name = '바질 참치 감자볼', description = '감자에 참치 통조림, 브로콜리, 양파를 곁들인 1인분 감자 볼. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0418';
UPDATE recipes SET name = '김 참치 감자볼', description = '감자에 참치 통조림, 브로콜리, 양파를 곁들인 1인분 감자 볼. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0419';
UPDATE recipes SET name = '허브 참치 감자볼', description = '감자에 참치 통조림, 브로콜리, 양파를 곁들인 1인분 감자 볼. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0420';
UPDATE recipes SET name = '레몬 참치 감자볼', description = '감자에 참치 통조림, 애호박, 파프리카를 곁들인 1인분 감자 볼. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0421';
UPDATE recipes SET name = '들깨 참치 감자볼', description = '감자에 참치 통조림, 애호박, 파프리카를 곁들인 1인분 감자 볼. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0422';
UPDATE recipes SET name = '간장 참치 감자볼', description = '감자에 참치 통조림, 애호박, 파프리카를 곁들인 1인분 감자 볼. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0423';
UPDATE recipes SET name = '마늘 참치 감자볼', description = '감자에 참치 통조림, 애호박, 파프리카를 곁들인 1인분 감자 볼. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0424';
UPDATE recipes SET name = '생강간장 참치 감자볼', description = '감자에 참치 통조림, 애호박, 파프리카를 곁들인 1인분 감자 볼. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0425';
UPDATE recipes SET name = '파간장 참치 감자볼', description = '감자에 참치 통조림, 애호박, 파프리카를 곁들인 1인분 감자 볼. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0426';
UPDATE recipes SET name = '깻잎 참치 감자볼', description = '감자에 참치 통조림, 애호박, 파프리카를 곁들인 1인분 감자 볼. 레몬올리브 양념, 깻잎 고명.', calories = 355.0, protein_g = 31.8, carbs_g = 39.0, fat_g = 8.1, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0427';
UPDATE recipes SET name = '바질 참치 감자볼', description = '감자에 참치 통조림, 애호박, 파프리카를 곁들인 1인분 감자 볼. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0428';
UPDATE recipes SET name = '김 참치 감자볼', description = '감자에 참치 통조림, 애호박, 파프리카를 곁들인 1인분 감자 볼. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0429';
UPDATE recipes SET name = '허브 참치 감자볼', description = '감자에 참치 통조림, 애호박, 파프리카를 곁들인 1인분 감자 볼. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0430';
UPDATE recipes SET name = '레몬 참치 감자볼', description = '감자에 참치 통조림, 시금치, 느타리버섯을 곁들인 1인분 감자 볼. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0431';
UPDATE recipes SET name = '들깨 참치 감자볼', description = '감자에 참치 통조림, 시금치, 느타리버섯을 곁들인 1인분 감자 볼. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0432';
UPDATE recipes SET name = '간장 참치 감자볼', description = '감자에 참치 통조림, 시금치, 느타리버섯을 곁들인 1인분 감자 볼. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0433';
UPDATE recipes SET name = '마늘 참치 감자볼', description = '감자에 참치 통조림, 시금치, 느타리버섯을 곁들인 1인분 감자 볼. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0434';
UPDATE recipes SET name = '생강간장 참치 감자볼', description = '감자에 참치 통조림, 시금치, 느타리버섯을 곁들인 1인분 감자 볼. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0435';
UPDATE recipes SET name = '파간장 참치 감자볼', description = '감자에 참치 통조림, 시금치, 느타리버섯을 곁들인 1인분 감자 볼. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0436';
UPDATE recipes SET name = '깻잎 참치 감자볼', description = '감자에 참치 통조림, 시금치, 느타리버섯을 곁들인 1인분 감자 볼. 레몬올리브 양념, 깻잎 고명.', calories = 371.0, protein_g = 34.6, carbs_g = 40.2, fat_g = 8.1, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0437';
UPDATE recipes SET name = '바질 참치 감자볼', description = '감자에 참치 통조림, 시금치, 느타리버섯을 곁들인 1인분 감자 볼. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0438';
UPDATE recipes SET name = '김 참치 감자볼', description = '감자에 참치 통조림, 시금치, 느타리버섯을 곁들인 1인분 감자 볼. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0439';
UPDATE recipes SET name = '허브 참치 감자볼', description = '감자에 참치 통조림, 시금치, 느타리버섯을 곁들인 1인분 감자 볼. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0440';
UPDATE recipes SET name = '레몬 참치 감자볼', description = '감자에 참치 통조림, 청경채, 양송이버섯을 곁들인 1인분 감자 볼. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0441';
UPDATE recipes SET name = '들깨 참치 감자볼', description = '감자에 참치 통조림, 청경채, 양송이버섯을 곁들인 1인분 감자 볼. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0442';
UPDATE recipes SET name = '간장 참치 감자볼', description = '감자에 참치 통조림, 청경채, 양송이버섯을 곁들인 1인분 감자 볼. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0443';
UPDATE recipes SET name = '마늘 참치 감자볼', description = '감자에 참치 통조림, 청경채, 양송이버섯을 곁들인 1인분 감자 볼. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0444';
UPDATE recipes SET name = '생강간장 참치 감자볼', description = '감자에 참치 통조림, 청경채, 양송이버섯을 곁들인 1인분 감자 볼. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0445';
UPDATE recipes SET name = '파간장 참치 감자볼', description = '감자에 참치 통조림, 청경채, 양송이버섯을 곁들인 1인분 감자 볼. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0446';
UPDATE recipes SET name = '깻잎 참치 감자볼', description = '감자에 참치 통조림, 청경채, 양송이버섯을 곁들인 1인분 감자 볼. 레몬올리브 양념, 깻잎 고명.', calories = 357.0, protein_g = 33.8, carbs_g = 37.3, fat_g = 8.1, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0447';
UPDATE recipes SET name = '바질 참치 감자볼', description = '감자에 참치 통조림, 청경채, 양송이버섯을 곁들인 1인분 감자 볼. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0448';
UPDATE recipes SET name = '김 참치 감자볼', description = '감자에 참치 통조림, 청경채, 양송이버섯을 곁들인 1인분 감자 볼. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0449';
UPDATE recipes SET name = '허브 참치 감자볼', description = '감자에 참치 통조림, 청경채, 양송이버섯을 곁들인 1인분 감자 볼. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0450';
UPDATE recipes SET name = '레몬 참치 감자볼', description = '감자에 참치 통조림, 가지, 토마토를 곁들인 1인분 감자 볼. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0451';
UPDATE recipes SET name = '들깨 참치 감자볼', description = '감자에 참치 통조림, 가지, 토마토를 곁들인 1인분 감자 볼. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0452';
UPDATE recipes SET name = '간장 참치 감자볼', description = '감자에 참치 통조림, 가지, 토마토를 곁들인 1인분 감자 볼. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0453';
UPDATE recipes SET name = '마늘 참치 감자볼', description = '감자에 참치 통조림, 가지, 토마토를 곁들인 1인분 감자 볼. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0454';
UPDATE recipes SET name = '생강간장 참치 감자볼', description = '감자에 참치 통조림, 가지, 토마토를 곁들인 1인분 감자 볼. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0455';
UPDATE recipes SET name = '파간장 참치 감자볼', description = '감자에 참치 통조림, 가지, 토마토를 곁들인 1인분 감자 볼. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0456';
UPDATE recipes SET name = '깻잎 참치 감자볼', description = '감자에 참치 통조림, 가지, 토마토를 곁들인 1인분 감자 볼. 레몬올리브 양념, 깻잎 고명.', calories = 364.0, protein_g = 31.9, carbs_g = 40.9, fat_g = 8.1, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0457';
UPDATE recipes SET name = '바질 참치 감자볼', description = '감자에 참치 통조림, 가지, 토마토를 곁들인 1인분 감자 볼. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0458';
UPDATE recipes SET name = '김 참치 감자볼', description = '감자에 참치 통조림, 가지, 토마토를 곁들인 1인분 감자 볼. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0459';
UPDATE recipes SET name = '허브 참치 감자볼', description = '감자에 참치 통조림, 가지, 토마토를 곁들인 1인분 감자 볼. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0460';
UPDATE recipes SET name = '레몬 참치 감자볼', description = '감자에 참치 통조림, 양배추, 파프리카를 곁들인 1인분 감자 볼. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0461';
UPDATE recipes SET name = '들깨 참치 감자볼', description = '감자에 참치 통조림, 양배추, 파프리카를 곁들인 1인분 감자 볼. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0462';
UPDATE recipes SET name = '간장 참치 감자볼', description = '감자에 참치 통조림, 양배추, 파프리카를 곁들인 1인분 감자 볼. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0463';
UPDATE recipes SET name = '마늘 참치 감자볼', description = '감자에 참치 통조림, 양배추, 파프리카를 곁들인 1인분 감자 볼. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0464';
UPDATE recipes SET name = '생강간장 참치 감자볼', description = '감자에 참치 통조림, 양배추, 파프리카를 곁들인 1인분 감자 볼. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0465';
UPDATE recipes SET name = '파간장 참치 감자볼', description = '감자에 참치 통조림, 양배추, 파프리카를 곁들인 1인분 감자 볼. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0466';
UPDATE recipes SET name = '깻잎 참치 감자볼', description = '감자에 참치 통조림, 양배추, 파프리카를 곁들인 1인분 감자 볼. 레몬올리브 양념, 깻잎 고명.', calories = 365.0, protein_g = 31.8, carbs_g = 41.5, fat_g = 8.1, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0467';
UPDATE recipes SET name = '바질 참치 감자볼', description = '감자에 참치 통조림, 양배추, 파프리카를 곁들인 1인분 감자 볼. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0468';
UPDATE recipes SET name = '김 참치 감자볼', description = '감자에 참치 통조림, 양배추, 파프리카를 곁들인 1인분 감자 볼. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0469';
UPDATE recipes SET name = '허브 참치 감자볼', description = '감자에 참치 통조림, 양배추, 파프리카를 곁들인 1인분 감자 볼. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0470';
UPDATE recipes SET name = '레몬 참치 감자볼', description = '감자에 참치 통조림, 브로콜리, 당근을 곁들인 1인분 감자 볼. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0471';
UPDATE recipes SET name = '들깨 참치 감자볼', description = '감자에 참치 통조림, 브로콜리, 당근을 곁들인 1인분 감자 볼. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0472';
UPDATE recipes SET name = '간장 참치 감자볼', description = '감자에 참치 통조림, 브로콜리, 당근을 곁들인 1인분 감자 볼. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0473';
UPDATE recipes SET name = '마늘 참치 감자볼', description = '감자에 참치 통조림, 브로콜리, 당근을 곁들인 1인분 감자 볼. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0474';
UPDATE recipes SET name = '생강간장 참치 감자볼', description = '감자에 참치 통조림, 브로콜리, 당근을 곁들인 1인분 감자 볼. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0475';
UPDATE recipes SET name = '파간장 참치 감자볼', description = '감자에 참치 통조림, 브로콜리, 당근을 곁들인 1인분 감자 볼. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0476';
UPDATE recipes SET name = '깻잎 참치 감자볼', description = '감자에 참치 통조림, 브로콜리, 당근을 곁들인 1인분 감자 볼. 레몬올리브 양념, 깻잎 고명.', calories = 382.0, protein_g = 33.4, carbs_g = 44.1, fat_g = 8.1, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0477';
UPDATE recipes SET name = '바질 참치 감자볼', description = '감자에 참치 통조림, 브로콜리, 당근을 곁들인 1인분 감자 볼. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0478';
UPDATE recipes SET name = '김 참치 감자볼', description = '감자에 참치 통조림, 브로콜리, 당근을 곁들인 1인분 감자 볼. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0479';
UPDATE recipes SET name = '허브 참치 감자볼', description = '감자에 참치 통조림, 브로콜리, 당근을 곁들인 1인분 감자 볼. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0480';
UPDATE recipes SET name = '레몬 참치 감자볼', description = '감자에 참치 통조림, 애호박, 양송이버섯을 곁들인 1인분 감자 볼. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0481';
UPDATE recipes SET name = '들깨 참치 감자볼', description = '감자에 참치 통조림, 애호박, 양송이버섯을 곁들인 1인분 감자 볼. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0482';
UPDATE recipes SET name = '간장 참치 감자볼', description = '감자에 참치 통조림, 애호박, 양송이버섯을 곁들인 1인분 감자 볼. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0483';
UPDATE recipes SET name = '마늘 참치 감자볼', description = '감자에 참치 통조림, 애호박, 양송이버섯을 곁들인 1인분 감자 볼. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0484';
UPDATE recipes SET name = '생강간장 참치 감자볼', description = '감자에 참치 통조림, 애호박, 양송이버섯을 곁들인 1인분 감자 볼. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0485';
UPDATE recipes SET name = '파간장 참치 감자볼', description = '감자에 참치 통조림, 애호박, 양송이버섯을 곁들인 1인분 감자 볼. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0486';
UPDATE recipes SET name = '깻잎 참치 감자볼', description = '감자에 참치 통조림, 애호박, 양송이버섯을 곁들인 1인분 감자 볼. 레몬올리브 양념, 깻잎 고명.', calories = 354.0, protein_g = 33.1, carbs_g = 37.3, fat_g = 8.1, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0487';
UPDATE recipes SET name = '바질 참치 감자볼', description = '감자에 참치 통조림, 애호박, 양송이버섯을 곁들인 1인분 감자 볼. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0488';
UPDATE recipes SET name = '김 참치 감자볼', description = '감자에 참치 통조림, 애호박, 양송이버섯을 곁들인 1인분 감자 볼. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0489';
UPDATE recipes SET name = '허브 참치 감자볼', description = '감자에 참치 통조림, 애호박, 양송이버섯을 곁들인 1인분 감자 볼. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0490';
UPDATE recipes SET name = '레몬 참치 감자볼', description = '감자에 참치 통조림, 시금치, 토마토를 곁들인 1인분 감자 볼. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0491';
UPDATE recipes SET name = '들깨 참치 감자볼', description = '감자에 참치 통조림, 시금치, 토마토를 곁들인 1인분 감자 볼. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0492';
UPDATE recipes SET name = '간장 참치 감자볼', description = '감자에 참치 통조림, 시금치, 토마토를 곁들인 1인분 감자 볼. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0493';
UPDATE recipes SET name = '마늘 참치 감자볼', description = '감자에 참치 통조림, 시금치, 토마토를 곁들인 1인분 감자 볼. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0494';
UPDATE recipes SET name = '생강간장 참치 감자볼', description = '감자에 참치 통조림, 시금치, 토마토를 곁들인 1인분 감자 볼. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0495';
UPDATE recipes SET name = '파간장 참치 감자볼', description = '감자에 참치 통조림, 시금치, 토마토를 곁들인 1인분 감자 볼. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0496';
UPDATE recipes SET name = '깻잎 참치 감자볼', description = '감자에 참치 통조림, 시금치, 토마토를 곁들인 1인분 감자 볼. 레몬올리브 양념, 깻잎 고명.', calories = 359.0, protein_g = 33.0, carbs_g = 38.7, fat_g = 8.1, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0497';
UPDATE recipes SET name = '바질 참치 감자볼', description = '감자에 참치 통조림, 시금치, 토마토를 곁들인 1인분 감자 볼. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0498';
UPDATE recipes SET name = '김 참치 감자볼', description = '감자에 참치 통조림, 시금치, 토마토를 곁들인 1인분 감자 볼. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0499';
UPDATE recipes SET name = '허브 참치 감자볼', description = '감자에 참치 통조림, 시금치, 토마토를 곁들인 1인분 감자 볼. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0500';
UPDATE recipes SET name = '레몬 연어 퀴노아볼', description = '퀴노아에 연어, 양배추, 당근을 곁들인 1인분 퀴노아 볼. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0501';
UPDATE recipes SET name = '들깨 연어 퀴노아볼', description = '퀴노아에 연어, 양배추, 당근을 곁들인 1인분 퀴노아 볼. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0502';
UPDATE recipes SET name = '간장 연어 퀴노아볼', description = '퀴노아에 연어, 양배추, 당근을 곁들인 1인분 퀴노아 볼. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0503';
UPDATE recipes SET name = '마늘 연어 퀴노아볼', description = '퀴노아에 연어, 양배추, 당근을 곁들인 1인분 퀴노아 볼. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0504';
UPDATE recipes SET name = '생강간장 연어 퀴노아볼', description = '퀴노아에 연어, 양배추, 당근을 곁들인 1인분 퀴노아 볼. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0505';
UPDATE recipes SET name = '파간장 연어 퀴노아볼', description = '퀴노아에 연어, 양배추, 당근을 곁들인 1인분 퀴노아 볼. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0506';
UPDATE recipes SET name = '깻잎 연어 퀴노아볼', description = '퀴노아에 연어, 양배추, 당근을 곁들인 1인분 퀴노아 볼. 레몬올리브 양념, 깻잎 고명.', calories = 552.0, protein_g = 30.5, carbs_g = 47.4, fat_g = 26.8, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0507';
UPDATE recipes SET name = '바질 연어 퀴노아볼', description = '퀴노아에 연어, 양배추, 당근을 곁들인 1인분 퀴노아 볼. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0508';
UPDATE recipes SET name = '김 연어 퀴노아볼', description = '퀴노아에 연어, 양배추, 당근을 곁들인 1인분 퀴노아 볼. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0509';
UPDATE recipes SET name = '허브 연어 퀴노아볼', description = '퀴노아에 연어, 양배추, 당근을 곁들인 1인분 퀴노아 볼. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0510';
UPDATE recipes SET name = '레몬 연어 퀴노아볼', description = '퀴노아에 연어, 브로콜리, 양파를 곁들인 1인분 퀴노아 볼. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0511';
UPDATE recipes SET name = '들깨 연어 퀴노아볼', description = '퀴노아에 연어, 브로콜리, 양파를 곁들인 1인분 퀴노아 볼. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0512';
UPDATE recipes SET name = '간장 연어 퀴노아볼', description = '퀴노아에 연어, 브로콜리, 양파를 곁들인 1인분 퀴노아 볼. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0513';
UPDATE recipes SET name = '마늘 연어 퀴노아볼', description = '퀴노아에 연어, 브로콜리, 양파를 곁들인 1인분 퀴노아 볼. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0514';
UPDATE recipes SET name = '생강간장 연어 퀴노아볼', description = '퀴노아에 연어, 브로콜리, 양파를 곁들인 1인분 퀴노아 볼. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0515';
UPDATE recipes SET name = '파간장 연어 퀴노아볼', description = '퀴노아에 연어, 브로콜리, 양파를 곁들인 1인분 퀴노아 볼. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0516';
UPDATE recipes SET name = '깻잎 연어 퀴노아볼', description = '퀴노아에 연어, 브로콜리, 양파를 곁들인 1인분 퀴노아 볼. 레몬올리브 양념, 깻잎 고명.', calories = 560.0, protein_g = 32.2, carbs_g = 47.6, fat_g = 26.8, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0517';
UPDATE recipes SET name = '바질 연어 퀴노아볼', description = '퀴노아에 연어, 브로콜리, 양파를 곁들인 1인분 퀴노아 볼. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0518';
UPDATE recipes SET name = '김 연어 퀴노아볼', description = '퀴노아에 연어, 브로콜리, 양파를 곁들인 1인분 퀴노아 볼. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0519';
UPDATE recipes SET name = '허브 연어 퀴노아볼', description = '퀴노아에 연어, 브로콜리, 양파를 곁들인 1인분 퀴노아 볼. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0520';
UPDATE recipes SET name = '레몬 연어 퀴노아볼', description = '퀴노아에 연어, 애호박, 파프리카를 곁들인 1인분 퀴노아 볼. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0521';
UPDATE recipes SET name = '들깨 연어 퀴노아볼', description = '퀴노아에 연어, 애호박, 파프리카를 곁들인 1인분 퀴노아 볼. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0522';
UPDATE recipes SET name = '간장 연어 퀴노아볼', description = '퀴노아에 연어, 애호박, 파프리카를 곁들인 1인분 퀴노아 볼. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0523';
UPDATE recipes SET name = '마늘 연어 퀴노아볼', description = '퀴노아에 연어, 애호박, 파프리카를 곁들인 1인분 퀴노아 볼. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0524';
UPDATE recipes SET name = '생강간장 연어 퀴노아볼', description = '퀴노아에 연어, 애호박, 파프리카를 곁들인 1인분 퀴노아 볼. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0525';
UPDATE recipes SET name = '파간장 연어 퀴노아볼', description = '퀴노아에 연어, 애호박, 파프리카를 곁들인 1인분 퀴노아 볼. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0526';
UPDATE recipes SET name = '깻잎 연어 퀴노아볼', description = '퀴노아에 연어, 애호박, 파프리카를 곁들인 1인분 퀴노아 볼. 레몬올리브 양념, 깻잎 고명.', calories = 537.0, protein_g = 30.6, carbs_g = 43.4, fat_g = 26.8, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0527';
UPDATE recipes SET name = '바질 연어 퀴노아볼', description = '퀴노아에 연어, 애호박, 파프리카를 곁들인 1인분 퀴노아 볼. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0528';
UPDATE recipes SET name = '김 연어 퀴노아볼', description = '퀴노아에 연어, 애호박, 파프리카를 곁들인 1인분 퀴노아 볼. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0529';
UPDATE recipes SET name = '허브 연어 퀴노아볼', description = '퀴노아에 연어, 애호박, 파프리카를 곁들인 1인분 퀴노아 볼. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0530';
UPDATE recipes SET name = '레몬 연어 퀴노아볼', description = '퀴노아에 연어, 시금치, 느타리버섯을 곁들인 1인분 퀴노아 볼. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0531';
UPDATE recipes SET name = '들깨 연어 퀴노아볼', description = '퀴노아에 연어, 시금치, 느타리버섯을 곁들인 1인분 퀴노아 볼. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0532';
UPDATE recipes SET name = '간장 연어 퀴노아볼', description = '퀴노아에 연어, 시금치, 느타리버섯을 곁들인 1인분 퀴노아 볼. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0533';
UPDATE recipes SET name = '마늘 연어 퀴노아볼', description = '퀴노아에 연어, 시금치, 느타리버섯을 곁들인 1인분 퀴노아 볼. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0534';
UPDATE recipes SET name = '생강간장 연어 퀴노아볼', description = '퀴노아에 연어, 시금치, 느타리버섯을 곁들인 1인분 퀴노아 볼. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0535';
UPDATE recipes SET name = '파간장 연어 퀴노아볼', description = '퀴노아에 연어, 시금치, 느타리버섯을 곁들인 1인분 퀴노아 볼. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0536';
UPDATE recipes SET name = '깻잎 연어 퀴노아볼', description = '퀴노아에 연어, 시금치, 느타리버섯을 곁들인 1인분 퀴노아 볼. 레몬올리브 양념, 깻잎 고명.', calories = 553.0, protein_g = 33.4, carbs_g = 44.7, fat_g = 26.8, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0537';
UPDATE recipes SET name = '바질 연어 퀴노아볼', description = '퀴노아에 연어, 시금치, 느타리버섯을 곁들인 1인분 퀴노아 볼. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0538';
UPDATE recipes SET name = '김 연어 퀴노아볼', description = '퀴노아에 연어, 시금치, 느타리버섯을 곁들인 1인분 퀴노아 볼. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0539';
UPDATE recipes SET name = '허브 연어 퀴노아볼', description = '퀴노아에 연어, 시금치, 느타리버섯을 곁들인 1인분 퀴노아 볼. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0540';
UPDATE recipes SET name = '레몬 연어 퀴노아볼', description = '퀴노아에 연어, 청경채, 양송이버섯을 곁들인 1인분 퀴노아 볼. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0541';
UPDATE recipes SET name = '들깨 연어 퀴노아볼', description = '퀴노아에 연어, 청경채, 양송이버섯을 곁들인 1인분 퀴노아 볼. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0542';
UPDATE recipes SET name = '간장 연어 퀴노아볼', description = '퀴노아에 연어, 청경채, 양송이버섯을 곁들인 1인분 퀴노아 볼. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0543';
UPDATE recipes SET name = '마늘 연어 퀴노아볼', description = '퀴노아에 연어, 청경채, 양송이버섯을 곁들인 1인분 퀴노아 볼. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0544';
UPDATE recipes SET name = '생강간장 연어 퀴노아볼', description = '퀴노아에 연어, 청경채, 양송이버섯을 곁들인 1인분 퀴노아 볼. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0545';
UPDATE recipes SET name = '파간장 연어 퀴노아볼', description = '퀴노아에 연어, 청경채, 양송이버섯을 곁들인 1인분 퀴노아 볼. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0546';
UPDATE recipes SET name = '깻잎 연어 퀴노아볼', description = '퀴노아에 연어, 청경채, 양송이버섯을 곁들인 1인분 퀴노아 볼. 레몬올리브 양념, 깻잎 고명.', calories = 538.0, protein_g = 32.6, carbs_g = 41.8, fat_g = 26.8, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0547';
UPDATE recipes SET name = '바질 연어 퀴노아볼', description = '퀴노아에 연어, 청경채, 양송이버섯을 곁들인 1인분 퀴노아 볼. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0548';
UPDATE recipes SET name = '김 연어 퀴노아볼', description = '퀴노아에 연어, 청경채, 양송이버섯을 곁들인 1인분 퀴노아 볼. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0549';
UPDATE recipes SET name = '허브 연어 퀴노아볼', description = '퀴노아에 연어, 청경채, 양송이버섯을 곁들인 1인분 퀴노아 볼. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0550';
UPDATE recipes SET name = '레몬 연어 퀴노아볼', description = '퀴노아에 연어, 가지, 토마토를 곁들인 1인분 퀴노아 볼. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0551';
UPDATE recipes SET name = '들깨 연어 퀴노아볼', description = '퀴노아에 연어, 가지, 토마토를 곁들인 1인분 퀴노아 볼. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0552';
UPDATE recipes SET name = '간장 연어 퀴노아볼', description = '퀴노아에 연어, 가지, 토마토를 곁들인 1인분 퀴노아 볼. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0553';
UPDATE recipes SET name = '마늘 연어 퀴노아볼', description = '퀴노아에 연어, 가지, 토마토를 곁들인 1인분 퀴노아 볼. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0554';
UPDATE recipes SET name = '생강간장 연어 퀴노아볼', description = '퀴노아에 연어, 가지, 토마토를 곁들인 1인분 퀴노아 볼. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0555';
UPDATE recipes SET name = '파간장 연어 퀴노아볼', description = '퀴노아에 연어, 가지, 토마토를 곁들인 1인분 퀴노아 볼. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0556';
UPDATE recipes SET name = '깻잎 연어 퀴노아볼', description = '퀴노아에 연어, 가지, 토마토를 곁들인 1인분 퀴노아 볼. 레몬올리브 양념, 깻잎 고명.', calories = 545.0, protein_g = 30.7, carbs_g = 45.4, fat_g = 26.8, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0557';
UPDATE recipes SET name = '바질 연어 퀴노아볼', description = '퀴노아에 연어, 가지, 토마토를 곁들인 1인분 퀴노아 볼. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0558';
UPDATE recipes SET name = '김 연어 퀴노아볼', description = '퀴노아에 연어, 가지, 토마토를 곁들인 1인분 퀴노아 볼. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0559';
UPDATE recipes SET name = '허브 연어 퀴노아볼', description = '퀴노아에 연어, 가지, 토마토를 곁들인 1인분 퀴노아 볼. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0560';
UPDATE recipes SET name = '레몬 연어 퀴노아볼', description = '퀴노아에 연어, 양배추, 파프리카를 곁들인 1인분 퀴노아 볼. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0561';
UPDATE recipes SET name = '들깨 연어 퀴노아볼', description = '퀴노아에 연어, 양배추, 파프리카를 곁들인 1인분 퀴노아 볼. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0562';
UPDATE recipes SET name = '간장 연어 퀴노아볼', description = '퀴노아에 연어, 양배추, 파프리카를 곁들인 1인분 퀴노아 볼. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0563';
UPDATE recipes SET name = '마늘 연어 퀴노아볼', description = '퀴노아에 연어, 양배추, 파프리카를 곁들인 1인분 퀴노아 볼. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0564';
UPDATE recipes SET name = '생강간장 연어 퀴노아볼', description = '퀴노아에 연어, 양배추, 파프리카를 곁들인 1인분 퀴노아 볼. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0565';
UPDATE recipes SET name = '파간장 연어 퀴노아볼', description = '퀴노아에 연어, 양배추, 파프리카를 곁들인 1인분 퀴노아 볼. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0566';
UPDATE recipes SET name = '깻잎 연어 퀴노아볼', description = '퀴노아에 연어, 양배추, 파프리카를 곁들인 1인분 퀴노아 볼. 레몬올리브 양념, 깻잎 고명.', calories = 547.0, protein_g = 30.6, carbs_g = 46.0, fat_g = 26.8, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0567';
UPDATE recipes SET name = '바질 연어 퀴노아볼', description = '퀴노아에 연어, 양배추, 파프리카를 곁들인 1인분 퀴노아 볼. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0568';
UPDATE recipes SET name = '김 연어 퀴노아볼', description = '퀴노아에 연어, 양배추, 파프리카를 곁들인 1인분 퀴노아 볼. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0569';
UPDATE recipes SET name = '허브 연어 퀴노아볼', description = '퀴노아에 연어, 양배추, 파프리카를 곁들인 1인분 퀴노아 볼. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0570';
UPDATE recipes SET name = '레몬 연어 퀴노아볼', description = '퀴노아에 연어, 브로콜리, 당근을 곁들인 1인분 퀴노아 볼. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0571';
UPDATE recipes SET name = '들깨 연어 퀴노아볼', description = '퀴노아에 연어, 브로콜리, 당근을 곁들인 1인분 퀴노아 볼. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0572';
UPDATE recipes SET name = '간장 연어 퀴노아볼', description = '퀴노아에 연어, 브로콜리, 당근을 곁들인 1인분 퀴노아 볼. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0573';
UPDATE recipes SET name = '마늘 연어 퀴노아볼', description = '퀴노아에 연어, 브로콜리, 당근을 곁들인 1인분 퀴노아 볼. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0574';
UPDATE recipes SET name = '생강간장 연어 퀴노아볼', description = '퀴노아에 연어, 브로콜리, 당근을 곁들인 1인분 퀴노아 볼. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0575';
UPDATE recipes SET name = '파간장 연어 퀴노아볼', description = '퀴노아에 연어, 브로콜리, 당근을 곁들인 1인분 퀴노아 볼. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0576';
UPDATE recipes SET name = '깻잎 연어 퀴노아볼', description = '퀴노아에 연어, 브로콜리, 당근을 곁들인 1인분 퀴노아 볼. 레몬올리브 양념, 깻잎 고명.', calories = 564.0, protein_g = 32.2, carbs_g = 48.5, fat_g = 26.8, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0577';
UPDATE recipes SET name = '바질 연어 퀴노아볼', description = '퀴노아에 연어, 브로콜리, 당근을 곁들인 1인분 퀴노아 볼. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0578';
UPDATE recipes SET name = '김 연어 퀴노아볼', description = '퀴노아에 연어, 브로콜리, 당근을 곁들인 1인분 퀴노아 볼. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0579';
UPDATE recipes SET name = '허브 연어 퀴노아볼', description = '퀴노아에 연어, 브로콜리, 당근을 곁들인 1인분 퀴노아 볼. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0580';
UPDATE recipes SET name = '레몬 연어 퀴노아볼', description = '퀴노아에 연어, 애호박, 양송이버섯을 곁들인 1인분 퀴노아 볼. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0581';
UPDATE recipes SET name = '들깨 연어 퀴노아볼', description = '퀴노아에 연어, 애호박, 양송이버섯을 곁들인 1인분 퀴노아 볼. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0582';
UPDATE recipes SET name = '간장 연어 퀴노아볼', description = '퀴노아에 연어, 애호박, 양송이버섯을 곁들인 1인분 퀴노아 볼. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0583';
UPDATE recipes SET name = '마늘 연어 퀴노아볼', description = '퀴노아에 연어, 애호박, 양송이버섯을 곁들인 1인분 퀴노아 볼. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0584';
UPDATE recipes SET name = '생강간장 연어 퀴노아볼', description = '퀴노아에 연어, 애호박, 양송이버섯을 곁들인 1인분 퀴노아 볼. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0585';
UPDATE recipes SET name = '파간장 연어 퀴노아볼', description = '퀴노아에 연어, 애호박, 양송이버섯을 곁들인 1인분 퀴노아 볼. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0586';
UPDATE recipes SET name = '깻잎 연어 퀴노아볼', description = '퀴노아에 연어, 애호박, 양송이버섯을 곁들인 1인분 퀴노아 볼. 레몬올리브 양념, 깻잎 고명.', calories = 535.0, protein_g = 31.9, carbs_g = 41.8, fat_g = 26.8, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0587';
UPDATE recipes SET name = '바질 연어 퀴노아볼', description = '퀴노아에 연어, 애호박, 양송이버섯을 곁들인 1인분 퀴노아 볼. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0588';
UPDATE recipes SET name = '김 연어 퀴노아볼', description = '퀴노아에 연어, 애호박, 양송이버섯을 곁들인 1인분 퀴노아 볼. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0589';
UPDATE recipes SET name = '허브 연어 퀴노아볼', description = '퀴노아에 연어, 애호박, 양송이버섯을 곁들인 1인분 퀴노아 볼. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0590';
UPDATE recipes SET name = '레몬 연어 퀴노아볼', description = '퀴노아에 연어, 시금치, 토마토를 곁들인 1인분 퀴노아 볼. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0591';
UPDATE recipes SET name = '들깨 연어 퀴노아볼', description = '퀴노아에 연어, 시금치, 토마토를 곁들인 1인분 퀴노아 볼. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0592';
UPDATE recipes SET name = '간장 연어 퀴노아볼', description = '퀴노아에 연어, 시금치, 토마토를 곁들인 1인분 퀴노아 볼. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0593';
UPDATE recipes SET name = '마늘 연어 퀴노아볼', description = '퀴노아에 연어, 시금치, 토마토를 곁들인 1인분 퀴노아 볼. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0594';
UPDATE recipes SET name = '생강간장 연어 퀴노아볼', description = '퀴노아에 연어, 시금치, 토마토를 곁들인 1인분 퀴노아 볼. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0595';
UPDATE recipes SET name = '파간장 연어 퀴노아볼', description = '퀴노아에 연어, 시금치, 토마토를 곁들인 1인분 퀴노아 볼. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0596';
UPDATE recipes SET name = '깻잎 연어 퀴노아볼', description = '퀴노아에 연어, 시금치, 토마토를 곁들인 1인분 퀴노아 볼. 레몬올리브 양념, 깻잎 고명.', calories = 540.0, protein_g = 31.8, carbs_g = 43.2, fat_g = 26.8, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0597';
UPDATE recipes SET name = '바질 연어 퀴노아볼', description = '퀴노아에 연어, 시금치, 토마토를 곁들인 1인분 퀴노아 볼. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0598';
UPDATE recipes SET name = '김 연어 퀴노아볼', description = '퀴노아에 연어, 시금치, 토마토를 곁들인 1인분 퀴노아 볼. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0599';
UPDATE recipes SET name = '허브 연어 퀴노아볼', description = '퀴노아에 연어, 시금치, 토마토를 곁들인 1인분 퀴노아 볼. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0600';
UPDATE recipes SET name = '들깨 소고기 비빔밥', description = '보리밥에 소고기 우둔살, 양배추, 당근을 곁들인 1인분 보리 비빔밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0602';
UPDATE recipes SET name = '간장 소고기 비빔밥', description = '보리밥에 소고기 우둔살, 양배추, 당근을 곁들인 1인분 보리 비빔밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0603';
UPDATE recipes SET name = '마늘 소고기 비빔밥', description = '보리밥에 소고기 우둔살, 양배추, 당근을 곁들인 1인분 보리 비빔밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0604';
UPDATE recipes SET name = '생강간장 소고기 비빔밥', description = '보리밥에 소고기 우둔살, 양배추, 당근을 곁들인 1인분 보리 비빔밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0605';
UPDATE recipes SET name = '파간장 소고기 비빔밥', description = '보리밥에 소고기 우둔살, 양배추, 당근을 곁들인 1인분 보리 비빔밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0606';
UPDATE recipes SET name = '깻잎 소고기 비빔밥', description = '보리밥에 소고기 우둔살, 양배추, 당근을 곁들인 1인분 보리 비빔밥. 들기름간장 양념, 깻잎 고명.', calories = 513.0, protein_g = 30.5, carbs_g = 57.9, fat_g = 17.6, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0607';
UPDATE recipes SET name = '김 소고기 비빔밥', description = '보리밥에 소고기 우둔살, 양배추, 당근을 곁들인 1인분 보리 비빔밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0609';
UPDATE recipes SET name = '들깨 소고기 비빔밥', description = '보리밥에 소고기 우둔살, 브로콜리, 양파를 곁들인 1인분 보리 비빔밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0612';
UPDATE recipes SET name = '간장 소고기 비빔밥', description = '보리밥에 소고기 우둔살, 브로콜리, 양파를 곁들인 1인분 보리 비빔밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0613';
UPDATE recipes SET name = '마늘 소고기 비빔밥', description = '보리밥에 소고기 우둔살, 브로콜리, 양파를 곁들인 1인분 보리 비빔밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0614';
UPDATE recipes SET name = '생강간장 소고기 비빔밥', description = '보리밥에 소고기 우둔살, 브로콜리, 양파를 곁들인 1인분 보리 비빔밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0615';
UPDATE recipes SET name = '파간장 소고기 비빔밥', description = '보리밥에 소고기 우둔살, 브로콜리, 양파를 곁들인 1인분 보리 비빔밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0616';
UPDATE recipes SET name = '깻잎 소고기 비빔밥', description = '보리밥에 소고기 우둔살, 브로콜리, 양파를 곁들인 1인분 보리 비빔밥. 들기름간장 양념, 깻잎 고명.', calories = 521.0, protein_g = 32.2, carbs_g = 58.1, fat_g = 17.6, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0617';
UPDATE recipes SET name = '김 소고기 비빔밥', description = '보리밥에 소고기 우둔살, 브로콜리, 양파를 곁들인 1인분 보리 비빔밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0619';
UPDATE recipes SET name = '들깨 소고기 비빔밥', description = '보리밥에 소고기 우둔살, 애호박, 파프리카를 곁들인 1인분 보리 비빔밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0622';
UPDATE recipes SET name = '간장 소고기 비빔밥', description = '보리밥에 소고기 우둔살, 애호박, 파프리카를 곁들인 1인분 보리 비빔밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0623';
UPDATE recipes SET name = '마늘 소고기 비빔밥', description = '보리밥에 소고기 우둔살, 애호박, 파프리카를 곁들인 1인분 보리 비빔밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0624';
UPDATE recipes SET name = '생강간장 소고기 비빔밥', description = '보리밥에 소고기 우둔살, 애호박, 파프리카를 곁들인 1인분 보리 비빔밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0625';
UPDATE recipes SET name = '파간장 소고기 비빔밥', description = '보리밥에 소고기 우둔살, 애호박, 파프리카를 곁들인 1인분 보리 비빔밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0626';
UPDATE recipes SET name = '깻잎 소고기 비빔밥', description = '보리밥에 소고기 우둔살, 애호박, 파프리카를 곁들인 1인분 보리 비빔밥. 들기름간장 양념, 깻잎 고명.', calories = 498.0, protein_g = 30.6, carbs_g = 54.0, fat_g = 17.6, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0627';
UPDATE recipes SET name = '김 소고기 비빔밥', description = '보리밥에 소고기 우둔살, 애호박, 파프리카를 곁들인 1인분 보리 비빔밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0629';
UPDATE recipes SET name = '들깨 소고기 비빔밥', description = '보리밥에 소고기 우둔살, 시금치, 느타리버섯을 곁들인 1인분 보리 비빔밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0632';
UPDATE recipes SET name = '간장 소고기 비빔밥', description = '보리밥에 소고기 우둔살, 시금치, 느타리버섯을 곁들인 1인분 보리 비빔밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0633';
UPDATE recipes SET name = '마늘 소고기 비빔밥', description = '보리밥에 소고기 우둔살, 시금치, 느타리버섯을 곁들인 1인분 보리 비빔밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0634';
UPDATE recipes SET name = '생강간장 소고기 비빔밥', description = '보리밥에 소고기 우둔살, 시금치, 느타리버섯을 곁들인 1인분 보리 비빔밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0635';
UPDATE recipes SET name = '파간장 소고기 비빔밥', description = '보리밥에 소고기 우둔살, 시금치, 느타리버섯을 곁들인 1인분 보리 비빔밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0636';
UPDATE recipes SET name = '깻잎 소고기 비빔밥', description = '보리밥에 소고기 우둔살, 시금치, 느타리버섯을 곁들인 1인분 보리 비빔밥. 들기름간장 양념, 깻잎 고명.', calories = 514.0, protein_g = 33.4, carbs_g = 55.2, fat_g = 17.6, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0637';
UPDATE recipes SET name = '김 소고기 비빔밥', description = '보리밥에 소고기 우둔살, 시금치, 느타리버섯을 곁들인 1인분 보리 비빔밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0639';
UPDATE recipes SET name = '들깨 소고기 비빔밥', description = '보리밥에 소고기 우둔살, 청경채, 양송이버섯을 곁들인 1인분 보리 비빔밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0642';
UPDATE recipes SET name = '간장 소고기 비빔밥', description = '보리밥에 소고기 우둔살, 청경채, 양송이버섯을 곁들인 1인분 보리 비빔밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0643';
UPDATE recipes SET name = '마늘 소고기 비빔밥', description = '보리밥에 소고기 우둔살, 청경채, 양송이버섯을 곁들인 1인분 보리 비빔밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0644';
UPDATE recipes SET name = '생강간장 소고기 비빔밥', description = '보리밥에 소고기 우둔살, 청경채, 양송이버섯을 곁들인 1인분 보리 비빔밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0645';
UPDATE recipes SET name = '파간장 소고기 비빔밥', description = '보리밥에 소고기 우둔살, 청경채, 양송이버섯을 곁들인 1인분 보리 비빔밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0646';
UPDATE recipes SET name = '깻잎 소고기 비빔밥', description = '보리밥에 소고기 우둔살, 청경채, 양송이버섯을 곁들인 1인분 보리 비빔밥. 들기름간장 양념, 깻잎 고명.', calories = 500.0, protein_g = 32.6, carbs_g = 52.3, fat_g = 17.6, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0647';
UPDATE recipes SET name = '김 소고기 비빔밥', description = '보리밥에 소고기 우둔살, 청경채, 양송이버섯을 곁들인 1인분 보리 비빔밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0649';
UPDATE recipes SET name = '들깨 소고기 비빔밥', description = '보리밥에 소고기 우둔살, 가지, 토마토를 곁들인 1인분 보리 비빔밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0652';
UPDATE recipes SET name = '간장 소고기 비빔밥', description = '보리밥에 소고기 우둔살, 가지, 토마토를 곁들인 1인분 보리 비빔밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0653';
UPDATE recipes SET name = '마늘 소고기 비빔밥', description = '보리밥에 소고기 우둔살, 가지, 토마토를 곁들인 1인분 보리 비빔밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0654';
UPDATE recipes SET name = '생강간장 소고기 비빔밥', description = '보리밥에 소고기 우둔살, 가지, 토마토를 곁들인 1인분 보리 비빔밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0655';
UPDATE recipes SET name = '파간장 소고기 비빔밥', description = '보리밥에 소고기 우둔살, 가지, 토마토를 곁들인 1인분 보리 비빔밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0656';
UPDATE recipes SET name = '깻잎 소고기 비빔밥', description = '보리밥에 소고기 우둔살, 가지, 토마토를 곁들인 1인분 보리 비빔밥. 들기름간장 양념, 깻잎 고명.', calories = 506.0, protein_g = 30.7, carbs_g = 55.9, fat_g = 17.6, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0657';
UPDATE recipes SET name = '김 소고기 비빔밥', description = '보리밥에 소고기 우둔살, 가지, 토마토를 곁들인 1인분 보리 비빔밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0659';
UPDATE recipes SET name = '들깨 소고기 비빔밥', description = '보리밥에 소고기 우둔살, 양배추, 파프리카를 곁들인 1인분 보리 비빔밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0662';
UPDATE recipes SET name = '간장 소고기 비빔밥', description = '보리밥에 소고기 우둔살, 양배추, 파프리카를 곁들인 1인분 보리 비빔밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0663';
UPDATE recipes SET name = '마늘 소고기 비빔밥', description = '보리밥에 소고기 우둔살, 양배추, 파프리카를 곁들인 1인분 보리 비빔밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0664';
UPDATE recipes SET name = '생강간장 소고기 비빔밥', description = '보리밥에 소고기 우둔살, 양배추, 파프리카를 곁들인 1인분 보리 비빔밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0665';
UPDATE recipes SET name = '파간장 소고기 비빔밥', description = '보리밥에 소고기 우둔살, 양배추, 파프리카를 곁들인 1인분 보리 비빔밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0666';
UPDATE recipes SET name = '깻잎 소고기 비빔밥', description = '보리밥에 소고기 우둔살, 양배추, 파프리카를 곁들인 1인분 보리 비빔밥. 들기름간장 양념, 깻잎 고명.', calories = 508.0, protein_g = 30.6, carbs_g = 56.5, fat_g = 17.6, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0667';
UPDATE recipes SET name = '김 소고기 비빔밥', description = '보리밥에 소고기 우둔살, 양배추, 파프리카를 곁들인 1인분 보리 비빔밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0669';
UPDATE recipes SET name = '들깨 소고기 비빔밥', description = '보리밥에 소고기 우둔살, 브로콜리, 당근을 곁들인 1인분 보리 비빔밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0672';
UPDATE recipes SET name = '간장 소고기 비빔밥', description = '보리밥에 소고기 우둔살, 브로콜리, 당근을 곁들인 1인분 보리 비빔밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0673';
UPDATE recipes SET name = '마늘 소고기 비빔밥', description = '보리밥에 소고기 우둔살, 브로콜리, 당근을 곁들인 1인분 보리 비빔밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0674';
UPDATE recipes SET name = '생강간장 소고기 비빔밥', description = '보리밥에 소고기 우둔살, 브로콜리, 당근을 곁들인 1인분 보리 비빔밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0675';
UPDATE recipes SET name = '파간장 소고기 비빔밥', description = '보리밥에 소고기 우둔살, 브로콜리, 당근을 곁들인 1인분 보리 비빔밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0676';
UPDATE recipes SET name = '깻잎 소고기 비빔밥', description = '보리밥에 소고기 우둔살, 브로콜리, 당근을 곁들인 1인분 보리 비빔밥. 들기름간장 양념, 깻잎 고명.', calories = 525.0, protein_g = 32.2, carbs_g = 59.1, fat_g = 17.6, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0677';
UPDATE recipes SET name = '김 소고기 비빔밥', description = '보리밥에 소고기 우둔살, 브로콜리, 당근을 곁들인 1인분 보리 비빔밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0679';
UPDATE recipes SET name = '들깨 소고기 비빔밥', description = '보리밥에 소고기 우둔살, 애호박, 양송이버섯을 곁들인 1인분 보리 비빔밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0682';
UPDATE recipes SET name = '간장 소고기 비빔밥', description = '보리밥에 소고기 우둔살, 애호박, 양송이버섯을 곁들인 1인분 보리 비빔밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0683';
UPDATE recipes SET name = '마늘 소고기 비빔밥', description = '보리밥에 소고기 우둔살, 애호박, 양송이버섯을 곁들인 1인분 보리 비빔밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0684';
UPDATE recipes SET name = '생강간장 소고기 비빔밥', description = '보리밥에 소고기 우둔살, 애호박, 양송이버섯을 곁들인 1인분 보리 비빔밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0685';
UPDATE recipes SET name = '파간장 소고기 비빔밥', description = '보리밥에 소고기 우둔살, 애호박, 양송이버섯을 곁들인 1인분 보리 비빔밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0686';
UPDATE recipes SET name = '깻잎 소고기 비빔밥', description = '보리밥에 소고기 우둔살, 애호박, 양송이버섯을 곁들인 1인분 보리 비빔밥. 들기름간장 양념, 깻잎 고명.', calories = 497.0, protein_g = 31.9, carbs_g = 52.3, fat_g = 17.6, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0687';
UPDATE recipes SET name = '김 소고기 비빔밥', description = '보리밥에 소고기 우둔살, 애호박, 양송이버섯을 곁들인 1인분 보리 비빔밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0689';
UPDATE recipes SET name = '들깨 소고기 비빔밥', description = '보리밥에 소고기 우둔살, 시금치, 토마토를 곁들인 1인분 보리 비빔밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0692';
UPDATE recipes SET name = '간장 소고기 비빔밥', description = '보리밥에 소고기 우둔살, 시금치, 토마토를 곁들인 1인분 보리 비빔밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0693';
UPDATE recipes SET name = '마늘 소고기 비빔밥', description = '보리밥에 소고기 우둔살, 시금치, 토마토를 곁들인 1인분 보리 비빔밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0694';
UPDATE recipes SET name = '생강간장 소고기 비빔밥', description = '보리밥에 소고기 우둔살, 시금치, 토마토를 곁들인 1인분 보리 비빔밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0695';
UPDATE recipes SET name = '파간장 소고기 비빔밥', description = '보리밥에 소고기 우둔살, 시금치, 토마토를 곁들인 1인분 보리 비빔밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0696';
UPDATE recipes SET name = '깻잎 소고기 비빔밥', description = '보리밥에 소고기 우둔살, 시금치, 토마토를 곁들인 1인분 보리 비빔밥. 들기름간장 양념, 깻잎 고명.', calories = 502.0, protein_g = 31.8, carbs_g = 53.7, fat_g = 17.6, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0697';
UPDATE recipes SET name = '김 소고기 비빔밥', description = '보리밥에 소고기 우둔살, 시금치, 토마토를 곁들인 1인분 보리 비빔밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0699';
UPDATE recipes SET name = '들깨 렌틸콩 덮밥', description = '현미밥에 렌틸콩, 양배추, 당근을 곁들인 1인분 현미 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0702';
UPDATE recipes SET name = '간장 렌틸콩 덮밥', description = '현미밥에 렌틸콩, 양배추, 당근을 곁들인 1인분 현미 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0703';
UPDATE recipes SET name = '마늘 렌틸콩 덮밥', description = '현미밥에 렌틸콩, 양배추, 당근을 곁들인 1인분 현미 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0704';
UPDATE recipes SET name = '생강간장 렌틸콩 덮밥', description = '현미밥에 렌틸콩, 양배추, 당근을 곁들인 1인분 현미 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0705';
UPDATE recipes SET name = '파간장 렌틸콩 덮밥', description = '현미밥에 렌틸콩, 양배추, 당근을 곁들인 1인분 현미 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0706';
UPDATE recipes SET name = '깻잎 렌틸콩 덮밥', description = '현미밥에 렌틸콩, 양배추, 당근을 곁들인 1인분 현미 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 480.0, protein_g = 19.9, carbs_g = 79.1, fat_g = 9.2, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0707';
UPDATE recipes SET name = '김 렌틸콩 덮밥', description = '현미밥에 렌틸콩, 양배추, 당근을 곁들인 1인분 현미 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0709';
UPDATE recipes SET name = '들깨 렌틸콩 덮밥', description = '현미밥에 렌틸콩, 브로콜리, 양파를 곁들인 1인분 현미 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0712';
UPDATE recipes SET name = '간장 렌틸콩 덮밥', description = '현미밥에 렌틸콩, 브로콜리, 양파를 곁들인 1인분 현미 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0713';
UPDATE recipes SET name = '마늘 렌틸콩 덮밥', description = '현미밥에 렌틸콩, 브로콜리, 양파를 곁들인 1인분 현미 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0714';
UPDATE recipes SET name = '생강간장 렌틸콩 덮밥', description = '현미밥에 렌틸콩, 브로콜리, 양파를 곁들인 1인분 현미 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0715';
UPDATE recipes SET name = '파간장 렌틸콩 덮밥', description = '현미밥에 렌틸콩, 브로콜리, 양파를 곁들인 1인분 현미 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0716';
UPDATE recipes SET name = '깻잎 렌틸콩 덮밥', description = '현미밥에 렌틸콩, 브로콜리, 양파를 곁들인 1인분 현미 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 487.0, protein_g = 21.6, carbs_g = 79.3, fat_g = 9.2, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0717';
UPDATE recipes SET name = '김 렌틸콩 덮밥', description = '현미밥에 렌틸콩, 브로콜리, 양파를 곁들인 1인분 현미 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0719';
UPDATE recipes SET name = '들깨 렌틸콩 덮밥', description = '현미밥에 렌틸콩, 애호박, 파프리카를 곁들인 1인분 현미 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0722';
UPDATE recipes SET name = '간장 렌틸콩 덮밥', description = '현미밥에 렌틸콩, 애호박, 파프리카를 곁들인 1인분 현미 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0723';
UPDATE recipes SET name = '마늘 렌틸콩 덮밥', description = '현미밥에 렌틸콩, 애호박, 파프리카를 곁들인 1인분 현미 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0724';
UPDATE recipes SET name = '생강간장 렌틸콩 덮밥', description = '현미밥에 렌틸콩, 애호박, 파프리카를 곁들인 1인분 현미 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0725';
UPDATE recipes SET name = '파간장 렌틸콩 덮밥', description = '현미밥에 렌틸콩, 애호박, 파프리카를 곁들인 1인분 현미 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0726';
UPDATE recipes SET name = '깻잎 렌틸콩 덮밥', description = '현미밥에 렌틸콩, 애호박, 파프리카를 곁들인 1인분 현미 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 464.0, protein_g = 20.0, carbs_g = 75.1, fat_g = 9.2, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0727';
UPDATE recipes SET name = '김 렌틸콩 덮밥', description = '현미밥에 렌틸콩, 애호박, 파프리카를 곁들인 1인분 현미 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0729';
UPDATE recipes SET name = '들깨 렌틸콩 덮밥', description = '현미밥에 렌틸콩, 시금치, 느타리버섯을 곁들인 1인분 현미 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0732';
UPDATE recipes SET name = '간장 렌틸콩 덮밥', description = '현미밥에 렌틸콩, 시금치, 느타리버섯을 곁들인 1인분 현미 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0733';
UPDATE recipes SET name = '마늘 렌틸콩 덮밥', description = '현미밥에 렌틸콩, 시금치, 느타리버섯을 곁들인 1인분 현미 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0734';
UPDATE recipes SET name = '생강간장 렌틸콩 덮밥', description = '현미밥에 렌틸콩, 시금치, 느타리버섯을 곁들인 1인분 현미 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0735';
UPDATE recipes SET name = '파간장 렌틸콩 덮밥', description = '현미밥에 렌틸콩, 시금치, 느타리버섯을 곁들인 1인분 현미 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0736';
UPDATE recipes SET name = '깻잎 렌틸콩 덮밥', description = '현미밥에 렌틸콩, 시금치, 느타리버섯을 곁들인 1인분 현미 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 481.0, protein_g = 22.8, carbs_g = 76.4, fat_g = 9.2, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0737';
UPDATE recipes SET name = '김 렌틸콩 덮밥', description = '현미밥에 렌틸콩, 시금치, 느타리버섯을 곁들인 1인분 현미 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0739';
UPDATE recipes SET name = '들깨 렌틸콩 덮밥', description = '현미밥에 렌틸콩, 청경채, 양송이버섯을 곁들인 1인분 현미 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0742';
UPDATE recipes SET name = '간장 렌틸콩 덮밥', description = '현미밥에 렌틸콩, 청경채, 양송이버섯을 곁들인 1인분 현미 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0743';
UPDATE recipes SET name = '마늘 렌틸콩 덮밥', description = '현미밥에 렌틸콩, 청경채, 양송이버섯을 곁들인 1인분 현미 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0744';
UPDATE recipes SET name = '생강간장 렌틸콩 덮밥', description = '현미밥에 렌틸콩, 청경채, 양송이버섯을 곁들인 1인분 현미 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0745';
UPDATE recipes SET name = '파간장 렌틸콩 덮밥', description = '현미밥에 렌틸콩, 청경채, 양송이버섯을 곁들인 1인분 현미 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0746';
UPDATE recipes SET name = '깻잎 렌틸콩 덮밥', description = '현미밥에 렌틸콩, 청경채, 양송이버섯을 곁들인 1인분 현미 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 466.0, protein_g = 22.1, carbs_g = 73.5, fat_g = 9.2, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0747';
UPDATE recipes SET name = '김 렌틸콩 덮밥', description = '현미밥에 렌틸콩, 청경채, 양송이버섯을 곁들인 1인분 현미 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0749';
UPDATE recipes SET name = '들깨 렌틸콩 덮밥', description = '현미밥에 렌틸콩, 가지, 토마토를 곁들인 1인분 현미 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0752';
UPDATE recipes SET name = '간장 렌틸콩 덮밥', description = '현미밥에 렌틸콩, 가지, 토마토를 곁들인 1인분 현미 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0753';
UPDATE recipes SET name = '마늘 렌틸콩 덮밥', description = '현미밥에 렌틸콩, 가지, 토마토를 곁들인 1인분 현미 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0754';
UPDATE recipes SET name = '생강간장 렌틸콩 덮밥', description = '현미밥에 렌틸콩, 가지, 토마토를 곁들인 1인분 현미 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0755';
UPDATE recipes SET name = '파간장 렌틸콩 덮밥', description = '현미밥에 렌틸콩, 가지, 토마토를 곁들인 1인분 현미 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0756';
UPDATE recipes SET name = '깻잎 렌틸콩 덮밥', description = '현미밥에 렌틸콩, 가지, 토마토를 곁들인 1인분 현미 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 473.0, protein_g = 20.2, carbs_g = 77.1, fat_g = 9.2, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0757';
UPDATE recipes SET name = '김 렌틸콩 덮밥', description = '현미밥에 렌틸콩, 가지, 토마토를 곁들인 1인분 현미 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0759';
UPDATE recipes SET name = '들깨 렌틸콩 덮밥', description = '현미밥에 렌틸콩, 양배추, 파프리카를 곁들인 1인분 현미 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0762';
UPDATE recipes SET name = '간장 렌틸콩 덮밥', description = '현미밥에 렌틸콩, 양배추, 파프리카를 곁들인 1인분 현미 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0763';
UPDATE recipes SET name = '마늘 렌틸콩 덮밥', description = '현미밥에 렌틸콩, 양배추, 파프리카를 곁들인 1인분 현미 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0764';
UPDATE recipes SET name = '생강간장 렌틸콩 덮밥', description = '현미밥에 렌틸콩, 양배추, 파프리카를 곁들인 1인분 현미 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0765';
UPDATE recipes SET name = '파간장 렌틸콩 덮밥', description = '현미밥에 렌틸콩, 양배추, 파프리카를 곁들인 1인분 현미 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0766';
UPDATE recipes SET name = '깻잎 렌틸콩 덮밥', description = '현미밥에 렌틸콩, 양배추, 파프리카를 곁들인 1인분 현미 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 475.0, protein_g = 20.0, carbs_g = 77.7, fat_g = 9.2, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0767';
UPDATE recipes SET name = '김 렌틸콩 덮밥', description = '현미밥에 렌틸콩, 양배추, 파프리카를 곁들인 1인분 현미 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0769';
UPDATE recipes SET name = '들깨 렌틸콩 덮밥', description = '현미밥에 렌틸콩, 브로콜리, 당근을 곁들인 1인분 현미 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0772';
UPDATE recipes SET name = '간장 렌틸콩 덮밥', description = '현미밥에 렌틸콩, 브로콜리, 당근을 곁들인 1인분 현미 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0773';
UPDATE recipes SET name = '마늘 렌틸콩 덮밥', description = '현미밥에 렌틸콩, 브로콜리, 당근을 곁들인 1인분 현미 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0774';
UPDATE recipes SET name = '생강간장 렌틸콩 덮밥', description = '현미밥에 렌틸콩, 브로콜리, 당근을 곁들인 1인분 현미 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0775';
UPDATE recipes SET name = '파간장 렌틸콩 덮밥', description = '현미밥에 렌틸콩, 브로콜리, 당근을 곁들인 1인분 현미 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0776';
UPDATE recipes SET name = '깻잎 렌틸콩 덮밥', description = '현미밥에 렌틸콩, 브로콜리, 당근을 곁들인 1인분 현미 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 491.0, protein_g = 21.7, carbs_g = 80.2, fat_g = 9.2, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0777';
UPDATE recipes SET name = '김 렌틸콩 덮밥', description = '현미밥에 렌틸콩, 브로콜리, 당근을 곁들인 1인분 현미 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0779';
UPDATE recipes SET name = '들깨 렌틸콩 덮밥', description = '현미밥에 렌틸콩, 애호박, 양송이버섯을 곁들인 1인분 현미 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0782';
UPDATE recipes SET name = '간장 렌틸콩 덮밥', description = '현미밥에 렌틸콩, 애호박, 양송이버섯을 곁들인 1인분 현미 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0783';
UPDATE recipes SET name = '마늘 렌틸콩 덮밥', description = '현미밥에 렌틸콩, 애호박, 양송이버섯을 곁들인 1인분 현미 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0784';
UPDATE recipes SET name = '생강간장 렌틸콩 덮밥', description = '현미밥에 렌틸콩, 애호박, 양송이버섯을 곁들인 1인분 현미 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0785';
UPDATE recipes SET name = '파간장 렌틸콩 덮밥', description = '현미밥에 렌틸콩, 애호박, 양송이버섯을 곁들인 1인분 현미 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0786';
UPDATE recipes SET name = '깻잎 렌틸콩 덮밥', description = '현미밥에 렌틸콩, 애호박, 양송이버섯을 곁들인 1인분 현미 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 463.0, protein_g = 21.3, carbs_g = 73.5, fat_g = 9.2, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0787';
UPDATE recipes SET name = '김 렌틸콩 덮밥', description = '현미밥에 렌틸콩, 애호박, 양송이버섯을 곁들인 1인분 현미 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0789';
UPDATE recipes SET name = '들깨 렌틸콩 덮밥', description = '현미밥에 렌틸콩, 시금치, 토마토를 곁들인 1인분 현미 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0792';
UPDATE recipes SET name = '간장 렌틸콩 덮밥', description = '현미밥에 렌틸콩, 시금치, 토마토를 곁들인 1인분 현미 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0793';
UPDATE recipes SET name = '마늘 렌틸콩 덮밥', description = '현미밥에 렌틸콩, 시금치, 토마토를 곁들인 1인분 현미 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0794';
UPDATE recipes SET name = '생강간장 렌틸콩 덮밥', description = '현미밥에 렌틸콩, 시금치, 토마토를 곁들인 1인분 현미 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0795';
UPDATE recipes SET name = '파간장 렌틸콩 덮밥', description = '현미밥에 렌틸콩, 시금치, 토마토를 곁들인 1인분 현미 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0796';
UPDATE recipes SET name = '깻잎 렌틸콩 덮밥', description = '현미밥에 렌틸콩, 시금치, 토마토를 곁들인 1인분 현미 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 468.0, protein_g = 21.2, carbs_g = 74.9, fat_g = 9.2, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0797';
UPDATE recipes SET name = '김 렌틸콩 덮밥', description = '현미밥에 렌틸콩, 시금치, 토마토를 곁들인 1인분 현미 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0799';
UPDATE recipes SET name = '들깨 병아리콩 덮밥', description = '잡곡밥에 병아리콩, 양배추, 당근을 곁들인 1인분 잡곡 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0802';
UPDATE recipes SET name = '간장 병아리콩 덮밥', description = '잡곡밥에 병아리콩, 양배추, 당근을 곁들인 1인분 잡곡 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0803';
UPDATE recipes SET name = '마늘 병아리콩 덮밥', description = '잡곡밥에 병아리콩, 양배추, 당근을 곁들인 1인분 잡곡 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0804';
UPDATE recipes SET name = '생강간장 병아리콩 덮밥', description = '잡곡밥에 병아리콩, 양배추, 당근을 곁들인 1인분 잡곡 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0805';
UPDATE recipes SET name = '파간장 병아리콩 덮밥', description = '잡곡밥에 병아리콩, 양배추, 당근을 곁들인 1인분 잡곡 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0806';
UPDATE recipes SET name = '깻잎 병아리콩 덮밥', description = '잡곡밥에 병아리콩, 양배추, 당근을 곁들인 1인분 잡곡 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 573.0, protein_g = 21.0, carbs_g = 92.9, fat_g = 12.9, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0807';
UPDATE recipes SET name = '김 병아리콩 덮밥', description = '잡곡밥에 병아리콩, 양배추, 당근을 곁들인 1인분 잡곡 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0809';
UPDATE recipes SET name = '들깨 병아리콩 덮밥', description = '잡곡밥에 병아리콩, 브로콜리, 양파를 곁들인 1인분 잡곡 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0812';
UPDATE recipes SET name = '간장 병아리콩 덮밥', description = '잡곡밥에 병아리콩, 브로콜리, 양파를 곁들인 1인분 잡곡 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0813';
UPDATE recipes SET name = '마늘 병아리콩 덮밥', description = '잡곡밥에 병아리콩, 브로콜리, 양파를 곁들인 1인분 잡곡 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0814';
UPDATE recipes SET name = '생강간장 병아리콩 덮밥', description = '잡곡밥에 병아리콩, 브로콜리, 양파를 곁들인 1인분 잡곡 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0815';
UPDATE recipes SET name = '파간장 병아리콩 덮밥', description = '잡곡밥에 병아리콩, 브로콜리, 양파를 곁들인 1인분 잡곡 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0816';
UPDATE recipes SET name = '깻잎 병아리콩 덮밥', description = '잡곡밥에 병아리콩, 브로콜리, 양파를 곁들인 1인분 잡곡 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 581.0, protein_g = 22.7, carbs_g = 93.1, fat_g = 12.9, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0817';
UPDATE recipes SET name = '김 병아리콩 덮밥', description = '잡곡밥에 병아리콩, 브로콜리, 양파를 곁들인 1인분 잡곡 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0819';
UPDATE recipes SET name = '들깨 병아리콩 덮밥', description = '잡곡밥에 병아리콩, 애호박, 파프리카를 곁들인 1인분 잡곡 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0822';
UPDATE recipes SET name = '간장 병아리콩 덮밥', description = '잡곡밥에 병아리콩, 애호박, 파프리카를 곁들인 1인분 잡곡 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0823';
UPDATE recipes SET name = '마늘 병아리콩 덮밥', description = '잡곡밥에 병아리콩, 애호박, 파프리카를 곁들인 1인분 잡곡 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0824';
UPDATE recipes SET name = '생강간장 병아리콩 덮밥', description = '잡곡밥에 병아리콩, 애호박, 파프리카를 곁들인 1인분 잡곡 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0825';
UPDATE recipes SET name = '파간장 병아리콩 덮밥', description = '잡곡밥에 병아리콩, 애호박, 파프리카를 곁들인 1인분 잡곡 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0826';
UPDATE recipes SET name = '깻잎 병아리콩 덮밥', description = '잡곡밥에 병아리콩, 애호박, 파프리카를 곁들인 1인분 잡곡 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 558.0, protein_g = 21.1, carbs_g = 88.9, fat_g = 12.9, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0827';
UPDATE recipes SET name = '김 병아리콩 덮밥', description = '잡곡밥에 병아리콩, 애호박, 파프리카를 곁들인 1인분 잡곡 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0829';
UPDATE recipes SET name = '들깨 병아리콩 덮밥', description = '잡곡밥에 병아리콩, 시금치, 느타리버섯을 곁들인 1인분 잡곡 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0832';
UPDATE recipes SET name = '간장 병아리콩 덮밥', description = '잡곡밥에 병아리콩, 시금치, 느타리버섯을 곁들인 1인분 잡곡 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0833';
UPDATE recipes SET name = '마늘 병아리콩 덮밥', description = '잡곡밥에 병아리콩, 시금치, 느타리버섯을 곁들인 1인분 잡곡 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0834';
UPDATE recipes SET name = '생강간장 병아리콩 덮밥', description = '잡곡밥에 병아리콩, 시금치, 느타리버섯을 곁들인 1인분 잡곡 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0835';
UPDATE recipes SET name = '파간장 병아리콩 덮밥', description = '잡곡밥에 병아리콩, 시금치, 느타리버섯을 곁들인 1인분 잡곡 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0836';
UPDATE recipes SET name = '깻잎 병아리콩 덮밥', description = '잡곡밥에 병아리콩, 시금치, 느타리버섯을 곁들인 1인분 잡곡 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 574.0, protein_g = 23.9, carbs_g = 90.2, fat_g = 12.9, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0837';
UPDATE recipes SET name = '김 병아리콩 덮밥', description = '잡곡밥에 병아리콩, 시금치, 느타리버섯을 곁들인 1인분 잡곡 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0839';
UPDATE recipes SET name = '들깨 병아리콩 덮밥', description = '잡곡밥에 병아리콩, 청경채, 양송이버섯을 곁들인 1인분 잡곡 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0842';
UPDATE recipes SET name = '간장 병아리콩 덮밥', description = '잡곡밥에 병아리콩, 청경채, 양송이버섯을 곁들인 1인분 잡곡 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0843';
UPDATE recipes SET name = '마늘 병아리콩 덮밥', description = '잡곡밥에 병아리콩, 청경채, 양송이버섯을 곁들인 1인분 잡곡 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0844';
UPDATE recipes SET name = '생강간장 병아리콩 덮밥', description = '잡곡밥에 병아리콩, 청경채, 양송이버섯을 곁들인 1인분 잡곡 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0845';
UPDATE recipes SET name = '파간장 병아리콩 덮밥', description = '잡곡밥에 병아리콩, 청경채, 양송이버섯을 곁들인 1인분 잡곡 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0846';
UPDATE recipes SET name = '깻잎 병아리콩 덮밥', description = '잡곡밥에 병아리콩, 청경채, 양송이버섯을 곁들인 1인분 잡곡 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 559.0, protein_g = 23.2, carbs_g = 87.3, fat_g = 12.9, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0847';
UPDATE recipes SET name = '김 병아리콩 덮밥', description = '잡곡밥에 병아리콩, 청경채, 양송이버섯을 곁들인 1인분 잡곡 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0849';
UPDATE recipes SET name = '들깨 병아리콩 덮밥', description = '잡곡밥에 병아리콩, 가지, 토마토를 곁들인 1인분 잡곡 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0852';
UPDATE recipes SET name = '간장 병아리콩 덮밥', description = '잡곡밥에 병아리콩, 가지, 토마토를 곁들인 1인분 잡곡 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0853';
UPDATE recipes SET name = '마늘 병아리콩 덮밥', description = '잡곡밥에 병아리콩, 가지, 토마토를 곁들인 1인분 잡곡 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0854';
UPDATE recipes SET name = '생강간장 병아리콩 덮밥', description = '잡곡밥에 병아리콩, 가지, 토마토를 곁들인 1인분 잡곡 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0855';
UPDATE recipes SET name = '파간장 병아리콩 덮밥', description = '잡곡밥에 병아리콩, 가지, 토마토를 곁들인 1인분 잡곡 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0856';
UPDATE recipes SET name = '깻잎 병아리콩 덮밥', description = '잡곡밥에 병아리콩, 가지, 토마토를 곁들인 1인분 잡곡 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 566.0, protein_g = 21.3, carbs_g = 90.9, fat_g = 12.9, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0857';
UPDATE recipes SET name = '김 병아리콩 덮밥', description = '잡곡밥에 병아리콩, 가지, 토마토를 곁들인 1인분 잡곡 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0859';
UPDATE recipes SET name = '들깨 병아리콩 덮밥', description = '잡곡밥에 병아리콩, 양배추, 파프리카를 곁들인 1인분 잡곡 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0862';
UPDATE recipes SET name = '간장 병아리콩 덮밥', description = '잡곡밥에 병아리콩, 양배추, 파프리카를 곁들인 1인분 잡곡 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0863';
UPDATE recipes SET name = '마늘 병아리콩 덮밥', description = '잡곡밥에 병아리콩, 양배추, 파프리카를 곁들인 1인분 잡곡 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0864';
UPDATE recipes SET name = '생강간장 병아리콩 덮밥', description = '잡곡밥에 병아리콩, 양배추, 파프리카를 곁들인 1인분 잡곡 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0865';
UPDATE recipes SET name = '파간장 병아리콩 덮밥', description = '잡곡밥에 병아리콩, 양배추, 파프리카를 곁들인 1인분 잡곡 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0866';
UPDATE recipes SET name = '깻잎 병아리콩 덮밥', description = '잡곡밥에 병아리콩, 양배추, 파프리카를 곁들인 1인분 잡곡 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 568.0, protein_g = 21.1, carbs_g = 91.5, fat_g = 12.9, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0867';
UPDATE recipes SET name = '김 병아리콩 덮밥', description = '잡곡밥에 병아리콩, 양배추, 파프리카를 곁들인 1인분 잡곡 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0869';
UPDATE recipes SET name = '들깨 병아리콩 덮밥', description = '잡곡밥에 병아리콩, 브로콜리, 당근을 곁들인 1인분 잡곡 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0872';
UPDATE recipes SET name = '간장 병아리콩 덮밥', description = '잡곡밥에 병아리콩, 브로콜리, 당근을 곁들인 1인분 잡곡 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0873';
UPDATE recipes SET name = '마늘 병아리콩 덮밥', description = '잡곡밥에 병아리콩, 브로콜리, 당근을 곁들인 1인분 잡곡 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0874';
UPDATE recipes SET name = '생강간장 병아리콩 덮밥', description = '잡곡밥에 병아리콩, 브로콜리, 당근을 곁들인 1인분 잡곡 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0875';
UPDATE recipes SET name = '파간장 병아리콩 덮밥', description = '잡곡밥에 병아리콩, 브로콜리, 당근을 곁들인 1인분 잡곡 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0876';
UPDATE recipes SET name = '깻잎 병아리콩 덮밥', description = '잡곡밥에 병아리콩, 브로콜리, 당근을 곁들인 1인분 잡곡 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 585.0, protein_g = 22.8, carbs_g = 94.0, fat_g = 12.9, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0877';
UPDATE recipes SET name = '김 병아리콩 덮밥', description = '잡곡밥에 병아리콩, 브로콜리, 당근을 곁들인 1인분 잡곡 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0879';
UPDATE recipes SET name = '들깨 병아리콩 덮밥', description = '잡곡밥에 병아리콩, 애호박, 양송이버섯을 곁들인 1인분 잡곡 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0882';
UPDATE recipes SET name = '간장 병아리콩 덮밥', description = '잡곡밥에 병아리콩, 애호박, 양송이버섯을 곁들인 1인분 잡곡 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0883';
UPDATE recipes SET name = '마늘 병아리콩 덮밥', description = '잡곡밥에 병아리콩, 애호박, 양송이버섯을 곁들인 1인분 잡곡 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0884';
UPDATE recipes SET name = '생강간장 병아리콩 덮밥', description = '잡곡밥에 병아리콩, 애호박, 양송이버섯을 곁들인 1인분 잡곡 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0885';
UPDATE recipes SET name = '파간장 병아리콩 덮밥', description = '잡곡밥에 병아리콩, 애호박, 양송이버섯을 곁들인 1인분 잡곡 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0886';
UPDATE recipes SET name = '깻잎 병아리콩 덮밥', description = '잡곡밥에 병아리콩, 애호박, 양송이버섯을 곁들인 1인분 잡곡 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 556.0, protein_g = 22.4, carbs_g = 87.3, fat_g = 12.9, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0887';
UPDATE recipes SET name = '김 병아리콩 덮밥', description = '잡곡밥에 병아리콩, 애호박, 양송이버섯을 곁들인 1인분 잡곡 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0889';
UPDATE recipes SET name = '들깨 병아리콩 덮밥', description = '잡곡밥에 병아리콩, 시금치, 토마토를 곁들인 1인분 잡곡 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0892';
UPDATE recipes SET name = '간장 병아리콩 덮밥', description = '잡곡밥에 병아리콩, 시금치, 토마토를 곁들인 1인분 잡곡 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0893';
UPDATE recipes SET name = '마늘 병아리콩 덮밥', description = '잡곡밥에 병아리콩, 시금치, 토마토를 곁들인 1인분 잡곡 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0894';
UPDATE recipes SET name = '생강간장 병아리콩 덮밥', description = '잡곡밥에 병아리콩, 시금치, 토마토를 곁들인 1인분 잡곡 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0895';
UPDATE recipes SET name = '파간장 병아리콩 덮밥', description = '잡곡밥에 병아리콩, 시금치, 토마토를 곁들인 1인분 잡곡 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0896';
UPDATE recipes SET name = '깻잎 병아리콩 덮밥', description = '잡곡밥에 병아리콩, 시금치, 토마토를 곁들인 1인분 잡곡 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 561.0, protein_g = 22.3, carbs_g = 88.7, fat_g = 12.9, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0897';
UPDATE recipes SET name = '김 병아리콩 덮밥', description = '잡곡밥에 병아리콩, 시금치, 토마토를 곁들인 1인분 잡곡 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0899';
UPDATE recipes SET name = '레몬 닭가슴살 오픈 샌드위치', description = '통밀 식빵에 닭가슴살, 양배추, 당근을 곁들인 1인분 오픈 샌드위치. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0901';
UPDATE recipes SET name = '후추 닭가슴살 오픈 샌드위치', description = '통밀 식빵에 닭가슴살, 양배추, 당근을 곁들인 1인분 오픈 샌드위치. 후추올리브 양념.', calories = 467.0, protein_g = 37.2, carbs_g = 47.0, fat_g = 14.7, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0902';
UPDATE recipes SET name = '마늘 닭가슴살 오픈 샌드위치', description = '통밀 식빵에 닭가슴살, 양배추, 당근을 곁들인 1인분 오픈 샌드위치. 마늘올리브 양념.', calories = 469.0, protein_g = 37.3, carbs_g = 47.3, fat_g = 14.7, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0904';
UPDATE recipes SET name = '깻잎 닭가슴살 오픈 샌드위치', description = '통밀 식빵에 닭가슴살, 양배추, 당근을 곁들인 1인분 오픈 샌드위치. 레몬올리브 양념, 깻잎 고명.', calories = 469.0, protein_g = 37.3, carbs_g = 47.2, fat_g = 14.7, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0907';
UPDATE recipes SET name = '바질 닭가슴살 오픈 샌드위치', description = '통밀 식빵에 닭가슴살, 양배추, 당근을 곁들인 1인분 오픈 샌드위치. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0908';
UPDATE recipes SET name = '허브 닭가슴살 오픈 샌드위치', description = '통밀 식빵에 닭가슴살, 양배추, 당근을 곁들인 1인분 오픈 샌드위치. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0910';
UPDATE recipes SET name = '레몬 닭가슴살 오픈 샌드위치', description = '통밀 식빵에 닭가슴살, 브로콜리, 양파를 곁들인 1인분 오픈 샌드위치. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0911';
UPDATE recipes SET name = '후추 닭가슴살 오픈 샌드위치', description = '통밀 식빵에 닭가슴살, 브로콜리, 양파를 곁들인 1인분 오픈 샌드위치. 후추올리브 양념.', calories = 475.0, protein_g = 38.9, carbs_g = 47.2, fat_g = 14.7, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0912';
UPDATE recipes SET name = '마늘 닭가슴살 오픈 샌드위치', description = '통밀 식빵에 닭가슴살, 브로콜리, 양파를 곁들인 1인분 오픈 샌드위치. 마늘올리브 양념.', calories = 477.0, protein_g = 39.0, carbs_g = 47.5, fat_g = 14.7, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0914';
UPDATE recipes SET name = '깻잎 닭가슴살 오픈 샌드위치', description = '통밀 식빵에 닭가슴살, 브로콜리, 양파를 곁들인 1인분 오픈 샌드위치. 레몬올리브 양념, 깻잎 고명.', calories = 477.0, protein_g = 39.0, carbs_g = 47.4, fat_g = 14.7, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0917';
UPDATE recipes SET name = '바질 닭가슴살 오픈 샌드위치', description = '통밀 식빵에 닭가슴살, 브로콜리, 양파를 곁들인 1인분 오픈 샌드위치. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0918';
UPDATE recipes SET name = '허브 닭가슴살 오픈 샌드위치', description = '통밀 식빵에 닭가슴살, 브로콜리, 양파를 곁들인 1인분 오픈 샌드위치. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0920';
UPDATE recipes SET name = '레몬 닭가슴살 오픈 샌드위치', description = '통밀 식빵에 닭가슴살, 애호박, 파프리카를 곁들인 1인분 오픈 샌드위치. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0921';
UPDATE recipes SET name = '후추 닭가슴살 오픈 샌드위치', description = '통밀 식빵에 닭가슴살, 애호박, 파프리카를 곁들인 1인분 오픈 샌드위치. 후추올리브 양념.', calories = 452.0, protein_g = 37.3, carbs_g = 43.1, fat_g = 14.7, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0922';
UPDATE recipes SET name = '마늘 닭가슴살 오픈 샌드위치', description = '통밀 식빵에 닭가슴살, 애호박, 파프리카를 곁들인 1인분 오픈 샌드위치. 마늘올리브 양념.', calories = 454.0, protein_g = 37.4, carbs_g = 43.4, fat_g = 14.7, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0924';
UPDATE recipes SET name = '깻잎 닭가슴살 오픈 샌드위치', description = '통밀 식빵에 닭가슴살, 애호박, 파프리카를 곁들인 1인분 오픈 샌드위치. 레몬올리브 양념, 깻잎 고명.', calories = 454.0, protein_g = 37.4, carbs_g = 43.2, fat_g = 14.7, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0927';
UPDATE recipes SET name = '바질 닭가슴살 오픈 샌드위치', description = '통밀 식빵에 닭가슴살, 애호박, 파프리카를 곁들인 1인분 오픈 샌드위치. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0928';
UPDATE recipes SET name = '허브 닭가슴살 오픈 샌드위치', description = '통밀 식빵에 닭가슴살, 애호박, 파프리카를 곁들인 1인분 오픈 샌드위치. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0930';
UPDATE recipes SET name = '레몬 닭가슴살 오픈 샌드위치', description = '통밀 식빵에 닭가슴살, 시금치, 느타리버섯을 곁들인 1인분 오픈 샌드위치. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0931';
UPDATE recipes SET name = '후추 닭가슴살 오픈 샌드위치', description = '통밀 식빵에 닭가슴살, 시금치, 느타리버섯을 곁들인 1인분 오픈 샌드위치. 후추올리브 양념.', calories = 468.0, protein_g = 40.1, carbs_g = 44.3, fat_g = 14.7, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0932';
UPDATE recipes SET name = '마늘 닭가슴살 오픈 샌드위치', description = '통밀 식빵에 닭가슴살, 시금치, 느타리버섯을 곁들인 1인분 오픈 샌드위치. 마늘올리브 양념.', calories = 470.0, protein_g = 40.2, carbs_g = 44.6, fat_g = 14.7, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0934';
UPDATE recipes SET name = '깻잎 닭가슴살 오픈 샌드위치', description = '통밀 식빵에 닭가슴살, 시금치, 느타리버섯을 곁들인 1인분 오픈 샌드위치. 레몬올리브 양념, 깻잎 고명.', calories = 470.0, protein_g = 40.2, carbs_g = 44.5, fat_g = 14.7, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0937';
UPDATE recipes SET name = '바질 닭가슴살 오픈 샌드위치', description = '통밀 식빵에 닭가슴살, 시금치, 느타리버섯을 곁들인 1인분 오픈 샌드위치. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0938';
UPDATE recipes SET name = '허브 닭가슴살 오픈 샌드위치', description = '통밀 식빵에 닭가슴살, 시금치, 느타리버섯을 곁들인 1인분 오픈 샌드위치. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0940';
UPDATE recipes SET name = '레몬 닭가슴살 오픈 샌드위치', description = '통밀 식빵에 닭가슴살, 청경채, 양송이버섯을 곁들인 1인분 오픈 샌드위치. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0941';
UPDATE recipes SET name = '후추 닭가슴살 오픈 샌드위치', description = '통밀 식빵에 닭가슴살, 청경채, 양송이버섯을 곁들인 1인분 오픈 샌드위치. 후추올리브 양념.', calories = 454.0, protein_g = 39.3, carbs_g = 41.4, fat_g = 14.7, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0942';
UPDATE recipes SET name = '마늘 닭가슴살 오픈 샌드위치', description = '통밀 식빵에 닭가슴살, 청경채, 양송이버섯을 곁들인 1인분 오픈 샌드위치. 마늘올리브 양념.', calories = 455.0, protein_g = 39.4, carbs_g = 41.7, fat_g = 14.7, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0944';
UPDATE recipes SET name = '깻잎 닭가슴살 오픈 샌드위치', description = '통밀 식빵에 닭가슴살, 청경채, 양송이버섯을 곁들인 1인분 오픈 샌드위치. 레몬올리브 양념, 깻잎 고명.', calories = 456.0, protein_g = 39.4, carbs_g = 41.6, fat_g = 14.7, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0947';
UPDATE recipes SET name = '바질 닭가슴살 오픈 샌드위치', description = '통밀 식빵에 닭가슴살, 청경채, 양송이버섯을 곁들인 1인분 오픈 샌드위치. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0948';
UPDATE recipes SET name = '허브 닭가슴살 오픈 샌드위치', description = '통밀 식빵에 닭가슴살, 청경채, 양송이버섯을 곁들인 1인분 오픈 샌드위치. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0950';
UPDATE recipes SET name = '레몬 닭가슴살 오픈 샌드위치', description = '통밀 식빵에 닭가슴살, 가지, 토마토를 곁들인 1인분 오픈 샌드위치. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0951';
UPDATE recipes SET name = '후추 닭가슴살 오픈 샌드위치', description = '통밀 식빵에 닭가슴살, 가지, 토마토를 곁들인 1인분 오픈 샌드위치. 후추올리브 양념.', calories = 460.0, protein_g = 37.5, carbs_g = 45.0, fat_g = 14.7, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0952';
UPDATE recipes SET name = '마늘 닭가슴살 오픈 샌드위치', description = '통밀 식빵에 닭가슴살, 가지, 토마토를 곁들인 1인분 오픈 샌드위치. 마늘올리브 양념.', calories = 462.0, protein_g = 37.5, carbs_g = 45.3, fat_g = 14.7, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0954';
UPDATE recipes SET name = '깻잎 닭가슴살 오픈 샌드위치', description = '통밀 식빵에 닭가슴살, 가지, 토마토를 곁들인 1인분 오픈 샌드위치. 레몬올리브 양념, 깻잎 고명.', calories = 462.0, protein_g = 37.5, carbs_g = 45.2, fat_g = 14.7, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0957';
UPDATE recipes SET name = '바질 닭가슴살 오픈 샌드위치', description = '통밀 식빵에 닭가슴살, 가지, 토마토를 곁들인 1인분 오픈 샌드위치. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0958';
UPDATE recipes SET name = '허브 닭가슴살 오픈 샌드위치', description = '통밀 식빵에 닭가슴살, 가지, 토마토를 곁들인 1인분 오픈 샌드위치. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0960';
UPDATE recipes SET name = '레몬 닭가슴살 오픈 샌드위치', description = '통밀 식빵에 닭가슴살, 양배추, 파프리카를 곁들인 1인분 오픈 샌드위치. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0961';
UPDATE recipes SET name = '후추 닭가슴살 오픈 샌드위치', description = '통밀 식빵에 닭가슴살, 양배추, 파프리카를 곁들인 1인분 오픈 샌드위치. 후추올리브 양념.', calories = 462.0, protein_g = 37.3, carbs_g = 45.6, fat_g = 14.7, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0962';
UPDATE recipes SET name = '마늘 닭가슴살 오픈 샌드위치', description = '통밀 식빵에 닭가슴살, 양배추, 파프리카를 곁들인 1인분 오픈 샌드위치. 마늘올리브 양념.', calories = 464.0, protein_g = 37.4, carbs_g = 45.9, fat_g = 14.7, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0964';
UPDATE recipes SET name = '깻잎 닭가슴살 오픈 샌드위치', description = '통밀 식빵에 닭가슴살, 양배추, 파프리카를 곁들인 1인분 오픈 샌드위치. 레몬올리브 양념, 깻잎 고명.', calories = 464.0, protein_g = 37.4, carbs_g = 45.8, fat_g = 14.7, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0967';
UPDATE recipes SET name = '바질 닭가슴살 오픈 샌드위치', description = '통밀 식빵에 닭가슴살, 양배추, 파프리카를 곁들인 1인분 오픈 샌드위치. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0968';
UPDATE recipes SET name = '허브 닭가슴살 오픈 샌드위치', description = '통밀 식빵에 닭가슴살, 양배추, 파프리카를 곁들인 1인분 오픈 샌드위치. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0970';
UPDATE recipes SET name = '레몬 닭가슴살 오픈 샌드위치', description = '통밀 식빵에 닭가슴살, 브로콜리, 당근을 곁들인 1인분 오픈 샌드위치. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0971';
UPDATE recipes SET name = '후추 닭가슴살 오픈 샌드위치', description = '통밀 식빵에 닭가슴살, 브로콜리, 당근을 곁들인 1인분 오픈 샌드위치. 후추올리브 양념.', calories = 479.0, protein_g = 39.0, carbs_g = 48.2, fat_g = 14.7, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0972';
UPDATE recipes SET name = '마늘 닭가슴살 오픈 샌드위치', description = '통밀 식빵에 닭가슴살, 브로콜리, 당근을 곁들인 1인분 오픈 샌드위치. 마늘올리브 양념.', calories = 481.0, protein_g = 39.0, carbs_g = 48.5, fat_g = 14.7, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0974';
UPDATE recipes SET name = '깻잎 닭가슴살 오픈 샌드위치', description = '통밀 식빵에 닭가슴살, 브로콜리, 당근을 곁들인 1인분 오픈 샌드위치. 레몬올리브 양념, 깻잎 고명.', calories = 481.0, protein_g = 39.0, carbs_g = 48.3, fat_g = 14.7, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0977';
UPDATE recipes SET name = '바질 닭가슴살 오픈 샌드위치', description = '통밀 식빵에 닭가슴살, 브로콜리, 당근을 곁들인 1인분 오픈 샌드위치. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0978';
UPDATE recipes SET name = '허브 닭가슴살 오픈 샌드위치', description = '통밀 식빵에 닭가슴살, 브로콜리, 당근을 곁들인 1인분 오픈 샌드위치. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0980';
UPDATE recipes SET name = '레몬 닭가슴살 오픈 샌드위치', description = '통밀 식빵에 닭가슴살, 애호박, 양송이버섯을 곁들인 1인분 오픈 샌드위치. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0981';
UPDATE recipes SET name = '후추 닭가슴살 오픈 샌드위치', description = '통밀 식빵에 닭가슴살, 애호박, 양송이버섯을 곁들인 1인분 오픈 샌드위치. 후추올리브 양념.', calories = 451.0, protein_g = 38.6, carbs_g = 41.4, fat_g = 14.7, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0982';
UPDATE recipes SET name = '마늘 닭가슴살 오픈 샌드위치', description = '통밀 식빵에 닭가슴살, 애호박, 양송이버섯을 곁들인 1인분 오픈 샌드위치. 마늘올리브 양념.', calories = 452.0, protein_g = 38.7, carbs_g = 41.7, fat_g = 14.7, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0984';
UPDATE recipes SET name = '깻잎 닭가슴살 오픈 샌드위치', description = '통밀 식빵에 닭가슴살, 애호박, 양송이버섯을 곁들인 1인분 오픈 샌드위치. 레몬올리브 양념, 깻잎 고명.', calories = 453.0, protein_g = 38.7, carbs_g = 41.6, fat_g = 14.7, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0987';
UPDATE recipes SET name = '바질 닭가슴살 오픈 샌드위치', description = '통밀 식빵에 닭가슴살, 애호박, 양송이버섯을 곁들인 1인분 오픈 샌드위치. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0988';
UPDATE recipes SET name = '허브 닭가슴살 오픈 샌드위치', description = '통밀 식빵에 닭가슴살, 애호박, 양송이버섯을 곁들인 1인분 오픈 샌드위치. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0990';
UPDATE recipes SET name = '레몬 닭가슴살 오픈 샌드위치', description = '통밀 식빵에 닭가슴살, 시금치, 토마토를 곁들인 1인분 오픈 샌드위치. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0991';
UPDATE recipes SET name = '후추 닭가슴살 오픈 샌드위치', description = '통밀 식빵에 닭가슴살, 시금치, 토마토를 곁들인 1인분 오픈 샌드위치. 후추올리브 양념.', calories = 456.0, protein_g = 38.5, carbs_g = 42.8, fat_g = 14.7, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0992';
UPDATE recipes SET name = '마늘 닭가슴살 오픈 샌드위치', description = '통밀 식빵에 닭가슴살, 시금치, 토마토를 곁들인 1인분 오픈 샌드위치. 마늘올리브 양념.', calories = 457.0, protein_g = 38.6, carbs_g = 43.1, fat_g = 14.7, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0994';
UPDATE recipes SET name = '깻잎 닭가슴살 오픈 샌드위치', description = '통밀 식빵에 닭가슴살, 시금치, 토마토를 곁들인 1인분 오픈 샌드위치. 레몬올리브 양념, 깻잎 고명.', calories = 458.0, protein_g = 38.6, carbs_g = 43.0, fat_g = 14.7, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0997';
UPDATE recipes SET name = '바질 닭가슴살 오픈 샌드위치', description = '통밀 식빵에 닭가슴살, 시금치, 토마토를 곁들인 1인분 오픈 샌드위치. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L0998';
UPDATE recipes SET name = '허브 닭가슴살 오픈 샌드위치', description = '통밀 식빵에 닭가슴살, 시금치, 토마토를 곁들인 1인분 오픈 샌드위치. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'L1000';
UPDATE recipes SET name = '레몬 연어 구이', description = '고구마에 연어, 양배추, 당근을 곁들인 1인분 구이 한 접시. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0001';
UPDATE recipes SET name = '들깨 연어 구이', description = '고구마에 연어, 양배추, 당근을 곁들인 1인분 구이 한 접시. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0002';
UPDATE recipes SET name = '간장 연어 구이', description = '고구마에 연어, 양배추, 당근을 곁들인 1인분 구이 한 접시. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0003';
UPDATE recipes SET name = '마늘 연어 구이', description = '고구마에 연어, 양배추, 당근을 곁들인 1인분 구이 한 접시. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0004';
UPDATE recipes SET name = '생강간장 연어 구이', description = '고구마에 연어, 양배추, 당근을 곁들인 1인분 구이 한 접시. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0005';
UPDATE recipes SET name = '파간장 연어 구이', description = '고구마에 연어, 양배추, 당근을 곁들인 1인분 구이 한 접시. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0006';
UPDATE recipes SET name = '깻잎 연어 구이', description = '고구마에 연어, 양배추, 당근을 곁들인 1인분 구이 한 접시. 레몬올리브 양념, 깻잎 고명.', calories = 536.0, protein_g = 30.0, carbs_g = 47.4, fat_g = 25.3, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0007';
UPDATE recipes SET name = '바질 연어 구이', description = '고구마에 연어, 양배추, 당근을 곁들인 1인분 구이 한 접시. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0008';
UPDATE recipes SET name = '김 연어 구이', description = '고구마에 연어, 양배추, 당근을 곁들인 1인분 구이 한 접시. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0009';
UPDATE recipes SET name = '허브 연어 구이', description = '고구마에 연어, 양배추, 당근을 곁들인 1인분 구이 한 접시. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0010';
UPDATE recipes SET name = '레몬 연어 구이', description = '고구마에 연어, 브로콜리, 양파를 곁들인 1인분 구이 한 접시. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0011';
UPDATE recipes SET name = '들깨 연어 구이', description = '고구마에 연어, 브로콜리, 양파를 곁들인 1인분 구이 한 접시. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0012';
UPDATE recipes SET name = '간장 연어 구이', description = '고구마에 연어, 브로콜리, 양파를 곁들인 1인분 구이 한 접시. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0013';
UPDATE recipes SET name = '마늘 연어 구이', description = '고구마에 연어, 브로콜리, 양파를 곁들인 1인분 구이 한 접시. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0014';
UPDATE recipes SET name = '생강간장 연어 구이', description = '고구마에 연어, 브로콜리, 양파를 곁들인 1인분 구이 한 접시. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0015';
UPDATE recipes SET name = '파간장 연어 구이', description = '고구마에 연어, 브로콜리, 양파를 곁들인 1인분 구이 한 접시. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0016';
UPDATE recipes SET name = '깻잎 연어 구이', description = '고구마에 연어, 브로콜리, 양파를 곁들인 1인분 구이 한 접시. 레몬올리브 양념, 깻잎 고명.', calories = 544.0, protein_g = 31.7, carbs_g = 47.6, fat_g = 25.3, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0017';
UPDATE recipes SET name = '바질 연어 구이', description = '고구마에 연어, 브로콜리, 양파를 곁들인 1인분 구이 한 접시. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0018';
UPDATE recipes SET name = '김 연어 구이', description = '고구마에 연어, 브로콜리, 양파를 곁들인 1인분 구이 한 접시. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0019';
UPDATE recipes SET name = '허브 연어 구이', description = '고구마에 연어, 브로콜리, 양파를 곁들인 1인분 구이 한 접시. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0020';
UPDATE recipes SET name = '레몬 연어 구이', description = '고구마에 연어, 애호박, 파프리카를 곁들인 1인분 구이 한 접시. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0021';
UPDATE recipes SET name = '들깨 연어 구이', description = '고구마에 연어, 애호박, 파프리카를 곁들인 1인분 구이 한 접시. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0022';
UPDATE recipes SET name = '간장 연어 구이', description = '고구마에 연어, 애호박, 파프리카를 곁들인 1인분 구이 한 접시. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0023';
UPDATE recipes SET name = '마늘 연어 구이', description = '고구마에 연어, 애호박, 파프리카를 곁들인 1인분 구이 한 접시. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0024';
UPDATE recipes SET name = '생강간장 연어 구이', description = '고구마에 연어, 애호박, 파프리카를 곁들인 1인분 구이 한 접시. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0025';
UPDATE recipes SET name = '파간장 연어 구이', description = '고구마에 연어, 애호박, 파프리카를 곁들인 1인분 구이 한 접시. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0026';
UPDATE recipes SET name = '깻잎 연어 구이', description = '고구마에 연어, 애호박, 파프리카를 곁들인 1인분 구이 한 접시. 레몬올리브 양념, 깻잎 고명.', calories = 521.0, protein_g = 30.1, carbs_g = 43.4, fat_g = 25.3, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0027';
UPDATE recipes SET name = '바질 연어 구이', description = '고구마에 연어, 애호박, 파프리카를 곁들인 1인분 구이 한 접시. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0028';
UPDATE recipes SET name = '김 연어 구이', description = '고구마에 연어, 애호박, 파프리카를 곁들인 1인분 구이 한 접시. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0029';
UPDATE recipes SET name = '허브 연어 구이', description = '고구마에 연어, 애호박, 파프리카를 곁들인 1인분 구이 한 접시. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0030';
UPDATE recipes SET name = '레몬 연어 구이', description = '고구마에 연어, 시금치, 느타리버섯을 곁들인 1인분 구이 한 접시. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0031';
UPDATE recipes SET name = '들깨 연어 구이', description = '고구마에 연어, 시금치, 느타리버섯을 곁들인 1인분 구이 한 접시. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0032';
UPDATE recipes SET name = '간장 연어 구이', description = '고구마에 연어, 시금치, 느타리버섯을 곁들인 1인분 구이 한 접시. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0033';
UPDATE recipes SET name = '마늘 연어 구이', description = '고구마에 연어, 시금치, 느타리버섯을 곁들인 1인분 구이 한 접시. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0034';
UPDATE recipes SET name = '생강간장 연어 구이', description = '고구마에 연어, 시금치, 느타리버섯을 곁들인 1인분 구이 한 접시. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0035';
UPDATE recipes SET name = '파간장 연어 구이', description = '고구마에 연어, 시금치, 느타리버섯을 곁들인 1인분 구이 한 접시. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0036';
UPDATE recipes SET name = '깻잎 연어 구이', description = '고구마에 연어, 시금치, 느타리버섯을 곁들인 1인분 구이 한 접시. 레몬올리브 양념, 깻잎 고명.', calories = 537.0, protein_g = 32.9, carbs_g = 44.7, fat_g = 25.3, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0037';
UPDATE recipes SET name = '바질 연어 구이', description = '고구마에 연어, 시금치, 느타리버섯을 곁들인 1인분 구이 한 접시. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0038';
UPDATE recipes SET name = '김 연어 구이', description = '고구마에 연어, 시금치, 느타리버섯을 곁들인 1인분 구이 한 접시. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0039';
UPDATE recipes SET name = '허브 연어 구이', description = '고구마에 연어, 시금치, 느타리버섯을 곁들인 1인분 구이 한 접시. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0040';
UPDATE recipes SET name = '레몬 연어 구이', description = '고구마에 연어, 청경채, 양송이버섯을 곁들인 1인분 구이 한 접시. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0041';
UPDATE recipes SET name = '들깨 연어 구이', description = '고구마에 연어, 청경채, 양송이버섯을 곁들인 1인분 구이 한 접시. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0042';
UPDATE recipes SET name = '간장 연어 구이', description = '고구마에 연어, 청경채, 양송이버섯을 곁들인 1인분 구이 한 접시. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0043';
UPDATE recipes SET name = '마늘 연어 구이', description = '고구마에 연어, 청경채, 양송이버섯을 곁들인 1인분 구이 한 접시. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0044';
UPDATE recipes SET name = '생강간장 연어 구이', description = '고구마에 연어, 청경채, 양송이버섯을 곁들인 1인분 구이 한 접시. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0045';
UPDATE recipes SET name = '파간장 연어 구이', description = '고구마에 연어, 청경채, 양송이버섯을 곁들인 1인분 구이 한 접시. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0046';
UPDATE recipes SET name = '깻잎 연어 구이', description = '고구마에 연어, 청경채, 양송이버섯을 곁들인 1인분 구이 한 접시. 레몬올리브 양념, 깻잎 고명.', calories = 522.0, protein_g = 32.1, carbs_g = 41.8, fat_g = 25.3, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0047';
UPDATE recipes SET name = '바질 연어 구이', description = '고구마에 연어, 청경채, 양송이버섯을 곁들인 1인분 구이 한 접시. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0048';
UPDATE recipes SET name = '김 연어 구이', description = '고구마에 연어, 청경채, 양송이버섯을 곁들인 1인분 구이 한 접시. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0049';
UPDATE recipes SET name = '허브 연어 구이', description = '고구마에 연어, 청경채, 양송이버섯을 곁들인 1인분 구이 한 접시. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0050';
UPDATE recipes SET name = '레몬 연어 구이', description = '고구마에 연어, 가지, 토마토를 곁들인 1인분 구이 한 접시. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0051';
UPDATE recipes SET name = '들깨 연어 구이', description = '고구마에 연어, 가지, 토마토를 곁들인 1인분 구이 한 접시. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0052';
UPDATE recipes SET name = '간장 연어 구이', description = '고구마에 연어, 가지, 토마토를 곁들인 1인분 구이 한 접시. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0053';
UPDATE recipes SET name = '마늘 연어 구이', description = '고구마에 연어, 가지, 토마토를 곁들인 1인분 구이 한 접시. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0054';
UPDATE recipes SET name = '생강간장 연어 구이', description = '고구마에 연어, 가지, 토마토를 곁들인 1인분 구이 한 접시. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0055';
UPDATE recipes SET name = '파간장 연어 구이', description = '고구마에 연어, 가지, 토마토를 곁들인 1인분 구이 한 접시. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0056';
UPDATE recipes SET name = '깻잎 연어 구이', description = '고구마에 연어, 가지, 토마토를 곁들인 1인분 구이 한 접시. 레몬올리브 양념, 깻잎 고명.', calories = 529.0, protein_g = 30.2, carbs_g = 45.4, fat_g = 25.3, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0057';
UPDATE recipes SET name = '바질 연어 구이', description = '고구마에 연어, 가지, 토마토를 곁들인 1인분 구이 한 접시. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0058';
UPDATE recipes SET name = '김 연어 구이', description = '고구마에 연어, 가지, 토마토를 곁들인 1인분 구이 한 접시. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0059';
UPDATE recipes SET name = '허브 연어 구이', description = '고구마에 연어, 가지, 토마토를 곁들인 1인분 구이 한 접시. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0060';
UPDATE recipes SET name = '레몬 연어 구이', description = '고구마에 연어, 양배추, 파프리카를 곁들인 1인분 구이 한 접시. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0061';
UPDATE recipes SET name = '들깨 연어 구이', description = '고구마에 연어, 양배추, 파프리카를 곁들인 1인분 구이 한 접시. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0062';
UPDATE recipes SET name = '간장 연어 구이', description = '고구마에 연어, 양배추, 파프리카를 곁들인 1인분 구이 한 접시. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0063';
UPDATE recipes SET name = '마늘 연어 구이', description = '고구마에 연어, 양배추, 파프리카를 곁들인 1인분 구이 한 접시. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0064';
UPDATE recipes SET name = '생강간장 연어 구이', description = '고구마에 연어, 양배추, 파프리카를 곁들인 1인분 구이 한 접시. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0065';
UPDATE recipes SET name = '파간장 연어 구이', description = '고구마에 연어, 양배추, 파프리카를 곁들인 1인분 구이 한 접시. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0066';
UPDATE recipes SET name = '깻잎 연어 구이', description = '고구마에 연어, 양배추, 파프리카를 곁들인 1인분 구이 한 접시. 레몬올리브 양념, 깻잎 고명.', calories = 531.0, protein_g = 30.1, carbs_g = 46.0, fat_g = 25.3, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0067';
UPDATE recipes SET name = '바질 연어 구이', description = '고구마에 연어, 양배추, 파프리카를 곁들인 1인분 구이 한 접시. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0068';
UPDATE recipes SET name = '김 연어 구이', description = '고구마에 연어, 양배추, 파프리카를 곁들인 1인분 구이 한 접시. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0069';
UPDATE recipes SET name = '허브 연어 구이', description = '고구마에 연어, 양배추, 파프리카를 곁들인 1인분 구이 한 접시. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0070';
UPDATE recipes SET name = '레몬 연어 구이', description = '고구마에 연어, 브로콜리, 당근을 곁들인 1인분 구이 한 접시. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0071';
UPDATE recipes SET name = '들깨 연어 구이', description = '고구마에 연어, 브로콜리, 당근을 곁들인 1인분 구이 한 접시. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0072';
UPDATE recipes SET name = '간장 연어 구이', description = '고구마에 연어, 브로콜리, 당근을 곁들인 1인분 구이 한 접시. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0073';
UPDATE recipes SET name = '마늘 연어 구이', description = '고구마에 연어, 브로콜리, 당근을 곁들인 1인분 구이 한 접시. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0074';
UPDATE recipes SET name = '생강간장 연어 구이', description = '고구마에 연어, 브로콜리, 당근을 곁들인 1인분 구이 한 접시. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0075';
UPDATE recipes SET name = '파간장 연어 구이', description = '고구마에 연어, 브로콜리, 당근을 곁들인 1인분 구이 한 접시. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0076';
UPDATE recipes SET name = '깻잎 연어 구이', description = '고구마에 연어, 브로콜리, 당근을 곁들인 1인분 구이 한 접시. 레몬올리브 양념, 깻잎 고명.', calories = 548.0, protein_g = 31.7, carbs_g = 48.5, fat_g = 25.3, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0077';
UPDATE recipes SET name = '바질 연어 구이', description = '고구마에 연어, 브로콜리, 당근을 곁들인 1인분 구이 한 접시. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0078';
UPDATE recipes SET name = '김 연어 구이', description = '고구마에 연어, 브로콜리, 당근을 곁들인 1인분 구이 한 접시. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0079';
UPDATE recipes SET name = '허브 연어 구이', description = '고구마에 연어, 브로콜리, 당근을 곁들인 1인분 구이 한 접시. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0080';
UPDATE recipes SET name = '레몬 연어 구이', description = '고구마에 연어, 애호박, 양송이버섯을 곁들인 1인분 구이 한 접시. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0081';
UPDATE recipes SET name = '들깨 연어 구이', description = '고구마에 연어, 애호박, 양송이버섯을 곁들인 1인분 구이 한 접시. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0082';
UPDATE recipes SET name = '간장 연어 구이', description = '고구마에 연어, 애호박, 양송이버섯을 곁들인 1인분 구이 한 접시. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0083';
UPDATE recipes SET name = '마늘 연어 구이', description = '고구마에 연어, 애호박, 양송이버섯을 곁들인 1인분 구이 한 접시. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0084';
UPDATE recipes SET name = '생강간장 연어 구이', description = '고구마에 연어, 애호박, 양송이버섯을 곁들인 1인분 구이 한 접시. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0085';
UPDATE recipes SET name = '파간장 연어 구이', description = '고구마에 연어, 애호박, 양송이버섯을 곁들인 1인분 구이 한 접시. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0086';
UPDATE recipes SET name = '깻잎 연어 구이', description = '고구마에 연어, 애호박, 양송이버섯을 곁들인 1인분 구이 한 접시. 레몬올리브 양념, 깻잎 고명.', calories = 519.0, protein_g = 31.4, carbs_g = 41.8, fat_g = 25.3, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0087';
UPDATE recipes SET name = '바질 연어 구이', description = '고구마에 연어, 애호박, 양송이버섯을 곁들인 1인분 구이 한 접시. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0088';
UPDATE recipes SET name = '김 연어 구이', description = '고구마에 연어, 애호박, 양송이버섯을 곁들인 1인분 구이 한 접시. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0089';
UPDATE recipes SET name = '허브 연어 구이', description = '고구마에 연어, 애호박, 양송이버섯을 곁들인 1인분 구이 한 접시. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0090';
UPDATE recipes SET name = '레몬 연어 구이', description = '고구마에 연어, 시금치, 토마토를 곁들인 1인분 구이 한 접시. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0091';
UPDATE recipes SET name = '들깨 연어 구이', description = '고구마에 연어, 시금치, 토마토를 곁들인 1인분 구이 한 접시. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0092';
UPDATE recipes SET name = '간장 연어 구이', description = '고구마에 연어, 시금치, 토마토를 곁들인 1인분 구이 한 접시. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0093';
UPDATE recipes SET name = '마늘 연어 구이', description = '고구마에 연어, 시금치, 토마토를 곁들인 1인분 구이 한 접시. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0094';
UPDATE recipes SET name = '생강간장 연어 구이', description = '고구마에 연어, 시금치, 토마토를 곁들인 1인분 구이 한 접시. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0095';
UPDATE recipes SET name = '파간장 연어 구이', description = '고구마에 연어, 시금치, 토마토를 곁들인 1인분 구이 한 접시. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0096';
UPDATE recipes SET name = '깻잎 연어 구이', description = '고구마에 연어, 시금치, 토마토를 곁들인 1인분 구이 한 접시. 레몬올리브 양념, 깻잎 고명.', calories = 524.0, protein_g = 31.3, carbs_g = 43.2, fat_g = 25.3, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0097';
UPDATE recipes SET name = '바질 연어 구이', description = '고구마에 연어, 시금치, 토마토를 곁들인 1인분 구이 한 접시. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0098';
UPDATE recipes SET name = '김 연어 구이', description = '고구마에 연어, 시금치, 토마토를 곁들인 1인분 구이 한 접시. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0099';
UPDATE recipes SET name = '허브 연어 구이', description = '고구마에 연어, 시금치, 토마토를 곁들인 1인분 구이 한 접시. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0100';
UPDATE recipes SET name = '들깨 고등어 구이 정식', description = '잡곡밥에 고등어, 양배추, 당근을 곁들인 1인분 구이 정식. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0102';
UPDATE recipes SET name = '간장 고등어 구이 정식', description = '잡곡밥에 고등어, 양배추, 당근을 곁들인 1인분 구이 정식. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0103';
UPDATE recipes SET name = '마늘 고등어 구이 정식', description = '잡곡밥에 고등어, 양배추, 당근을 곁들인 1인분 구이 정식. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0104';
UPDATE recipes SET name = '생강간장 고등어 구이 정식', description = '잡곡밥에 고등어, 양배추, 당근을 곁들인 1인분 구이 정식. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0105';
UPDATE recipes SET name = '파간장 고등어 구이 정식', description = '잡곡밥에 고등어, 양배추, 당근을 곁들인 1인분 구이 정식. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0106';
UPDATE recipes SET name = '깻잎 고등어 구이 정식', description = '잡곡밥에 고등어, 양배추, 당근을 곁들인 1인분 구이 정식. 들기름간장 양념, 깻잎 고명.', calories = 575.0, protein_g = 29.8, carbs_g = 53.7, fat_g = 26.7, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0107';
UPDATE recipes SET name = '김 고등어 구이 정식', description = '잡곡밥에 고등어, 양배추, 당근을 곁들인 1인분 구이 정식. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0109';
UPDATE recipes SET name = '들깨 고등어 구이 정식', description = '잡곡밥에 고등어, 브로콜리, 양파를 곁들인 1인분 구이 정식. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0112';
UPDATE recipes SET name = '간장 고등어 구이 정식', description = '잡곡밥에 고등어, 브로콜리, 양파를 곁들인 1인분 구이 정식. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0113';
UPDATE recipes SET name = '마늘 고등어 구이 정식', description = '잡곡밥에 고등어, 브로콜리, 양파를 곁들인 1인분 구이 정식. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0114';
UPDATE recipes SET name = '생강간장 고등어 구이 정식', description = '잡곡밥에 고등어, 브로콜리, 양파를 곁들인 1인분 구이 정식. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0115';
UPDATE recipes SET name = '파간장 고등어 구이 정식', description = '잡곡밥에 고등어, 브로콜리, 양파를 곁들인 1인분 구이 정식. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0116';
UPDATE recipes SET name = '깻잎 고등어 구이 정식', description = '잡곡밥에 고등어, 브로콜리, 양파를 곁들인 1인분 구이 정식. 들기름간장 양념, 깻잎 고명.', calories = 583.0, protein_g = 31.5, carbs_g = 53.9, fat_g = 26.7, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0117';
UPDATE recipes SET name = '김 고등어 구이 정식', description = '잡곡밥에 고등어, 브로콜리, 양파를 곁들인 1인분 구이 정식. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0119';
UPDATE recipes SET name = '들깨 고등어 구이 정식', description = '잡곡밥에 고등어, 애호박, 파프리카를 곁들인 1인분 구이 정식. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0122';
UPDATE recipes SET name = '간장 고등어 구이 정식', description = '잡곡밥에 고등어, 애호박, 파프리카를 곁들인 1인분 구이 정식. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0123';
UPDATE recipes SET name = '마늘 고등어 구이 정식', description = '잡곡밥에 고등어, 애호박, 파프리카를 곁들인 1인분 구이 정식. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0124';
UPDATE recipes SET name = '생강간장 고등어 구이 정식', description = '잡곡밥에 고등어, 애호박, 파프리카를 곁들인 1인분 구이 정식. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0125';
UPDATE recipes SET name = '파간장 고등어 구이 정식', description = '잡곡밥에 고등어, 애호박, 파프리카를 곁들인 1인분 구이 정식. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0126';
UPDATE recipes SET name = '깻잎 고등어 구이 정식', description = '잡곡밥에 고등어, 애호박, 파프리카를 곁들인 1인분 구이 정식. 들기름간장 양념, 깻잎 고명.', calories = 560.0, protein_g = 29.9, carbs_g = 49.8, fat_g = 26.7, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0127';
UPDATE recipes SET name = '김 고등어 구이 정식', description = '잡곡밥에 고등어, 애호박, 파프리카를 곁들인 1인분 구이 정식. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0129';
UPDATE recipes SET name = '들깨 고등어 구이 정식', description = '잡곡밥에 고등어, 시금치, 느타리버섯을 곁들인 1인분 구이 정식. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0132';
UPDATE recipes SET name = '간장 고등어 구이 정식', description = '잡곡밥에 고등어, 시금치, 느타리버섯을 곁들인 1인분 구이 정식. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0133';
UPDATE recipes SET name = '마늘 고등어 구이 정식', description = '잡곡밥에 고등어, 시금치, 느타리버섯을 곁들인 1인분 구이 정식. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0134';
UPDATE recipes SET name = '생강간장 고등어 구이 정식', description = '잡곡밥에 고등어, 시금치, 느타리버섯을 곁들인 1인분 구이 정식. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0135';
UPDATE recipes SET name = '파간장 고등어 구이 정식', description = '잡곡밥에 고등어, 시금치, 느타리버섯을 곁들인 1인분 구이 정식. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0136';
UPDATE recipes SET name = '깻잎 고등어 구이 정식', description = '잡곡밥에 고등어, 시금치, 느타리버섯을 곁들인 1인분 구이 정식. 들기름간장 양념, 깻잎 고명.', calories = 576.0, protein_g = 32.7, carbs_g = 51.0, fat_g = 26.7, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0137';
UPDATE recipes SET name = '김 고등어 구이 정식', description = '잡곡밥에 고등어, 시금치, 느타리버섯을 곁들인 1인분 구이 정식. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0139';
UPDATE recipes SET name = '들깨 고등어 구이 정식', description = '잡곡밥에 고등어, 청경채, 양송이버섯을 곁들인 1인분 구이 정식. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0142';
UPDATE recipes SET name = '간장 고등어 구이 정식', description = '잡곡밥에 고등어, 청경채, 양송이버섯을 곁들인 1인분 구이 정식. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0143';
UPDATE recipes SET name = '마늘 고등어 구이 정식', description = '잡곡밥에 고등어, 청경채, 양송이버섯을 곁들인 1인분 구이 정식. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0144';
UPDATE recipes SET name = '생강간장 고등어 구이 정식', description = '잡곡밥에 고등어, 청경채, 양송이버섯을 곁들인 1인분 구이 정식. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0145';
UPDATE recipes SET name = '파간장 고등어 구이 정식', description = '잡곡밥에 고등어, 청경채, 양송이버섯을 곁들인 1인분 구이 정식. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0146';
UPDATE recipes SET name = '깻잎 고등어 구이 정식', description = '잡곡밥에 고등어, 청경채, 양송이버섯을 곁들인 1인분 구이 정식. 들기름간장 양념, 깻잎 고명.', calories = 562.0, protein_g = 32.0, carbs_g = 48.1, fat_g = 26.7, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0147';
UPDATE recipes SET name = '김 고등어 구이 정식', description = '잡곡밥에 고등어, 청경채, 양송이버섯을 곁들인 1인분 구이 정식. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0149';
UPDATE recipes SET name = '들깨 고등어 구이 정식', description = '잡곡밥에 고등어, 가지, 토마토를 곁들인 1인분 구이 정식. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0152';
UPDATE recipes SET name = '간장 고등어 구이 정식', description = '잡곡밥에 고등어, 가지, 토마토를 곁들인 1인분 구이 정식. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0153';
UPDATE recipes SET name = '마늘 고등어 구이 정식', description = '잡곡밥에 고등어, 가지, 토마토를 곁들인 1인분 구이 정식. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0154';
UPDATE recipes SET name = '생강간장 고등어 구이 정식', description = '잡곡밥에 고등어, 가지, 토마토를 곁들인 1인분 구이 정식. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0155';
UPDATE recipes SET name = '파간장 고등어 구이 정식', description = '잡곡밥에 고등어, 가지, 토마토를 곁들인 1인분 구이 정식. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0156';
UPDATE recipes SET name = '깻잎 고등어 구이 정식', description = '잡곡밥에 고등어, 가지, 토마토를 곁들인 1인분 구이 정식. 들기름간장 양념, 깻잎 고명.', calories = 568.0, protein_g = 30.1, carbs_g = 51.7, fat_g = 26.7, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0157';
UPDATE recipes SET name = '김 고등어 구이 정식', description = '잡곡밥에 고등어, 가지, 토마토를 곁들인 1인분 구이 정식. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0159';
UPDATE recipes SET name = '들깨 고등어 구이 정식', description = '잡곡밥에 고등어, 양배추, 파프리카를 곁들인 1인분 구이 정식. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0162';
UPDATE recipes SET name = '간장 고등어 구이 정식', description = '잡곡밥에 고등어, 양배추, 파프리카를 곁들인 1인분 구이 정식. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0163';
UPDATE recipes SET name = '마늘 고등어 구이 정식', description = '잡곡밥에 고등어, 양배추, 파프리카를 곁들인 1인분 구이 정식. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0164';
UPDATE recipes SET name = '생강간장 고등어 구이 정식', description = '잡곡밥에 고등어, 양배추, 파프리카를 곁들인 1인분 구이 정식. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0165';
UPDATE recipes SET name = '파간장 고등어 구이 정식', description = '잡곡밥에 고등어, 양배추, 파프리카를 곁들인 1인분 구이 정식. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0166';
UPDATE recipes SET name = '깻잎 고등어 구이 정식', description = '잡곡밥에 고등어, 양배추, 파프리카를 곁들인 1인분 구이 정식. 들기름간장 양념, 깻잎 고명.', calories = 570.0, protein_g = 29.9, carbs_g = 52.3, fat_g = 26.7, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0167';
UPDATE recipes SET name = '김 고등어 구이 정식', description = '잡곡밥에 고등어, 양배추, 파프리카를 곁들인 1인분 구이 정식. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0169';
UPDATE recipes SET name = '들깨 고등어 구이 정식', description = '잡곡밥에 고등어, 브로콜리, 당근을 곁들인 1인분 구이 정식. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0172';
UPDATE recipes SET name = '간장 고등어 구이 정식', description = '잡곡밥에 고등어, 브로콜리, 당근을 곁들인 1인분 구이 정식. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0173';
UPDATE recipes SET name = '마늘 고등어 구이 정식', description = '잡곡밥에 고등어, 브로콜리, 당근을 곁들인 1인분 구이 정식. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0174';
UPDATE recipes SET name = '생강간장 고등어 구이 정식', description = '잡곡밥에 고등어, 브로콜리, 당근을 곁들인 1인분 구이 정식. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0175';
UPDATE recipes SET name = '파간장 고등어 구이 정식', description = '잡곡밥에 고등어, 브로콜리, 당근을 곁들인 1인분 구이 정식. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0176';
UPDATE recipes SET name = '깻잎 고등어 구이 정식', description = '잡곡밥에 고등어, 브로콜리, 당근을 곁들인 1인분 구이 정식. 들기름간장 양념, 깻잎 고명.', calories = 587.0, protein_g = 31.6, carbs_g = 54.9, fat_g = 26.7, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0177';
UPDATE recipes SET name = '김 고등어 구이 정식', description = '잡곡밥에 고등어, 브로콜리, 당근을 곁들인 1인분 구이 정식. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0179';
UPDATE recipes SET name = '들깨 고등어 구이 정식', description = '잡곡밥에 고등어, 애호박, 양송이버섯을 곁들인 1인분 구이 정식. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0182';
UPDATE recipes SET name = '간장 고등어 구이 정식', description = '잡곡밥에 고등어, 애호박, 양송이버섯을 곁들인 1인분 구이 정식. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0183';
UPDATE recipes SET name = '마늘 고등어 구이 정식', description = '잡곡밥에 고등어, 애호박, 양송이버섯을 곁들인 1인분 구이 정식. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0184';
UPDATE recipes SET name = '생강간장 고등어 구이 정식', description = '잡곡밥에 고등어, 애호박, 양송이버섯을 곁들인 1인분 구이 정식. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0185';
UPDATE recipes SET name = '파간장 고등어 구이 정식', description = '잡곡밥에 고등어, 애호박, 양송이버섯을 곁들인 1인분 구이 정식. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0186';
UPDATE recipes SET name = '깻잎 고등어 구이 정식', description = '잡곡밥에 고등어, 애호박, 양송이버섯을 곁들인 1인분 구이 정식. 들기름간장 양념, 깻잎 고명.', calories = 559.0, protein_g = 31.2, carbs_g = 48.1, fat_g = 26.7, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0187';
UPDATE recipes SET name = '김 고등어 구이 정식', description = '잡곡밥에 고등어, 애호박, 양송이버섯을 곁들인 1인분 구이 정식. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0189';
UPDATE recipes SET name = '들깨 고등어 구이 정식', description = '잡곡밥에 고등어, 시금치, 토마토를 곁들인 1인분 구이 정식. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0192';
UPDATE recipes SET name = '간장 고등어 구이 정식', description = '잡곡밥에 고등어, 시금치, 토마토를 곁들인 1인분 구이 정식. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0193';
UPDATE recipes SET name = '마늘 고등어 구이 정식', description = '잡곡밥에 고등어, 시금치, 토마토를 곁들인 1인분 구이 정식. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0194';
UPDATE recipes SET name = '생강간장 고등어 구이 정식', description = '잡곡밥에 고등어, 시금치, 토마토를 곁들인 1인분 구이 정식. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0195';
UPDATE recipes SET name = '파간장 고등어 구이 정식', description = '잡곡밥에 고등어, 시금치, 토마토를 곁들인 1인분 구이 정식. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0196';
UPDATE recipes SET name = '깻잎 고등어 구이 정식', description = '잡곡밥에 고등어, 시금치, 토마토를 곁들인 1인분 구이 정식. 들기름간장 양념, 깻잎 고명.', calories = 564.0, protein_g = 31.1, carbs_g = 49.5, fat_g = 26.7, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0197';
UPDATE recipes SET name = '김 고등어 구이 정식', description = '잡곡밥에 고등어, 시금치, 토마토를 곁들인 1인분 구이 정식. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0199';
UPDATE recipes SET name = '들깨 대구 덮밥', description = '현미밥에 대구, 양배추, 당근을 곁들인 1인분 현미 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0202';
UPDATE recipes SET name = '간장 대구 덮밥', description = '현미밥에 대구, 양배추, 당근을 곁들인 1인분 현미 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0203';
UPDATE recipes SET name = '마늘 대구 덮밥', description = '현미밥에 대구, 양배추, 당근을 곁들인 1인분 현미 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0204';
UPDATE recipes SET name = '생강간장 대구 덮밥', description = '현미밥에 대구, 양배추, 당근을 곁들인 1인분 현미 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0205';
UPDATE recipes SET name = '파간장 대구 덮밥', description = '현미밥에 대구, 양배추, 당근을 곁들인 1인분 현미 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0206';
UPDATE recipes SET name = '깻잎 대구 덮밥', description = '현미밥에 대구, 양배추, 당근을 곁들인 1인분 현미 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 432.0, protein_g = 31.6, carbs_g = 49.1, fat_g = 12.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0207';
UPDATE recipes SET name = '김 대구 덮밥', description = '현미밥에 대구, 양배추, 당근을 곁들인 1인분 현미 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0209';
UPDATE recipes SET name = '들깨 대구 덮밥', description = '현미밥에 대구, 브로콜리, 양파를 곁들인 1인분 현미 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0212';
UPDATE recipes SET name = '간장 대구 덮밥', description = '현미밥에 대구, 브로콜리, 양파를 곁들인 1인분 현미 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0213';
UPDATE recipes SET name = '마늘 대구 덮밥', description = '현미밥에 대구, 브로콜리, 양파를 곁들인 1인분 현미 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0214';
UPDATE recipes SET name = '생강간장 대구 덮밥', description = '현미밥에 대구, 브로콜리, 양파를 곁들인 1인분 현미 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0215';
UPDATE recipes SET name = '파간장 대구 덮밥', description = '현미밥에 대구, 브로콜리, 양파를 곁들인 1인분 현미 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0216';
UPDATE recipes SET name = '깻잎 대구 덮밥', description = '현미밥에 대구, 브로콜리, 양파를 곁들인 1인분 현미 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 439.0, protein_g = 33.3, carbs_g = 49.3, fat_g = 12.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0217';
UPDATE recipes SET name = '김 대구 덮밥', description = '현미밥에 대구, 브로콜리, 양파를 곁들인 1인분 현미 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0219';
UPDATE recipes SET name = '들깨 대구 덮밥', description = '현미밥에 대구, 애호박, 파프리카를 곁들인 1인분 현미 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0222';
UPDATE recipes SET name = '간장 대구 덮밥', description = '현미밥에 대구, 애호박, 파프리카를 곁들인 1인분 현미 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0223';
UPDATE recipes SET name = '마늘 대구 덮밥', description = '현미밥에 대구, 애호박, 파프리카를 곁들인 1인분 현미 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0224';
UPDATE recipes SET name = '생강간장 대구 덮밥', description = '현미밥에 대구, 애호박, 파프리카를 곁들인 1인분 현미 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0225';
UPDATE recipes SET name = '파간장 대구 덮밥', description = '현미밥에 대구, 애호박, 파프리카를 곁들인 1인분 현미 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0226';
UPDATE recipes SET name = '깻잎 대구 덮밥', description = '현미밥에 대구, 애호박, 파프리카를 곁들인 1인분 현미 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 416.0, protein_g = 31.7, carbs_g = 45.1, fat_g = 12.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0227';
UPDATE recipes SET name = '김 대구 덮밥', description = '현미밥에 대구, 애호박, 파프리카를 곁들인 1인분 현미 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0229';
UPDATE recipes SET name = '들깨 대구 덮밥', description = '현미밥에 대구, 시금치, 느타리버섯을 곁들인 1인분 현미 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0232';
UPDATE recipes SET name = '간장 대구 덮밥', description = '현미밥에 대구, 시금치, 느타리버섯을 곁들인 1인분 현미 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0233';
UPDATE recipes SET name = '마늘 대구 덮밥', description = '현미밥에 대구, 시금치, 느타리버섯을 곁들인 1인분 현미 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0234';
UPDATE recipes SET name = '생강간장 대구 덮밥', description = '현미밥에 대구, 시금치, 느타리버섯을 곁들인 1인분 현미 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0235';
UPDATE recipes SET name = '파간장 대구 덮밥', description = '현미밥에 대구, 시금치, 느타리버섯을 곁들인 1인분 현미 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0236';
UPDATE recipes SET name = '깻잎 대구 덮밥', description = '현미밥에 대구, 시금치, 느타리버섯을 곁들인 1인분 현미 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 433.0, protein_g = 34.5, carbs_g = 46.4, fat_g = 12.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0237';
UPDATE recipes SET name = '김 대구 덮밥', description = '현미밥에 대구, 시금치, 느타리버섯을 곁들인 1인분 현미 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0239';
UPDATE recipes SET name = '들깨 대구 덮밥', description = '현미밥에 대구, 청경채, 양송이버섯을 곁들인 1인분 현미 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0242';
UPDATE recipes SET name = '간장 대구 덮밥', description = '현미밥에 대구, 청경채, 양송이버섯을 곁들인 1인분 현미 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0243';
UPDATE recipes SET name = '마늘 대구 덮밥', description = '현미밥에 대구, 청경채, 양송이버섯을 곁들인 1인분 현미 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0244';
UPDATE recipes SET name = '생강간장 대구 덮밥', description = '현미밥에 대구, 청경채, 양송이버섯을 곁들인 1인분 현미 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0245';
UPDATE recipes SET name = '파간장 대구 덮밥', description = '현미밥에 대구, 청경채, 양송이버섯을 곁들인 1인분 현미 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0246';
UPDATE recipes SET name = '깻잎 대구 덮밥', description = '현미밥에 대구, 청경채, 양송이버섯을 곁들인 1인분 현미 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 418.0, protein_g = 33.8, carbs_g = 43.5, fat_g = 12.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0247';
UPDATE recipes SET name = '김 대구 덮밥', description = '현미밥에 대구, 청경채, 양송이버섯을 곁들인 1인분 현미 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0249';
UPDATE recipes SET name = '들깨 대구 덮밥', description = '현미밥에 대구, 가지, 토마토를 곁들인 1인분 현미 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0252';
UPDATE recipes SET name = '간장 대구 덮밥', description = '현미밥에 대구, 가지, 토마토를 곁들인 1인분 현미 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0253';
UPDATE recipes SET name = '마늘 대구 덮밥', description = '현미밥에 대구, 가지, 토마토를 곁들인 1인분 현미 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0254';
UPDATE recipes SET name = '생강간장 대구 덮밥', description = '현미밥에 대구, 가지, 토마토를 곁들인 1인분 현미 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0255';
UPDATE recipes SET name = '파간장 대구 덮밥', description = '현미밥에 대구, 가지, 토마토를 곁들인 1인분 현미 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0256';
UPDATE recipes SET name = '깻잎 대구 덮밥', description = '현미밥에 대구, 가지, 토마토를 곁들인 1인분 현미 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 425.0, protein_g = 31.9, carbs_g = 47.1, fat_g = 12.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0257';
UPDATE recipes SET name = '김 대구 덮밥', description = '현미밥에 대구, 가지, 토마토를 곁들인 1인분 현미 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0259';
UPDATE recipes SET name = '들깨 대구 덮밥', description = '현미밥에 대구, 양배추, 파프리카를 곁들인 1인분 현미 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0262';
UPDATE recipes SET name = '간장 대구 덮밥', description = '현미밥에 대구, 양배추, 파프리카를 곁들인 1인분 현미 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0263';
UPDATE recipes SET name = '마늘 대구 덮밥', description = '현미밥에 대구, 양배추, 파프리카를 곁들인 1인분 현미 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0264';
UPDATE recipes SET name = '생강간장 대구 덮밥', description = '현미밥에 대구, 양배추, 파프리카를 곁들인 1인분 현미 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0265';
UPDATE recipes SET name = '파간장 대구 덮밥', description = '현미밥에 대구, 양배추, 파프리카를 곁들인 1인분 현미 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0266';
UPDATE recipes SET name = '깻잎 대구 덮밥', description = '현미밥에 대구, 양배추, 파프리카를 곁들인 1인분 현미 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 427.0, protein_g = 31.7, carbs_g = 47.7, fat_g = 12.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0267';
UPDATE recipes SET name = '김 대구 덮밥', description = '현미밥에 대구, 양배추, 파프리카를 곁들인 1인분 현미 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0269';
UPDATE recipes SET name = '들깨 대구 덮밥', description = '현미밥에 대구, 브로콜리, 당근을 곁들인 1인분 현미 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0272';
UPDATE recipes SET name = '간장 대구 덮밥', description = '현미밥에 대구, 브로콜리, 당근을 곁들인 1인분 현미 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0273';
UPDATE recipes SET name = '마늘 대구 덮밥', description = '현미밥에 대구, 브로콜리, 당근을 곁들인 1인분 현미 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0274';
UPDATE recipes SET name = '생강간장 대구 덮밥', description = '현미밥에 대구, 브로콜리, 당근을 곁들인 1인분 현미 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0275';
UPDATE recipes SET name = '파간장 대구 덮밥', description = '현미밥에 대구, 브로콜리, 당근을 곁들인 1인분 현미 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0276';
UPDATE recipes SET name = '깻잎 대구 덮밥', description = '현미밥에 대구, 브로콜리, 당근을 곁들인 1인분 현미 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 443.0, protein_g = 33.4, carbs_g = 50.2, fat_g = 12.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0277';
UPDATE recipes SET name = '김 대구 덮밥', description = '현미밥에 대구, 브로콜리, 당근을 곁들인 1인분 현미 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0279';
UPDATE recipes SET name = '들깨 대구 덮밥', description = '현미밥에 대구, 애호박, 양송이버섯을 곁들인 1인분 현미 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0282';
UPDATE recipes SET name = '간장 대구 덮밥', description = '현미밥에 대구, 애호박, 양송이버섯을 곁들인 1인분 현미 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0283';
UPDATE recipes SET name = '마늘 대구 덮밥', description = '현미밥에 대구, 애호박, 양송이버섯을 곁들인 1인분 현미 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0284';
UPDATE recipes SET name = '생강간장 대구 덮밥', description = '현미밥에 대구, 애호박, 양송이버섯을 곁들인 1인분 현미 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0285';
UPDATE recipes SET name = '파간장 대구 덮밥', description = '현미밥에 대구, 애호박, 양송이버섯을 곁들인 1인분 현미 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0286';
UPDATE recipes SET name = '깻잎 대구 덮밥', description = '현미밥에 대구, 애호박, 양송이버섯을 곁들인 1인분 현미 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 415.0, protein_g = 33.0, carbs_g = 43.5, fat_g = 12.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0287';
UPDATE recipes SET name = '김 대구 덮밥', description = '현미밥에 대구, 애호박, 양송이버섯을 곁들인 1인분 현미 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0289';
UPDATE recipes SET name = '들깨 대구 덮밥', description = '현미밥에 대구, 시금치, 토마토를 곁들인 1인분 현미 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0292';
UPDATE recipes SET name = '간장 대구 덮밥', description = '현미밥에 대구, 시금치, 토마토를 곁들인 1인분 현미 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0293';
UPDATE recipes SET name = '마늘 대구 덮밥', description = '현미밥에 대구, 시금치, 토마토를 곁들인 1인분 현미 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0294';
UPDATE recipes SET name = '생강간장 대구 덮밥', description = '현미밥에 대구, 시금치, 토마토를 곁들인 1인분 현미 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0295';
UPDATE recipes SET name = '파간장 대구 덮밥', description = '현미밥에 대구, 시금치, 토마토를 곁들인 1인분 현미 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0296';
UPDATE recipes SET name = '깻잎 대구 덮밥', description = '현미밥에 대구, 시금치, 토마토를 곁들인 1인분 현미 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 420.0, protein_g = 32.9, carbs_g = 44.9, fat_g = 12.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0297';
UPDATE recipes SET name = '김 대구 덮밥', description = '현미밥에 대구, 시금치, 토마토를 곁들인 1인분 현미 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0299';
UPDATE recipes SET name = '레몬 돼지 안심 구이', description = '감자에 돼지 안심, 양배추, 당근을 곁들인 1인분 구이 한 접시. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0301';
UPDATE recipes SET name = '들깨 돼지 안심 구이', description = '감자에 돼지 안심, 양배추, 당근을 곁들인 1인분 구이 한 접시. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0302';
UPDATE recipes SET name = '간장 돼지 안심 구이', description = '감자에 돼지 안심, 양배추, 당근을 곁들인 1인분 구이 한 접시. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0303';
UPDATE recipes SET name = '마늘 돼지 안심 구이', description = '감자에 돼지 안심, 양배추, 당근을 곁들인 1인분 구이 한 접시. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0304';
UPDATE recipes SET name = '생강간장 돼지 안심 구이', description = '감자에 돼지 안심, 양배추, 당근을 곁들인 1인분 구이 한 접시. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0305';
UPDATE recipes SET name = '파간장 돼지 안심 구이', description = '감자에 돼지 안심, 양배추, 당근을 곁들인 1인분 구이 한 접시. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0306';
UPDATE recipes SET name = '깻잎 돼지 안심 구이', description = '감자에 돼지 안심, 양배추, 당근을 곁들인 1인분 구이 한 접시. 레몬올리브 양념, 깻잎 고명.', calories = 427.0, protein_g = 33.7, carbs_g = 41.2, fat_g = 14.2, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0307';
UPDATE recipes SET name = '바질 돼지 안심 구이', description = '감자에 돼지 안심, 양배추, 당근을 곁들인 1인분 구이 한 접시. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0308';
UPDATE recipes SET name = '김 돼지 안심 구이', description = '감자에 돼지 안심, 양배추, 당근을 곁들인 1인분 구이 한 접시. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0309';
UPDATE recipes SET name = '허브 돼지 안심 구이', description = '감자에 돼지 안심, 양배추, 당근을 곁들인 1인분 구이 한 접시. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0310';
UPDATE recipes SET name = '레몬 돼지 안심 구이', description = '감자에 돼지 안심, 브로콜리, 양파를 곁들인 1인분 구이 한 접시. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0311';
UPDATE recipes SET name = '들깨 돼지 안심 구이', description = '감자에 돼지 안심, 브로콜리, 양파를 곁들인 1인분 구이 한 접시. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0312';
UPDATE recipes SET name = '간장 돼지 안심 구이', description = '감자에 돼지 안심, 브로콜리, 양파를 곁들인 1인분 구이 한 접시. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0313';
UPDATE recipes SET name = '마늘 돼지 안심 구이', description = '감자에 돼지 안심, 브로콜리, 양파를 곁들인 1인분 구이 한 접시. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0314';
UPDATE recipes SET name = '생강간장 돼지 안심 구이', description = '감자에 돼지 안심, 브로콜리, 양파를 곁들인 1인분 구이 한 접시. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0315';
UPDATE recipes SET name = '파간장 돼지 안심 구이', description = '감자에 돼지 안심, 브로콜리, 양파를 곁들인 1인분 구이 한 접시. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0316';
UPDATE recipes SET name = '깻잎 돼지 안심 구이', description = '감자에 돼지 안심, 브로콜리, 양파를 곁들인 1인분 구이 한 접시. 레몬올리브 양념, 깻잎 고명.', calories = 434.0, protein_g = 35.4, carbs_g = 41.4, fat_g = 14.2, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0317';
UPDATE recipes SET name = '바질 돼지 안심 구이', description = '감자에 돼지 안심, 브로콜리, 양파를 곁들인 1인분 구이 한 접시. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0318';
UPDATE recipes SET name = '김 돼지 안심 구이', description = '감자에 돼지 안심, 브로콜리, 양파를 곁들인 1인분 구이 한 접시. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0319';
UPDATE recipes SET name = '허브 돼지 안심 구이', description = '감자에 돼지 안심, 브로콜리, 양파를 곁들인 1인분 구이 한 접시. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0320';
UPDATE recipes SET name = '레몬 돼지 안심 구이', description = '감자에 돼지 안심, 애호박, 파프리카를 곁들인 1인분 구이 한 접시. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0321';
UPDATE recipes SET name = '들깨 돼지 안심 구이', description = '감자에 돼지 안심, 애호박, 파프리카를 곁들인 1인분 구이 한 접시. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0322';
UPDATE recipes SET name = '간장 돼지 안심 구이', description = '감자에 돼지 안심, 애호박, 파프리카를 곁들인 1인분 구이 한 접시. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0323';
UPDATE recipes SET name = '마늘 돼지 안심 구이', description = '감자에 돼지 안심, 애호박, 파프리카를 곁들인 1인분 구이 한 접시. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0324';
UPDATE recipes SET name = '생강간장 돼지 안심 구이', description = '감자에 돼지 안심, 애호박, 파프리카를 곁들인 1인분 구이 한 접시. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0325';
UPDATE recipes SET name = '파간장 돼지 안심 구이', description = '감자에 돼지 안심, 애호박, 파프리카를 곁들인 1인분 구이 한 접시. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0326';
UPDATE recipes SET name = '깻잎 돼지 안심 구이', description = '감자에 돼지 안심, 애호박, 파프리카를 곁들인 1인분 구이 한 접시. 레몬올리브 양념, 깻잎 고명.', calories = 411.0, protein_g = 33.8, carbs_g = 37.3, fat_g = 14.2, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0327';
UPDATE recipes SET name = '바질 돼지 안심 구이', description = '감자에 돼지 안심, 애호박, 파프리카를 곁들인 1인분 구이 한 접시. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0328';
UPDATE recipes SET name = '김 돼지 안심 구이', description = '감자에 돼지 안심, 애호박, 파프리카를 곁들인 1인분 구이 한 접시. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0329';
UPDATE recipes SET name = '허브 돼지 안심 구이', description = '감자에 돼지 안심, 애호박, 파프리카를 곁들인 1인분 구이 한 접시. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0330';
UPDATE recipes SET name = '레몬 돼지 안심 구이', description = '감자에 돼지 안심, 시금치, 느타리버섯을 곁들인 1인분 구이 한 접시. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0331';
UPDATE recipes SET name = '들깨 돼지 안심 구이', description = '감자에 돼지 안심, 시금치, 느타리버섯을 곁들인 1인분 구이 한 접시. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0332';
UPDATE recipes SET name = '간장 돼지 안심 구이', description = '감자에 돼지 안심, 시금치, 느타리버섯을 곁들인 1인분 구이 한 접시. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0333';
UPDATE recipes SET name = '마늘 돼지 안심 구이', description = '감자에 돼지 안심, 시금치, 느타리버섯을 곁들인 1인분 구이 한 접시. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0334';
UPDATE recipes SET name = '생강간장 돼지 안심 구이', description = '감자에 돼지 안심, 시금치, 느타리버섯을 곁들인 1인분 구이 한 접시. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0335';
UPDATE recipes SET name = '파간장 돼지 안심 구이', description = '감자에 돼지 안심, 시금치, 느타리버섯을 곁들인 1인분 구이 한 접시. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0336';
UPDATE recipes SET name = '깻잎 돼지 안심 구이', description = '감자에 돼지 안심, 시금치, 느타리버섯을 곁들인 1인분 구이 한 접시. 레몬올리브 양념, 깻잎 고명.', calories = 428.0, protein_g = 36.6, carbs_g = 38.5, fat_g = 14.2, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0337';
UPDATE recipes SET name = '바질 돼지 안심 구이', description = '감자에 돼지 안심, 시금치, 느타리버섯을 곁들인 1인분 구이 한 접시. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0338';
UPDATE recipes SET name = '김 돼지 안심 구이', description = '감자에 돼지 안심, 시금치, 느타리버섯을 곁들인 1인분 구이 한 접시. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0339';
UPDATE recipes SET name = '허브 돼지 안심 구이', description = '감자에 돼지 안심, 시금치, 느타리버섯을 곁들인 1인분 구이 한 접시. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0340';
UPDATE recipes SET name = '레몬 돼지 안심 구이', description = '감자에 돼지 안심, 청경채, 양송이버섯을 곁들인 1인분 구이 한 접시. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0341';
UPDATE recipes SET name = '들깨 돼지 안심 구이', description = '감자에 돼지 안심, 청경채, 양송이버섯을 곁들인 1인분 구이 한 접시. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0342';
UPDATE recipes SET name = '간장 돼지 안심 구이', description = '감자에 돼지 안심, 청경채, 양송이버섯을 곁들인 1인분 구이 한 접시. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0343';
UPDATE recipes SET name = '마늘 돼지 안심 구이', description = '감자에 돼지 안심, 청경채, 양송이버섯을 곁들인 1인분 구이 한 접시. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0344';
UPDATE recipes SET name = '생강간장 돼지 안심 구이', description = '감자에 돼지 안심, 청경채, 양송이버섯을 곁들인 1인분 구이 한 접시. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0345';
UPDATE recipes SET name = '파간장 돼지 안심 구이', description = '감자에 돼지 안심, 청경채, 양송이버섯을 곁들인 1인분 구이 한 접시. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0346';
UPDATE recipes SET name = '깻잎 돼지 안심 구이', description = '감자에 돼지 안심, 청경채, 양송이버섯을 곁들인 1인분 구이 한 접시. 레몬올리브 양념, 깻잎 고명.', calories = 413.0, protein_g = 35.8, carbs_g = 35.6, fat_g = 14.2, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0347';
UPDATE recipes SET name = '바질 돼지 안심 구이', description = '감자에 돼지 안심, 청경채, 양송이버섯을 곁들인 1인분 구이 한 접시. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0348';
UPDATE recipes SET name = '김 돼지 안심 구이', description = '감자에 돼지 안심, 청경채, 양송이버섯을 곁들인 1인분 구이 한 접시. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0349';
UPDATE recipes SET name = '허브 돼지 안심 구이', description = '감자에 돼지 안심, 청경채, 양송이버섯을 곁들인 1인분 구이 한 접시. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0350';
UPDATE recipes SET name = '레몬 돼지 안심 구이', description = '감자에 돼지 안심, 가지, 토마토를 곁들인 1인분 구이 한 접시. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0351';
UPDATE recipes SET name = '들깨 돼지 안심 구이', description = '감자에 돼지 안심, 가지, 토마토를 곁들인 1인분 구이 한 접시. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0352';
UPDATE recipes SET name = '간장 돼지 안심 구이', description = '감자에 돼지 안심, 가지, 토마토를 곁들인 1인분 구이 한 접시. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0353';
UPDATE recipes SET name = '마늘 돼지 안심 구이', description = '감자에 돼지 안심, 가지, 토마토를 곁들인 1인분 구이 한 접시. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0354';
UPDATE recipes SET name = '생강간장 돼지 안심 구이', description = '감자에 돼지 안심, 가지, 토마토를 곁들인 1인분 구이 한 접시. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0355';
UPDATE recipes SET name = '파간장 돼지 안심 구이', description = '감자에 돼지 안심, 가지, 토마토를 곁들인 1인분 구이 한 접시. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0356';
UPDATE recipes SET name = '깻잎 돼지 안심 구이', description = '감자에 돼지 안심, 가지, 토마토를 곁들인 1인분 구이 한 접시. 레몬올리브 양념, 깻잎 고명.', calories = 420.0, protein_g = 33.9, carbs_g = 39.2, fat_g = 14.2, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0357';
UPDATE recipes SET name = '바질 돼지 안심 구이', description = '감자에 돼지 안심, 가지, 토마토를 곁들인 1인분 구이 한 접시. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0358';
UPDATE recipes SET name = '김 돼지 안심 구이', description = '감자에 돼지 안심, 가지, 토마토를 곁들인 1인분 구이 한 접시. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0359';
UPDATE recipes SET name = '허브 돼지 안심 구이', description = '감자에 돼지 안심, 가지, 토마토를 곁들인 1인분 구이 한 접시. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0360';
UPDATE recipes SET name = '레몬 돼지 안심 구이', description = '감자에 돼지 안심, 양배추, 파프리카를 곁들인 1인분 구이 한 접시. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0361';
UPDATE recipes SET name = '들깨 돼지 안심 구이', description = '감자에 돼지 안심, 양배추, 파프리카를 곁들인 1인분 구이 한 접시. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0362';
UPDATE recipes SET name = '간장 돼지 안심 구이', description = '감자에 돼지 안심, 양배추, 파프리카를 곁들인 1인분 구이 한 접시. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0363';
UPDATE recipes SET name = '마늘 돼지 안심 구이', description = '감자에 돼지 안심, 양배추, 파프리카를 곁들인 1인분 구이 한 접시. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0364';
UPDATE recipes SET name = '생강간장 돼지 안심 구이', description = '감자에 돼지 안심, 양배추, 파프리카를 곁들인 1인분 구이 한 접시. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0365';
UPDATE recipes SET name = '파간장 돼지 안심 구이', description = '감자에 돼지 안심, 양배추, 파프리카를 곁들인 1인분 구이 한 접시. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0366';
UPDATE recipes SET name = '깻잎 돼지 안심 구이', description = '감자에 돼지 안심, 양배추, 파프리카를 곁들인 1인분 구이 한 접시. 레몬올리브 양념, 깻잎 고명.', calories = 422.0, protein_g = 33.8, carbs_g = 39.8, fat_g = 14.2, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0367';
UPDATE recipes SET name = '바질 돼지 안심 구이', description = '감자에 돼지 안심, 양배추, 파프리카를 곁들인 1인분 구이 한 접시. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0368';
UPDATE recipes SET name = '김 돼지 안심 구이', description = '감자에 돼지 안심, 양배추, 파프리카를 곁들인 1인분 구이 한 접시. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0369';
UPDATE recipes SET name = '허브 돼지 안심 구이', description = '감자에 돼지 안심, 양배추, 파프리카를 곁들인 1인분 구이 한 접시. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0370';
UPDATE recipes SET name = '레몬 돼지 안심 구이', description = '감자에 돼지 안심, 브로콜리, 당근을 곁들인 1인분 구이 한 접시. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0371';
UPDATE recipes SET name = '들깨 돼지 안심 구이', description = '감자에 돼지 안심, 브로콜리, 당근을 곁들인 1인분 구이 한 접시. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0372';
UPDATE recipes SET name = '간장 돼지 안심 구이', description = '감자에 돼지 안심, 브로콜리, 당근을 곁들인 1인분 구이 한 접시. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0373';
UPDATE recipes SET name = '마늘 돼지 안심 구이', description = '감자에 돼지 안심, 브로콜리, 당근을 곁들인 1인분 구이 한 접시. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0374';
UPDATE recipes SET name = '생강간장 돼지 안심 구이', description = '감자에 돼지 안심, 브로콜리, 당근을 곁들인 1인분 구이 한 접시. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0375';
UPDATE recipes SET name = '파간장 돼지 안심 구이', description = '감자에 돼지 안심, 브로콜리, 당근을 곁들인 1인분 구이 한 접시. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0376';
UPDATE recipes SET name = '깻잎 돼지 안심 구이', description = '감자에 돼지 안심, 브로콜리, 당근을 곁들인 1인분 구이 한 접시. 레몬올리브 양념, 깻잎 고명.', calories = 438.0, protein_g = 35.4, carbs_g = 42.4, fat_g = 14.2, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0377';
UPDATE recipes SET name = '바질 돼지 안심 구이', description = '감자에 돼지 안심, 브로콜리, 당근을 곁들인 1인분 구이 한 접시. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0378';
UPDATE recipes SET name = '김 돼지 안심 구이', description = '감자에 돼지 안심, 브로콜리, 당근을 곁들인 1인분 구이 한 접시. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0379';
UPDATE recipes SET name = '허브 돼지 안심 구이', description = '감자에 돼지 안심, 브로콜리, 당근을 곁들인 1인분 구이 한 접시. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0380';
UPDATE recipes SET name = '레몬 돼지 안심 구이', description = '감자에 돼지 안심, 애호박, 양송이버섯을 곁들인 1인분 구이 한 접시. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0381';
UPDATE recipes SET name = '들깨 돼지 안심 구이', description = '감자에 돼지 안심, 애호박, 양송이버섯을 곁들인 1인분 구이 한 접시. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0382';
UPDATE recipes SET name = '간장 돼지 안심 구이', description = '감자에 돼지 안심, 애호박, 양송이버섯을 곁들인 1인분 구이 한 접시. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0383';
UPDATE recipes SET name = '마늘 돼지 안심 구이', description = '감자에 돼지 안심, 애호박, 양송이버섯을 곁들인 1인분 구이 한 접시. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0384';
UPDATE recipes SET name = '생강간장 돼지 안심 구이', description = '감자에 돼지 안심, 애호박, 양송이버섯을 곁들인 1인분 구이 한 접시. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0385';
UPDATE recipes SET name = '파간장 돼지 안심 구이', description = '감자에 돼지 안심, 애호박, 양송이버섯을 곁들인 1인분 구이 한 접시. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0386';
UPDATE recipes SET name = '깻잎 돼지 안심 구이', description = '감자에 돼지 안심, 애호박, 양송이버섯을 곁들인 1인분 구이 한 접시. 레몬올리브 양념, 깻잎 고명.', calories = 410.0, protein_g = 35.1, carbs_g = 35.6, fat_g = 14.2, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0387';
UPDATE recipes SET name = '바질 돼지 안심 구이', description = '감자에 돼지 안심, 애호박, 양송이버섯을 곁들인 1인분 구이 한 접시. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0388';
UPDATE recipes SET name = '김 돼지 안심 구이', description = '감자에 돼지 안심, 애호박, 양송이버섯을 곁들인 1인분 구이 한 접시. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0389';
UPDATE recipes SET name = '허브 돼지 안심 구이', description = '감자에 돼지 안심, 애호박, 양송이버섯을 곁들인 1인분 구이 한 접시. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0390';
UPDATE recipes SET name = '레몬 돼지 안심 구이', description = '감자에 돼지 안심, 시금치, 토마토를 곁들인 1인분 구이 한 접시. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0391';
UPDATE recipes SET name = '들깨 돼지 안심 구이', description = '감자에 돼지 안심, 시금치, 토마토를 곁들인 1인분 구이 한 접시. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0392';
UPDATE recipes SET name = '간장 돼지 안심 구이', description = '감자에 돼지 안심, 시금치, 토마토를 곁들인 1인분 구이 한 접시. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0393';
UPDATE recipes SET name = '마늘 돼지 안심 구이', description = '감자에 돼지 안심, 시금치, 토마토를 곁들인 1인분 구이 한 접시. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0394';
UPDATE recipes SET name = '생강간장 돼지 안심 구이', description = '감자에 돼지 안심, 시금치, 토마토를 곁들인 1인분 구이 한 접시. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0395';
UPDATE recipes SET name = '파간장 돼지 안심 구이', description = '감자에 돼지 안심, 시금치, 토마토를 곁들인 1인분 구이 한 접시. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0396';
UPDATE recipes SET name = '깻잎 돼지 안심 구이', description = '감자에 돼지 안심, 시금치, 토마토를 곁들인 1인분 구이 한 접시. 레몬올리브 양념, 깻잎 고명.', calories = 415.0, protein_g = 35.0, carbs_g = 37.0, fat_g = 14.2, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0397';
UPDATE recipes SET name = '바질 돼지 안심 구이', description = '감자에 돼지 안심, 시금치, 토마토를 곁들인 1인분 구이 한 접시. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0398';
UPDATE recipes SET name = '김 돼지 안심 구이', description = '감자에 돼지 안심, 시금치, 토마토를 곁들인 1인분 구이 한 접시. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0399';
UPDATE recipes SET name = '허브 돼지 안심 구이', description = '감자에 돼지 안심, 시금치, 토마토를 곁들인 1인분 구이 한 접시. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0400';
UPDATE recipes SET name = '레몬 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 양배추, 당근을 곁들인 1인분 퀴노아 볼. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0401';
UPDATE recipes SET name = '들깨 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 양배추, 당근을 곁들인 1인분 퀴노아 볼. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0402';
UPDATE recipes SET name = '간장 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 양배추, 당근을 곁들인 1인분 퀴노아 볼. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0403';
UPDATE recipes SET name = '마늘 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 양배추, 당근을 곁들인 1인분 퀴노아 볼. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0404';
UPDATE recipes SET name = '생강간장 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 양배추, 당근을 곁들인 1인분 퀴노아 볼. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0405';
UPDATE recipes SET name = '파간장 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 양배추, 당근을 곁들인 1인분 퀴노아 볼. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0406';
UPDATE recipes SET name = '깻잎 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 양배추, 당근을 곁들인 1인분 퀴노아 볼. 레몬올리브 양념, 깻잎 고명.', calories = 495.0, protein_g = 35.4, carbs_g = 44.2, fat_g = 19.7, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0407';
UPDATE recipes SET name = '바질 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 양배추, 당근을 곁들인 1인분 퀴노아 볼. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0408';
UPDATE recipes SET name = '김 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 양배추, 당근을 곁들인 1인분 퀴노아 볼. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0409';
UPDATE recipes SET name = '허브 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 양배추, 당근을 곁들인 1인분 퀴노아 볼. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0410';
UPDATE recipes SET name = '레몬 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 브로콜리, 양파를 곁들인 1인분 퀴노아 볼. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0411';
UPDATE recipes SET name = '들깨 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 브로콜리, 양파를 곁들인 1인분 퀴노아 볼. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0412';
UPDATE recipes SET name = '간장 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 브로콜리, 양파를 곁들인 1인분 퀴노아 볼. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0413';
UPDATE recipes SET name = '마늘 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 브로콜리, 양파를 곁들인 1인분 퀴노아 볼. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0414';
UPDATE recipes SET name = '생강간장 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 브로콜리, 양파를 곁들인 1인분 퀴노아 볼. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0415';
UPDATE recipes SET name = '파간장 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 브로콜리, 양파를 곁들인 1인분 퀴노아 볼. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0416';
UPDATE recipes SET name = '깻잎 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 브로콜리, 양파를 곁들인 1인분 퀴노아 볼. 레몬올리브 양념, 깻잎 고명.', calories = 503.0, protein_g = 37.1, carbs_g = 44.4, fat_g = 19.7, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0417';
UPDATE recipes SET name = '바질 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 브로콜리, 양파를 곁들인 1인분 퀴노아 볼. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0418';
UPDATE recipes SET name = '김 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 브로콜리, 양파를 곁들인 1인분 퀴노아 볼. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0419';
UPDATE recipes SET name = '허브 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 브로콜리, 양파를 곁들인 1인분 퀴노아 볼. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0420';
UPDATE recipes SET name = '레몬 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 애호박, 파프리카를 곁들인 1인분 퀴노아 볼. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0421';
UPDATE recipes SET name = '들깨 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 애호박, 파프리카를 곁들인 1인분 퀴노아 볼. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0422';
UPDATE recipes SET name = '간장 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 애호박, 파프리카를 곁들인 1인분 퀴노아 볼. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0423';
UPDATE recipes SET name = '마늘 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 애호박, 파프리카를 곁들인 1인분 퀴노아 볼. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0424';
UPDATE recipes SET name = '생강간장 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 애호박, 파프리카를 곁들인 1인분 퀴노아 볼. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0425';
UPDATE recipes SET name = '파간장 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 애호박, 파프리카를 곁들인 1인분 퀴노아 볼. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0426';
UPDATE recipes SET name = '깻잎 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 애호박, 파프리카를 곁들인 1인분 퀴노아 볼. 레몬올리브 양념, 깻잎 고명.', calories = 480.0, protein_g = 35.5, carbs_g = 40.3, fat_g = 19.7, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0427';
UPDATE recipes SET name = '바질 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 애호박, 파프리카를 곁들인 1인분 퀴노아 볼. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0428';
UPDATE recipes SET name = '김 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 애호박, 파프리카를 곁들인 1인분 퀴노아 볼. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0429';
UPDATE recipes SET name = '허브 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 애호박, 파프리카를 곁들인 1인분 퀴노아 볼. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0430';
UPDATE recipes SET name = '레몬 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 시금치, 느타리버섯을 곁들인 1인분 퀴노아 볼. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0431';
UPDATE recipes SET name = '들깨 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 시금치, 느타리버섯을 곁들인 1인분 퀴노아 볼. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0432';
UPDATE recipes SET name = '간장 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 시금치, 느타리버섯을 곁들인 1인분 퀴노아 볼. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0433';
UPDATE recipes SET name = '마늘 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 시금치, 느타리버섯을 곁들인 1인분 퀴노아 볼. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0434';
UPDATE recipes SET name = '생강간장 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 시금치, 느타리버섯을 곁들인 1인분 퀴노아 볼. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0435';
UPDATE recipes SET name = '파간장 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 시금치, 느타리버섯을 곁들인 1인분 퀴노아 볼. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0436';
UPDATE recipes SET name = '깻잎 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 시금치, 느타리버섯을 곁들인 1인분 퀴노아 볼. 레몬올리브 양념, 깻잎 고명.', calories = 496.0, protein_g = 38.3, carbs_g = 41.5, fat_g = 19.7, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0437';
UPDATE recipes SET name = '바질 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 시금치, 느타리버섯을 곁들인 1인분 퀴노아 볼. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0438';
UPDATE recipes SET name = '김 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 시금치, 느타리버섯을 곁들인 1인분 퀴노아 볼. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0439';
UPDATE recipes SET name = '허브 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 시금치, 느타리버섯을 곁들인 1인분 퀴노아 볼. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0440';
UPDATE recipes SET name = '레몬 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 청경채, 양송이버섯을 곁들인 1인분 퀴노아 볼. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0441';
UPDATE recipes SET name = '들깨 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 청경채, 양송이버섯을 곁들인 1인분 퀴노아 볼. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0442';
UPDATE recipes SET name = '간장 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 청경채, 양송이버섯을 곁들인 1인분 퀴노아 볼. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0443';
UPDATE recipes SET name = '마늘 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 청경채, 양송이버섯을 곁들인 1인분 퀴노아 볼. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0444';
UPDATE recipes SET name = '생강간장 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 청경채, 양송이버섯을 곁들인 1인분 퀴노아 볼. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0445';
UPDATE recipes SET name = '파간장 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 청경채, 양송이버섯을 곁들인 1인분 퀴노아 볼. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0446';
UPDATE recipes SET name = '깻잎 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 청경채, 양송이버섯을 곁들인 1인분 퀴노아 볼. 레몬올리브 양념, 깻잎 고명.', calories = 481.0, protein_g = 37.5, carbs_g = 38.6, fat_g = 19.7, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0447';
UPDATE recipes SET name = '바질 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 청경채, 양송이버섯을 곁들인 1인분 퀴노아 볼. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0448';
UPDATE recipes SET name = '김 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 청경채, 양송이버섯을 곁들인 1인분 퀴노아 볼. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0449';
UPDATE recipes SET name = '허브 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 청경채, 양송이버섯을 곁들인 1인분 퀴노아 볼. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0450';
UPDATE recipes SET name = '레몬 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 가지, 토마토를 곁들인 1인분 퀴노아 볼. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0451';
UPDATE recipes SET name = '들깨 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 가지, 토마토를 곁들인 1인분 퀴노아 볼. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0452';
UPDATE recipes SET name = '간장 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 가지, 토마토를 곁들인 1인분 퀴노아 볼. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0453';
UPDATE recipes SET name = '마늘 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 가지, 토마토를 곁들인 1인분 퀴노아 볼. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0454';
UPDATE recipes SET name = '생강간장 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 가지, 토마토를 곁들인 1인분 퀴노아 볼. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0455';
UPDATE recipes SET name = '파간장 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 가지, 토마토를 곁들인 1인분 퀴노아 볼. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0456';
UPDATE recipes SET name = '깻잎 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 가지, 토마토를 곁들인 1인분 퀴노아 볼. 레몬올리브 양념, 깻잎 고명.', calories = 488.0, protein_g = 35.6, carbs_g = 42.2, fat_g = 19.7, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0457';
UPDATE recipes SET name = '바질 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 가지, 토마토를 곁들인 1인분 퀴노아 볼. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0458';
UPDATE recipes SET name = '김 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 가지, 토마토를 곁들인 1인분 퀴노아 볼. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0459';
UPDATE recipes SET name = '허브 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 가지, 토마토를 곁들인 1인분 퀴노아 볼. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0460';
UPDATE recipes SET name = '레몬 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 양배추, 파프리카를 곁들인 1인분 퀴노아 볼. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0461';
UPDATE recipes SET name = '들깨 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 양배추, 파프리카를 곁들인 1인분 퀴노아 볼. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0462';
UPDATE recipes SET name = '간장 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 양배추, 파프리카를 곁들인 1인분 퀴노아 볼. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0463';
UPDATE recipes SET name = '마늘 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 양배추, 파프리카를 곁들인 1인분 퀴노아 볼. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0464';
UPDATE recipes SET name = '생강간장 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 양배추, 파프리카를 곁들인 1인분 퀴노아 볼. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0465';
UPDATE recipes SET name = '파간장 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 양배추, 파프리카를 곁들인 1인분 퀴노아 볼. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0466';
UPDATE recipes SET name = '깻잎 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 양배추, 파프리카를 곁들인 1인분 퀴노아 볼. 레몬올리브 양념, 깻잎 고명.', calories = 490.0, protein_g = 35.5, carbs_g = 42.8, fat_g = 19.7, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0467';
UPDATE recipes SET name = '바질 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 양배추, 파프리카를 곁들인 1인분 퀴노아 볼. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0468';
UPDATE recipes SET name = '김 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 양배추, 파프리카를 곁들인 1인분 퀴노아 볼. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0469';
UPDATE recipes SET name = '허브 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 양배추, 파프리카를 곁들인 1인분 퀴노아 볼. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0470';
UPDATE recipes SET name = '레몬 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 브로콜리, 당근을 곁들인 1인분 퀴노아 볼. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0471';
UPDATE recipes SET name = '들깨 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 브로콜리, 당근을 곁들인 1인분 퀴노아 볼. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0472';
UPDATE recipes SET name = '간장 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 브로콜리, 당근을 곁들인 1인분 퀴노아 볼. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0473';
UPDATE recipes SET name = '마늘 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 브로콜리, 당근을 곁들인 1인분 퀴노아 볼. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0474';
UPDATE recipes SET name = '생강간장 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 브로콜리, 당근을 곁들인 1인분 퀴노아 볼. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0475';
UPDATE recipes SET name = '파간장 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 브로콜리, 당근을 곁들인 1인분 퀴노아 볼. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0476';
UPDATE recipes SET name = '깻잎 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 브로콜리, 당근을 곁들인 1인분 퀴노아 볼. 레몬올리브 양념, 깻잎 고명.', calories = 507.0, protein_g = 37.1, carbs_g = 45.4, fat_g = 19.7, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0477';
UPDATE recipes SET name = '바질 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 브로콜리, 당근을 곁들인 1인분 퀴노아 볼. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0478';
UPDATE recipes SET name = '김 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 브로콜리, 당근을 곁들인 1인분 퀴노아 볼. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0479';
UPDATE recipes SET name = '허브 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 브로콜리, 당근을 곁들인 1인분 퀴노아 볼. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0480';
UPDATE recipes SET name = '레몬 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 애호박, 양송이버섯을 곁들인 1인분 퀴노아 볼. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0481';
UPDATE recipes SET name = '들깨 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 애호박, 양송이버섯을 곁들인 1인분 퀴노아 볼. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0482';
UPDATE recipes SET name = '간장 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 애호박, 양송이버섯을 곁들인 1인분 퀴노아 볼. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0483';
UPDATE recipes SET name = '마늘 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 애호박, 양송이버섯을 곁들인 1인분 퀴노아 볼. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0484';
UPDATE recipes SET name = '생강간장 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 애호박, 양송이버섯을 곁들인 1인분 퀴노아 볼. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0485';
UPDATE recipes SET name = '파간장 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 애호박, 양송이버섯을 곁들인 1인분 퀴노아 볼. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0486';
UPDATE recipes SET name = '깻잎 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 애호박, 양송이버섯을 곁들인 1인분 퀴노아 볼. 레몬올리브 양념, 깻잎 고명.', calories = 478.0, protein_g = 36.8, carbs_g = 38.6, fat_g = 19.7, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0487';
UPDATE recipes SET name = '바질 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 애호박, 양송이버섯을 곁들인 1인분 퀴노아 볼. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0488';
UPDATE recipes SET name = '김 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 애호박, 양송이버섯을 곁들인 1인분 퀴노아 볼. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0489';
UPDATE recipes SET name = '허브 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 애호박, 양송이버섯을 곁들인 1인분 퀴노아 볼. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0490';
UPDATE recipes SET name = '레몬 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 시금치, 토마토를 곁들인 1인분 퀴노아 볼. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0491';
UPDATE recipes SET name = '들깨 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 시금치, 토마토를 곁들인 1인분 퀴노아 볼. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0492';
UPDATE recipes SET name = '간장 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 시금치, 토마토를 곁들인 1인분 퀴노아 볼. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0493';
UPDATE recipes SET name = '마늘 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 시금치, 토마토를 곁들인 1인분 퀴노아 볼. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0494';
UPDATE recipes SET name = '생강간장 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 시금치, 토마토를 곁들인 1인분 퀴노아 볼. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0495';
UPDATE recipes SET name = '파간장 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 시금치, 토마토를 곁들인 1인분 퀴노아 볼. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0496';
UPDATE recipes SET name = '깻잎 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 시금치, 토마토를 곁들인 1인분 퀴노아 볼. 레몬올리브 양념, 깻잎 고명.', calories = 483.0, protein_g = 36.7, carbs_g = 40.0, fat_g = 19.7, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0497';
UPDATE recipes SET name = '바질 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 시금치, 토마토를 곁들인 1인분 퀴노아 볼. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0498';
UPDATE recipes SET name = '김 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 시금치, 토마토를 곁들인 1인분 퀴노아 볼. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0499';
UPDATE recipes SET name = '허브 소고기 퀴노아볼', description = '퀴노아에 소고기 우둔살, 시금치, 토마토를 곁들인 1인분 퀴노아 볼. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0500';
UPDATE recipes SET name = '들깨 두부 비빔밥', description = '보리밥에 두부, 양배추, 당근을 곁들인 1인분 보리 비빔밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0502';
UPDATE recipes SET name = '간장 두부 비빔밥', description = '보리밥에 두부, 양배추, 당근을 곁들인 1인분 보리 비빔밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0503';
UPDATE recipes SET name = '마늘 두부 비빔밥', description = '보리밥에 두부, 양배추, 당근을 곁들인 1인분 보리 비빔밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0504';
UPDATE recipes SET name = '생강간장 두부 비빔밥', description = '보리밥에 두부, 양배추, 당근을 곁들인 1인분 보리 비빔밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0505';
UPDATE recipes SET name = '파간장 두부 비빔밥', description = '보리밥에 두부, 양배추, 당근을 곁들인 1인분 보리 비빔밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0506';
UPDATE recipes SET name = '깻잎 두부 비빔밥', description = '보리밥에 두부, 양배추, 당근을 곁들인 1인분 보리 비빔밥. 들기름간장 양념, 깻잎 고명.', calories = 488.0, protein_g = 20.3, carbs_g = 58.5, fat_g = 19.1, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0507';
UPDATE recipes SET name = '김 두부 비빔밥', description = '보리밥에 두부, 양배추, 당근을 곁들인 1인분 보리 비빔밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0509';
UPDATE recipes SET name = '들깨 두부 비빔밥', description = '보리밥에 두부, 브로콜리, 양파를 곁들인 1인분 보리 비빔밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0512';
UPDATE recipes SET name = '간장 두부 비빔밥', description = '보리밥에 두부, 브로콜리, 양파를 곁들인 1인분 보리 비빔밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0513';
UPDATE recipes SET name = '마늘 두부 비빔밥', description = '보리밥에 두부, 브로콜리, 양파를 곁들인 1인분 보리 비빔밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0514';
UPDATE recipes SET name = '생강간장 두부 비빔밥', description = '보리밥에 두부, 브로콜리, 양파를 곁들인 1인분 보리 비빔밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0515';
UPDATE recipes SET name = '파간장 두부 비빔밥', description = '보리밥에 두부, 브로콜리, 양파를 곁들인 1인분 보리 비빔밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0516';
UPDATE recipes SET name = '깻잎 두부 비빔밥', description = '보리밥에 두부, 브로콜리, 양파를 곁들인 1인분 보리 비빔밥. 들기름간장 양념, 깻잎 고명.', calories = 496.0, protein_g = 22.0, carbs_g = 58.7, fat_g = 19.1, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0517';
UPDATE recipes SET name = '김 두부 비빔밥', description = '보리밥에 두부, 브로콜리, 양파를 곁들인 1인분 보리 비빔밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0519';
UPDATE recipes SET name = '들깨 두부 비빔밥', description = '보리밥에 두부, 애호박, 파프리카를 곁들인 1인분 보리 비빔밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0522';
UPDATE recipes SET name = '간장 두부 비빔밥', description = '보리밥에 두부, 애호박, 파프리카를 곁들인 1인분 보리 비빔밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0523';
UPDATE recipes SET name = '마늘 두부 비빔밥', description = '보리밥에 두부, 애호박, 파프리카를 곁들인 1인분 보리 비빔밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0524';
UPDATE recipes SET name = '생강간장 두부 비빔밥', description = '보리밥에 두부, 애호박, 파프리카를 곁들인 1인분 보리 비빔밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0525';
UPDATE recipes SET name = '파간장 두부 비빔밥', description = '보리밥에 두부, 애호박, 파프리카를 곁들인 1인분 보리 비빔밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0526';
UPDATE recipes SET name = '깻잎 두부 비빔밥', description = '보리밥에 두부, 애호박, 파프리카를 곁들인 1인분 보리 비빔밥. 들기름간장 양념, 깻잎 고명.', calories = 473.0, protein_g = 20.4, carbs_g = 54.6, fat_g = 19.1, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0527';
UPDATE recipes SET name = '김 두부 비빔밥', description = '보리밥에 두부, 애호박, 파프리카를 곁들인 1인분 보리 비빔밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0529';
UPDATE recipes SET name = '들깨 두부 비빔밥', description = '보리밥에 두부, 시금치, 느타리버섯을 곁들인 1인분 보리 비빔밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0532';
UPDATE recipes SET name = '간장 두부 비빔밥', description = '보리밥에 두부, 시금치, 느타리버섯을 곁들인 1인분 보리 비빔밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0533';
UPDATE recipes SET name = '마늘 두부 비빔밥', description = '보리밥에 두부, 시금치, 느타리버섯을 곁들인 1인분 보리 비빔밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0534';
UPDATE recipes SET name = '생강간장 두부 비빔밥', description = '보리밥에 두부, 시금치, 느타리버섯을 곁들인 1인분 보리 비빔밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0535';
UPDATE recipes SET name = '파간장 두부 비빔밥', description = '보리밥에 두부, 시금치, 느타리버섯을 곁들인 1인분 보리 비빔밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0536';
UPDATE recipes SET name = '깻잎 두부 비빔밥', description = '보리밥에 두부, 시금치, 느타리버섯을 곁들인 1인분 보리 비빔밥. 들기름간장 양념, 깻잎 고명.', calories = 489.0, protein_g = 23.2, carbs_g = 55.8, fat_g = 19.1, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0537';
UPDATE recipes SET name = '김 두부 비빔밥', description = '보리밥에 두부, 시금치, 느타리버섯을 곁들인 1인분 보리 비빔밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0539';
UPDATE recipes SET name = '들깨 두부 비빔밥', description = '보리밥에 두부, 청경채, 양송이버섯을 곁들인 1인분 보리 비빔밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0542';
UPDATE recipes SET name = '간장 두부 비빔밥', description = '보리밥에 두부, 청경채, 양송이버섯을 곁들인 1인분 보리 비빔밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0543';
UPDATE recipes SET name = '마늘 두부 비빔밥', description = '보리밥에 두부, 청경채, 양송이버섯을 곁들인 1인분 보리 비빔밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0544';
UPDATE recipes SET name = '생강간장 두부 비빔밥', description = '보리밥에 두부, 청경채, 양송이버섯을 곁들인 1인분 보리 비빔밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0545';
UPDATE recipes SET name = '파간장 두부 비빔밥', description = '보리밥에 두부, 청경채, 양송이버섯을 곁들인 1인분 보리 비빔밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0546';
UPDATE recipes SET name = '깻잎 두부 비빔밥', description = '보리밥에 두부, 청경채, 양송이버섯을 곁들인 1인분 보리 비빔밥. 들기름간장 양념, 깻잎 고명.', calories = 475.0, protein_g = 22.4, carbs_g = 52.9, fat_g = 19.1, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0547';
UPDATE recipes SET name = '김 두부 비빔밥', description = '보리밥에 두부, 청경채, 양송이버섯을 곁들인 1인분 보리 비빔밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0549';
UPDATE recipes SET name = '들깨 두부 비빔밥', description = '보리밥에 두부, 가지, 토마토를 곁들인 1인분 보리 비빔밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0552';
UPDATE recipes SET name = '간장 두부 비빔밥', description = '보리밥에 두부, 가지, 토마토를 곁들인 1인분 보리 비빔밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0553';
UPDATE recipes SET name = '마늘 두부 비빔밥', description = '보리밥에 두부, 가지, 토마토를 곁들인 1인분 보리 비빔밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0554';
UPDATE recipes SET name = '생강간장 두부 비빔밥', description = '보리밥에 두부, 가지, 토마토를 곁들인 1인분 보리 비빔밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0555';
UPDATE recipes SET name = '파간장 두부 비빔밥', description = '보리밥에 두부, 가지, 토마토를 곁들인 1인분 보리 비빔밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0556';
UPDATE recipes SET name = '깻잎 두부 비빔밥', description = '보리밥에 두부, 가지, 토마토를 곁들인 1인분 보리 비빔밥. 들기름간장 양념, 깻잎 고명.', calories = 481.0, protein_g = 20.5, carbs_g = 56.5, fat_g = 19.1, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0557';
UPDATE recipes SET name = '김 두부 비빔밥', description = '보리밥에 두부, 가지, 토마토를 곁들인 1인분 보리 비빔밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0559';
UPDATE recipes SET name = '들깨 두부 비빔밥', description = '보리밥에 두부, 양배추, 파프리카를 곁들인 1인분 보리 비빔밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0562';
UPDATE recipes SET name = '간장 두부 비빔밥', description = '보리밥에 두부, 양배추, 파프리카를 곁들인 1인분 보리 비빔밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0563';
UPDATE recipes SET name = '마늘 두부 비빔밥', description = '보리밥에 두부, 양배추, 파프리카를 곁들인 1인분 보리 비빔밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0564';
UPDATE recipes SET name = '생강간장 두부 비빔밥', description = '보리밥에 두부, 양배추, 파프리카를 곁들인 1인분 보리 비빔밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0565';
UPDATE recipes SET name = '파간장 두부 비빔밥', description = '보리밥에 두부, 양배추, 파프리카를 곁들인 1인분 보리 비빔밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0566';
UPDATE recipes SET name = '깻잎 두부 비빔밥', description = '보리밥에 두부, 양배추, 파프리카를 곁들인 1인분 보리 비빔밥. 들기름간장 양념, 깻잎 고명.', calories = 483.0, protein_g = 20.4, carbs_g = 57.1, fat_g = 19.1, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0567';
UPDATE recipes SET name = '김 두부 비빔밥', description = '보리밥에 두부, 양배추, 파프리카를 곁들인 1인분 보리 비빔밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0569';
UPDATE recipes SET name = '들깨 두부 비빔밥', description = '보리밥에 두부, 브로콜리, 당근을 곁들인 1인분 보리 비빔밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0572';
UPDATE recipes SET name = '간장 두부 비빔밥', description = '보리밥에 두부, 브로콜리, 당근을 곁들인 1인분 보리 비빔밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0573';
UPDATE recipes SET name = '마늘 두부 비빔밥', description = '보리밥에 두부, 브로콜리, 당근을 곁들인 1인분 보리 비빔밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0574';
UPDATE recipes SET name = '생강간장 두부 비빔밥', description = '보리밥에 두부, 브로콜리, 당근을 곁들인 1인분 보리 비빔밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0575';
UPDATE recipes SET name = '파간장 두부 비빔밥', description = '보리밥에 두부, 브로콜리, 당근을 곁들인 1인분 보리 비빔밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0576';
UPDATE recipes SET name = '깻잎 두부 비빔밥', description = '보리밥에 두부, 브로콜리, 당근을 곁들인 1인분 보리 비빔밥. 들기름간장 양념, 깻잎 고명.', calories = 500.0, protein_g = 22.0, carbs_g = 59.7, fat_g = 19.1, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0577';
UPDATE recipes SET name = '김 두부 비빔밥', description = '보리밥에 두부, 브로콜리, 당근을 곁들인 1인분 보리 비빔밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0579';
UPDATE recipes SET name = '들깨 두부 비빔밥', description = '보리밥에 두부, 애호박, 양송이버섯을 곁들인 1인분 보리 비빔밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0582';
UPDATE recipes SET name = '간장 두부 비빔밥', description = '보리밥에 두부, 애호박, 양송이버섯을 곁들인 1인분 보리 비빔밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0583';
UPDATE recipes SET name = '마늘 두부 비빔밥', description = '보리밥에 두부, 애호박, 양송이버섯을 곁들인 1인분 보리 비빔밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0584';
UPDATE recipes SET name = '생강간장 두부 비빔밥', description = '보리밥에 두부, 애호박, 양송이버섯을 곁들인 1인분 보리 비빔밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0585';
UPDATE recipes SET name = '파간장 두부 비빔밥', description = '보리밥에 두부, 애호박, 양송이버섯을 곁들인 1인분 보리 비빔밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0586';
UPDATE recipes SET name = '깻잎 두부 비빔밥', description = '보리밥에 두부, 애호박, 양송이버섯을 곁들인 1인분 보리 비빔밥. 들기름간장 양념, 깻잎 고명.', calories = 472.0, protein_g = 21.7, carbs_g = 52.9, fat_g = 19.1, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0587';
UPDATE recipes SET name = '김 두부 비빔밥', description = '보리밥에 두부, 애호박, 양송이버섯을 곁들인 1인분 보리 비빔밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0589';
UPDATE recipes SET name = '들깨 두부 비빔밥', description = '보리밥에 두부, 시금치, 토마토를 곁들인 1인분 보리 비빔밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0592';
UPDATE recipes SET name = '간장 두부 비빔밥', description = '보리밥에 두부, 시금치, 토마토를 곁들인 1인분 보리 비빔밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0593';
UPDATE recipes SET name = '마늘 두부 비빔밥', description = '보리밥에 두부, 시금치, 토마토를 곁들인 1인분 보리 비빔밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0594';
UPDATE recipes SET name = '생강간장 두부 비빔밥', description = '보리밥에 두부, 시금치, 토마토를 곁들인 1인분 보리 비빔밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0595';
UPDATE recipes SET name = '파간장 두부 비빔밥', description = '보리밥에 두부, 시금치, 토마토를 곁들인 1인분 보리 비빔밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0596';
UPDATE recipes SET name = '깻잎 두부 비빔밥', description = '보리밥에 두부, 시금치, 토마토를 곁들인 1인분 보리 비빔밥. 들기름간장 양념, 깻잎 고명.', calories = 477.0, protein_g = 21.6, carbs_g = 54.3, fat_g = 19.1, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0597';
UPDATE recipes SET name = '김 두부 비빔밥', description = '보리밥에 두부, 시금치, 토마토를 곁들인 1인분 보리 비빔밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0599';
UPDATE recipes SET name = '들깨 닭가슴살 메밀비빔면', description = '메밀면에 닭가슴살, 양배추, 당근을 곁들인 1인분 메밀 비빔면. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0602';
UPDATE recipes SET name = '간장 닭가슴살 메밀비빔면', description = '메밀면에 닭가슴살, 양배추, 당근을 곁들인 1인분 메밀 비빔면. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0603';
UPDATE recipes SET name = '마늘 닭가슴살 메밀비빔면', description = '메밀면에 닭가슴살, 양배추, 당근을 곁들인 1인분 메밀 비빔면. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0604';
UPDATE recipes SET name = '생강간장 닭가슴살 메밀비빔면', description = '메밀면에 닭가슴살, 양배추, 당근을 곁들인 1인분 메밀 비빔면. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0605';
UPDATE recipes SET name = '파간장 닭가슴살 메밀비빔면', description = '메밀면에 닭가슴살, 양배추, 당근을 곁들인 1인분 메밀 비빔면. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0606';
UPDATE recipes SET name = '깻잎 닭가슴살 메밀비빔면', description = '메밀면에 닭가슴살, 양배추, 당근을 곁들인 1인분 메밀 비빔면. 들기름간장 양념, 깻잎 고명.', calories = 492.0, protein_g = 39.8, carbs_g = 52.9, fat_g = 13.4, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0607';
UPDATE recipes SET name = '김 닭가슴살 메밀비빔면', description = '메밀면에 닭가슴살, 양배추, 당근을 곁들인 1인분 메밀 비빔면. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0609';
UPDATE recipes SET name = '들깨 닭가슴살 메밀비빔면', description = '메밀면에 닭가슴살, 브로콜리, 양파를 곁들인 1인분 메밀 비빔면. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0612';
UPDATE recipes SET name = '간장 닭가슴살 메밀비빔면', description = '메밀면에 닭가슴살, 브로콜리, 양파를 곁들인 1인분 메밀 비빔면. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0613';
UPDATE recipes SET name = '마늘 닭가슴살 메밀비빔면', description = '메밀면에 닭가슴살, 브로콜리, 양파를 곁들인 1인분 메밀 비빔면. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0614';
UPDATE recipes SET name = '생강간장 닭가슴살 메밀비빔면', description = '메밀면에 닭가슴살, 브로콜리, 양파를 곁들인 1인분 메밀 비빔면. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0615';
UPDATE recipes SET name = '파간장 닭가슴살 메밀비빔면', description = '메밀면에 닭가슴살, 브로콜리, 양파를 곁들인 1인분 메밀 비빔면. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0616';
UPDATE recipes SET name = '깻잎 닭가슴살 메밀비빔면', description = '메밀면에 닭가슴살, 브로콜리, 양파를 곁들인 1인분 메밀 비빔면. 들기름간장 양념, 깻잎 고명.', calories = 500.0, protein_g = 41.5, carbs_g = 53.1, fat_g = 13.4, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0617';
UPDATE recipes SET name = '김 닭가슴살 메밀비빔면', description = '메밀면에 닭가슴살, 브로콜리, 양파를 곁들인 1인분 메밀 비빔면. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0619';
UPDATE recipes SET name = '들깨 닭가슴살 메밀비빔면', description = '메밀면에 닭가슴살, 애호박, 파프리카를 곁들인 1인분 메밀 비빔면. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0622';
UPDATE recipes SET name = '간장 닭가슴살 메밀비빔면', description = '메밀면에 닭가슴살, 애호박, 파프리카를 곁들인 1인분 메밀 비빔면. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0623';
UPDATE recipes SET name = '마늘 닭가슴살 메밀비빔면', description = '메밀면에 닭가슴살, 애호박, 파프리카를 곁들인 1인분 메밀 비빔면. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0624';
UPDATE recipes SET name = '생강간장 닭가슴살 메밀비빔면', description = '메밀면에 닭가슴살, 애호박, 파프리카를 곁들인 1인분 메밀 비빔면. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0625';
UPDATE recipes SET name = '파간장 닭가슴살 메밀비빔면', description = '메밀면에 닭가슴살, 애호박, 파프리카를 곁들인 1인분 메밀 비빔면. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0626';
UPDATE recipes SET name = '깻잎 닭가슴살 메밀비빔면', description = '메밀면에 닭가슴살, 애호박, 파프리카를 곁들인 1인분 메밀 비빔면. 들기름간장 양념, 깻잎 고명.', calories = 477.0, protein_g = 39.9, carbs_g = 48.9, fat_g = 13.4, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0627';
UPDATE recipes SET name = '김 닭가슴살 메밀비빔면', description = '메밀면에 닭가슴살, 애호박, 파프리카를 곁들인 1인분 메밀 비빔면. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0629';
UPDATE recipes SET name = '들깨 닭가슴살 메밀비빔면', description = '메밀면에 닭가슴살, 시금치, 느타리버섯을 곁들인 1인분 메밀 비빔면. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0632';
UPDATE recipes SET name = '간장 닭가슴살 메밀비빔면', description = '메밀면에 닭가슴살, 시금치, 느타리버섯을 곁들인 1인분 메밀 비빔면. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0633';
UPDATE recipes SET name = '마늘 닭가슴살 메밀비빔면', description = '메밀면에 닭가슴살, 시금치, 느타리버섯을 곁들인 1인분 메밀 비빔면. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0634';
UPDATE recipes SET name = '생강간장 닭가슴살 메밀비빔면', description = '메밀면에 닭가슴살, 시금치, 느타리버섯을 곁들인 1인분 메밀 비빔면. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0635';
UPDATE recipes SET name = '파간장 닭가슴살 메밀비빔면', description = '메밀면에 닭가슴살, 시금치, 느타리버섯을 곁들인 1인분 메밀 비빔면. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0636';
UPDATE recipes SET name = '깻잎 닭가슴살 메밀비빔면', description = '메밀면에 닭가슴살, 시금치, 느타리버섯을 곁들인 1인분 메밀 비빔면. 들기름간장 양념, 깻잎 고명.', calories = 493.0, protein_g = 42.7, carbs_g = 50.2, fat_g = 13.4, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0637';
UPDATE recipes SET name = '김 닭가슴살 메밀비빔면', description = '메밀면에 닭가슴살, 시금치, 느타리버섯을 곁들인 1인분 메밀 비빔면. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0639';
UPDATE recipes SET name = '들깨 닭가슴살 메밀비빔면', description = '메밀면에 닭가슴살, 청경채, 양송이버섯을 곁들인 1인분 메밀 비빔면. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0642';
UPDATE recipes SET name = '간장 닭가슴살 메밀비빔면', description = '메밀면에 닭가슴살, 청경채, 양송이버섯을 곁들인 1인분 메밀 비빔면. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0643';
UPDATE recipes SET name = '마늘 닭가슴살 메밀비빔면', description = '메밀면에 닭가슴살, 청경채, 양송이버섯을 곁들인 1인분 메밀 비빔면. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0644';
UPDATE recipes SET name = '생강간장 닭가슴살 메밀비빔면', description = '메밀면에 닭가슴살, 청경채, 양송이버섯을 곁들인 1인분 메밀 비빔면. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0645';
UPDATE recipes SET name = '파간장 닭가슴살 메밀비빔면', description = '메밀면에 닭가슴살, 청경채, 양송이버섯을 곁들인 1인분 메밀 비빔면. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0646';
UPDATE recipes SET name = '깻잎 닭가슴살 메밀비빔면', description = '메밀면에 닭가슴살, 청경채, 양송이버섯을 곁들인 1인분 메밀 비빔면. 들기름간장 양념, 깻잎 고명.', calories = 478.0, protein_g = 41.9, carbs_g = 47.3, fat_g = 13.4, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0647';
UPDATE recipes SET name = '김 닭가슴살 메밀비빔면', description = '메밀면에 닭가슴살, 청경채, 양송이버섯을 곁들인 1인분 메밀 비빔면. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0649';
UPDATE recipes SET name = '들깨 닭가슴살 메밀비빔면', description = '메밀면에 닭가슴살, 가지, 토마토를 곁들인 1인분 메밀 비빔면. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0652';
UPDATE recipes SET name = '간장 닭가슴살 메밀비빔면', description = '메밀면에 닭가슴살, 가지, 토마토를 곁들인 1인분 메밀 비빔면. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0653';
UPDATE recipes SET name = '마늘 닭가슴살 메밀비빔면', description = '메밀면에 닭가슴살, 가지, 토마토를 곁들인 1인분 메밀 비빔면. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0654';
UPDATE recipes SET name = '생강간장 닭가슴살 메밀비빔면', description = '메밀면에 닭가슴살, 가지, 토마토를 곁들인 1인분 메밀 비빔면. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0655';
UPDATE recipes SET name = '파간장 닭가슴살 메밀비빔면', description = '메밀면에 닭가슴살, 가지, 토마토를 곁들인 1인분 메밀 비빔면. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0656';
UPDATE recipes SET name = '깻잎 닭가슴살 메밀비빔면', description = '메밀면에 닭가슴살, 가지, 토마토를 곁들인 1인분 메밀 비빔면. 들기름간장 양념, 깻잎 고명.', calories = 485.0, protein_g = 40.0, carbs_g = 50.9, fat_g = 13.4, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0657';
UPDATE recipes SET name = '김 닭가슴살 메밀비빔면', description = '메밀면에 닭가슴살, 가지, 토마토를 곁들인 1인분 메밀 비빔면. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0659';
UPDATE recipes SET name = '들깨 닭가슴살 메밀비빔면', description = '메밀면에 닭가슴살, 양배추, 파프리카를 곁들인 1인분 메밀 비빔면. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0662';
UPDATE recipes SET name = '간장 닭가슴살 메밀비빔면', description = '메밀면에 닭가슴살, 양배추, 파프리카를 곁들인 1인분 메밀 비빔면. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0663';
UPDATE recipes SET name = '마늘 닭가슴살 메밀비빔면', description = '메밀면에 닭가슴살, 양배추, 파프리카를 곁들인 1인분 메밀 비빔면. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0664';
UPDATE recipes SET name = '생강간장 닭가슴살 메밀비빔면', description = '메밀면에 닭가슴살, 양배추, 파프리카를 곁들인 1인분 메밀 비빔면. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0665';
UPDATE recipes SET name = '파간장 닭가슴살 메밀비빔면', description = '메밀면에 닭가슴살, 양배추, 파프리카를 곁들인 1인분 메밀 비빔면. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0666';
UPDATE recipes SET name = '깻잎 닭가슴살 메밀비빔면', description = '메밀면에 닭가슴살, 양배추, 파프리카를 곁들인 1인분 메밀 비빔면. 들기름간장 양념, 깻잎 고명.', calories = 487.0, protein_g = 39.9, carbs_g = 51.5, fat_g = 13.4, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0667';
UPDATE recipes SET name = '김 닭가슴살 메밀비빔면', description = '메밀면에 닭가슴살, 양배추, 파프리카를 곁들인 1인분 메밀 비빔면. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0669';
UPDATE recipes SET name = '들깨 닭가슴살 메밀비빔면', description = '메밀면에 닭가슴살, 브로콜리, 당근을 곁들인 1인분 메밀 비빔면. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0672';
UPDATE recipes SET name = '간장 닭가슴살 메밀비빔면', description = '메밀면에 닭가슴살, 브로콜리, 당근을 곁들인 1인분 메밀 비빔면. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0673';
UPDATE recipes SET name = '마늘 닭가슴살 메밀비빔면', description = '메밀면에 닭가슴살, 브로콜리, 당근을 곁들인 1인분 메밀 비빔면. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0674';
UPDATE recipes SET name = '생강간장 닭가슴살 메밀비빔면', description = '메밀면에 닭가슴살, 브로콜리, 당근을 곁들인 1인분 메밀 비빔면. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0675';
UPDATE recipes SET name = '파간장 닭가슴살 메밀비빔면', description = '메밀면에 닭가슴살, 브로콜리, 당근을 곁들인 1인분 메밀 비빔면. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0676';
UPDATE recipes SET name = '깻잎 닭가슴살 메밀비빔면', description = '메밀면에 닭가슴살, 브로콜리, 당근을 곁들인 1인분 메밀 비빔면. 들기름간장 양념, 깻잎 고명.', calories = 504.0, protein_g = 41.5, carbs_g = 54.0, fat_g = 13.4, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0677';
UPDATE recipes SET name = '김 닭가슴살 메밀비빔면', description = '메밀면에 닭가슴살, 브로콜리, 당근을 곁들인 1인분 메밀 비빔면. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0679';
UPDATE recipes SET name = '들깨 닭가슴살 메밀비빔면', description = '메밀면에 닭가슴살, 애호박, 양송이버섯을 곁들인 1인분 메밀 비빔면. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0682';
UPDATE recipes SET name = '간장 닭가슴살 메밀비빔면', description = '메밀면에 닭가슴살, 애호박, 양송이버섯을 곁들인 1인분 메밀 비빔면. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0683';
UPDATE recipes SET name = '마늘 닭가슴살 메밀비빔면', description = '메밀면에 닭가슴살, 애호박, 양송이버섯을 곁들인 1인분 메밀 비빔면. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0684';
UPDATE recipes SET name = '생강간장 닭가슴살 메밀비빔면', description = '메밀면에 닭가슴살, 애호박, 양송이버섯을 곁들인 1인분 메밀 비빔면. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0685';
UPDATE recipes SET name = '파간장 닭가슴살 메밀비빔면', description = '메밀면에 닭가슴살, 애호박, 양송이버섯을 곁들인 1인분 메밀 비빔면. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0686';
UPDATE recipes SET name = '깻잎 닭가슴살 메밀비빔면', description = '메밀면에 닭가슴살, 애호박, 양송이버섯을 곁들인 1인분 메밀 비빔면. 들기름간장 양념, 깻잎 고명.', calories = 475.0, protein_g = 41.2, carbs_g = 47.3, fat_g = 13.4, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0687';
UPDATE recipes SET name = '김 닭가슴살 메밀비빔면', description = '메밀면에 닭가슴살, 애호박, 양송이버섯을 곁들인 1인분 메밀 비빔면. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0689';
UPDATE recipes SET name = '들깨 닭가슴살 메밀비빔면', description = '메밀면에 닭가슴살, 시금치, 토마토를 곁들인 1인분 메밀 비빔면. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0692';
UPDATE recipes SET name = '간장 닭가슴살 메밀비빔면', description = '메밀면에 닭가슴살, 시금치, 토마토를 곁들인 1인분 메밀 비빔면. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0693';
UPDATE recipes SET name = '마늘 닭가슴살 메밀비빔면', description = '메밀면에 닭가슴살, 시금치, 토마토를 곁들인 1인분 메밀 비빔면. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0694';
UPDATE recipes SET name = '생강간장 닭가슴살 메밀비빔면', description = '메밀면에 닭가슴살, 시금치, 토마토를 곁들인 1인분 메밀 비빔면. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0695';
UPDATE recipes SET name = '파간장 닭가슴살 메밀비빔면', description = '메밀면에 닭가슴살, 시금치, 토마토를 곁들인 1인분 메밀 비빔면. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0696';
UPDATE recipes SET name = '깻잎 닭가슴살 메밀비빔면', description = '메밀면에 닭가슴살, 시금치, 토마토를 곁들인 1인분 메밀 비빔면. 들기름간장 양념, 깻잎 고명.', calories = 481.0, protein_g = 41.1, carbs_g = 48.7, fat_g = 13.4, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0697';
UPDATE recipes SET name = '김 닭가슴살 메밀비빔면', description = '메밀면에 닭가슴살, 시금치, 토마토를 곁들인 1인분 메밀 비빔면. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0699';
UPDATE recipes SET name = '들깨 새우 덮밥', description = '잡곡밥에 새우, 양배추, 당근을 곁들인 1인분 잡곡 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0702';
UPDATE recipes SET name = '간장 새우 덮밥', description = '잡곡밥에 새우, 양배추, 당근을 곁들인 1인분 잡곡 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0703';
UPDATE recipes SET name = '마늘 새우 덮밥', description = '잡곡밥에 새우, 양배추, 당근을 곁들인 1인분 잡곡 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0704';
UPDATE recipes SET name = '생강간장 새우 덮밥', description = '잡곡밥에 새우, 양배추, 당근을 곁들인 1인분 잡곡 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0705';
UPDATE recipes SET name = '파간장 새우 덮밥', description = '잡곡밥에 새우, 양배추, 당근을 곁들인 1인분 잡곡 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0706';
UPDATE recipes SET name = '깻잎 새우 덮밥', description = '잡곡밥에 새우, 양배추, 당근을 곁들인 1인분 잡곡 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 472.0, protein_g = 37.0, carbs_g = 53.7, fat_g = 12.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0707';
UPDATE recipes SET name = '김 새우 덮밥', description = '잡곡밥에 새우, 양배추, 당근을 곁들인 1인분 잡곡 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0709';
UPDATE recipes SET name = '들깨 새우 덮밥', description = '잡곡밥에 새우, 브로콜리, 양파를 곁들인 1인분 잡곡 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0712';
UPDATE recipes SET name = '간장 새우 덮밥', description = '잡곡밥에 새우, 브로콜리, 양파를 곁들인 1인분 잡곡 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0713';
UPDATE recipes SET name = '마늘 새우 덮밥', description = '잡곡밥에 새우, 브로콜리, 양파를 곁들인 1인분 잡곡 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0714';
UPDATE recipes SET name = '생강간장 새우 덮밥', description = '잡곡밥에 새우, 브로콜리, 양파를 곁들인 1인분 잡곡 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0715';
UPDATE recipes SET name = '파간장 새우 덮밥', description = '잡곡밥에 새우, 브로콜리, 양파를 곁들인 1인분 잡곡 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0716';
UPDATE recipes SET name = '깻잎 새우 덮밥', description = '잡곡밥에 새우, 브로콜리, 양파를 곁들인 1인분 잡곡 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 480.0, protein_g = 38.7, carbs_g = 53.9, fat_g = 12.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0717';
UPDATE recipes SET name = '김 새우 덮밥', description = '잡곡밥에 새우, 브로콜리, 양파를 곁들인 1인분 잡곡 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0719';
UPDATE recipes SET name = '들깨 새우 덮밥', description = '잡곡밥에 새우, 애호박, 파프리카를 곁들인 1인분 잡곡 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0722';
UPDATE recipes SET name = '간장 새우 덮밥', description = '잡곡밥에 새우, 애호박, 파프리카를 곁들인 1인분 잡곡 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0723';
UPDATE recipes SET name = '마늘 새우 덮밥', description = '잡곡밥에 새우, 애호박, 파프리카를 곁들인 1인분 잡곡 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0724';
UPDATE recipes SET name = '생강간장 새우 덮밥', description = '잡곡밥에 새우, 애호박, 파프리카를 곁들인 1인분 잡곡 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0725';
UPDATE recipes SET name = '파간장 새우 덮밥', description = '잡곡밥에 새우, 애호박, 파프리카를 곁들인 1인분 잡곡 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0726';
UPDATE recipes SET name = '깻잎 새우 덮밥', description = '잡곡밥에 새우, 애호박, 파프리카를 곁들인 1인분 잡곡 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 457.0, protein_g = 37.1, carbs_g = 49.8, fat_g = 12.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0727';
UPDATE recipes SET name = '김 새우 덮밥', description = '잡곡밥에 새우, 애호박, 파프리카를 곁들인 1인분 잡곡 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0729';
UPDATE recipes SET name = '들깨 새우 덮밥', description = '잡곡밥에 새우, 시금치, 느타리버섯을 곁들인 1인분 잡곡 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0732';
UPDATE recipes SET name = '간장 새우 덮밥', description = '잡곡밥에 새우, 시금치, 느타리버섯을 곁들인 1인분 잡곡 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0733';
UPDATE recipes SET name = '마늘 새우 덮밥', description = '잡곡밥에 새우, 시금치, 느타리버섯을 곁들인 1인분 잡곡 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0734';
UPDATE recipes SET name = '생강간장 새우 덮밥', description = '잡곡밥에 새우, 시금치, 느타리버섯을 곁들인 1인분 잡곡 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0735';
UPDATE recipes SET name = '파간장 새우 덮밥', description = '잡곡밥에 새우, 시금치, 느타리버섯을 곁들인 1인분 잡곡 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0736';
UPDATE recipes SET name = '깻잎 새우 덮밥', description = '잡곡밥에 새우, 시금치, 느타리버섯을 곁들인 1인분 잡곡 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 473.0, protein_g = 39.9, carbs_g = 51.0, fat_g = 12.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0737';
UPDATE recipes SET name = '김 새우 덮밥', description = '잡곡밥에 새우, 시금치, 느타리버섯을 곁들인 1인분 잡곡 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0739';
UPDATE recipes SET name = '들깨 새우 덮밥', description = '잡곡밥에 새우, 청경채, 양송이버섯을 곁들인 1인분 잡곡 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0742';
UPDATE recipes SET name = '간장 새우 덮밥', description = '잡곡밥에 새우, 청경채, 양송이버섯을 곁들인 1인분 잡곡 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0743';
UPDATE recipes SET name = '마늘 새우 덮밥', description = '잡곡밥에 새우, 청경채, 양송이버섯을 곁들인 1인분 잡곡 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0744';
UPDATE recipes SET name = '생강간장 새우 덮밥', description = '잡곡밥에 새우, 청경채, 양송이버섯을 곁들인 1인분 잡곡 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0745';
UPDATE recipes SET name = '파간장 새우 덮밥', description = '잡곡밥에 새우, 청경채, 양송이버섯을 곁들인 1인분 잡곡 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0746';
UPDATE recipes SET name = '깻잎 새우 덮밥', description = '잡곡밥에 새우, 청경채, 양송이버섯을 곁들인 1인분 잡곡 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 458.0, protein_g = 39.1, carbs_g = 48.1, fat_g = 12.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0747';
UPDATE recipes SET name = '김 새우 덮밥', description = '잡곡밥에 새우, 청경채, 양송이버섯을 곁들인 1인분 잡곡 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0749';
UPDATE recipes SET name = '들깨 새우 덮밥', description = '잡곡밥에 새우, 가지, 토마토를 곁들인 1인분 잡곡 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0752';
UPDATE recipes SET name = '간장 새우 덮밥', description = '잡곡밥에 새우, 가지, 토마토를 곁들인 1인분 잡곡 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0753';
UPDATE recipes SET name = '마늘 새우 덮밥', description = '잡곡밥에 새우, 가지, 토마토를 곁들인 1인분 잡곡 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0754';
UPDATE recipes SET name = '생강간장 새우 덮밥', description = '잡곡밥에 새우, 가지, 토마토를 곁들인 1인분 잡곡 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0755';
UPDATE recipes SET name = '파간장 새우 덮밥', description = '잡곡밥에 새우, 가지, 토마토를 곁들인 1인분 잡곡 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0756';
UPDATE recipes SET name = '깻잎 새우 덮밥', description = '잡곡밥에 새우, 가지, 토마토를 곁들인 1인분 잡곡 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 465.0, protein_g = 37.2, carbs_g = 51.7, fat_g = 12.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0757';
UPDATE recipes SET name = '김 새우 덮밥', description = '잡곡밥에 새우, 가지, 토마토를 곁들인 1인분 잡곡 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0759';
UPDATE recipes SET name = '들깨 새우 덮밥', description = '잡곡밥에 새우, 양배추, 파프리카를 곁들인 1인분 잡곡 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0762';
UPDATE recipes SET name = '간장 새우 덮밥', description = '잡곡밥에 새우, 양배추, 파프리카를 곁들인 1인분 잡곡 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0763';
UPDATE recipes SET name = '마늘 새우 덮밥', description = '잡곡밥에 새우, 양배추, 파프리카를 곁들인 1인분 잡곡 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0764';
UPDATE recipes SET name = '생강간장 새우 덮밥', description = '잡곡밥에 새우, 양배추, 파프리카를 곁들인 1인분 잡곡 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0765';
UPDATE recipes SET name = '파간장 새우 덮밥', description = '잡곡밥에 새우, 양배추, 파프리카를 곁들인 1인분 잡곡 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0766';
UPDATE recipes SET name = '깻잎 새우 덮밥', description = '잡곡밥에 새우, 양배추, 파프리카를 곁들인 1인분 잡곡 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 467.0, protein_g = 37.1, carbs_g = 52.3, fat_g = 12.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0767';
UPDATE recipes SET name = '김 새우 덮밥', description = '잡곡밥에 새우, 양배추, 파프리카를 곁들인 1인분 잡곡 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0769';
UPDATE recipes SET name = '들깨 새우 덮밥', description = '잡곡밥에 새우, 브로콜리, 당근을 곁들인 1인분 잡곡 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0772';
UPDATE recipes SET name = '간장 새우 덮밥', description = '잡곡밥에 새우, 브로콜리, 당근을 곁들인 1인분 잡곡 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0773';
UPDATE recipes SET name = '마늘 새우 덮밥', description = '잡곡밥에 새우, 브로콜리, 당근을 곁들인 1인분 잡곡 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0774';
UPDATE recipes SET name = '생강간장 새우 덮밥', description = '잡곡밥에 새우, 브로콜리, 당근을 곁들인 1인분 잡곡 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0775';
UPDATE recipes SET name = '파간장 새우 덮밥', description = '잡곡밥에 새우, 브로콜리, 당근을 곁들인 1인분 잡곡 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0776';
UPDATE recipes SET name = '깻잎 새우 덮밥', description = '잡곡밥에 새우, 브로콜리, 당근을 곁들인 1인분 잡곡 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 484.0, protein_g = 38.7, carbs_g = 54.9, fat_g = 12.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0777';
UPDATE recipes SET name = '김 새우 덮밥', description = '잡곡밥에 새우, 브로콜리, 당근을 곁들인 1인분 잡곡 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0779';
UPDATE recipes SET name = '들깨 새우 덮밥', description = '잡곡밥에 새우, 애호박, 양송이버섯을 곁들인 1인분 잡곡 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0782';
UPDATE recipes SET name = '간장 새우 덮밥', description = '잡곡밥에 새우, 애호박, 양송이버섯을 곁들인 1인분 잡곡 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0783';
UPDATE recipes SET name = '마늘 새우 덮밥', description = '잡곡밥에 새우, 애호박, 양송이버섯을 곁들인 1인분 잡곡 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0784';
UPDATE recipes SET name = '생강간장 새우 덮밥', description = '잡곡밥에 새우, 애호박, 양송이버섯을 곁들인 1인분 잡곡 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0785';
UPDATE recipes SET name = '파간장 새우 덮밥', description = '잡곡밥에 새우, 애호박, 양송이버섯을 곁들인 1인분 잡곡 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0786';
UPDATE recipes SET name = '깻잎 새우 덮밥', description = '잡곡밥에 새우, 애호박, 양송이버섯을 곁들인 1인분 잡곡 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 455.0, protein_g = 38.4, carbs_g = 48.1, fat_g = 12.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0787';
UPDATE recipes SET name = '김 새우 덮밥', description = '잡곡밥에 새우, 애호박, 양송이버섯을 곁들인 1인분 잡곡 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0789';
UPDATE recipes SET name = '들깨 새우 덮밥', description = '잡곡밥에 새우, 시금치, 토마토를 곁들인 1인분 잡곡 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0792';
UPDATE recipes SET name = '간장 새우 덮밥', description = '잡곡밥에 새우, 시금치, 토마토를 곁들인 1인분 잡곡 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0793';
UPDATE recipes SET name = '마늘 새우 덮밥', description = '잡곡밥에 새우, 시금치, 토마토를 곁들인 1인분 잡곡 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0794';
UPDATE recipes SET name = '생강간장 새우 덮밥', description = '잡곡밥에 새우, 시금치, 토마토를 곁들인 1인분 잡곡 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0795';
UPDATE recipes SET name = '파간장 새우 덮밥', description = '잡곡밥에 새우, 시금치, 토마토를 곁들인 1인분 잡곡 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0796';
UPDATE recipes SET name = '깻잎 새우 덮밥', description = '잡곡밥에 새우, 시금치, 토마토를 곁들인 1인분 잡곡 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 461.0, protein_g = 38.3, carbs_g = 49.5, fat_g = 12.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0797';
UPDATE recipes SET name = '김 새우 덮밥', description = '잡곡밥에 새우, 시금치, 토마토를 곁들인 1인분 잡곡 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0799';
UPDATE recipes SET name = '들깨 병아리콩 덮밥', description = '현미밥에 병아리콩, 양배추, 당근을 곁들인 1인분 현미 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0802';
UPDATE recipes SET name = '간장 병아리콩 덮밥', description = '현미밥에 병아리콩, 양배추, 당근을 곁들인 1인분 현미 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0803';
UPDATE recipes SET name = '마늘 병아리콩 덮밥', description = '현미밥에 병아리콩, 양배추, 당근을 곁들인 1인분 현미 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0804';
UPDATE recipes SET name = '생강간장 병아리콩 덮밥', description = '현미밥에 병아리콩, 양배추, 당근을 곁들인 1인분 현미 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0805';
UPDATE recipes SET name = '파간장 병아리콩 덮밥', description = '현미밥에 병아리콩, 양배추, 당근을 곁들인 1인분 현미 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0806';
UPDATE recipes SET name = '깻잎 병아리콩 덮밥', description = '현미밥에 병아리콩, 양배추, 당근을 곁들인 1인분 현미 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 551.0, protein_g = 19.8, carbs_g = 88.3, fat_g = 13.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0807';
UPDATE recipes SET name = '김 병아리콩 덮밥', description = '현미밥에 병아리콩, 양배추, 당근을 곁들인 1인분 현미 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0809';
UPDATE recipes SET name = '들깨 병아리콩 덮밥', description = '현미밥에 병아리콩, 브로콜리, 양파를 곁들인 1인분 현미 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0812';
UPDATE recipes SET name = '간장 병아리콩 덮밥', description = '현미밥에 병아리콩, 브로콜리, 양파를 곁들인 1인분 현미 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0813';
UPDATE recipes SET name = '마늘 병아리콩 덮밥', description = '현미밥에 병아리콩, 브로콜리, 양파를 곁들인 1인분 현미 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0814';
UPDATE recipes SET name = '생강간장 병아리콩 덮밥', description = '현미밥에 병아리콩, 브로콜리, 양파를 곁들인 1인분 현미 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0815';
UPDATE recipes SET name = '파간장 병아리콩 덮밥', description = '현미밥에 병아리콩, 브로콜리, 양파를 곁들인 1인분 현미 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0816';
UPDATE recipes SET name = '깻잎 병아리콩 덮밥', description = '현미밥에 병아리콩, 브로콜리, 양파를 곁들인 1인분 현미 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 558.0, protein_g = 21.5, carbs_g = 88.5, fat_g = 13.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0817';
UPDATE recipes SET name = '김 병아리콩 덮밥', description = '현미밥에 병아리콩, 브로콜리, 양파를 곁들인 1인분 현미 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0819';
UPDATE recipes SET name = '들깨 병아리콩 덮밥', description = '현미밥에 병아리콩, 애호박, 파프리카를 곁들인 1인분 현미 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0822';
UPDATE recipes SET name = '간장 병아리콩 덮밥', description = '현미밥에 병아리콩, 애호박, 파프리카를 곁들인 1인분 현미 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0823';
UPDATE recipes SET name = '마늘 병아리콩 덮밥', description = '현미밥에 병아리콩, 애호박, 파프리카를 곁들인 1인분 현미 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0824';
UPDATE recipes SET name = '생강간장 병아리콩 덮밥', description = '현미밥에 병아리콩, 애호박, 파프리카를 곁들인 1인분 현미 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0825';
UPDATE recipes SET name = '파간장 병아리콩 덮밥', description = '현미밥에 병아리콩, 애호박, 파프리카를 곁들인 1인분 현미 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0826';
UPDATE recipes SET name = '깻잎 병아리콩 덮밥', description = '현미밥에 병아리콩, 애호박, 파프리카를 곁들인 1인분 현미 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 535.0, protein_g = 19.9, carbs_g = 84.4, fat_g = 13.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0827';
UPDATE recipes SET name = '김 병아리콩 덮밥', description = '현미밥에 병아리콩, 애호박, 파프리카를 곁들인 1인분 현미 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0829';
UPDATE recipes SET name = '들깨 병아리콩 덮밥', description = '현미밥에 병아리콩, 시금치, 느타리버섯을 곁들인 1인분 현미 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0832';
UPDATE recipes SET name = '간장 병아리콩 덮밥', description = '현미밥에 병아리콩, 시금치, 느타리버섯을 곁들인 1인분 현미 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0833';
UPDATE recipes SET name = '마늘 병아리콩 덮밥', description = '현미밥에 병아리콩, 시금치, 느타리버섯을 곁들인 1인분 현미 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0834';
UPDATE recipes SET name = '생강간장 병아리콩 덮밥', description = '현미밥에 병아리콩, 시금치, 느타리버섯을 곁들인 1인분 현미 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0835';
UPDATE recipes SET name = '파간장 병아리콩 덮밥', description = '현미밥에 병아리콩, 시금치, 느타리버섯을 곁들인 1인분 현미 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0836';
UPDATE recipes SET name = '깻잎 병아리콩 덮밥', description = '현미밥에 병아리콩, 시금치, 느타리버섯을 곁들인 1인분 현미 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 552.0, protein_g = 22.7, carbs_g = 85.6, fat_g = 13.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0837';
UPDATE recipes SET name = '김 병아리콩 덮밥', description = '현미밥에 병아리콩, 시금치, 느타리버섯을 곁들인 1인분 현미 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0839';
UPDATE recipes SET name = '들깨 병아리콩 덮밥', description = '현미밥에 병아리콩, 청경채, 양송이버섯을 곁들인 1인분 현미 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0842';
UPDATE recipes SET name = '간장 병아리콩 덮밥', description = '현미밥에 병아리콩, 청경채, 양송이버섯을 곁들인 1인분 현미 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0843';
UPDATE recipes SET name = '마늘 병아리콩 덮밥', description = '현미밥에 병아리콩, 청경채, 양송이버섯을 곁들인 1인분 현미 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0844';
UPDATE recipes SET name = '생강간장 병아리콩 덮밥', description = '현미밥에 병아리콩, 청경채, 양송이버섯을 곁들인 1인분 현미 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0845';
UPDATE recipes SET name = '파간장 병아리콩 덮밥', description = '현미밥에 병아리콩, 청경채, 양송이버섯을 곁들인 1인분 현미 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0846';
UPDATE recipes SET name = '깻잎 병아리콩 덮밥', description = '현미밥에 병아리콩, 청경채, 양송이버섯을 곁들인 1인분 현미 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 537.0, protein_g = 21.9, carbs_g = 82.7, fat_g = 13.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0847';
UPDATE recipes SET name = '김 병아리콩 덮밥', description = '현미밥에 병아리콩, 청경채, 양송이버섯을 곁들인 1인분 현미 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0849';
UPDATE recipes SET name = '들깨 병아리콩 덮밥', description = '현미밥에 병아리콩, 가지, 토마토를 곁들인 1인분 현미 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0852';
UPDATE recipes SET name = '간장 병아리콩 덮밥', description = '현미밥에 병아리콩, 가지, 토마토를 곁들인 1인분 현미 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0853';
UPDATE recipes SET name = '마늘 병아리콩 덮밥', description = '현미밥에 병아리콩, 가지, 토마토를 곁들인 1인분 현미 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0854';
UPDATE recipes SET name = '생강간장 병아리콩 덮밥', description = '현미밥에 병아리콩, 가지, 토마토를 곁들인 1인분 현미 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0855';
UPDATE recipes SET name = '파간장 병아리콩 덮밥', description = '현미밥에 병아리콩, 가지, 토마토를 곁들인 1인분 현미 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0856';
UPDATE recipes SET name = '깻잎 병아리콩 덮밥', description = '현미밥에 병아리콩, 가지, 토마토를 곁들인 1인분 현미 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 544.0, protein_g = 20.0, carbs_g = 86.3, fat_g = 13.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0857';
UPDATE recipes SET name = '김 병아리콩 덮밥', description = '현미밥에 병아리콩, 가지, 토마토를 곁들인 1인분 현미 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0859';
UPDATE recipes SET name = '들깨 병아리콩 덮밥', description = '현미밥에 병아리콩, 양배추, 파프리카를 곁들인 1인분 현미 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0862';
UPDATE recipes SET name = '간장 병아리콩 덮밥', description = '현미밥에 병아리콩, 양배추, 파프리카를 곁들인 1인분 현미 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0863';
UPDATE recipes SET name = '마늘 병아리콩 덮밥', description = '현미밥에 병아리콩, 양배추, 파프리카를 곁들인 1인분 현미 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0864';
UPDATE recipes SET name = '생강간장 병아리콩 덮밥', description = '현미밥에 병아리콩, 양배추, 파프리카를 곁들인 1인분 현미 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0865';
UPDATE recipes SET name = '파간장 병아리콩 덮밥', description = '현미밥에 병아리콩, 양배추, 파프리카를 곁들인 1인분 현미 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0866';
UPDATE recipes SET name = '깻잎 병아리콩 덮밥', description = '현미밥에 병아리콩, 양배추, 파프리카를 곁들인 1인분 현미 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 546.0, protein_g = 19.9, carbs_g = 86.9, fat_g = 13.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0867';
UPDATE recipes SET name = '김 병아리콩 덮밥', description = '현미밥에 병아리콩, 양배추, 파프리카를 곁들인 1인분 현미 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0869';
UPDATE recipes SET name = '들깨 병아리콩 덮밥', description = '현미밥에 병아리콩, 브로콜리, 당근을 곁들인 1인분 현미 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0872';
UPDATE recipes SET name = '간장 병아리콩 덮밥', description = '현미밥에 병아리콩, 브로콜리, 당근을 곁들인 1인분 현미 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0873';
UPDATE recipes SET name = '마늘 병아리콩 덮밥', description = '현미밥에 병아리콩, 브로콜리, 당근을 곁들인 1인분 현미 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0874';
UPDATE recipes SET name = '생강간장 병아리콩 덮밥', description = '현미밥에 병아리콩, 브로콜리, 당근을 곁들인 1인분 현미 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0875';
UPDATE recipes SET name = '파간장 병아리콩 덮밥', description = '현미밥에 병아리콩, 브로콜리, 당근을 곁들인 1인분 현미 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0876';
UPDATE recipes SET name = '깻잎 병아리콩 덮밥', description = '현미밥에 병아리콩, 브로콜리, 당근을 곁들인 1인분 현미 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 562.0, protein_g = 21.5, carbs_g = 89.5, fat_g = 13.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0877';
UPDATE recipes SET name = '김 병아리콩 덮밥', description = '현미밥에 병아리콩, 브로콜리, 당근을 곁들인 1인분 현미 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0879';
UPDATE recipes SET name = '들깨 병아리콩 덮밥', description = '현미밥에 병아리콩, 애호박, 양송이버섯을 곁들인 1인분 현미 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0882';
UPDATE recipes SET name = '간장 병아리콩 덮밥', description = '현미밥에 병아리콩, 애호박, 양송이버섯을 곁들인 1인분 현미 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0883';
UPDATE recipes SET name = '마늘 병아리콩 덮밥', description = '현미밥에 병아리콩, 애호박, 양송이버섯을 곁들인 1인분 현미 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0884';
UPDATE recipes SET name = '생강간장 병아리콩 덮밥', description = '현미밥에 병아리콩, 애호박, 양송이버섯을 곁들인 1인분 현미 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0885';
UPDATE recipes SET name = '파간장 병아리콩 덮밥', description = '현미밥에 병아리콩, 애호박, 양송이버섯을 곁들인 1인분 현미 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0886';
UPDATE recipes SET name = '깻잎 병아리콩 덮밥', description = '현미밥에 병아리콩, 애호박, 양송이버섯을 곁들인 1인분 현미 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 534.0, protein_g = 21.2, carbs_g = 82.7, fat_g = 13.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0887';
UPDATE recipes SET name = '김 병아리콩 덮밥', description = '현미밥에 병아리콩, 애호박, 양송이버섯을 곁들인 1인분 현미 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0889';
UPDATE recipes SET name = '들깨 병아리콩 덮밥', description = '현미밥에 병아리콩, 시금치, 토마토를 곁들인 1인분 현미 덮밥. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0892';
UPDATE recipes SET name = '간장 병아리콩 덮밥', description = '현미밥에 병아리콩, 시금치, 토마토를 곁들인 1인분 현미 덮밥. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0893';
UPDATE recipes SET name = '마늘 병아리콩 덮밥', description = '현미밥에 병아리콩, 시금치, 토마토를 곁들인 1인분 현미 덮밥. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0894';
UPDATE recipes SET name = '생강간장 병아리콩 덮밥', description = '현미밥에 병아리콩, 시금치, 토마토를 곁들인 1인분 현미 덮밥. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0895';
UPDATE recipes SET name = '파간장 병아리콩 덮밥', description = '현미밥에 병아리콩, 시금치, 토마토를 곁들인 1인분 현미 덮밥. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0896';
UPDATE recipes SET name = '깻잎 병아리콩 덮밥', description = '현미밥에 병아리콩, 시금치, 토마토를 곁들인 1인분 현미 덮밥. 들기름간장 양념, 깻잎 고명.', calories = 539.0, protein_g = 21.1, carbs_g = 84.1, fat_g = 13.0, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0897';
UPDATE recipes SET name = '김 병아리콩 덮밥', description = '현미밥에 병아리콩, 시금치, 토마토를 곁들인 1인분 현미 덮밥. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0899';
UPDATE recipes SET name = '레몬 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 양배추, 당근을 곁들인 1인분 고구마 볼. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0901';
UPDATE recipes SET name = '들깨 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 양배추, 당근을 곁들인 1인분 고구마 볼. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0902';
UPDATE recipes SET name = '간장 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 양배추, 당근을 곁들인 1인분 고구마 볼. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0903';
UPDATE recipes SET name = '마늘 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 양배추, 당근을 곁들인 1인분 고구마 볼. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0904';
UPDATE recipes SET name = '생강간장 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 양배추, 당근을 곁들인 1인분 고구마 볼. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0905';
UPDATE recipes SET name = '파간장 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 양배추, 당근을 곁들인 1인분 고구마 볼. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0906';
UPDATE recipes SET name = '깻잎 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 양배추, 당근을 곁들인 1인분 고구마 볼. 레몬올리브 양념, 깻잎 고명.', calories = 442.0, protein_g = 18.3, carbs_g = 75.3, fat_g = 7.6, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0907';
UPDATE recipes SET name = '바질 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 양배추, 당근을 곁들인 1인분 고구마 볼. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0908';
UPDATE recipes SET name = '김 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 양배추, 당근을 곁들인 1인분 고구마 볼. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0909';
UPDATE recipes SET name = '허브 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 양배추, 당근을 곁들인 1인분 고구마 볼. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0910';
UPDATE recipes SET name = '레몬 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 브로콜리, 양파를 곁들인 1인분 고구마 볼. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0911';
UPDATE recipes SET name = '들깨 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 브로콜리, 양파를 곁들인 1인분 고구마 볼. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0912';
UPDATE recipes SET name = '간장 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 브로콜리, 양파를 곁들인 1인분 고구마 볼. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0913';
UPDATE recipes SET name = '마늘 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 브로콜리, 양파를 곁들인 1인분 고구마 볼. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0914';
UPDATE recipes SET name = '생강간장 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 브로콜리, 양파를 곁들인 1인분 고구마 볼. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0915';
UPDATE recipes SET name = '파간장 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 브로콜리, 양파를 곁들인 1인분 고구마 볼. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0916';
UPDATE recipes SET name = '깻잎 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 브로콜리, 양파를 곁들인 1인분 고구마 볼. 레몬올리브 양념, 깻잎 고명.', calories = 450.0, protein_g = 20.0, carbs_g = 75.5, fat_g = 7.6, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0917';
UPDATE recipes SET name = '바질 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 브로콜리, 양파를 곁들인 1인분 고구마 볼. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0918';
UPDATE recipes SET name = '김 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 브로콜리, 양파를 곁들인 1인분 고구마 볼. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0919';
UPDATE recipes SET name = '허브 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 브로콜리, 양파를 곁들인 1인분 고구마 볼. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0920';
UPDATE recipes SET name = '레몬 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 애호박, 파프리카를 곁들인 1인분 고구마 볼. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0921';
UPDATE recipes SET name = '들깨 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 애호박, 파프리카를 곁들인 1인분 고구마 볼. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0922';
UPDATE recipes SET name = '간장 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 애호박, 파프리카를 곁들인 1인분 고구마 볼. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0923';
UPDATE recipes SET name = '마늘 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 애호박, 파프리카를 곁들인 1인분 고구마 볼. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0924';
UPDATE recipes SET name = '생강간장 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 애호박, 파프리카를 곁들인 1인분 고구마 볼. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0925';
UPDATE recipes SET name = '파간장 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 애호박, 파프리카를 곁들인 1인분 고구마 볼. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0926';
UPDATE recipes SET name = '깻잎 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 애호박, 파프리카를 곁들인 1인분 고구마 볼. 레몬올리브 양념, 깻잎 고명.', calories = 427.0, protein_g = 18.4, carbs_g = 71.3, fat_g = 7.6, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0927';
UPDATE recipes SET name = '바질 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 애호박, 파프리카를 곁들인 1인분 고구마 볼. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0928';
UPDATE recipes SET name = '김 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 애호박, 파프리카를 곁들인 1인분 고구마 볼. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0929';
UPDATE recipes SET name = '허브 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 애호박, 파프리카를 곁들인 1인분 고구마 볼. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0930';
UPDATE recipes SET name = '레몬 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 시금치, 느타리버섯을 곁들인 1인분 고구마 볼. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0931';
UPDATE recipes SET name = '들깨 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 시금치, 느타리버섯을 곁들인 1인분 고구마 볼. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0932';
UPDATE recipes SET name = '간장 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 시금치, 느타리버섯을 곁들인 1인분 고구마 볼. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0933';
UPDATE recipes SET name = '마늘 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 시금치, 느타리버섯을 곁들인 1인분 고구마 볼. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0934';
UPDATE recipes SET name = '생강간장 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 시금치, 느타리버섯을 곁들인 1인분 고구마 볼. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0935';
UPDATE recipes SET name = '파간장 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 시금치, 느타리버섯을 곁들인 1인분 고구마 볼. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0936';
UPDATE recipes SET name = '깻잎 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 시금치, 느타리버섯을 곁들인 1인분 고구마 볼. 레몬올리브 양념, 깻잎 고명.', calories = 443.0, protein_g = 21.2, carbs_g = 72.6, fat_g = 7.6, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0937';
UPDATE recipes SET name = '바질 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 시금치, 느타리버섯을 곁들인 1인분 고구마 볼. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0938';
UPDATE recipes SET name = '김 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 시금치, 느타리버섯을 곁들인 1인분 고구마 볼. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0939';
UPDATE recipes SET name = '허브 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 시금치, 느타리버섯을 곁들인 1인분 고구마 볼. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0940';
UPDATE recipes SET name = '레몬 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 청경채, 양송이버섯을 곁들인 1인분 고구마 볼. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0941';
UPDATE recipes SET name = '들깨 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 청경채, 양송이버섯을 곁들인 1인분 고구마 볼. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0942';
UPDATE recipes SET name = '간장 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 청경채, 양송이버섯을 곁들인 1인분 고구마 볼. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0943';
UPDATE recipes SET name = '마늘 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 청경채, 양송이버섯을 곁들인 1인분 고구마 볼. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0944';
UPDATE recipes SET name = '생강간장 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 청경채, 양송이버섯을 곁들인 1인분 고구마 볼. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0945';
UPDATE recipes SET name = '파간장 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 청경채, 양송이버섯을 곁들인 1인분 고구마 볼. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0946';
UPDATE recipes SET name = '깻잎 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 청경채, 양송이버섯을 곁들인 1인분 고구마 볼. 레몬올리브 양념, 깻잎 고명.', calories = 428.0, protein_g = 20.4, carbs_g = 69.7, fat_g = 7.6, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0947';
UPDATE recipes SET name = '바질 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 청경채, 양송이버섯을 곁들인 1인분 고구마 볼. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0948';
UPDATE recipes SET name = '김 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 청경채, 양송이버섯을 곁들인 1인분 고구마 볼. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0949';
UPDATE recipes SET name = '허브 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 청경채, 양송이버섯을 곁들인 1인분 고구마 볼. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0950';
UPDATE recipes SET name = '레몬 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 가지, 토마토를 곁들인 1인분 고구마 볼. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0951';
UPDATE recipes SET name = '들깨 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 가지, 토마토를 곁들인 1인분 고구마 볼. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0952';
UPDATE recipes SET name = '간장 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 가지, 토마토를 곁들인 1인분 고구마 볼. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0953';
UPDATE recipes SET name = '마늘 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 가지, 토마토를 곁들인 1인분 고구마 볼. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0954';
UPDATE recipes SET name = '생강간장 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 가지, 토마토를 곁들인 1인분 고구마 볼. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0955';
UPDATE recipes SET name = '파간장 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 가지, 토마토를 곁들인 1인분 고구마 볼. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0956';
UPDATE recipes SET name = '깻잎 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 가지, 토마토를 곁들인 1인분 고구마 볼. 레몬올리브 양념, 깻잎 고명.', calories = 435.0, protein_g = 18.5, carbs_g = 73.3, fat_g = 7.6, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0957';
UPDATE recipes SET name = '바질 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 가지, 토마토를 곁들인 1인분 고구마 볼. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0958';
UPDATE recipes SET name = '김 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 가지, 토마토를 곁들인 1인분 고구마 볼. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0959';
UPDATE recipes SET name = '허브 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 가지, 토마토를 곁들인 1인분 고구마 볼. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0960';
UPDATE recipes SET name = '레몬 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 양배추, 파프리카를 곁들인 1인분 고구마 볼. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0961';
UPDATE recipes SET name = '들깨 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 양배추, 파프리카를 곁들인 1인분 고구마 볼. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0962';
UPDATE recipes SET name = '간장 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 양배추, 파프리카를 곁들인 1인분 고구마 볼. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0963';
UPDATE recipes SET name = '마늘 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 양배추, 파프리카를 곁들인 1인분 고구마 볼. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0964';
UPDATE recipes SET name = '생강간장 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 양배추, 파프리카를 곁들인 1인분 고구마 볼. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0965';
UPDATE recipes SET name = '파간장 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 양배추, 파프리카를 곁들인 1인분 고구마 볼. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0966';
UPDATE recipes SET name = '깻잎 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 양배추, 파프리카를 곁들인 1인분 고구마 볼. 레몬올리브 양념, 깻잎 고명.', calories = 437.0, protein_g = 18.4, carbs_g = 73.9, fat_g = 7.6, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0967';
UPDATE recipes SET name = '바질 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 양배추, 파프리카를 곁들인 1인분 고구마 볼. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0968';
UPDATE recipes SET name = '김 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 양배추, 파프리카를 곁들인 1인분 고구마 볼. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0969';
UPDATE recipes SET name = '허브 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 양배추, 파프리카를 곁들인 1인분 고구마 볼. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0970';
UPDATE recipes SET name = '레몬 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 브로콜리, 당근을 곁들인 1인분 고구마 볼. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0971';
UPDATE recipes SET name = '들깨 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 브로콜리, 당근을 곁들인 1인분 고구마 볼. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0972';
UPDATE recipes SET name = '간장 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 브로콜리, 당근을 곁들인 1인분 고구마 볼. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0973';
UPDATE recipes SET name = '마늘 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 브로콜리, 당근을 곁들인 1인분 고구마 볼. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0974';
UPDATE recipes SET name = '생강간장 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 브로콜리, 당근을 곁들인 1인분 고구마 볼. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0975';
UPDATE recipes SET name = '파간장 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 브로콜리, 당근을 곁들인 1인분 고구마 볼. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0976';
UPDATE recipes SET name = '깻잎 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 브로콜리, 당근을 곁들인 1인분 고구마 볼. 레몬올리브 양념, 깻잎 고명.', calories = 454.0, protein_g = 20.0, carbs_g = 76.4, fat_g = 7.6, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0977';
UPDATE recipes SET name = '바질 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 브로콜리, 당근을 곁들인 1인분 고구마 볼. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0978';
UPDATE recipes SET name = '김 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 브로콜리, 당근을 곁들인 1인분 고구마 볼. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0979';
UPDATE recipes SET name = '허브 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 브로콜리, 당근을 곁들인 1인분 고구마 볼. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0980';
UPDATE recipes SET name = '레몬 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 애호박, 양송이버섯을 곁들인 1인분 고구마 볼. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0981';
UPDATE recipes SET name = '들깨 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 애호박, 양송이버섯을 곁들인 1인분 고구마 볼. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0982';
UPDATE recipes SET name = '간장 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 애호박, 양송이버섯을 곁들인 1인분 고구마 볼. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0983';
UPDATE recipes SET name = '마늘 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 애호박, 양송이버섯을 곁들인 1인분 고구마 볼. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0984';
UPDATE recipes SET name = '생강간장 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 애호박, 양송이버섯을 곁들인 1인분 고구마 볼. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0985';
UPDATE recipes SET name = '파간장 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 애호박, 양송이버섯을 곁들인 1인분 고구마 볼. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0986';
UPDATE recipes SET name = '깻잎 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 애호박, 양송이버섯을 곁들인 1인분 고구마 볼. 레몬올리브 양념, 깻잎 고명.', calories = 425.0, protein_g = 19.7, carbs_g = 69.7, fat_g = 7.6, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0987';
UPDATE recipes SET name = '바질 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 애호박, 양송이버섯을 곁들인 1인분 고구마 볼. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0988';
UPDATE recipes SET name = '김 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 애호박, 양송이버섯을 곁들인 1인분 고구마 볼. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0989';
UPDATE recipes SET name = '허브 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 애호박, 양송이버섯을 곁들인 1인분 고구마 볼. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0990';
UPDATE recipes SET name = '레몬 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 시금치, 토마토를 곁들인 1인분 고구마 볼. 레몬올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0991';
UPDATE recipes SET name = '들깨 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 시금치, 토마토를 곁들인 1인분 고구마 볼. 들깨향 식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0992';
UPDATE recipes SET name = '간장 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 시금치, 토마토를 곁들인 1인분 고구마 볼. 참기름 간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0993';
UPDATE recipes SET name = '마늘 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 시금치, 토마토를 곁들인 1인분 고구마 볼. 마늘식초 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0994';
UPDATE recipes SET name = '생강간장 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 시금치, 토마토를 곁들인 1인분 고구마 볼. 생강간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0995';
UPDATE recipes SET name = '파간장 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 시금치, 토마토를 곁들인 1인분 고구마 볼. 대파간장 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0996';
UPDATE recipes SET name = '깻잎 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 시금치, 토마토를 곁들인 1인분 고구마 볼. 레몬올리브 양념, 깻잎 고명.', calories = 430.0, protein_g = 19.6, carbs_g = 71.1, fat_g = 7.6, updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0997';
UPDATE recipes SET name = '바질 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 시금치, 토마토를 곁들인 1인분 고구마 볼. 바질올리브 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0998';
UPDATE recipes SET name = '김 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 시금치, 토마토를 곁들인 1인분 고구마 볼. 김참기름 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D0999';
UPDATE recipes SET name = '허브 렌틸콩 고구마볼', description = '고구마에 렌틸콩, 시금치, 토마토를 곁들인 1인분 고구마 볼. 파슬리후추 양념.', updated_at = CURRENT_TIMESTAMP(6) WHERE recipe_code = 'D1000';

DELETE FROM recipe_ingredients WHERE recipe_id IN (SELECT id FROM recipes WHERE recipe_code IN ('B0002', 'B0004', 'B0007', 'B0012', 'B0014', 'B0017', 'B0022', 'B0024', 'B0027', 'B0032', 'B0034', 'B0037', 'B0042', 'B0044', 'B0047', 'B0052', 'B0054', 'B0057', 'B0062', 'B0064', 'B0067', 'B0072', 'B0074', 'B0077', 'B0082', 'B0084', 'B0087', 'B0092', 'B0094', 'B0097', 'B0101', 'B0102', 'B0104', 'B0107', 'B0108', 'B0110', 'B0111', 'B0112', 'B0114', 'B0117', 'B0118', 'B0120', 'B0121', 'B0122', 'B0124', 'B0127', 'B0128', 'B0130', 'B0131', 'B0132', 'B0134', 'B0137', 'B0138', 'B0140', 'B0141', 'B0142', 'B0144', 'B0147', 'B0148', 'B0150', 'B0151', 'B0152', 'B0154', 'B0157', 'B0158', 'B0160', 'B0161', 'B0162', 'B0164', 'B0167', 'B0168', 'B0170', 'B0171', 'B0172', 'B0174', 'B0177', 'B0178', 'B0180', 'B0181', 'B0182', 'B0184', 'B0187', 'B0188', 'B0190', 'B0191', 'B0192', 'B0194', 'B0197', 'B0198', 'B0200', 'B0207', 'B0217', 'B0227', 'B0237', 'B0247', 'B0257', 'B0267', 'B0277', 'B0287', 'B0297', 'B0307', 'B0317', 'B0327', 'B0337', 'B0347', 'B0357', 'B0367', 'B0377', 'B0387', 'B0397', 'B0407', 'B0417', 'B0427', 'B0437', 'B0447', 'B0457', 'B0467', 'B0477', 'B0487', 'B0497', 'B0507', 'B0517', 'B0527', 'B0537', 'B0547', 'B0557', 'B0567', 'B0577', 'B0587', 'B0597', 'B0607', 'B0617', 'B0627', 'B0637', 'B0647', 'B0657', 'B0667', 'B0677', 'B0687', 'B0697', 'B0707', 'B0717', 'B0727', 'B0737', 'B0747', 'B0757', 'B0767', 'B0777', 'B0787', 'B0797', 'B0807', 'B0817', 'B0827', 'B0837', 'B0847', 'B0857', 'B0867', 'B0877', 'B0887', 'B0897', 'B0901', 'B0902', 'B0904', 'B0907', 'B0908', 'B0910', 'B0911', 'B0912', 'B0914', 'B0917', 'B0918', 'B0920', 'B0921', 'B0922', 'B0924', 'B0927', 'B0928', 'B0930', 'B0931', 'B0932', 'B0934', 'B0937', 'B0938', 'B0940', 'B0941', 'B0942', 'B0944', 'B0947', 'B0948', 'B0950', 'B0951', 'B0952', 'B0954', 'B0957', 'B0958', 'B0960', 'B0961', 'B0962', 'B0964', 'B0967', 'B0968', 'B0970', 'B0971', 'B0972', 'B0974', 'B0977', 'B0978', 'B0980', 'B0981', 'B0982', 'B0984', 'B0987', 'B0988', 'B0990', 'B0991', 'B0992', 'B0994', 'B0997', 'B0998', 'B1000', 'L0007', 'L0017', 'L0027', 'L0037', 'L0047', 'L0057', 'L0067', 'L0077', 'L0087', 'L0097', 'L0107', 'L0117', 'L0127', 'L0137', 'L0147', 'L0157', 'L0167', 'L0177', 'L0187', 'L0197', 'L0207', 'L0217', 'L0227', 'L0237', 'L0247', 'L0257', 'L0267', 'L0277', 'L0287', 'L0297', 'L0307', 'L0317', 'L0327', 'L0337', 'L0347', 'L0357', 'L0367', 'L0377', 'L0387', 'L0397', 'L0407', 'L0417', 'L0427', 'L0437', 'L0447', 'L0457', 'L0467', 'L0477', 'L0487', 'L0497', 'L0507', 'L0517', 'L0527', 'L0537', 'L0547', 'L0557', 'L0567', 'L0577', 'L0587', 'L0597', 'L0607', 'L0617', 'L0627', 'L0637', 'L0647', 'L0657', 'L0667', 'L0677', 'L0687', 'L0697', 'L0707', 'L0717', 'L0727', 'L0737', 'L0747', 'L0757', 'L0767', 'L0777', 'L0787', 'L0797', 'L0807', 'L0817', 'L0827', 'L0837', 'L0847', 'L0857', 'L0867', 'L0877', 'L0887', 'L0897', 'L0902', 'L0904', 'L0907', 'L0912', 'L0914', 'L0917', 'L0922', 'L0924', 'L0927', 'L0932', 'L0934', 'L0937', 'L0942', 'L0944', 'L0947', 'L0952', 'L0954', 'L0957', 'L0962', 'L0964', 'L0967', 'L0972', 'L0974', 'L0977', 'L0982', 'L0984', 'L0987', 'L0992', 'L0994', 'L0997', 'D0007', 'D0017', 'D0027', 'D0037', 'D0047', 'D0057', 'D0067', 'D0077', 'D0087', 'D0097', 'D0107', 'D0117', 'D0127', 'D0137', 'D0147', 'D0157', 'D0167', 'D0177', 'D0187', 'D0197', 'D0207', 'D0217', 'D0227', 'D0237', 'D0247', 'D0257', 'D0267', 'D0277', 'D0287', 'D0297', 'D0307', 'D0317', 'D0327', 'D0337', 'D0347', 'D0357', 'D0367', 'D0377', 'D0387', 'D0397', 'D0407', 'D0417', 'D0427', 'D0437', 'D0447', 'D0457', 'D0467', 'D0477', 'D0487', 'D0497', 'D0507', 'D0517', 'D0527', 'D0537', 'D0547', 'D0557', 'D0567', 'D0577', 'D0587', 'D0597', 'D0607', 'D0617', 'D0627', 'D0637', 'D0647', 'D0657', 'D0667', 'D0677', 'D0687', 'D0697', 'D0707', 'D0717', 'D0727', 'D0737', 'D0747', 'D0757', 'D0767', 'D0777', 'D0787', 'D0797', 'D0807', 'D0817', 'D0827', 'D0837', 'D0847', 'D0857', 'D0867', 'D0877', 'D0887', 'D0897', 'D0907', 'D0917', 'D0927', 'D0937', 'D0947', 'D0957', 'D0967', 'D0977', 'D0987', 'D0997'));
DELETE FROM recipe_steps WHERE recipe_id IN (SELECT id FROM recipes WHERE recipe_code IN ('B0002', 'B0004', 'B0007', 'B0012', 'B0014', 'B0017', 'B0022', 'B0024', 'B0027', 'B0032', 'B0034', 'B0037', 'B0042', 'B0044', 'B0047', 'B0052', 'B0054', 'B0057', 'B0062', 'B0064', 'B0067', 'B0072', 'B0074', 'B0077', 'B0082', 'B0084', 'B0087', 'B0092', 'B0094', 'B0097', 'B0101', 'B0102', 'B0104', 'B0107', 'B0108', 'B0110', 'B0111', 'B0112', 'B0114', 'B0117', 'B0118', 'B0120', 'B0121', 'B0122', 'B0124', 'B0127', 'B0128', 'B0130', 'B0131', 'B0132', 'B0134', 'B0137', 'B0138', 'B0140', 'B0141', 'B0142', 'B0144', 'B0147', 'B0148', 'B0150', 'B0151', 'B0152', 'B0154', 'B0157', 'B0158', 'B0160', 'B0161', 'B0162', 'B0164', 'B0167', 'B0168', 'B0170', 'B0171', 'B0172', 'B0174', 'B0177', 'B0178', 'B0180', 'B0181', 'B0182', 'B0184', 'B0187', 'B0188', 'B0190', 'B0191', 'B0192', 'B0194', 'B0197', 'B0198', 'B0200', 'B0207', 'B0217', 'B0227', 'B0237', 'B0247', 'B0257', 'B0267', 'B0277', 'B0287', 'B0297', 'B0307', 'B0317', 'B0327', 'B0337', 'B0347', 'B0357', 'B0367', 'B0377', 'B0387', 'B0397', 'B0407', 'B0417', 'B0427', 'B0437', 'B0447', 'B0457', 'B0467', 'B0477', 'B0487', 'B0497', 'B0507', 'B0517', 'B0527', 'B0537', 'B0547', 'B0557', 'B0567', 'B0577', 'B0587', 'B0597', 'B0607', 'B0617', 'B0627', 'B0637', 'B0647', 'B0657', 'B0667', 'B0677', 'B0687', 'B0697', 'B0707', 'B0717', 'B0727', 'B0737', 'B0747', 'B0757', 'B0767', 'B0777', 'B0787', 'B0797', 'B0807', 'B0817', 'B0827', 'B0837', 'B0847', 'B0857', 'B0867', 'B0877', 'B0887', 'B0897', 'B0901', 'B0902', 'B0904', 'B0907', 'B0908', 'B0910', 'B0911', 'B0912', 'B0914', 'B0917', 'B0918', 'B0920', 'B0921', 'B0922', 'B0924', 'B0927', 'B0928', 'B0930', 'B0931', 'B0932', 'B0934', 'B0937', 'B0938', 'B0940', 'B0941', 'B0942', 'B0944', 'B0947', 'B0948', 'B0950', 'B0951', 'B0952', 'B0954', 'B0957', 'B0958', 'B0960', 'B0961', 'B0962', 'B0964', 'B0967', 'B0968', 'B0970', 'B0971', 'B0972', 'B0974', 'B0977', 'B0978', 'B0980', 'B0981', 'B0982', 'B0984', 'B0987', 'B0988', 'B0990', 'B0991', 'B0992', 'B0994', 'B0997', 'B0998', 'B1000', 'L0007', 'L0017', 'L0027', 'L0037', 'L0047', 'L0057', 'L0067', 'L0077', 'L0087', 'L0097', 'L0107', 'L0117', 'L0127', 'L0137', 'L0147', 'L0157', 'L0167', 'L0177', 'L0187', 'L0197', 'L0207', 'L0217', 'L0227', 'L0237', 'L0247', 'L0257', 'L0267', 'L0277', 'L0287', 'L0297', 'L0307', 'L0317', 'L0327', 'L0337', 'L0347', 'L0357', 'L0367', 'L0377', 'L0387', 'L0397', 'L0407', 'L0417', 'L0427', 'L0437', 'L0447', 'L0457', 'L0467', 'L0477', 'L0487', 'L0497', 'L0507', 'L0517', 'L0527', 'L0537', 'L0547', 'L0557', 'L0567', 'L0577', 'L0587', 'L0597', 'L0607', 'L0617', 'L0627', 'L0637', 'L0647', 'L0657', 'L0667', 'L0677', 'L0687', 'L0697', 'L0707', 'L0717', 'L0727', 'L0737', 'L0747', 'L0757', 'L0767', 'L0777', 'L0787', 'L0797', 'L0807', 'L0817', 'L0827', 'L0837', 'L0847', 'L0857', 'L0867', 'L0877', 'L0887', 'L0897', 'L0902', 'L0904', 'L0907', 'L0912', 'L0914', 'L0917', 'L0922', 'L0924', 'L0927', 'L0932', 'L0934', 'L0937', 'L0942', 'L0944', 'L0947', 'L0952', 'L0954', 'L0957', 'L0962', 'L0964', 'L0967', 'L0972', 'L0974', 'L0977', 'L0982', 'L0984', 'L0987', 'L0992', 'L0994', 'L0997', 'D0007', 'D0017', 'D0027', 'D0037', 'D0047', 'D0057', 'D0067', 'D0077', 'D0087', 'D0097', 'D0107', 'D0117', 'D0127', 'D0137', 'D0147', 'D0157', 'D0167', 'D0177', 'D0187', 'D0197', 'D0207', 'D0217', 'D0227', 'D0237', 'D0247', 'D0257', 'D0267', 'D0277', 'D0287', 'D0297', 'D0307', 'D0317', 'D0327', 'D0337', 'D0347', 'D0357', 'D0367', 'D0377', 'D0387', 'D0397', 'D0407', 'D0417', 'D0427', 'D0437', 'D0447', 'D0457', 'D0467', 'D0477', 'D0487', 'D0497', 'D0507', 'D0517', 'D0527', 'D0537', 'D0547', 'D0557', 'D0567', 'D0577', 'D0587', 'D0597', 'D0607', 'D0617', 'D0627', 'D0637', 'D0647', 'D0657', 'D0667', 'D0677', 'D0687', 'D0697', 'D0707', 'D0717', 'D0727', 'D0737', 'D0747', 'D0757', 'D0767', 'D0777', 'D0787', 'D0797', 'D0807', 'D0817', 'D0827', 'D0837', 'D0847', 'D0857', 'D0867', 'D0877', 'D0887', 'D0897', 'D0907', 'D0917', 'D0927', 'D0937', 'D0947', 'D0957', 'D0967', 'D0977', 'D0987', 'D0997'));

INSERT INTO recipe_ingredients (recipe_id, ingredient_name, required_qty, unit)
SELECT r.id, v.ingredient_name, v.required_qty, v.unit FROM recipes r JOIN (VALUES
    ('B0002', '통밀 식빵', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0002', '달걀', CAST(2 AS NUMERIC(12,3)), '개'),
    ('B0002', '양배추', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('B0002', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0002', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('B0002', '후추', CAST(1 AS NUMERIC(12,3)), 'g'),
    ('B0004', '통밀 식빵', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0004', '달걀', CAST(2 AS NUMERIC(12,3)), '개'),
    ('B0004', '양배추', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('B0004', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0004', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('B0004', '다진 마늘', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0007', '통밀 식빵', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0007', '달걀', CAST(2 AS NUMERIC(12,3)), '개'),
    ('B0007', '양배추', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('B0007', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0007', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('B0007', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0007', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('B0012', '통밀 식빵', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0012', '달걀', CAST(2 AS NUMERIC(12,3)), '개'),
    ('B0012', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('B0012', '양파', CAST(45 AS NUMERIC(12,3)), 'g'),
    ('B0012', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('B0012', '후추', CAST(1 AS NUMERIC(12,3)), 'g'),
    ('B0014', '통밀 식빵', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0014', '달걀', CAST(2 AS NUMERIC(12,3)), '개'),
    ('B0014', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('B0014', '양파', CAST(45 AS NUMERIC(12,3)), 'g'),
    ('B0014', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('B0014', '다진 마늘', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0017', '통밀 식빵', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0017', '달걀', CAST(2 AS NUMERIC(12,3)), '개'),
    ('B0017', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('B0017', '양파', CAST(45 AS NUMERIC(12,3)), 'g'),
    ('B0017', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('B0017', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0017', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('B0022', '통밀 식빵', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0022', '달걀', CAST(2 AS NUMERIC(12,3)), '개'),
    ('B0022', '애호박', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('B0022', '파프리카', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('B0022', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('B0022', '후추', CAST(1 AS NUMERIC(12,3)), 'g'),
    ('B0024', '통밀 식빵', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0024', '달걀', CAST(2 AS NUMERIC(12,3)), '개'),
    ('B0024', '애호박', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('B0024', '파프리카', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('B0024', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('B0024', '다진 마늘', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0027', '통밀 식빵', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0027', '달걀', CAST(2 AS NUMERIC(12,3)), '개'),
    ('B0027', '애호박', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('B0027', '파프리카', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('B0027', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('B0027', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0027', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('B0032', '통밀 식빵', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0032', '달걀', CAST(2 AS NUMERIC(12,3)), '개'),
    ('B0032', '시금치', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0032', '느타리버섯', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0032', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('B0032', '후추', CAST(1 AS NUMERIC(12,3)), 'g'),
    ('B0034', '통밀 식빵', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0034', '달걀', CAST(2 AS NUMERIC(12,3)), '개'),
    ('B0034', '시금치', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0034', '느타리버섯', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0034', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('B0034', '다진 마늘', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0037', '통밀 식빵', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0037', '달걀', CAST(2 AS NUMERIC(12,3)), '개'),
    ('B0037', '시금치', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0037', '느타리버섯', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0037', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('B0037', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0037', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('B0042', '통밀 식빵', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0042', '달걀', CAST(2 AS NUMERIC(12,3)), '개'),
    ('B0042', '청경채', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0042', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0042', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('B0042', '후추', CAST(1 AS NUMERIC(12,3)), 'g'),
    ('B0044', '통밀 식빵', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0044', '달걀', CAST(2 AS NUMERIC(12,3)), '개'),
    ('B0044', '청경채', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0044', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0044', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('B0044', '다진 마늘', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0047', '통밀 식빵', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0047', '달걀', CAST(2 AS NUMERIC(12,3)), '개'),
    ('B0047', '청경채', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0047', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0047', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('B0047', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0047', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('B0052', '통밀 식빵', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0052', '달걀', CAST(2 AS NUMERIC(12,3)), '개'),
    ('B0052', '가지', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('B0052', '토마토', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0052', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('B0052', '후추', CAST(1 AS NUMERIC(12,3)), 'g'),
    ('B0054', '통밀 식빵', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0054', '달걀', CAST(2 AS NUMERIC(12,3)), '개'),
    ('B0054', '가지', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('B0054', '토마토', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0054', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('B0054', '다진 마늘', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0057', '통밀 식빵', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0057', '달걀', CAST(2 AS NUMERIC(12,3)), '개'),
    ('B0057', '가지', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('B0057', '토마토', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0057', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('B0057', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0057', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('B0062', '통밀 식빵', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0062', '달걀', CAST(2 AS NUMERIC(12,3)), '개'),
    ('B0062', '양배추', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0062', '파프리카', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0062', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('B0062', '후추', CAST(1 AS NUMERIC(12,3)), 'g'),
    ('B0064', '통밀 식빵', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0064', '달걀', CAST(2 AS NUMERIC(12,3)), '개'),
    ('B0064', '양배추', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0064', '파프리카', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0064', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('B0064', '다진 마늘', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0067', '통밀 식빵', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0067', '달걀', CAST(2 AS NUMERIC(12,3)), '개'),
    ('B0067', '양배추', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0067', '파프리카', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0067', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('B0067', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0067', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('B0072', '통밀 식빵', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0072', '달걀', CAST(2 AS NUMERIC(12,3)), '개'),
    ('B0072', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('B0072', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0072', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('B0072', '후추', CAST(1 AS NUMERIC(12,3)), 'g'),
    ('B0074', '통밀 식빵', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0074', '달걀', CAST(2 AS NUMERIC(12,3)), '개'),
    ('B0074', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('B0074', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0074', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('B0074', '다진 마늘', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0077', '통밀 식빵', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0077', '달걀', CAST(2 AS NUMERIC(12,3)), '개'),
    ('B0077', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('B0077', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0077', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('B0077', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0077', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('B0082', '통밀 식빵', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0082', '달걀', CAST(2 AS NUMERIC(12,3)), '개'),
    ('B0082', '애호박', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0082', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0082', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('B0082', '후추', CAST(1 AS NUMERIC(12,3)), 'g'),
    ('B0084', '통밀 식빵', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0084', '달걀', CAST(2 AS NUMERIC(12,3)), '개'),
    ('B0084', '애호박', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0084', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0084', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('B0084', '다진 마늘', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0087', '통밀 식빵', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0087', '달걀', CAST(2 AS NUMERIC(12,3)), '개'),
    ('B0087', '애호박', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0087', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0087', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('B0087', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0087', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('B0092', '통밀 식빵', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0092', '달걀', CAST(2 AS NUMERIC(12,3)), '개'),
    ('B0092', '시금치', CAST(60 AS NUMERIC(12,3)), 'g'),
    ('B0092', '토마토', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('B0092', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('B0092', '후추', CAST(1 AS NUMERIC(12,3)), 'g'),
    ('B0094', '통밀 식빵', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0094', '달걀', CAST(2 AS NUMERIC(12,3)), '개'),
    ('B0094', '시금치', CAST(60 AS NUMERIC(12,3)), 'g'),
    ('B0094', '토마토', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('B0094', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('B0094', '다진 마늘', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0097', '통밀 식빵', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0097', '달걀', CAST(2 AS NUMERIC(12,3)), '개'),
    ('B0097', '시금치', CAST(60 AS NUMERIC(12,3)), 'g'),
    ('B0097', '토마토', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('B0097', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('B0097', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0097', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('B0101', '오트밀', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0101', '두부', CAST(130 AS NUMERIC(12,3)), 'g'),
    ('B0101', '양배추', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('B0101', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0101', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0101', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0101', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0101', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0102', '오트밀', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0102', '두부', CAST(130 AS NUMERIC(12,3)), 'g'),
    ('B0102', '양배추', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('B0102', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0102', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0102', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0102', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0102', '소금', CAST(0.5 AS NUMERIC(12,3)), 'g'),
    ('B0104', '오트밀', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0104', '두부', CAST(130 AS NUMERIC(12,3)), 'g'),
    ('B0104', '양배추', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('B0104', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0104', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0104', '다진 마늘', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0104', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0104', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0107', '오트밀', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0107', '두부', CAST(130 AS NUMERIC(12,3)), 'g'),
    ('B0107', '양배추', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('B0107', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0107', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0107', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0107', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0107', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0107', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0108', '오트밀', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0108', '두부', CAST(130 AS NUMERIC(12,3)), 'g'),
    ('B0108', '양배추', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('B0108', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0108', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0108', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0108', '대파', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('B0108', '참기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0110', '오트밀', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0110', '두부', CAST(130 AS NUMERIC(12,3)), 'g'),
    ('B0110', '양배추', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('B0110', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0110', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0110', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0110', '김가루', CAST(2 AS NUMERIC(12,3)), 'g'),
    ('B0110', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0111', '오트밀', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0111', '두부', CAST(130 AS NUMERIC(12,3)), 'g'),
    ('B0111', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('B0111', '양파', CAST(45 AS NUMERIC(12,3)), 'g'),
    ('B0111', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0111', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0111', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0111', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0112', '오트밀', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0112', '두부', CAST(130 AS NUMERIC(12,3)), 'g'),
    ('B0112', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('B0112', '양파', CAST(45 AS NUMERIC(12,3)), 'g'),
    ('B0112', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0112', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0112', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0112', '소금', CAST(0.5 AS NUMERIC(12,3)), 'g'),
    ('B0114', '오트밀', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0114', '두부', CAST(130 AS NUMERIC(12,3)), 'g'),
    ('B0114', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('B0114', '양파', CAST(45 AS NUMERIC(12,3)), 'g'),
    ('B0114', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0114', '다진 마늘', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0114', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0114', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0117', '오트밀', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0117', '두부', CAST(130 AS NUMERIC(12,3)), 'g'),
    ('B0117', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('B0117', '양파', CAST(45 AS NUMERIC(12,3)), 'g'),
    ('B0117', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0117', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0117', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0117', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0117', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0118', '오트밀', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0118', '두부', CAST(130 AS NUMERIC(12,3)), 'g'),
    ('B0118', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('B0118', '양파', CAST(45 AS NUMERIC(12,3)), 'g'),
    ('B0118', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0118', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0118', '대파', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('B0118', '참기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0120', '오트밀', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0120', '두부', CAST(130 AS NUMERIC(12,3)), 'g'),
    ('B0120', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('B0120', '양파', CAST(45 AS NUMERIC(12,3)), 'g'),
    ('B0120', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0120', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0120', '김가루', CAST(2 AS NUMERIC(12,3)), 'g'),
    ('B0120', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0121', '오트밀', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0121', '두부', CAST(130 AS NUMERIC(12,3)), 'g'),
    ('B0121', '애호박', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('B0121', '파프리카', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('B0121', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0121', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0121', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0121', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0122', '오트밀', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0122', '두부', CAST(130 AS NUMERIC(12,3)), 'g'),
    ('B0122', '애호박', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('B0122', '파프리카', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('B0122', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0122', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0122', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0122', '소금', CAST(0.5 AS NUMERIC(12,3)), 'g'),
    ('B0124', '오트밀', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0124', '두부', CAST(130 AS NUMERIC(12,3)), 'g'),
    ('B0124', '애호박', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('B0124', '파프리카', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('B0124', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0124', '다진 마늘', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0124', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0124', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0127', '오트밀', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0127', '두부', CAST(130 AS NUMERIC(12,3)), 'g'),
    ('B0127', '애호박', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('B0127', '파프리카', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('B0127', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0127', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0127', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0127', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0127', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0128', '오트밀', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0128', '두부', CAST(130 AS NUMERIC(12,3)), 'g'),
    ('B0128', '애호박', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('B0128', '파프리카', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('B0128', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0128', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0128', '대파', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('B0128', '참기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0130', '오트밀', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0130', '두부', CAST(130 AS NUMERIC(12,3)), 'g'),
    ('B0130', '애호박', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('B0130', '파프리카', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('B0130', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0130', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0130', '김가루', CAST(2 AS NUMERIC(12,3)), 'g'),
    ('B0130', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0131', '오트밀', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0131', '두부', CAST(130 AS NUMERIC(12,3)), 'g'),
    ('B0131', '시금치', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0131', '느타리버섯', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0131', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0131', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0131', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0131', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0132', '오트밀', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0132', '두부', CAST(130 AS NUMERIC(12,3)), 'g'),
    ('B0132', '시금치', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0132', '느타리버섯', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0132', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0132', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0132', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0132', '소금', CAST(0.5 AS NUMERIC(12,3)), 'g'),
    ('B0134', '오트밀', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0134', '두부', CAST(130 AS NUMERIC(12,3)), 'g'),
    ('B0134', '시금치', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0134', '느타리버섯', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0134', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0134', '다진 마늘', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0134', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0134', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0137', '오트밀', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0137', '두부', CAST(130 AS NUMERIC(12,3)), 'g'),
    ('B0137', '시금치', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0137', '느타리버섯', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0137', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0137', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0137', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0137', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0137', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0138', '오트밀', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0138', '두부', CAST(130 AS NUMERIC(12,3)), 'g'),
    ('B0138', '시금치', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0138', '느타리버섯', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0138', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0138', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0138', '대파', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('B0138', '참기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0140', '오트밀', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0140', '두부', CAST(130 AS NUMERIC(12,3)), 'g'),
    ('B0140', '시금치', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0140', '느타리버섯', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0140', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0140', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0140', '김가루', CAST(2 AS NUMERIC(12,3)), 'g'),
    ('B0140', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0141', '오트밀', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0141', '두부', CAST(130 AS NUMERIC(12,3)), 'g'),
    ('B0141', '청경채', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0141', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0141', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0141', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0141', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0141', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0142', '오트밀', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0142', '두부', CAST(130 AS NUMERIC(12,3)), 'g'),
    ('B0142', '청경채', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0142', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0142', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0142', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0142', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0142', '소금', CAST(0.5 AS NUMERIC(12,3)), 'g'),
    ('B0144', '오트밀', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0144', '두부', CAST(130 AS NUMERIC(12,3)), 'g'),
    ('B0144', '청경채', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0144', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0144', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0144', '다진 마늘', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0144', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0144', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0147', '오트밀', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0147', '두부', CAST(130 AS NUMERIC(12,3)), 'g'),
    ('B0147', '청경채', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0147', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0147', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0147', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0147', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0147', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0147', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0148', '오트밀', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0148', '두부', CAST(130 AS NUMERIC(12,3)), 'g'),
    ('B0148', '청경채', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0148', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0148', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0148', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0148', '대파', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('B0148', '참기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0150', '오트밀', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0150', '두부', CAST(130 AS NUMERIC(12,3)), 'g'),
    ('B0150', '청경채', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0150', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0150', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0150', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0150', '김가루', CAST(2 AS NUMERIC(12,3)), 'g'),
    ('B0150', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0151', '오트밀', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0151', '두부', CAST(130 AS NUMERIC(12,3)), 'g'),
    ('B0151', '가지', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('B0151', '토마토', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0151', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0151', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0151', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0151', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0152', '오트밀', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0152', '두부', CAST(130 AS NUMERIC(12,3)), 'g'),
    ('B0152', '가지', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('B0152', '토마토', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0152', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0152', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0152', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0152', '소금', CAST(0.5 AS NUMERIC(12,3)), 'g'),
    ('B0154', '오트밀', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0154', '두부', CAST(130 AS NUMERIC(12,3)), 'g'),
    ('B0154', '가지', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('B0154', '토마토', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0154', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0154', '다진 마늘', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0154', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0154', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0157', '오트밀', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0157', '두부', CAST(130 AS NUMERIC(12,3)), 'g'),
    ('B0157', '가지', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('B0157', '토마토', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0157', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0157', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0157', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0157', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0157', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0158', '오트밀', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0158', '두부', CAST(130 AS NUMERIC(12,3)), 'g'),
    ('B0158', '가지', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('B0158', '토마토', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0158', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0158', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0158', '대파', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('B0158', '참기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0160', '오트밀', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0160', '두부', CAST(130 AS NUMERIC(12,3)), 'g'),
    ('B0160', '가지', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('B0160', '토마토', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0160', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0160', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0160', '김가루', CAST(2 AS NUMERIC(12,3)), 'g'),
    ('B0160', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0161', '오트밀', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0161', '두부', CAST(130 AS NUMERIC(12,3)), 'g'),
    ('B0161', '양배추', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0161', '파프리카', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0161', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0161', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0161', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0161', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0162', '오트밀', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0162', '두부', CAST(130 AS NUMERIC(12,3)), 'g'),
    ('B0162', '양배추', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0162', '파프리카', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0162', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0162', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0162', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0162', '소금', CAST(0.5 AS NUMERIC(12,3)), 'g'),
    ('B0164', '오트밀', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0164', '두부', CAST(130 AS NUMERIC(12,3)), 'g'),
    ('B0164', '양배추', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0164', '파프리카', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0164', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0164', '다진 마늘', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0164', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0164', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0167', '오트밀', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0167', '두부', CAST(130 AS NUMERIC(12,3)), 'g'),
    ('B0167', '양배추', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0167', '파프리카', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0167', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0167', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0167', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0167', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0167', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0168', '오트밀', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0168', '두부', CAST(130 AS NUMERIC(12,3)), 'g'),
    ('B0168', '양배추', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0168', '파프리카', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0168', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0168', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0168', '대파', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('B0168', '참기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0170', '오트밀', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0170', '두부', CAST(130 AS NUMERIC(12,3)), 'g'),
    ('B0170', '양배추', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0170', '파프리카', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0170', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0170', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0170', '김가루', CAST(2 AS NUMERIC(12,3)), 'g'),
    ('B0170', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0171', '오트밀', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0171', '두부', CAST(130 AS NUMERIC(12,3)), 'g'),
    ('B0171', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('B0171', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0171', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0171', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0171', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0171', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0172', '오트밀', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0172', '두부', CAST(130 AS NUMERIC(12,3)), 'g'),
    ('B0172', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('B0172', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0172', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0172', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0172', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0172', '소금', CAST(0.5 AS NUMERIC(12,3)), 'g'),
    ('B0174', '오트밀', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0174', '두부', CAST(130 AS NUMERIC(12,3)), 'g'),
    ('B0174', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('B0174', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0174', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0174', '다진 마늘', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0174', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0174', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0177', '오트밀', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0177', '두부', CAST(130 AS NUMERIC(12,3)), 'g'),
    ('B0177', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('B0177', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0177', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0177', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0177', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0177', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0177', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0178', '오트밀', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0178', '두부', CAST(130 AS NUMERIC(12,3)), 'g'),
    ('B0178', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('B0178', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0178', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0178', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0178', '대파', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('B0178', '참기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0180', '오트밀', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0180', '두부', CAST(130 AS NUMERIC(12,3)), 'g'),
    ('B0180', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('B0180', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0180', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0180', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0180', '김가루', CAST(2 AS NUMERIC(12,3)), 'g'),
    ('B0180', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0181', '오트밀', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0181', '두부', CAST(130 AS NUMERIC(12,3)), 'g'),
    ('B0181', '애호박', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0181', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0181', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0181', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0181', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0181', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0182', '오트밀', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0182', '두부', CAST(130 AS NUMERIC(12,3)), 'g'),
    ('B0182', '애호박', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0182', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0182', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0182', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0182', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0182', '소금', CAST(0.5 AS NUMERIC(12,3)), 'g'),
    ('B0184', '오트밀', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0184', '두부', CAST(130 AS NUMERIC(12,3)), 'g'),
    ('B0184', '애호박', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0184', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0184', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0184', '다진 마늘', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0184', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0184', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0187', '오트밀', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0187', '두부', CAST(130 AS NUMERIC(12,3)), 'g'),
    ('B0187', '애호박', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0187', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0187', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0187', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0187', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0187', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0187', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0188', '오트밀', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0188', '두부', CAST(130 AS NUMERIC(12,3)), 'g'),
    ('B0188', '애호박', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0188', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0188', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0188', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0188', '대파', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('B0188', '참기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0190', '오트밀', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0190', '두부', CAST(130 AS NUMERIC(12,3)), 'g'),
    ('B0190', '애호박', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0190', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0190', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0190', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0190', '김가루', CAST(2 AS NUMERIC(12,3)), 'g'),
    ('B0190', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0191', '오트밀', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0191', '두부', CAST(130 AS NUMERIC(12,3)), 'g'),
    ('B0191', '시금치', CAST(60 AS NUMERIC(12,3)), 'g'),
    ('B0191', '토마토', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('B0191', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0191', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0191', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0191', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0192', '오트밀', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0192', '두부', CAST(130 AS NUMERIC(12,3)), 'g'),
    ('B0192', '시금치', CAST(60 AS NUMERIC(12,3)), 'g'),
    ('B0192', '토마토', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('B0192', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0192', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0192', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0192', '소금', CAST(0.5 AS NUMERIC(12,3)), 'g'),
    ('B0194', '오트밀', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0194', '두부', CAST(130 AS NUMERIC(12,3)), 'g'),
    ('B0194', '시금치', CAST(60 AS NUMERIC(12,3)), 'g'),
    ('B0194', '토마토', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('B0194', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0194', '다진 마늘', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0194', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0194', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0197', '오트밀', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0197', '두부', CAST(130 AS NUMERIC(12,3)), 'g'),
    ('B0197', '시금치', CAST(60 AS NUMERIC(12,3)), 'g'),
    ('B0197', '토마토', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('B0197', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0197', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0197', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0197', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0197', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0198', '오트밀', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0198', '두부', CAST(130 AS NUMERIC(12,3)), 'g'),
    ('B0198', '시금치', CAST(60 AS NUMERIC(12,3)), 'g'),
    ('B0198', '토마토', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('B0198', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0198', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0198', '대파', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('B0198', '참기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0200', '오트밀', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0200', '두부', CAST(130 AS NUMERIC(12,3)), 'g'),
    ('B0200', '시금치', CAST(60 AS NUMERIC(12,3)), 'g'),
    ('B0200', '토마토', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('B0200', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0200', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0200', '김가루', CAST(2 AS NUMERIC(12,3)), 'g'),
    ('B0200', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0207', '고구마', CAST(170 AS NUMERIC(12,3)), 'g'),
    ('B0207', '달걀', CAST(2 AS NUMERIC(12,3)), '개'),
    ('B0207', '양배추', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('B0207', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0207', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('B0207', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0207', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('B0217', '고구마', CAST(170 AS NUMERIC(12,3)), 'g'),
    ('B0217', '달걀', CAST(2 AS NUMERIC(12,3)), '개'),
    ('B0217', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('B0217', '양파', CAST(45 AS NUMERIC(12,3)), 'g'),
    ('B0217', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('B0217', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0217', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('B0227', '고구마', CAST(170 AS NUMERIC(12,3)), 'g'),
    ('B0227', '달걀', CAST(2 AS NUMERIC(12,3)), '개'),
    ('B0227', '애호박', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('B0227', '파프리카', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('B0227', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('B0227', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0227', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('B0237', '고구마', CAST(170 AS NUMERIC(12,3)), 'g'),
    ('B0237', '달걀', CAST(2 AS NUMERIC(12,3)), '개'),
    ('B0237', '시금치', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0237', '느타리버섯', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0237', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('B0237', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0237', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('B0247', '고구마', CAST(170 AS NUMERIC(12,3)), 'g'),
    ('B0247', '달걀', CAST(2 AS NUMERIC(12,3)), '개'),
    ('B0247', '청경채', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0247', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0247', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('B0247', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0247', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('B0257', '고구마', CAST(170 AS NUMERIC(12,3)), 'g'),
    ('B0257', '달걀', CAST(2 AS NUMERIC(12,3)), '개'),
    ('B0257', '가지', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('B0257', '토마토', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0257', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('B0257', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0257', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('B0267', '고구마', CAST(170 AS NUMERIC(12,3)), 'g'),
    ('B0267', '달걀', CAST(2 AS NUMERIC(12,3)), '개'),
    ('B0267', '양배추', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0267', '파프리카', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0267', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('B0267', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0267', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('B0277', '고구마', CAST(170 AS NUMERIC(12,3)), 'g'),
    ('B0277', '달걀', CAST(2 AS NUMERIC(12,3)), '개'),
    ('B0277', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('B0277', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0277', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('B0277', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0277', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('B0287', '고구마', CAST(170 AS NUMERIC(12,3)), 'g'),
    ('B0287', '달걀', CAST(2 AS NUMERIC(12,3)), '개'),
    ('B0287', '애호박', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0287', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0287', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('B0287', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0287', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('B0297', '고구마', CAST(170 AS NUMERIC(12,3)), 'g'),
    ('B0297', '달걀', CAST(2 AS NUMERIC(12,3)), '개'),
    ('B0297', '시금치', CAST(60 AS NUMERIC(12,3)), 'g'),
    ('B0297', '토마토', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('B0297', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('B0297', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0297', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('B0307', '감자', CAST(180 AS NUMERIC(12,3)), 'g'),
    ('B0307', '닭가슴살', CAST(100 AS NUMERIC(12,3)), 'g'),
    ('B0307', '양배추', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('B0307', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0307', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('B0307', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0307', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('B0317', '감자', CAST(180 AS NUMERIC(12,3)), 'g'),
    ('B0317', '닭가슴살', CAST(100 AS NUMERIC(12,3)), 'g'),
    ('B0317', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('B0317', '양파', CAST(45 AS NUMERIC(12,3)), 'g'),
    ('B0317', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('B0317', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0317', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('B0327', '감자', CAST(180 AS NUMERIC(12,3)), 'g'),
    ('B0327', '닭가슴살', CAST(100 AS NUMERIC(12,3)), 'g'),
    ('B0327', '애호박', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('B0327', '파프리카', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('B0327', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('B0327', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0327', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('B0337', '감자', CAST(180 AS NUMERIC(12,3)), 'g'),
    ('B0337', '닭가슴살', CAST(100 AS NUMERIC(12,3)), 'g'),
    ('B0337', '시금치', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0337', '느타리버섯', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0337', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('B0337', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0337', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('B0347', '감자', CAST(180 AS NUMERIC(12,3)), 'g'),
    ('B0347', '닭가슴살', CAST(100 AS NUMERIC(12,3)), 'g'),
    ('B0347', '청경채', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0347', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0347', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('B0347', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0347', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('B0357', '감자', CAST(180 AS NUMERIC(12,3)), 'g'),
    ('B0357', '닭가슴살', CAST(100 AS NUMERIC(12,3)), 'g'),
    ('B0357', '가지', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('B0357', '토마토', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0357', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('B0357', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0357', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('B0367', '감자', CAST(180 AS NUMERIC(12,3)), 'g'),
    ('B0367', '닭가슴살', CAST(100 AS NUMERIC(12,3)), 'g'),
    ('B0367', '양배추', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0367', '파프리카', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0367', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('B0367', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0367', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('B0377', '감자', CAST(180 AS NUMERIC(12,3)), 'g'),
    ('B0377', '닭가슴살', CAST(100 AS NUMERIC(12,3)), 'g'),
    ('B0377', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('B0377', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0377', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('B0377', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0377', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('B0387', '감자', CAST(180 AS NUMERIC(12,3)), 'g'),
    ('B0387', '닭가슴살', CAST(100 AS NUMERIC(12,3)), 'g'),
    ('B0387', '애호박', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0387', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0387', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('B0387', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0387', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('B0397', '감자', CAST(180 AS NUMERIC(12,3)), 'g'),
    ('B0397', '닭가슴살', CAST(100 AS NUMERIC(12,3)), 'g'),
    ('B0397', '시금치', CAST(60 AS NUMERIC(12,3)), 'g'),
    ('B0397', '토마토', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('B0397', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('B0397', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0397', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('B0407', '잡곡밥', CAST(145 AS NUMERIC(12,3)), 'g'),
    ('B0407', '두부', CAST(140 AS NUMERIC(12,3)), 'g'),
    ('B0407', '양배추', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('B0407', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0407', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0407', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0407', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0407', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0417', '잡곡밥', CAST(145 AS NUMERIC(12,3)), 'g'),
    ('B0417', '두부', CAST(140 AS NUMERIC(12,3)), 'g'),
    ('B0417', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('B0417', '양파', CAST(45 AS NUMERIC(12,3)), 'g'),
    ('B0417', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0417', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0417', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0417', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0427', '잡곡밥', CAST(145 AS NUMERIC(12,3)), 'g'),
    ('B0427', '두부', CAST(140 AS NUMERIC(12,3)), 'g'),
    ('B0427', '애호박', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('B0427', '파프리카', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('B0427', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0427', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0427', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0427', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0437', '잡곡밥', CAST(145 AS NUMERIC(12,3)), 'g'),
    ('B0437', '두부', CAST(140 AS NUMERIC(12,3)), 'g'),
    ('B0437', '시금치', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0437', '느타리버섯', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0437', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0437', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0437', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0437', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0447', '잡곡밥', CAST(145 AS NUMERIC(12,3)), 'g'),
    ('B0447', '두부', CAST(140 AS NUMERIC(12,3)), 'g'),
    ('B0447', '청경채', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0447', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0447', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0447', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0447', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0447', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0457', '잡곡밥', CAST(145 AS NUMERIC(12,3)), 'g'),
    ('B0457', '두부', CAST(140 AS NUMERIC(12,3)), 'g'),
    ('B0457', '가지', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('B0457', '토마토', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0457', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0457', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0457', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0457', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0467', '잡곡밥', CAST(145 AS NUMERIC(12,3)), 'g'),
    ('B0467', '두부', CAST(140 AS NUMERIC(12,3)), 'g'),
    ('B0467', '양배추', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0467', '파프리카', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0467', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0467', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0467', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0467', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0477', '잡곡밥', CAST(145 AS NUMERIC(12,3)), 'g'),
    ('B0477', '두부', CAST(140 AS NUMERIC(12,3)), 'g'),
    ('B0477', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('B0477', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0477', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0477', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0477', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0477', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0487', '잡곡밥', CAST(145 AS NUMERIC(12,3)), 'g'),
    ('B0487', '두부', CAST(140 AS NUMERIC(12,3)), 'g'),
    ('B0487', '애호박', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0487', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0487', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0487', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0487', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0487', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0497', '잡곡밥', CAST(145 AS NUMERIC(12,3)), 'g'),
    ('B0497', '두부', CAST(140 AS NUMERIC(12,3)), 'g'),
    ('B0497', '시금치', CAST(60 AS NUMERIC(12,3)), 'g'),
    ('B0497', '토마토', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('B0497', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0497', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0497', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0497', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0507', '통밀 또띠아', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0507', '닭가슴살', CAST(100 AS NUMERIC(12,3)), 'g'),
    ('B0507', '양배추', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('B0507', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0507', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('B0507', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0507', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('B0517', '통밀 또띠아', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0517', '닭가슴살', CAST(100 AS NUMERIC(12,3)), 'g'),
    ('B0517', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('B0517', '양파', CAST(45 AS NUMERIC(12,3)), 'g'),
    ('B0517', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('B0517', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0517', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('B0527', '통밀 또띠아', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0527', '닭가슴살', CAST(100 AS NUMERIC(12,3)), 'g'),
    ('B0527', '애호박', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('B0527', '파프리카', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('B0527', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('B0527', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0527', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('B0537', '통밀 또띠아', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0537', '닭가슴살', CAST(100 AS NUMERIC(12,3)), 'g'),
    ('B0537', '시금치', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0537', '느타리버섯', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0537', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('B0537', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0537', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('B0547', '통밀 또띠아', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0547', '닭가슴살', CAST(100 AS NUMERIC(12,3)), 'g'),
    ('B0547', '청경채', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0547', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0547', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('B0547', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0547', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('B0557', '통밀 또띠아', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0557', '닭가슴살', CAST(100 AS NUMERIC(12,3)), 'g'),
    ('B0557', '가지', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('B0557', '토마토', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0557', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('B0557', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0557', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('B0567', '통밀 또띠아', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0567', '닭가슴살', CAST(100 AS NUMERIC(12,3)), 'g'),
    ('B0567', '양배추', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0567', '파프리카', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0567', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('B0567', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0567', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('B0577', '통밀 또띠아', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0577', '닭가슴살', CAST(100 AS NUMERIC(12,3)), 'g'),
    ('B0577', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('B0577', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0577', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('B0577', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0577', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('B0587', '통밀 또띠아', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0587', '닭가슴살', CAST(100 AS NUMERIC(12,3)), 'g'),
    ('B0587', '애호박', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0587', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0587', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('B0587', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0587', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('B0597', '통밀 또띠아', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0597', '닭가슴살', CAST(100 AS NUMERIC(12,3)), 'g'),
    ('B0597', '시금치', CAST(60 AS NUMERIC(12,3)), 'g'),
    ('B0597', '토마토', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('B0597', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('B0597', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0597', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('B0607', '현미밥', CAST(145 AS NUMERIC(12,3)), 'g'),
    ('B0607', '참치 통조림', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('B0607', '양배추', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('B0607', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0607', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0607', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0607', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0607', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0617', '현미밥', CAST(145 AS NUMERIC(12,3)), 'g'),
    ('B0617', '참치 통조림', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('B0617', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('B0617', '양파', CAST(45 AS NUMERIC(12,3)), 'g'),
    ('B0617', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0617', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0617', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0617', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0627', '현미밥', CAST(145 AS NUMERIC(12,3)), 'g'),
    ('B0627', '참치 통조림', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('B0627', '애호박', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('B0627', '파프리카', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('B0627', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0627', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0627', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0627', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0637', '현미밥', CAST(145 AS NUMERIC(12,3)), 'g'),
    ('B0637', '참치 통조림', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('B0637', '시금치', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0637', '느타리버섯', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0637', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0637', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0637', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0637', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0647', '현미밥', CAST(145 AS NUMERIC(12,3)), 'g'),
    ('B0647', '참치 통조림', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('B0647', '청경채', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0647', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0647', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0647', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0647', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0647', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0657', '현미밥', CAST(145 AS NUMERIC(12,3)), 'g'),
    ('B0657', '참치 통조림', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('B0657', '가지', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('B0657', '토마토', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0657', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0657', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0657', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0657', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0667', '현미밥', CAST(145 AS NUMERIC(12,3)), 'g'),
    ('B0667', '참치 통조림', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('B0667', '양배추', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0667', '파프리카', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0667', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0667', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0667', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0667', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0677', '현미밥', CAST(145 AS NUMERIC(12,3)), 'g'),
    ('B0677', '참치 통조림', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('B0677', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('B0677', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0677', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0677', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0677', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0677', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0687', '현미밥', CAST(145 AS NUMERIC(12,3)), 'g'),
    ('B0687', '참치 통조림', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('B0687', '애호박', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0687', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0687', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0687', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0687', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0687', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0697', '현미밥', CAST(145 AS NUMERIC(12,3)), 'g'),
    ('B0697', '참치 통조림', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('B0697', '시금치', CAST(60 AS NUMERIC(12,3)), 'g'),
    ('B0697', '토마토', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('B0697', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0697', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0697', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0697', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0707', '퀴노아', CAST(160 AS NUMERIC(12,3)), 'g'),
    ('B0707', '병아리콩', CAST(100 AS NUMERIC(12,3)), 'g'),
    ('B0707', '양배추', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('B0707', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0707', '올리브유', CAST(7 AS NUMERIC(12,3)), 'g'),
    ('B0707', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0707', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('B0717', '퀴노아', CAST(160 AS NUMERIC(12,3)), 'g'),
    ('B0717', '병아리콩', CAST(100 AS NUMERIC(12,3)), 'g'),
    ('B0717', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('B0717', '양파', CAST(45 AS NUMERIC(12,3)), 'g'),
    ('B0717', '올리브유', CAST(7 AS NUMERIC(12,3)), 'g'),
    ('B0717', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0717', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('B0727', '퀴노아', CAST(160 AS NUMERIC(12,3)), 'g'),
    ('B0727', '병아리콩', CAST(100 AS NUMERIC(12,3)), 'g'),
    ('B0727', '애호박', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('B0727', '파프리카', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('B0727', '올리브유', CAST(7 AS NUMERIC(12,3)), 'g'),
    ('B0727', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0727', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('B0737', '퀴노아', CAST(160 AS NUMERIC(12,3)), 'g'),
    ('B0737', '병아리콩', CAST(100 AS NUMERIC(12,3)), 'g'),
    ('B0737', '시금치', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0737', '느타리버섯', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0737', '올리브유', CAST(7 AS NUMERIC(12,3)), 'g'),
    ('B0737', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0737', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('B0747', '퀴노아', CAST(160 AS NUMERIC(12,3)), 'g'),
    ('B0747', '병아리콩', CAST(100 AS NUMERIC(12,3)), 'g'),
    ('B0747', '청경채', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0747', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0747', '올리브유', CAST(7 AS NUMERIC(12,3)), 'g'),
    ('B0747', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0747', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('B0757', '퀴노아', CAST(160 AS NUMERIC(12,3)), 'g'),
    ('B0757', '병아리콩', CAST(100 AS NUMERIC(12,3)), 'g'),
    ('B0757', '가지', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('B0757', '토마토', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0757', '올리브유', CAST(7 AS NUMERIC(12,3)), 'g'),
    ('B0757', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0757', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('B0767', '퀴노아', CAST(160 AS NUMERIC(12,3)), 'g'),
    ('B0767', '병아리콩', CAST(100 AS NUMERIC(12,3)), 'g'),
    ('B0767', '양배추', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0767', '파프리카', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0767', '올리브유', CAST(7 AS NUMERIC(12,3)), 'g'),
    ('B0767', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0767', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('B0777', '퀴노아', CAST(160 AS NUMERIC(12,3)), 'g'),
    ('B0777', '병아리콩', CAST(100 AS NUMERIC(12,3)), 'g'),
    ('B0777', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('B0777', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0777', '올리브유', CAST(7 AS NUMERIC(12,3)), 'g'),
    ('B0777', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0777', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('B0787', '퀴노아', CAST(160 AS NUMERIC(12,3)), 'g'),
    ('B0787', '병아리콩', CAST(100 AS NUMERIC(12,3)), 'g'),
    ('B0787', '애호박', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0787', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0787', '올리브유', CAST(7 AS NUMERIC(12,3)), 'g'),
    ('B0787', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0787', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('B0797', '퀴노아', CAST(160 AS NUMERIC(12,3)), 'g'),
    ('B0797', '병아리콩', CAST(100 AS NUMERIC(12,3)), 'g'),
    ('B0797', '시금치', CAST(60 AS NUMERIC(12,3)), 'g'),
    ('B0797', '토마토', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('B0797', '올리브유', CAST(7 AS NUMERIC(12,3)), 'g'),
    ('B0797', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0797', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('B0807', '보리밥', CAST(150 AS NUMERIC(12,3)), 'g'),
    ('B0807', '달걀', CAST(2 AS NUMERIC(12,3)), '개'),
    ('B0807', '양배추', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('B0807', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0807', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0807', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0807', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0807', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0817', '보리밥', CAST(150 AS NUMERIC(12,3)), 'g'),
    ('B0817', '달걀', CAST(2 AS NUMERIC(12,3)), '개'),
    ('B0817', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('B0817', '양파', CAST(45 AS NUMERIC(12,3)), 'g'),
    ('B0817', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0817', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0817', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0817', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0827', '보리밥', CAST(150 AS NUMERIC(12,3)), 'g'),
    ('B0827', '달걀', CAST(2 AS NUMERIC(12,3)), '개'),
    ('B0827', '애호박', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('B0827', '파프리카', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('B0827', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0827', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0827', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0827', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0837', '보리밥', CAST(150 AS NUMERIC(12,3)), 'g'),
    ('B0837', '달걀', CAST(2 AS NUMERIC(12,3)), '개'),
    ('B0837', '시금치', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0837', '느타리버섯', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0837', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0837', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0837', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0837', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0847', '보리밥', CAST(150 AS NUMERIC(12,3)), 'g'),
    ('B0847', '달걀', CAST(2 AS NUMERIC(12,3)), '개'),
    ('B0847', '청경채', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0847', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0847', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0847', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0847', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0847', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0857', '보리밥', CAST(150 AS NUMERIC(12,3)), 'g'),
    ('B0857', '달걀', CAST(2 AS NUMERIC(12,3)), '개'),
    ('B0857', '가지', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('B0857', '토마토', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0857', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0857', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0857', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0857', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0867', '보리밥', CAST(150 AS NUMERIC(12,3)), 'g'),
    ('B0867', '달걀', CAST(2 AS NUMERIC(12,3)), '개'),
    ('B0867', '양배추', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0867', '파프리카', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0867', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0867', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0867', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0867', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0877', '보리밥', CAST(150 AS NUMERIC(12,3)), 'g'),
    ('B0877', '달걀', CAST(2 AS NUMERIC(12,3)), '개'),
    ('B0877', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('B0877', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0877', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0877', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0877', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0877', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0887', '보리밥', CAST(150 AS NUMERIC(12,3)), 'g'),
    ('B0887', '달걀', CAST(2 AS NUMERIC(12,3)), '개'),
    ('B0887', '애호박', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0887', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0887', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0887', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0887', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0887', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0897', '보리밥', CAST(150 AS NUMERIC(12,3)), 'g'),
    ('B0897', '달걀', CAST(2 AS NUMERIC(12,3)), '개'),
    ('B0897', '시금치', CAST(60 AS NUMERIC(12,3)), 'g'),
    ('B0897', '토마토', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('B0897', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0897', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0897', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0897', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0901', '오트밀', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('B0901', '렌틸콩', CAST(110 AS NUMERIC(12,3)), 'g'),
    ('B0901', '양배추', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('B0901', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0901', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0901', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0901', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0901', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0902', '오트밀', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('B0902', '렌틸콩', CAST(110 AS NUMERIC(12,3)), 'g'),
    ('B0902', '양배추', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('B0902', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0902', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0902', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0902', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0902', '소금', CAST(0.5 AS NUMERIC(12,3)), 'g'),
    ('B0904', '오트밀', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('B0904', '렌틸콩', CAST(110 AS NUMERIC(12,3)), 'g'),
    ('B0904', '양배추', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('B0904', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0904', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0904', '다진 마늘', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0904', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0904', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0907', '오트밀', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('B0907', '렌틸콩', CAST(110 AS NUMERIC(12,3)), 'g'),
    ('B0907', '양배추', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('B0907', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0907', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0907', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0907', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0907', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0907', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0908', '오트밀', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('B0908', '렌틸콩', CAST(110 AS NUMERIC(12,3)), 'g'),
    ('B0908', '양배추', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('B0908', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0908', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0908', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0908', '대파', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('B0908', '참기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0910', '오트밀', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('B0910', '렌틸콩', CAST(110 AS NUMERIC(12,3)), 'g'),
    ('B0910', '양배추', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('B0910', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0910', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0910', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0910', '김가루', CAST(2 AS NUMERIC(12,3)), 'g'),
    ('B0910', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0911', '오트밀', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('B0911', '렌틸콩', CAST(110 AS NUMERIC(12,3)), 'g'),
    ('B0911', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('B0911', '양파', CAST(45 AS NUMERIC(12,3)), 'g'),
    ('B0911', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0911', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0911', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0911', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0912', '오트밀', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('B0912', '렌틸콩', CAST(110 AS NUMERIC(12,3)), 'g'),
    ('B0912', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('B0912', '양파', CAST(45 AS NUMERIC(12,3)), 'g'),
    ('B0912', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0912', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0912', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0912', '소금', CAST(0.5 AS NUMERIC(12,3)), 'g'),
    ('B0914', '오트밀', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('B0914', '렌틸콩', CAST(110 AS NUMERIC(12,3)), 'g'),
    ('B0914', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('B0914', '양파', CAST(45 AS NUMERIC(12,3)), 'g'),
    ('B0914', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0914', '다진 마늘', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0914', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0914', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0917', '오트밀', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('B0917', '렌틸콩', CAST(110 AS NUMERIC(12,3)), 'g'),
    ('B0917', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('B0917', '양파', CAST(45 AS NUMERIC(12,3)), 'g'),
    ('B0917', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0917', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0917', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0917', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0917', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0918', '오트밀', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('B0918', '렌틸콩', CAST(110 AS NUMERIC(12,3)), 'g'),
    ('B0918', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('B0918', '양파', CAST(45 AS NUMERIC(12,3)), 'g'),
    ('B0918', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0918', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0918', '대파', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('B0918', '참기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0920', '오트밀', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('B0920', '렌틸콩', CAST(110 AS NUMERIC(12,3)), 'g'),
    ('B0920', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('B0920', '양파', CAST(45 AS NUMERIC(12,3)), 'g'),
    ('B0920', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0920', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0920', '김가루', CAST(2 AS NUMERIC(12,3)), 'g'),
    ('B0920', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0921', '오트밀', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('B0921', '렌틸콩', CAST(110 AS NUMERIC(12,3)), 'g'),
    ('B0921', '애호박', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('B0921', '파프리카', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('B0921', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0921', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0921', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0921', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0922', '오트밀', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('B0922', '렌틸콩', CAST(110 AS NUMERIC(12,3)), 'g'),
    ('B0922', '애호박', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('B0922', '파프리카', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('B0922', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0922', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0922', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0922', '소금', CAST(0.5 AS NUMERIC(12,3)), 'g'),
    ('B0924', '오트밀', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('B0924', '렌틸콩', CAST(110 AS NUMERIC(12,3)), 'g'),
    ('B0924', '애호박', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('B0924', '파프리카', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('B0924', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0924', '다진 마늘', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0924', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0924', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0927', '오트밀', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('B0927', '렌틸콩', CAST(110 AS NUMERIC(12,3)), 'g'),
    ('B0927', '애호박', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('B0927', '파프리카', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('B0927', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0927', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0927', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0927', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0927', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0928', '오트밀', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('B0928', '렌틸콩', CAST(110 AS NUMERIC(12,3)), 'g'),
    ('B0928', '애호박', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('B0928', '파프리카', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('B0928', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0928', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0928', '대파', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('B0928', '참기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0930', '오트밀', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('B0930', '렌틸콩', CAST(110 AS NUMERIC(12,3)), 'g'),
    ('B0930', '애호박', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('B0930', '파프리카', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('B0930', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0930', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0930', '김가루', CAST(2 AS NUMERIC(12,3)), 'g'),
    ('B0930', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0931', '오트밀', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('B0931', '렌틸콩', CAST(110 AS NUMERIC(12,3)), 'g'),
    ('B0931', '시금치', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0931', '느타리버섯', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0931', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0931', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0931', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0931', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0932', '오트밀', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('B0932', '렌틸콩', CAST(110 AS NUMERIC(12,3)), 'g'),
    ('B0932', '시금치', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0932', '느타리버섯', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0932', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0932', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0932', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0932', '소금', CAST(0.5 AS NUMERIC(12,3)), 'g'),
    ('B0934', '오트밀', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('B0934', '렌틸콩', CAST(110 AS NUMERIC(12,3)), 'g'),
    ('B0934', '시금치', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0934', '느타리버섯', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0934', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0934', '다진 마늘', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0934', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0934', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0937', '오트밀', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('B0937', '렌틸콩', CAST(110 AS NUMERIC(12,3)), 'g'),
    ('B0937', '시금치', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0937', '느타리버섯', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0937', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0937', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0937', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0937', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0937', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0938', '오트밀', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('B0938', '렌틸콩', CAST(110 AS NUMERIC(12,3)), 'g'),
    ('B0938', '시금치', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0938', '느타리버섯', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0938', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0938', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0938', '대파', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('B0938', '참기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0940', '오트밀', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('B0940', '렌틸콩', CAST(110 AS NUMERIC(12,3)), 'g'),
    ('B0940', '시금치', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0940', '느타리버섯', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0940', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0940', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0940', '김가루', CAST(2 AS NUMERIC(12,3)), 'g'),
    ('B0940', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0941', '오트밀', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('B0941', '렌틸콩', CAST(110 AS NUMERIC(12,3)), 'g'),
    ('B0941', '청경채', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0941', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0941', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0941', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0941', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0941', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0942', '오트밀', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('B0942', '렌틸콩', CAST(110 AS NUMERIC(12,3)), 'g'),
    ('B0942', '청경채', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0942', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0942', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0942', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0942', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0942', '소금', CAST(0.5 AS NUMERIC(12,3)), 'g'),
    ('B0944', '오트밀', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('B0944', '렌틸콩', CAST(110 AS NUMERIC(12,3)), 'g'),
    ('B0944', '청경채', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0944', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0944', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0944', '다진 마늘', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0944', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0944', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0947', '오트밀', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('B0947', '렌틸콩', CAST(110 AS NUMERIC(12,3)), 'g'),
    ('B0947', '청경채', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0947', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0947', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0947', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0947', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0947', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0947', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0948', '오트밀', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('B0948', '렌틸콩', CAST(110 AS NUMERIC(12,3)), 'g'),
    ('B0948', '청경채', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0948', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0948', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0948', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0948', '대파', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('B0948', '참기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0950', '오트밀', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('B0950', '렌틸콩', CAST(110 AS NUMERIC(12,3)), 'g'),
    ('B0950', '청경채', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0950', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0950', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0950', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0950', '김가루', CAST(2 AS NUMERIC(12,3)), 'g'),
    ('B0950', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0951', '오트밀', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('B0951', '렌틸콩', CAST(110 AS NUMERIC(12,3)), 'g'),
    ('B0951', '가지', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('B0951', '토마토', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0951', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0951', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0951', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0951', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0952', '오트밀', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('B0952', '렌틸콩', CAST(110 AS NUMERIC(12,3)), 'g'),
    ('B0952', '가지', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('B0952', '토마토', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0952', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0952', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0952', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0952', '소금', CAST(0.5 AS NUMERIC(12,3)), 'g'),
    ('B0954', '오트밀', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('B0954', '렌틸콩', CAST(110 AS NUMERIC(12,3)), 'g'),
    ('B0954', '가지', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('B0954', '토마토', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0954', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0954', '다진 마늘', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0954', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0954', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0957', '오트밀', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('B0957', '렌틸콩', CAST(110 AS NUMERIC(12,3)), 'g'),
    ('B0957', '가지', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('B0957', '토마토', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0957', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0957', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0957', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0957', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0957', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0958', '오트밀', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('B0958', '렌틸콩', CAST(110 AS NUMERIC(12,3)), 'g'),
    ('B0958', '가지', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('B0958', '토마토', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0958', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0958', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0958', '대파', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('B0958', '참기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0960', '오트밀', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('B0960', '렌틸콩', CAST(110 AS NUMERIC(12,3)), 'g'),
    ('B0960', '가지', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('B0960', '토마토', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0960', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0960', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0960', '김가루', CAST(2 AS NUMERIC(12,3)), 'g'),
    ('B0960', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0961', '오트밀', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('B0961', '렌틸콩', CAST(110 AS NUMERIC(12,3)), 'g'),
    ('B0961', '양배추', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0961', '파프리카', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0961', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0961', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0961', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0961', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0962', '오트밀', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('B0962', '렌틸콩', CAST(110 AS NUMERIC(12,3)), 'g'),
    ('B0962', '양배추', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0962', '파프리카', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0962', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0962', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0962', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0962', '소금', CAST(0.5 AS NUMERIC(12,3)), 'g'),
    ('B0964', '오트밀', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('B0964', '렌틸콩', CAST(110 AS NUMERIC(12,3)), 'g'),
    ('B0964', '양배추', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0964', '파프리카', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0964', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0964', '다진 마늘', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0964', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0964', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0967', '오트밀', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('B0967', '렌틸콩', CAST(110 AS NUMERIC(12,3)), 'g'),
    ('B0967', '양배추', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0967', '파프리카', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0967', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0967', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0967', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0967', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0967', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0968', '오트밀', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('B0968', '렌틸콩', CAST(110 AS NUMERIC(12,3)), 'g'),
    ('B0968', '양배추', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0968', '파프리카', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0968', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0968', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0968', '대파', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('B0968', '참기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0970', '오트밀', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('B0970', '렌틸콩', CAST(110 AS NUMERIC(12,3)), 'g'),
    ('B0970', '양배추', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0970', '파프리카', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0970', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0970', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0970', '김가루', CAST(2 AS NUMERIC(12,3)), 'g'),
    ('B0970', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0971', '오트밀', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('B0971', '렌틸콩', CAST(110 AS NUMERIC(12,3)), 'g'),
    ('B0971', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('B0971', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0971', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0971', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0971', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0971', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0972', '오트밀', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('B0972', '렌틸콩', CAST(110 AS NUMERIC(12,3)), 'g'),
    ('B0972', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('B0972', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0972', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0972', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0972', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0972', '소금', CAST(0.5 AS NUMERIC(12,3)), 'g'),
    ('B0974', '오트밀', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('B0974', '렌틸콩', CAST(110 AS NUMERIC(12,3)), 'g'),
    ('B0974', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('B0974', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0974', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0974', '다진 마늘', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0974', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0974', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0977', '오트밀', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('B0977', '렌틸콩', CAST(110 AS NUMERIC(12,3)), 'g'),
    ('B0977', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('B0977', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0977', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0977', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0977', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0977', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0977', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0978', '오트밀', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('B0978', '렌틸콩', CAST(110 AS NUMERIC(12,3)), 'g'),
    ('B0978', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('B0978', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0978', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0978', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0978', '대파', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('B0978', '참기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0980', '오트밀', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('B0980', '렌틸콩', CAST(110 AS NUMERIC(12,3)), 'g'),
    ('B0980', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('B0980', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('B0980', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0980', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0980', '김가루', CAST(2 AS NUMERIC(12,3)), 'g'),
    ('B0980', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0981', '오트밀', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('B0981', '렌틸콩', CAST(110 AS NUMERIC(12,3)), 'g'),
    ('B0981', '애호박', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0981', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0981', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0981', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0981', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0981', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0982', '오트밀', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('B0982', '렌틸콩', CAST(110 AS NUMERIC(12,3)), 'g'),
    ('B0982', '애호박', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0982', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0982', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0982', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0982', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0982', '소금', CAST(0.5 AS NUMERIC(12,3)), 'g'),
    ('B0984', '오트밀', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('B0984', '렌틸콩', CAST(110 AS NUMERIC(12,3)), 'g'),
    ('B0984', '애호박', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0984', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0984', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0984', '다진 마늘', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0984', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0984', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0987', '오트밀', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('B0987', '렌틸콩', CAST(110 AS NUMERIC(12,3)), 'g'),
    ('B0987', '애호박', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0987', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0987', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0987', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0987', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0987', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0987', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0988', '오트밀', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('B0988', '렌틸콩', CAST(110 AS NUMERIC(12,3)), 'g'),
    ('B0988', '애호박', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0988', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0988', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0988', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0988', '대파', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('B0988', '참기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0990', '오트밀', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('B0990', '렌틸콩', CAST(110 AS NUMERIC(12,3)), 'g'),
    ('B0990', '애호박', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('B0990', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('B0990', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0990', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0990', '김가루', CAST(2 AS NUMERIC(12,3)), 'g'),
    ('B0990', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0991', '오트밀', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('B0991', '렌틸콩', CAST(110 AS NUMERIC(12,3)), 'g'),
    ('B0991', '시금치', CAST(60 AS NUMERIC(12,3)), 'g'),
    ('B0991', '토마토', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('B0991', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0991', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0991', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0991', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0992', '오트밀', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('B0992', '렌틸콩', CAST(110 AS NUMERIC(12,3)), 'g'),
    ('B0992', '시금치', CAST(60 AS NUMERIC(12,3)), 'g'),
    ('B0992', '토마토', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('B0992', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0992', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0992', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0992', '소금', CAST(0.5 AS NUMERIC(12,3)), 'g'),
    ('B0994', '오트밀', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('B0994', '렌틸콩', CAST(110 AS NUMERIC(12,3)), 'g'),
    ('B0994', '시금치', CAST(60 AS NUMERIC(12,3)), 'g'),
    ('B0994', '토마토', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('B0994', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0994', '다진 마늘', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0994', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0994', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0997', '오트밀', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('B0997', '렌틸콩', CAST(110 AS NUMERIC(12,3)), 'g'),
    ('B0997', '시금치', CAST(60 AS NUMERIC(12,3)), 'g'),
    ('B0997', '토마토', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('B0997', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0997', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0997', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0997', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B0997', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('B0998', '오트밀', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('B0998', '렌틸콩', CAST(110 AS NUMERIC(12,3)), 'g'),
    ('B0998', '시금치', CAST(60 AS NUMERIC(12,3)), 'g'),
    ('B0998', '토마토', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('B0998', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B0998', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B0998', '대파', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('B0998', '참기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('B1000', '오트밀', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('B1000', '렌틸콩', CAST(110 AS NUMERIC(12,3)), 'g'),
    ('B1000', '시금치', CAST(60 AS NUMERIC(12,3)), 'g'),
    ('B1000', '토마토', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('B1000', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('B1000', '물', CAST(230 AS NUMERIC(12,3)), 'ml'),
    ('B1000', '김가루', CAST(2 AS NUMERIC(12,3)), 'g'),
    ('B1000', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0007', '현미밥', CAST(165 AS NUMERIC(12,3)), 'g'),
    ('L0007', '닭가슴살', CAST(125 AS NUMERIC(12,3)), 'g'),
    ('L0007', '양배추', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('L0007', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('L0007', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0007', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0007', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0007', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0017', '현미밥', CAST(165 AS NUMERIC(12,3)), 'g'),
    ('L0017', '닭가슴살', CAST(125 AS NUMERIC(12,3)), 'g'),
    ('L0017', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('L0017', '양파', CAST(45 AS NUMERIC(12,3)), 'g'),
    ('L0017', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0017', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0017', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0017', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0027', '현미밥', CAST(165 AS NUMERIC(12,3)), 'g'),
    ('L0027', '닭가슴살', CAST(125 AS NUMERIC(12,3)), 'g'),
    ('L0027', '애호박', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('L0027', '파프리카', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('L0027', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0027', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0027', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0027', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0037', '현미밥', CAST(165 AS NUMERIC(12,3)), 'g'),
    ('L0037', '닭가슴살', CAST(125 AS NUMERIC(12,3)), 'g'),
    ('L0037', '시금치', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('L0037', '느타리버섯', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('L0037', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0037', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0037', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0037', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0047', '현미밥', CAST(165 AS NUMERIC(12,3)), 'g'),
    ('L0047', '닭가슴살', CAST(125 AS NUMERIC(12,3)), 'g'),
    ('L0047', '청경채', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('L0047', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('L0047', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0047', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0047', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0047', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0057', '현미밥', CAST(165 AS NUMERIC(12,3)), 'g'),
    ('L0057', '닭가슴살', CAST(125 AS NUMERIC(12,3)), 'g'),
    ('L0057', '가지', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('L0057', '토마토', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('L0057', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0057', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0057', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0057', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0067', '현미밥', CAST(165 AS NUMERIC(12,3)), 'g'),
    ('L0067', '닭가슴살', CAST(125 AS NUMERIC(12,3)), 'g'),
    ('L0067', '양배추', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('L0067', '파프리카', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('L0067', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0067', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0067', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0067', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0077', '현미밥', CAST(165 AS NUMERIC(12,3)), 'g'),
    ('L0077', '닭가슴살', CAST(125 AS NUMERIC(12,3)), 'g'),
    ('L0077', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('L0077', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('L0077', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0077', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0077', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0077', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0087', '현미밥', CAST(165 AS NUMERIC(12,3)), 'g'),
    ('L0087', '닭가슴살', CAST(125 AS NUMERIC(12,3)), 'g'),
    ('L0087', '애호박', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('L0087', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('L0087', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0087', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0087', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0087', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0097', '현미밥', CAST(165 AS NUMERIC(12,3)), 'g'),
    ('L0097', '닭가슴살', CAST(125 AS NUMERIC(12,3)), 'g'),
    ('L0097', '시금치', CAST(60 AS NUMERIC(12,3)), 'g'),
    ('L0097', '토마토', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('L0097', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0097', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0097', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0097', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0107', '잡곡밥', CAST(165 AS NUMERIC(12,3)), 'g'),
    ('L0107', '돼지 안심', CAST(120 AS NUMERIC(12,3)), 'g'),
    ('L0107', '양배추', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('L0107', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('L0107', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0107', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0107', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0107', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0117', '잡곡밥', CAST(165 AS NUMERIC(12,3)), 'g'),
    ('L0117', '돼지 안심', CAST(120 AS NUMERIC(12,3)), 'g'),
    ('L0117', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('L0117', '양파', CAST(45 AS NUMERIC(12,3)), 'g'),
    ('L0117', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0117', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0117', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0117', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0127', '잡곡밥', CAST(165 AS NUMERIC(12,3)), 'g'),
    ('L0127', '돼지 안심', CAST(120 AS NUMERIC(12,3)), 'g'),
    ('L0127', '애호박', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('L0127', '파프리카', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('L0127', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0127', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0127', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0127', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0137', '잡곡밥', CAST(165 AS NUMERIC(12,3)), 'g'),
    ('L0137', '돼지 안심', CAST(120 AS NUMERIC(12,3)), 'g'),
    ('L0137', '시금치', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('L0137', '느타리버섯', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('L0137', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0137', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0137', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0137', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0147', '잡곡밥', CAST(165 AS NUMERIC(12,3)), 'g'),
    ('L0147', '돼지 안심', CAST(120 AS NUMERIC(12,3)), 'g'),
    ('L0147', '청경채', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('L0147', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('L0147', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0147', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0147', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0147', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0157', '잡곡밥', CAST(165 AS NUMERIC(12,3)), 'g'),
    ('L0157', '돼지 안심', CAST(120 AS NUMERIC(12,3)), 'g'),
    ('L0157', '가지', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('L0157', '토마토', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('L0157', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0157', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0157', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0157', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0167', '잡곡밥', CAST(165 AS NUMERIC(12,3)), 'g'),
    ('L0167', '돼지 안심', CAST(120 AS NUMERIC(12,3)), 'g'),
    ('L0167', '양배추', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('L0167', '파프리카', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('L0167', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0167', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0167', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0167', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0177', '잡곡밥', CAST(165 AS NUMERIC(12,3)), 'g'),
    ('L0177', '돼지 안심', CAST(120 AS NUMERIC(12,3)), 'g'),
    ('L0177', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('L0177', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('L0177', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0177', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0177', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0177', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0187', '잡곡밥', CAST(165 AS NUMERIC(12,3)), 'g'),
    ('L0187', '돼지 안심', CAST(120 AS NUMERIC(12,3)), 'g'),
    ('L0187', '애호박', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('L0187', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('L0187', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0187', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0187', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0187', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0197', '잡곡밥', CAST(165 AS NUMERIC(12,3)), 'g'),
    ('L0197', '돼지 안심', CAST(120 AS NUMERIC(12,3)), 'g'),
    ('L0197', '시금치', CAST(60 AS NUMERIC(12,3)), 'g'),
    ('L0197', '토마토', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('L0197', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0197', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0197', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0197', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0207', '통밀 또띠아', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('L0207', '두부', CAST(150 AS NUMERIC(12,3)), 'g'),
    ('L0207', '양배추', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('L0207', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('L0207', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('L0207', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0207', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('L0217', '통밀 또띠아', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('L0217', '두부', CAST(150 AS NUMERIC(12,3)), 'g'),
    ('L0217', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('L0217', '양파', CAST(45 AS NUMERIC(12,3)), 'g'),
    ('L0217', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('L0217', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0217', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('L0227', '통밀 또띠아', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('L0227', '두부', CAST(150 AS NUMERIC(12,3)), 'g'),
    ('L0227', '애호박', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('L0227', '파프리카', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('L0227', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('L0227', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0227', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('L0237', '통밀 또띠아', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('L0237', '두부', CAST(150 AS NUMERIC(12,3)), 'g'),
    ('L0237', '시금치', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('L0237', '느타리버섯', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('L0237', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('L0237', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0237', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('L0247', '통밀 또띠아', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('L0247', '두부', CAST(150 AS NUMERIC(12,3)), 'g'),
    ('L0247', '청경채', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('L0247', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('L0247', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('L0247', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0247', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('L0257', '통밀 또띠아', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('L0257', '두부', CAST(150 AS NUMERIC(12,3)), 'g'),
    ('L0257', '가지', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('L0257', '토마토', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('L0257', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('L0257', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0257', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('L0267', '통밀 또띠아', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('L0267', '두부', CAST(150 AS NUMERIC(12,3)), 'g'),
    ('L0267', '양배추', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('L0267', '파프리카', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('L0267', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('L0267', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0267', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('L0277', '통밀 또띠아', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('L0277', '두부', CAST(150 AS NUMERIC(12,3)), 'g'),
    ('L0277', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('L0277', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('L0277', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('L0277', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0277', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('L0287', '통밀 또띠아', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('L0287', '두부', CAST(150 AS NUMERIC(12,3)), 'g'),
    ('L0287', '애호박', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('L0287', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('L0287', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('L0287', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0287', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('L0297', '통밀 또띠아', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('L0297', '두부', CAST(150 AS NUMERIC(12,3)), 'g'),
    ('L0297', '시금치', CAST(60 AS NUMERIC(12,3)), 'g'),
    ('L0297', '토마토', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('L0297', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('L0297', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0297', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('L0307', '메밀면', CAST(89 AS NUMERIC(12,3)), 'g'),
    ('L0307', '새우', CAST(125 AS NUMERIC(12,3)), 'g'),
    ('L0307', '양배추', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('L0307', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('L0307', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0307', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0307', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0307', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0317', '메밀면', CAST(89 AS NUMERIC(12,3)), 'g'),
    ('L0317', '새우', CAST(125 AS NUMERIC(12,3)), 'g'),
    ('L0317', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('L0317', '양파', CAST(45 AS NUMERIC(12,3)), 'g'),
    ('L0317', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0317', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0317', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0317', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0327', '메밀면', CAST(89 AS NUMERIC(12,3)), 'g'),
    ('L0327', '새우', CAST(125 AS NUMERIC(12,3)), 'g'),
    ('L0327', '애호박', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('L0327', '파프리카', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('L0327', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0327', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0327', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0327', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0337', '메밀면', CAST(89 AS NUMERIC(12,3)), 'g'),
    ('L0337', '새우', CAST(125 AS NUMERIC(12,3)), 'g'),
    ('L0337', '시금치', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('L0337', '느타리버섯', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('L0337', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0337', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0337', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0337', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0347', '메밀면', CAST(89 AS NUMERIC(12,3)), 'g'),
    ('L0347', '새우', CAST(125 AS NUMERIC(12,3)), 'g'),
    ('L0347', '청경채', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('L0347', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('L0347', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0347', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0347', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0347', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0357', '메밀면', CAST(89 AS NUMERIC(12,3)), 'g'),
    ('L0357', '새우', CAST(125 AS NUMERIC(12,3)), 'g'),
    ('L0357', '가지', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('L0357', '토마토', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('L0357', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0357', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0357', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0357', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0367', '메밀면', CAST(89 AS NUMERIC(12,3)), 'g'),
    ('L0367', '새우', CAST(125 AS NUMERIC(12,3)), 'g'),
    ('L0367', '양배추', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('L0367', '파프리카', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('L0367', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0367', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0367', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0367', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0377', '메밀면', CAST(89 AS NUMERIC(12,3)), 'g'),
    ('L0377', '새우', CAST(125 AS NUMERIC(12,3)), 'g'),
    ('L0377', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('L0377', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('L0377', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0377', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0377', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0377', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0387', '메밀면', CAST(89 AS NUMERIC(12,3)), 'g'),
    ('L0387', '새우', CAST(125 AS NUMERIC(12,3)), 'g'),
    ('L0387', '애호박', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('L0387', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('L0387', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0387', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0387', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0387', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0397', '메밀면', CAST(89 AS NUMERIC(12,3)), 'g'),
    ('L0397', '새우', CAST(125 AS NUMERIC(12,3)), 'g'),
    ('L0397', '시금치', CAST(60 AS NUMERIC(12,3)), 'g'),
    ('L0397', '토마토', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('L0397', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0397', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0397', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0397', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0407', '감자', CAST(190 AS NUMERIC(12,3)), 'g'),
    ('L0407', '참치 통조림', CAST(110 AS NUMERIC(12,3)), 'g'),
    ('L0407', '양배추', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('L0407', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('L0407', '올리브유', CAST(7 AS NUMERIC(12,3)), 'g'),
    ('L0407', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0407', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('L0417', '감자', CAST(190 AS NUMERIC(12,3)), 'g'),
    ('L0417', '참치 통조림', CAST(110 AS NUMERIC(12,3)), 'g'),
    ('L0417', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('L0417', '양파', CAST(45 AS NUMERIC(12,3)), 'g'),
    ('L0417', '올리브유', CAST(7 AS NUMERIC(12,3)), 'g'),
    ('L0417', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0417', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('L0427', '감자', CAST(190 AS NUMERIC(12,3)), 'g'),
    ('L0427', '참치 통조림', CAST(110 AS NUMERIC(12,3)), 'g'),
    ('L0427', '애호박', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('L0427', '파프리카', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('L0427', '올리브유', CAST(7 AS NUMERIC(12,3)), 'g'),
    ('L0427', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0427', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('L0437', '감자', CAST(190 AS NUMERIC(12,3)), 'g'),
    ('L0437', '참치 통조림', CAST(110 AS NUMERIC(12,3)), 'g'),
    ('L0437', '시금치', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('L0437', '느타리버섯', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('L0437', '올리브유', CAST(7 AS NUMERIC(12,3)), 'g'),
    ('L0437', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0437', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('L0447', '감자', CAST(190 AS NUMERIC(12,3)), 'g'),
    ('L0447', '참치 통조림', CAST(110 AS NUMERIC(12,3)), 'g'),
    ('L0447', '청경채', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('L0447', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('L0447', '올리브유', CAST(7 AS NUMERIC(12,3)), 'g'),
    ('L0447', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0447', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('L0457', '감자', CAST(190 AS NUMERIC(12,3)), 'g'),
    ('L0457', '참치 통조림', CAST(110 AS NUMERIC(12,3)), 'g'),
    ('L0457', '가지', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('L0457', '토마토', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('L0457', '올리브유', CAST(7 AS NUMERIC(12,3)), 'g'),
    ('L0457', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0457', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('L0467', '감자', CAST(190 AS NUMERIC(12,3)), 'g'),
    ('L0467', '참치 통조림', CAST(110 AS NUMERIC(12,3)), 'g'),
    ('L0467', '양배추', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('L0467', '파프리카', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('L0467', '올리브유', CAST(7 AS NUMERIC(12,3)), 'g'),
    ('L0467', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0467', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('L0477', '감자', CAST(190 AS NUMERIC(12,3)), 'g'),
    ('L0477', '참치 통조림', CAST(110 AS NUMERIC(12,3)), 'g'),
    ('L0477', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('L0477', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('L0477', '올리브유', CAST(7 AS NUMERIC(12,3)), 'g'),
    ('L0477', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0477', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('L0487', '감자', CAST(190 AS NUMERIC(12,3)), 'g'),
    ('L0487', '참치 통조림', CAST(110 AS NUMERIC(12,3)), 'g'),
    ('L0487', '애호박', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('L0487', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('L0487', '올리브유', CAST(7 AS NUMERIC(12,3)), 'g'),
    ('L0487', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0487', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('L0497', '감자', CAST(190 AS NUMERIC(12,3)), 'g'),
    ('L0497', '참치 통조림', CAST(110 AS NUMERIC(12,3)), 'g'),
    ('L0497', '시금치', CAST(60 AS NUMERIC(12,3)), 'g'),
    ('L0497', '토마토', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('L0497', '올리브유', CAST(7 AS NUMERIC(12,3)), 'g'),
    ('L0497', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0497', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('L0507', '퀴노아', CAST(175 AS NUMERIC(12,3)), 'g'),
    ('L0507', '연어', CAST(110 AS NUMERIC(12,3)), 'g'),
    ('L0507', '양배추', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('L0507', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('L0507', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('L0507', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0507', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('L0517', '퀴노아', CAST(175 AS NUMERIC(12,3)), 'g'),
    ('L0517', '연어', CAST(110 AS NUMERIC(12,3)), 'g'),
    ('L0517', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('L0517', '양파', CAST(45 AS NUMERIC(12,3)), 'g'),
    ('L0517', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('L0517', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0517', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('L0527', '퀴노아', CAST(175 AS NUMERIC(12,3)), 'g'),
    ('L0527', '연어', CAST(110 AS NUMERIC(12,3)), 'g'),
    ('L0527', '애호박', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('L0527', '파프리카', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('L0527', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('L0527', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0527', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('L0537', '퀴노아', CAST(175 AS NUMERIC(12,3)), 'g'),
    ('L0537', '연어', CAST(110 AS NUMERIC(12,3)), 'g'),
    ('L0537', '시금치', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('L0537', '느타리버섯', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('L0537', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('L0537', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0537', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('L0547', '퀴노아', CAST(175 AS NUMERIC(12,3)), 'g'),
    ('L0547', '연어', CAST(110 AS NUMERIC(12,3)), 'g'),
    ('L0547', '청경채', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('L0547', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('L0547', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('L0547', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0547', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('L0557', '퀴노아', CAST(175 AS NUMERIC(12,3)), 'g'),
    ('L0557', '연어', CAST(110 AS NUMERIC(12,3)), 'g'),
    ('L0557', '가지', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('L0557', '토마토', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('L0557', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('L0557', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0557', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('L0567', '퀴노아', CAST(175 AS NUMERIC(12,3)), 'g'),
    ('L0567', '연어', CAST(110 AS NUMERIC(12,3)), 'g'),
    ('L0567', '양배추', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('L0567', '파프리카', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('L0567', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('L0567', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0567', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('L0577', '퀴노아', CAST(175 AS NUMERIC(12,3)), 'g'),
    ('L0577', '연어', CAST(110 AS NUMERIC(12,3)), 'g'),
    ('L0577', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('L0577', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('L0577', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('L0577', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0577', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('L0587', '퀴노아', CAST(175 AS NUMERIC(12,3)), 'g'),
    ('L0587', '연어', CAST(110 AS NUMERIC(12,3)), 'g'),
    ('L0587', '애호박', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('L0587', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('L0587', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('L0587', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0587', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('L0597', '퀴노아', CAST(175 AS NUMERIC(12,3)), 'g'),
    ('L0597', '연어', CAST(110 AS NUMERIC(12,3)), 'g'),
    ('L0597', '시금치', CAST(60 AS NUMERIC(12,3)), 'g'),
    ('L0597', '토마토', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('L0597', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('L0597', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0597', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('L0607', '보리밥', CAST(170 AS NUMERIC(12,3)), 'g'),
    ('L0607', '소고기 우둔살', CAST(115 AS NUMERIC(12,3)), 'g'),
    ('L0607', '양배추', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('L0607', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('L0607', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0607', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0607', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0607', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0617', '보리밥', CAST(170 AS NUMERIC(12,3)), 'g'),
    ('L0617', '소고기 우둔살', CAST(115 AS NUMERIC(12,3)), 'g'),
    ('L0617', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('L0617', '양파', CAST(45 AS NUMERIC(12,3)), 'g'),
    ('L0617', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0617', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0617', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0617', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0627', '보리밥', CAST(170 AS NUMERIC(12,3)), 'g'),
    ('L0627', '소고기 우둔살', CAST(115 AS NUMERIC(12,3)), 'g'),
    ('L0627', '애호박', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('L0627', '파프리카', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('L0627', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0627', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0627', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0627', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0637', '보리밥', CAST(170 AS NUMERIC(12,3)), 'g'),
    ('L0637', '소고기 우둔살', CAST(115 AS NUMERIC(12,3)), 'g'),
    ('L0637', '시금치', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('L0637', '느타리버섯', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('L0637', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0637', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0637', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0637', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0647', '보리밥', CAST(170 AS NUMERIC(12,3)), 'g'),
    ('L0647', '소고기 우둔살', CAST(115 AS NUMERIC(12,3)), 'g'),
    ('L0647', '청경채', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('L0647', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('L0647', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0647', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0647', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0647', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0657', '보리밥', CAST(170 AS NUMERIC(12,3)), 'g'),
    ('L0657', '소고기 우둔살', CAST(115 AS NUMERIC(12,3)), 'g'),
    ('L0657', '가지', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('L0657', '토마토', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('L0657', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0657', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0657', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0657', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0667', '보리밥', CAST(170 AS NUMERIC(12,3)), 'g'),
    ('L0667', '소고기 우둔살', CAST(115 AS NUMERIC(12,3)), 'g'),
    ('L0667', '양배추', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('L0667', '파프리카', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('L0667', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0667', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0667', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0667', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0677', '보리밥', CAST(170 AS NUMERIC(12,3)), 'g'),
    ('L0677', '소고기 우둔살', CAST(115 AS NUMERIC(12,3)), 'g'),
    ('L0677', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('L0677', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('L0677', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0677', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0677', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0677', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0687', '보리밥', CAST(170 AS NUMERIC(12,3)), 'g'),
    ('L0687', '소고기 우둔살', CAST(115 AS NUMERIC(12,3)), 'g'),
    ('L0687', '애호박', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('L0687', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('L0687', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0687', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0687', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0687', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0697', '보리밥', CAST(170 AS NUMERIC(12,3)), 'g'),
    ('L0697', '소고기 우둔살', CAST(115 AS NUMERIC(12,3)), 'g'),
    ('L0697', '시금치', CAST(60 AS NUMERIC(12,3)), 'g'),
    ('L0697', '토마토', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('L0697', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0697', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0697', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0697', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0707', '현미밥', CAST(155 AS NUMERIC(12,3)), 'g'),
    ('L0707', '렌틸콩', CAST(150 AS NUMERIC(12,3)), 'g'),
    ('L0707', '양배추', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('L0707', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('L0707', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('L0707', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0707', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0707', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0717', '현미밥', CAST(155 AS NUMERIC(12,3)), 'g'),
    ('L0717', '렌틸콩', CAST(150 AS NUMERIC(12,3)), 'g'),
    ('L0717', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('L0717', '양파', CAST(45 AS NUMERIC(12,3)), 'g'),
    ('L0717', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('L0717', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0717', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0717', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0727', '현미밥', CAST(155 AS NUMERIC(12,3)), 'g'),
    ('L0727', '렌틸콩', CAST(150 AS NUMERIC(12,3)), 'g'),
    ('L0727', '애호박', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('L0727', '파프리카', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('L0727', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('L0727', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0727', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0727', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0737', '현미밥', CAST(155 AS NUMERIC(12,3)), 'g'),
    ('L0737', '렌틸콩', CAST(150 AS NUMERIC(12,3)), 'g'),
    ('L0737', '시금치', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('L0737', '느타리버섯', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('L0737', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('L0737', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0737', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0737', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0747', '현미밥', CAST(155 AS NUMERIC(12,3)), 'g'),
    ('L0747', '렌틸콩', CAST(150 AS NUMERIC(12,3)), 'g'),
    ('L0747', '청경채', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('L0747', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('L0747', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('L0747', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0747', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0747', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0757', '현미밥', CAST(155 AS NUMERIC(12,3)), 'g'),
    ('L0757', '렌틸콩', CAST(150 AS NUMERIC(12,3)), 'g'),
    ('L0757', '가지', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('L0757', '토마토', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('L0757', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('L0757', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0757', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0757', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0767', '현미밥', CAST(155 AS NUMERIC(12,3)), 'g'),
    ('L0767', '렌틸콩', CAST(150 AS NUMERIC(12,3)), 'g'),
    ('L0767', '양배추', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('L0767', '파프리카', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('L0767', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('L0767', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0767', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0767', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0777', '현미밥', CAST(155 AS NUMERIC(12,3)), 'g'),
    ('L0777', '렌틸콩', CAST(150 AS NUMERIC(12,3)), 'g'),
    ('L0777', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('L0777', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('L0777', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('L0777', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0777', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0777', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0787', '현미밥', CAST(155 AS NUMERIC(12,3)), 'g'),
    ('L0787', '렌틸콩', CAST(150 AS NUMERIC(12,3)), 'g'),
    ('L0787', '애호박', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('L0787', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('L0787', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('L0787', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0787', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0787', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0797', '현미밥', CAST(155 AS NUMERIC(12,3)), 'g'),
    ('L0797', '렌틸콩', CAST(150 AS NUMERIC(12,3)), 'g'),
    ('L0797', '시금치', CAST(60 AS NUMERIC(12,3)), 'g'),
    ('L0797', '토마토', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('L0797', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('L0797', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0797', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0797', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0807', '잡곡밥', CAST(155 AS NUMERIC(12,3)), 'g'),
    ('L0807', '병아리콩', CAST(145 AS NUMERIC(12,3)), 'g'),
    ('L0807', '양배추', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('L0807', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('L0807', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('L0807', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0807', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0807', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0817', '잡곡밥', CAST(155 AS NUMERIC(12,3)), 'g'),
    ('L0817', '병아리콩', CAST(145 AS NUMERIC(12,3)), 'g'),
    ('L0817', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('L0817', '양파', CAST(45 AS NUMERIC(12,3)), 'g'),
    ('L0817', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('L0817', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0817', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0817', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0827', '잡곡밥', CAST(155 AS NUMERIC(12,3)), 'g'),
    ('L0827', '병아리콩', CAST(145 AS NUMERIC(12,3)), 'g'),
    ('L0827', '애호박', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('L0827', '파프리카', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('L0827', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('L0827', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0827', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0827', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0837', '잡곡밥', CAST(155 AS NUMERIC(12,3)), 'g'),
    ('L0837', '병아리콩', CAST(145 AS NUMERIC(12,3)), 'g'),
    ('L0837', '시금치', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('L0837', '느타리버섯', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('L0837', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('L0837', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0837', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0837', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0847', '잡곡밥', CAST(155 AS NUMERIC(12,3)), 'g'),
    ('L0847', '병아리콩', CAST(145 AS NUMERIC(12,3)), 'g'),
    ('L0847', '청경채', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('L0847', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('L0847', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('L0847', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0847', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0847', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0857', '잡곡밥', CAST(155 AS NUMERIC(12,3)), 'g'),
    ('L0857', '병아리콩', CAST(145 AS NUMERIC(12,3)), 'g'),
    ('L0857', '가지', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('L0857', '토마토', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('L0857', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('L0857', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0857', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0857', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0867', '잡곡밥', CAST(155 AS NUMERIC(12,3)), 'g'),
    ('L0867', '병아리콩', CAST(145 AS NUMERIC(12,3)), 'g'),
    ('L0867', '양배추', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('L0867', '파프리카', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('L0867', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('L0867', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0867', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0867', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0877', '잡곡밥', CAST(155 AS NUMERIC(12,3)), 'g'),
    ('L0877', '병아리콩', CAST(145 AS NUMERIC(12,3)), 'g'),
    ('L0877', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('L0877', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('L0877', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('L0877', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0877', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0877', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0887', '잡곡밥', CAST(155 AS NUMERIC(12,3)), 'g'),
    ('L0887', '병아리콩', CAST(145 AS NUMERIC(12,3)), 'g'),
    ('L0887', '애호박', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('L0887', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('L0887', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('L0887', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0887', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0887', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0897', '잡곡밥', CAST(155 AS NUMERIC(12,3)), 'g'),
    ('L0897', '병아리콩', CAST(145 AS NUMERIC(12,3)), 'g'),
    ('L0897', '시금치', CAST(60 AS NUMERIC(12,3)), 'g'),
    ('L0897', '토마토', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('L0897', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('L0897', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0897', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0897', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('L0902', '통밀 식빵', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('L0902', '닭가슴살', CAST(115 AS NUMERIC(12,3)), 'g'),
    ('L0902', '양배추', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('L0902', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('L0902', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('L0902', '후추', CAST(1 AS NUMERIC(12,3)), 'g'),
    ('L0904', '통밀 식빵', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('L0904', '닭가슴살', CAST(115 AS NUMERIC(12,3)), 'g'),
    ('L0904', '양배추', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('L0904', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('L0904', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('L0904', '다진 마늘', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('L0907', '통밀 식빵', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('L0907', '닭가슴살', CAST(115 AS NUMERIC(12,3)), 'g'),
    ('L0907', '양배추', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('L0907', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('L0907', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('L0907', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0907', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('L0912', '통밀 식빵', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('L0912', '닭가슴살', CAST(115 AS NUMERIC(12,3)), 'g'),
    ('L0912', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('L0912', '양파', CAST(45 AS NUMERIC(12,3)), 'g'),
    ('L0912', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('L0912', '후추', CAST(1 AS NUMERIC(12,3)), 'g'),
    ('L0914', '통밀 식빵', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('L0914', '닭가슴살', CAST(115 AS NUMERIC(12,3)), 'g'),
    ('L0914', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('L0914', '양파', CAST(45 AS NUMERIC(12,3)), 'g'),
    ('L0914', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('L0914', '다진 마늘', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('L0917', '통밀 식빵', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('L0917', '닭가슴살', CAST(115 AS NUMERIC(12,3)), 'g'),
    ('L0917', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('L0917', '양파', CAST(45 AS NUMERIC(12,3)), 'g'),
    ('L0917', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('L0917', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0917', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('L0922', '통밀 식빵', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('L0922', '닭가슴살', CAST(115 AS NUMERIC(12,3)), 'g'),
    ('L0922', '애호박', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('L0922', '파프리카', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('L0922', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('L0922', '후추', CAST(1 AS NUMERIC(12,3)), 'g'),
    ('L0924', '통밀 식빵', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('L0924', '닭가슴살', CAST(115 AS NUMERIC(12,3)), 'g'),
    ('L0924', '애호박', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('L0924', '파프리카', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('L0924', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('L0924', '다진 마늘', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('L0927', '통밀 식빵', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('L0927', '닭가슴살', CAST(115 AS NUMERIC(12,3)), 'g'),
    ('L0927', '애호박', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('L0927', '파프리카', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('L0927', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('L0927', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0927', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('L0932', '통밀 식빵', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('L0932', '닭가슴살', CAST(115 AS NUMERIC(12,3)), 'g'),
    ('L0932', '시금치', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('L0932', '느타리버섯', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('L0932', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('L0932', '후추', CAST(1 AS NUMERIC(12,3)), 'g'),
    ('L0934', '통밀 식빵', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('L0934', '닭가슴살', CAST(115 AS NUMERIC(12,3)), 'g'),
    ('L0934', '시금치', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('L0934', '느타리버섯', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('L0934', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('L0934', '다진 마늘', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('L0937', '통밀 식빵', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('L0937', '닭가슴살', CAST(115 AS NUMERIC(12,3)), 'g'),
    ('L0937', '시금치', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('L0937', '느타리버섯', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('L0937', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('L0937', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0937', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('L0942', '통밀 식빵', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('L0942', '닭가슴살', CAST(115 AS NUMERIC(12,3)), 'g'),
    ('L0942', '청경채', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('L0942', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('L0942', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('L0942', '후추', CAST(1 AS NUMERIC(12,3)), 'g'),
    ('L0944', '통밀 식빵', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('L0944', '닭가슴살', CAST(115 AS NUMERIC(12,3)), 'g'),
    ('L0944', '청경채', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('L0944', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('L0944', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('L0944', '다진 마늘', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('L0947', '통밀 식빵', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('L0947', '닭가슴살', CAST(115 AS NUMERIC(12,3)), 'g'),
    ('L0947', '청경채', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('L0947', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('L0947', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('L0947', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0947', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('L0952', '통밀 식빵', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('L0952', '닭가슴살', CAST(115 AS NUMERIC(12,3)), 'g'),
    ('L0952', '가지', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('L0952', '토마토', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('L0952', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('L0952', '후추', CAST(1 AS NUMERIC(12,3)), 'g'),
    ('L0954', '통밀 식빵', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('L0954', '닭가슴살', CAST(115 AS NUMERIC(12,3)), 'g'),
    ('L0954', '가지', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('L0954', '토마토', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('L0954', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('L0954', '다진 마늘', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('L0957', '통밀 식빵', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('L0957', '닭가슴살', CAST(115 AS NUMERIC(12,3)), 'g'),
    ('L0957', '가지', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('L0957', '토마토', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('L0957', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('L0957', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0957', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('L0962', '통밀 식빵', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('L0962', '닭가슴살', CAST(115 AS NUMERIC(12,3)), 'g'),
    ('L0962', '양배추', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('L0962', '파프리카', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('L0962', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('L0962', '후추', CAST(1 AS NUMERIC(12,3)), 'g'),
    ('L0964', '통밀 식빵', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('L0964', '닭가슴살', CAST(115 AS NUMERIC(12,3)), 'g'),
    ('L0964', '양배추', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('L0964', '파프리카', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('L0964', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('L0964', '다진 마늘', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('L0967', '통밀 식빵', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('L0967', '닭가슴살', CAST(115 AS NUMERIC(12,3)), 'g'),
    ('L0967', '양배추', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('L0967', '파프리카', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('L0967', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('L0967', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0967', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('L0972', '통밀 식빵', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('L0972', '닭가슴살', CAST(115 AS NUMERIC(12,3)), 'g'),
    ('L0972', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('L0972', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('L0972', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('L0972', '후추', CAST(1 AS NUMERIC(12,3)), 'g'),
    ('L0974', '통밀 식빵', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('L0974', '닭가슴살', CAST(115 AS NUMERIC(12,3)), 'g'),
    ('L0974', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('L0974', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('L0974', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('L0974', '다진 마늘', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('L0977', '통밀 식빵', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('L0977', '닭가슴살', CAST(115 AS NUMERIC(12,3)), 'g'),
    ('L0977', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('L0977', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('L0977', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('L0977', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0977', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('L0982', '통밀 식빵', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('L0982', '닭가슴살', CAST(115 AS NUMERIC(12,3)), 'g'),
    ('L0982', '애호박', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('L0982', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('L0982', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('L0982', '후추', CAST(1 AS NUMERIC(12,3)), 'g'),
    ('L0984', '통밀 식빵', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('L0984', '닭가슴살', CAST(115 AS NUMERIC(12,3)), 'g'),
    ('L0984', '애호박', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('L0984', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('L0984', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('L0984', '다진 마늘', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('L0987', '통밀 식빵', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('L0987', '닭가슴살', CAST(115 AS NUMERIC(12,3)), 'g'),
    ('L0987', '애호박', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('L0987', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('L0987', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('L0987', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0987', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('L0992', '통밀 식빵', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('L0992', '닭가슴살', CAST(115 AS NUMERIC(12,3)), 'g'),
    ('L0992', '시금치', CAST(60 AS NUMERIC(12,3)), 'g'),
    ('L0992', '토마토', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('L0992', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('L0992', '후추', CAST(1 AS NUMERIC(12,3)), 'g'),
    ('L0994', '통밀 식빵', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('L0994', '닭가슴살', CAST(115 AS NUMERIC(12,3)), 'g'),
    ('L0994', '시금치', CAST(60 AS NUMERIC(12,3)), 'g'),
    ('L0994', '토마토', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('L0994', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('L0994', '다진 마늘', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('L0997', '통밀 식빵', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('L0997', '닭가슴살', CAST(115 AS NUMERIC(12,3)), 'g'),
    ('L0997', '시금치', CAST(60 AS NUMERIC(12,3)), 'g'),
    ('L0997', '토마토', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('L0997', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('L0997', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('L0997', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('D0007', '고구마', CAST(175 AS NUMERIC(12,3)), 'g'),
    ('D0007', '연어', CAST(125 AS NUMERIC(12,3)), 'g'),
    ('D0007', '양배추', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('D0007', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('D0007', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('D0007', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0007', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('D0017', '고구마', CAST(175 AS NUMERIC(12,3)), 'g'),
    ('D0017', '연어', CAST(125 AS NUMERIC(12,3)), 'g'),
    ('D0017', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('D0017', '양파', CAST(45 AS NUMERIC(12,3)), 'g'),
    ('D0017', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('D0017', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0017', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('D0027', '고구마', CAST(175 AS NUMERIC(12,3)), 'g'),
    ('D0027', '연어', CAST(125 AS NUMERIC(12,3)), 'g'),
    ('D0027', '애호박', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('D0027', '파프리카', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('D0027', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('D0027', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0027', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('D0037', '고구마', CAST(175 AS NUMERIC(12,3)), 'g'),
    ('D0037', '연어', CAST(125 AS NUMERIC(12,3)), 'g'),
    ('D0037', '시금치', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('D0037', '느타리버섯', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('D0037', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('D0037', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0037', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('D0047', '고구마', CAST(175 AS NUMERIC(12,3)), 'g'),
    ('D0047', '연어', CAST(125 AS NUMERIC(12,3)), 'g'),
    ('D0047', '청경채', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('D0047', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('D0047', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('D0047', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0047', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('D0057', '고구마', CAST(175 AS NUMERIC(12,3)), 'g'),
    ('D0057', '연어', CAST(125 AS NUMERIC(12,3)), 'g'),
    ('D0057', '가지', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('D0057', '토마토', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('D0057', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('D0057', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0057', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('D0067', '고구마', CAST(175 AS NUMERIC(12,3)), 'g'),
    ('D0067', '연어', CAST(125 AS NUMERIC(12,3)), 'g'),
    ('D0067', '양배추', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('D0067', '파프리카', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('D0067', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('D0067', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0067', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('D0077', '고구마', CAST(175 AS NUMERIC(12,3)), 'g'),
    ('D0077', '연어', CAST(125 AS NUMERIC(12,3)), 'g'),
    ('D0077', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('D0077', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('D0077', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('D0077', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0077', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('D0087', '고구마', CAST(175 AS NUMERIC(12,3)), 'g'),
    ('D0087', '연어', CAST(125 AS NUMERIC(12,3)), 'g'),
    ('D0087', '애호박', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('D0087', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('D0087', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('D0087', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0087', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('D0097', '고구마', CAST(175 AS NUMERIC(12,3)), 'g'),
    ('D0097', '연어', CAST(125 AS NUMERIC(12,3)), 'g'),
    ('D0097', '시금치', CAST(60 AS NUMERIC(12,3)), 'g'),
    ('D0097', '토마토', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('D0097', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('D0097', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0097', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('D0107', '잡곡밥', CAST(155 AS NUMERIC(12,3)), 'g'),
    ('D0107', '고등어', CAST(115 AS NUMERIC(12,3)), 'g'),
    ('D0107', '양배추', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('D0107', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('D0107', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0107', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0107', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0107', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0117', '잡곡밥', CAST(155 AS NUMERIC(12,3)), 'g'),
    ('D0117', '고등어', CAST(115 AS NUMERIC(12,3)), 'g'),
    ('D0117', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('D0117', '양파', CAST(45 AS NUMERIC(12,3)), 'g'),
    ('D0117', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0117', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0117', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0117', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0127', '잡곡밥', CAST(155 AS NUMERIC(12,3)), 'g'),
    ('D0127', '고등어', CAST(115 AS NUMERIC(12,3)), 'g'),
    ('D0127', '애호박', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('D0127', '파프리카', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('D0127', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0127', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0127', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0127', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0137', '잡곡밥', CAST(155 AS NUMERIC(12,3)), 'g'),
    ('D0137', '고등어', CAST(115 AS NUMERIC(12,3)), 'g'),
    ('D0137', '시금치', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('D0137', '느타리버섯', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('D0137', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0137', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0137', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0137', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0147', '잡곡밥', CAST(155 AS NUMERIC(12,3)), 'g'),
    ('D0147', '고등어', CAST(115 AS NUMERIC(12,3)), 'g'),
    ('D0147', '청경채', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('D0147', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('D0147', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0147', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0147', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0147', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0157', '잡곡밥', CAST(155 AS NUMERIC(12,3)), 'g'),
    ('D0157', '고등어', CAST(115 AS NUMERIC(12,3)), 'g'),
    ('D0157', '가지', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('D0157', '토마토', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('D0157', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0157', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0157', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0157', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0167', '잡곡밥', CAST(155 AS NUMERIC(12,3)), 'g'),
    ('D0167', '고등어', CAST(115 AS NUMERIC(12,3)), 'g'),
    ('D0167', '양배추', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('D0167', '파프리카', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('D0167', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0167', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0167', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0167', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0177', '잡곡밥', CAST(155 AS NUMERIC(12,3)), 'g'),
    ('D0177', '고등어', CAST(115 AS NUMERIC(12,3)), 'g'),
    ('D0177', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('D0177', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('D0177', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0177', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0177', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0177', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0187', '잡곡밥', CAST(155 AS NUMERIC(12,3)), 'g'),
    ('D0187', '고등어', CAST(115 AS NUMERIC(12,3)), 'g'),
    ('D0187', '애호박', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('D0187', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('D0187', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0187', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0187', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0187', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0197', '잡곡밥', CAST(155 AS NUMERIC(12,3)), 'g'),
    ('D0197', '고등어', CAST(115 AS NUMERIC(12,3)), 'g'),
    ('D0197', '시금치', CAST(60 AS NUMERIC(12,3)), 'g'),
    ('D0197', '토마토', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('D0197', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0197', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0197', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0197', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0207', '현미밥', CAST(155 AS NUMERIC(12,3)), 'g'),
    ('D0207', '대구', CAST(140 AS NUMERIC(12,3)), 'g'),
    ('D0207', '양배추', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('D0207', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('D0207', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0207', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0207', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0207', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0217', '현미밥', CAST(155 AS NUMERIC(12,3)), 'g'),
    ('D0217', '대구', CAST(140 AS NUMERIC(12,3)), 'g'),
    ('D0217', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('D0217', '양파', CAST(45 AS NUMERIC(12,3)), 'g'),
    ('D0217', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0217', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0217', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0217', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0227', '현미밥', CAST(155 AS NUMERIC(12,3)), 'g'),
    ('D0227', '대구', CAST(140 AS NUMERIC(12,3)), 'g'),
    ('D0227', '애호박', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('D0227', '파프리카', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('D0227', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0227', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0227', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0227', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0237', '현미밥', CAST(155 AS NUMERIC(12,3)), 'g'),
    ('D0237', '대구', CAST(140 AS NUMERIC(12,3)), 'g'),
    ('D0237', '시금치', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('D0237', '느타리버섯', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('D0237', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0237', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0237', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0237', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0247', '현미밥', CAST(155 AS NUMERIC(12,3)), 'g'),
    ('D0247', '대구', CAST(140 AS NUMERIC(12,3)), 'g'),
    ('D0247', '청경채', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('D0247', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('D0247', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0247', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0247', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0247', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0257', '현미밥', CAST(155 AS NUMERIC(12,3)), 'g'),
    ('D0257', '대구', CAST(140 AS NUMERIC(12,3)), 'g'),
    ('D0257', '가지', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('D0257', '토마토', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('D0257', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0257', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0257', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0257', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0267', '현미밥', CAST(155 AS NUMERIC(12,3)), 'g'),
    ('D0267', '대구', CAST(140 AS NUMERIC(12,3)), 'g'),
    ('D0267', '양배추', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('D0267', '파프리카', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('D0267', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0267', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0267', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0267', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0277', '현미밥', CAST(155 AS NUMERIC(12,3)), 'g'),
    ('D0277', '대구', CAST(140 AS NUMERIC(12,3)), 'g'),
    ('D0277', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('D0277', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('D0277', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0277', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0277', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0277', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0287', '현미밥', CAST(155 AS NUMERIC(12,3)), 'g'),
    ('D0287', '대구', CAST(140 AS NUMERIC(12,3)), 'g'),
    ('D0287', '애호박', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('D0287', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('D0287', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0287', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0287', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0287', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0297', '현미밥', CAST(155 AS NUMERIC(12,3)), 'g'),
    ('D0297', '대구', CAST(140 AS NUMERIC(12,3)), 'g'),
    ('D0297', '시금치', CAST(60 AS NUMERIC(12,3)), 'g'),
    ('D0297', '토마토', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('D0297', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0297', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0297', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0297', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0307', '감자', CAST(180 AS NUMERIC(12,3)), 'g'),
    ('D0307', '돼지 안심', CAST(130 AS NUMERIC(12,3)), 'g'),
    ('D0307', '양배추', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('D0307', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('D0307', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('D0307', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0307', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('D0317', '감자', CAST(180 AS NUMERIC(12,3)), 'g'),
    ('D0317', '돼지 안심', CAST(130 AS NUMERIC(12,3)), 'g'),
    ('D0317', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('D0317', '양파', CAST(45 AS NUMERIC(12,3)), 'g'),
    ('D0317', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('D0317', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0317', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('D0327', '감자', CAST(180 AS NUMERIC(12,3)), 'g'),
    ('D0327', '돼지 안심', CAST(130 AS NUMERIC(12,3)), 'g'),
    ('D0327', '애호박', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('D0327', '파프리카', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('D0327', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('D0327', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0327', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('D0337', '감자', CAST(180 AS NUMERIC(12,3)), 'g'),
    ('D0337', '돼지 안심', CAST(130 AS NUMERIC(12,3)), 'g'),
    ('D0337', '시금치', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('D0337', '느타리버섯', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('D0337', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('D0337', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0337', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('D0347', '감자', CAST(180 AS NUMERIC(12,3)), 'g'),
    ('D0347', '돼지 안심', CAST(130 AS NUMERIC(12,3)), 'g'),
    ('D0347', '청경채', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('D0347', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('D0347', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('D0347', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0347', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('D0357', '감자', CAST(180 AS NUMERIC(12,3)), 'g'),
    ('D0357', '돼지 안심', CAST(130 AS NUMERIC(12,3)), 'g'),
    ('D0357', '가지', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('D0357', '토마토', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('D0357', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('D0357', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0357', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('D0367', '감자', CAST(180 AS NUMERIC(12,3)), 'g'),
    ('D0367', '돼지 안심', CAST(130 AS NUMERIC(12,3)), 'g'),
    ('D0367', '양배추', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('D0367', '파프리카', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('D0367', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('D0367', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0367', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('D0377', '감자', CAST(180 AS NUMERIC(12,3)), 'g'),
    ('D0377', '돼지 안심', CAST(130 AS NUMERIC(12,3)), 'g'),
    ('D0377', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('D0377', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('D0377', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('D0377', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0377', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('D0387', '감자', CAST(180 AS NUMERIC(12,3)), 'g'),
    ('D0387', '돼지 안심', CAST(130 AS NUMERIC(12,3)), 'g'),
    ('D0387', '애호박', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('D0387', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('D0387', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('D0387', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0387', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('D0397', '감자', CAST(180 AS NUMERIC(12,3)), 'g'),
    ('D0397', '돼지 안심', CAST(130 AS NUMERIC(12,3)), 'g'),
    ('D0397', '시금치', CAST(60 AS NUMERIC(12,3)), 'g'),
    ('D0397', '토마토', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('D0397', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('D0397', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0397', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('D0407', '퀴노아', CAST(160 AS NUMERIC(12,3)), 'g'),
    ('D0407', '소고기 우둔살', CAST(125 AS NUMERIC(12,3)), 'g'),
    ('D0407', '양배추', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('D0407', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('D0407', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('D0407', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0407', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('D0417', '퀴노아', CAST(160 AS NUMERIC(12,3)), 'g'),
    ('D0417', '소고기 우둔살', CAST(125 AS NUMERIC(12,3)), 'g'),
    ('D0417', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('D0417', '양파', CAST(45 AS NUMERIC(12,3)), 'g'),
    ('D0417', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('D0417', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0417', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('D0427', '퀴노아', CAST(160 AS NUMERIC(12,3)), 'g'),
    ('D0427', '소고기 우둔살', CAST(125 AS NUMERIC(12,3)), 'g'),
    ('D0427', '애호박', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('D0427', '파프리카', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('D0427', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('D0427', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0427', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('D0437', '퀴노아', CAST(160 AS NUMERIC(12,3)), 'g'),
    ('D0437', '소고기 우둔살', CAST(125 AS NUMERIC(12,3)), 'g'),
    ('D0437', '시금치', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('D0437', '느타리버섯', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('D0437', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('D0437', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0437', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('D0447', '퀴노아', CAST(160 AS NUMERIC(12,3)), 'g'),
    ('D0447', '소고기 우둔살', CAST(125 AS NUMERIC(12,3)), 'g'),
    ('D0447', '청경채', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('D0447', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('D0447', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('D0447', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0447', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('D0457', '퀴노아', CAST(160 AS NUMERIC(12,3)), 'g'),
    ('D0457', '소고기 우둔살', CAST(125 AS NUMERIC(12,3)), 'g'),
    ('D0457', '가지', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('D0457', '토마토', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('D0457', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('D0457', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0457', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('D0467', '퀴노아', CAST(160 AS NUMERIC(12,3)), 'g'),
    ('D0467', '소고기 우둔살', CAST(125 AS NUMERIC(12,3)), 'g'),
    ('D0467', '양배추', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('D0467', '파프리카', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('D0467', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('D0467', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0467', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('D0477', '퀴노아', CAST(160 AS NUMERIC(12,3)), 'g'),
    ('D0477', '소고기 우둔살', CAST(125 AS NUMERIC(12,3)), 'g'),
    ('D0477', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('D0477', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('D0477', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('D0477', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0477', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('D0487', '퀴노아', CAST(160 AS NUMERIC(12,3)), 'g'),
    ('D0487', '소고기 우둔살', CAST(125 AS NUMERIC(12,3)), 'g'),
    ('D0487', '애호박', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('D0487', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('D0487', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('D0487', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0487', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('D0497', '퀴노아', CAST(160 AS NUMERIC(12,3)), 'g'),
    ('D0497', '소고기 우둔살', CAST(125 AS NUMERIC(12,3)), 'g'),
    ('D0497', '시금치', CAST(60 AS NUMERIC(12,3)), 'g'),
    ('D0497', '토마토', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('D0497', '올리브유', CAST(9 AS NUMERIC(12,3)), 'g'),
    ('D0497', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0497', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('D0507', '보리밥', CAST(160 AS NUMERIC(12,3)), 'g'),
    ('D0507', '두부', CAST(170 AS NUMERIC(12,3)), 'g'),
    ('D0507', '양배추', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('D0507', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('D0507', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0507', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0507', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0507', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0517', '보리밥', CAST(160 AS NUMERIC(12,3)), 'g'),
    ('D0517', '두부', CAST(170 AS NUMERIC(12,3)), 'g'),
    ('D0517', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('D0517', '양파', CAST(45 AS NUMERIC(12,3)), 'g'),
    ('D0517', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0517', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0517', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0517', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0527', '보리밥', CAST(160 AS NUMERIC(12,3)), 'g'),
    ('D0527', '두부', CAST(170 AS NUMERIC(12,3)), 'g'),
    ('D0527', '애호박', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('D0527', '파프리카', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('D0527', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0527', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0527', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0527', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0537', '보리밥', CAST(160 AS NUMERIC(12,3)), 'g'),
    ('D0537', '두부', CAST(170 AS NUMERIC(12,3)), 'g'),
    ('D0537', '시금치', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('D0537', '느타리버섯', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('D0537', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0537', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0537', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0537', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0547', '보리밥', CAST(160 AS NUMERIC(12,3)), 'g'),
    ('D0547', '두부', CAST(170 AS NUMERIC(12,3)), 'g'),
    ('D0547', '청경채', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('D0547', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('D0547', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0547', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0547', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0547', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0557', '보리밥', CAST(160 AS NUMERIC(12,3)), 'g'),
    ('D0557', '두부', CAST(170 AS NUMERIC(12,3)), 'g'),
    ('D0557', '가지', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('D0557', '토마토', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('D0557', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0557', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0557', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0557', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0567', '보리밥', CAST(160 AS NUMERIC(12,3)), 'g'),
    ('D0567', '두부', CAST(170 AS NUMERIC(12,3)), 'g'),
    ('D0567', '양배추', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('D0567', '파프리카', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('D0567', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0567', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0567', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0567', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0577', '보리밥', CAST(160 AS NUMERIC(12,3)), 'g'),
    ('D0577', '두부', CAST(170 AS NUMERIC(12,3)), 'g'),
    ('D0577', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('D0577', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('D0577', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0577', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0577', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0577', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0587', '보리밥', CAST(160 AS NUMERIC(12,3)), 'g'),
    ('D0587', '두부', CAST(170 AS NUMERIC(12,3)), 'g'),
    ('D0587', '애호박', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('D0587', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('D0587', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0587', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0587', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0587', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0597', '보리밥', CAST(160 AS NUMERIC(12,3)), 'g'),
    ('D0597', '두부', CAST(170 AS NUMERIC(12,3)), 'g'),
    ('D0597', '시금치', CAST(60 AS NUMERIC(12,3)), 'g'),
    ('D0597', '토마토', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('D0597', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0597', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0597', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0597', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0607', '메밀면', CAST(87 AS NUMERIC(12,3)), 'g'),
    ('D0607', '닭가슴살', CAST(125 AS NUMERIC(12,3)), 'g'),
    ('D0607', '양배추', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('D0607', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('D0607', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0607', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0607', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0607', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0617', '메밀면', CAST(87 AS NUMERIC(12,3)), 'g'),
    ('D0617', '닭가슴살', CAST(125 AS NUMERIC(12,3)), 'g'),
    ('D0617', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('D0617', '양파', CAST(45 AS NUMERIC(12,3)), 'g'),
    ('D0617', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0617', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0617', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0617', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0627', '메밀면', CAST(87 AS NUMERIC(12,3)), 'g'),
    ('D0627', '닭가슴살', CAST(125 AS NUMERIC(12,3)), 'g'),
    ('D0627', '애호박', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('D0627', '파프리카', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('D0627', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0627', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0627', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0627', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0637', '메밀면', CAST(87 AS NUMERIC(12,3)), 'g'),
    ('D0637', '닭가슴살', CAST(125 AS NUMERIC(12,3)), 'g'),
    ('D0637', '시금치', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('D0637', '느타리버섯', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('D0637', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0637', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0637', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0637', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0647', '메밀면', CAST(87 AS NUMERIC(12,3)), 'g'),
    ('D0647', '닭가슴살', CAST(125 AS NUMERIC(12,3)), 'g'),
    ('D0647', '청경채', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('D0647', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('D0647', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0647', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0647', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0647', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0657', '메밀면', CAST(87 AS NUMERIC(12,3)), 'g'),
    ('D0657', '닭가슴살', CAST(125 AS NUMERIC(12,3)), 'g'),
    ('D0657', '가지', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('D0657', '토마토', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('D0657', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0657', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0657', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0657', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0667', '메밀면', CAST(87 AS NUMERIC(12,3)), 'g'),
    ('D0667', '닭가슴살', CAST(125 AS NUMERIC(12,3)), 'g'),
    ('D0667', '양배추', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('D0667', '파프리카', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('D0667', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0667', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0667', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0667', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0677', '메밀면', CAST(87 AS NUMERIC(12,3)), 'g'),
    ('D0677', '닭가슴살', CAST(125 AS NUMERIC(12,3)), 'g'),
    ('D0677', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('D0677', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('D0677', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0677', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0677', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0677', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0687', '메밀면', CAST(87 AS NUMERIC(12,3)), 'g'),
    ('D0687', '닭가슴살', CAST(125 AS NUMERIC(12,3)), 'g'),
    ('D0687', '애호박', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('D0687', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('D0687', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0687', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0687', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0687', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0697', '메밀면', CAST(87 AS NUMERIC(12,3)), 'g'),
    ('D0697', '닭가슴살', CAST(125 AS NUMERIC(12,3)), 'g'),
    ('D0697', '시금치', CAST(60 AS NUMERIC(12,3)), 'g'),
    ('D0697', '토마토', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('D0697', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0697', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0697', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0697', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0707', '잡곡밥', CAST(155 AS NUMERIC(12,3)), 'g'),
    ('D0707', '새우', CAST(145 AS NUMERIC(12,3)), 'g'),
    ('D0707', '양배추', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('D0707', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('D0707', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0707', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0707', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0707', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0717', '잡곡밥', CAST(155 AS NUMERIC(12,3)), 'g'),
    ('D0717', '새우', CAST(145 AS NUMERIC(12,3)), 'g'),
    ('D0717', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('D0717', '양파', CAST(45 AS NUMERIC(12,3)), 'g'),
    ('D0717', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0717', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0717', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0717', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0727', '잡곡밥', CAST(155 AS NUMERIC(12,3)), 'g'),
    ('D0727', '새우', CAST(145 AS NUMERIC(12,3)), 'g'),
    ('D0727', '애호박', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('D0727', '파프리카', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('D0727', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0727', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0727', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0727', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0737', '잡곡밥', CAST(155 AS NUMERIC(12,3)), 'g'),
    ('D0737', '새우', CAST(145 AS NUMERIC(12,3)), 'g'),
    ('D0737', '시금치', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('D0737', '느타리버섯', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('D0737', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0737', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0737', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0737', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0747', '잡곡밥', CAST(155 AS NUMERIC(12,3)), 'g'),
    ('D0747', '새우', CAST(145 AS NUMERIC(12,3)), 'g'),
    ('D0747', '청경채', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('D0747', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('D0747', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0747', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0747', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0747', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0757', '잡곡밥', CAST(155 AS NUMERIC(12,3)), 'g'),
    ('D0757', '새우', CAST(145 AS NUMERIC(12,3)), 'g'),
    ('D0757', '가지', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('D0757', '토마토', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('D0757', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0757', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0757', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0757', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0767', '잡곡밥', CAST(155 AS NUMERIC(12,3)), 'g'),
    ('D0767', '새우', CAST(145 AS NUMERIC(12,3)), 'g'),
    ('D0767', '양배추', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('D0767', '파프리카', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('D0767', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0767', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0767', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0767', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0777', '잡곡밥', CAST(155 AS NUMERIC(12,3)), 'g'),
    ('D0777', '새우', CAST(145 AS NUMERIC(12,3)), 'g'),
    ('D0777', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('D0777', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('D0777', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0777', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0777', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0777', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0787', '잡곡밥', CAST(155 AS NUMERIC(12,3)), 'g'),
    ('D0787', '새우', CAST(145 AS NUMERIC(12,3)), 'g'),
    ('D0787', '애호박', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('D0787', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('D0787', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0787', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0787', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0787', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0797', '잡곡밥', CAST(155 AS NUMERIC(12,3)), 'g'),
    ('D0797', '새우', CAST(145 AS NUMERIC(12,3)), 'g'),
    ('D0797', '시금치', CAST(60 AS NUMERIC(12,3)), 'g'),
    ('D0797', '토마토', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('D0797', '올리브유', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0797', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0797', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0797', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0807', '현미밥', CAST(150 AS NUMERIC(12,3)), 'g'),
    ('D0807', '병아리콩', CAST(150 AS NUMERIC(12,3)), 'g'),
    ('D0807', '양배추', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('D0807', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('D0807', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('D0807', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0807', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0807', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0817', '현미밥', CAST(150 AS NUMERIC(12,3)), 'g'),
    ('D0817', '병아리콩', CAST(150 AS NUMERIC(12,3)), 'g'),
    ('D0817', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('D0817', '양파', CAST(45 AS NUMERIC(12,3)), 'g'),
    ('D0817', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('D0817', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0817', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0817', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0827', '현미밥', CAST(150 AS NUMERIC(12,3)), 'g'),
    ('D0827', '병아리콩', CAST(150 AS NUMERIC(12,3)), 'g'),
    ('D0827', '애호박', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('D0827', '파프리카', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('D0827', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('D0827', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0827', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0827', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0837', '현미밥', CAST(150 AS NUMERIC(12,3)), 'g'),
    ('D0837', '병아리콩', CAST(150 AS NUMERIC(12,3)), 'g'),
    ('D0837', '시금치', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('D0837', '느타리버섯', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('D0837', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('D0837', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0837', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0837', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0847', '현미밥', CAST(150 AS NUMERIC(12,3)), 'g'),
    ('D0847', '병아리콩', CAST(150 AS NUMERIC(12,3)), 'g'),
    ('D0847', '청경채', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('D0847', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('D0847', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('D0847', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0847', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0847', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0857', '현미밥', CAST(150 AS NUMERIC(12,3)), 'g'),
    ('D0857', '병아리콩', CAST(150 AS NUMERIC(12,3)), 'g'),
    ('D0857', '가지', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('D0857', '토마토', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('D0857', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('D0857', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0857', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0857', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0867', '현미밥', CAST(150 AS NUMERIC(12,3)), 'g'),
    ('D0867', '병아리콩', CAST(150 AS NUMERIC(12,3)), 'g'),
    ('D0867', '양배추', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('D0867', '파프리카', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('D0867', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('D0867', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0867', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0867', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0877', '현미밥', CAST(150 AS NUMERIC(12,3)), 'g'),
    ('D0877', '병아리콩', CAST(150 AS NUMERIC(12,3)), 'g'),
    ('D0877', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('D0877', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('D0877', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('D0877', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0877', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0877', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0887', '현미밥', CAST(150 AS NUMERIC(12,3)), 'g'),
    ('D0887', '병아리콩', CAST(150 AS NUMERIC(12,3)), 'g'),
    ('D0887', '애호박', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('D0887', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('D0887', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('D0887', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0887', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0887', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0897', '현미밥', CAST(150 AS NUMERIC(12,3)), 'g'),
    ('D0897', '병아리콩', CAST(150 AS NUMERIC(12,3)), 'g'),
    ('D0897', '시금치', CAST(60 AS NUMERIC(12,3)), 'g'),
    ('D0897', '토마토', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('D0897', '올리브유', CAST(3 AS NUMERIC(12,3)), 'g'),
    ('D0897', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0897', '들기름', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0897', '간장', CAST(5 AS NUMERIC(12,3)), 'g'),
    ('D0907', '고구마', CAST(165 AS NUMERIC(12,3)), 'g'),
    ('D0907', '렌틸콩', CAST(150 AS NUMERIC(12,3)), 'g'),
    ('D0907', '양배추', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('D0907', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('D0907', '올리브유', CAST(7 AS NUMERIC(12,3)), 'g'),
    ('D0907', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0907', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('D0917', '고구마', CAST(165 AS NUMERIC(12,3)), 'g'),
    ('D0917', '렌틸콩', CAST(150 AS NUMERIC(12,3)), 'g'),
    ('D0917', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('D0917', '양파', CAST(45 AS NUMERIC(12,3)), 'g'),
    ('D0917', '올리브유', CAST(7 AS NUMERIC(12,3)), 'g'),
    ('D0917', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0917', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('D0927', '고구마', CAST(165 AS NUMERIC(12,3)), 'g'),
    ('D0927', '렌틸콩', CAST(150 AS NUMERIC(12,3)), 'g'),
    ('D0927', '애호박', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('D0927', '파프리카', CAST(55 AS NUMERIC(12,3)), 'g'),
    ('D0927', '올리브유', CAST(7 AS NUMERIC(12,3)), 'g'),
    ('D0927', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0927', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('D0937', '고구마', CAST(165 AS NUMERIC(12,3)), 'g'),
    ('D0937', '렌틸콩', CAST(150 AS NUMERIC(12,3)), 'g'),
    ('D0937', '시금치', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('D0937', '느타리버섯', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('D0937', '올리브유', CAST(7 AS NUMERIC(12,3)), 'g'),
    ('D0937', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0937', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('D0947', '고구마', CAST(165 AS NUMERIC(12,3)), 'g'),
    ('D0947', '렌틸콩', CAST(150 AS NUMERIC(12,3)), 'g'),
    ('D0947', '청경채', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('D0947', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('D0947', '올리브유', CAST(7 AS NUMERIC(12,3)), 'g'),
    ('D0947', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0947', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('D0957', '고구마', CAST(165 AS NUMERIC(12,3)), 'g'),
    ('D0957', '렌틸콩', CAST(150 AS NUMERIC(12,3)), 'g'),
    ('D0957', '가지', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('D0957', '토마토', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('D0957', '올리브유', CAST(7 AS NUMERIC(12,3)), 'g'),
    ('D0957', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0957', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('D0967', '고구마', CAST(165 AS NUMERIC(12,3)), 'g'),
    ('D0967', '렌틸콩', CAST(150 AS NUMERIC(12,3)), 'g'),
    ('D0967', '양배추', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('D0967', '파프리카', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('D0967', '올리브유', CAST(7 AS NUMERIC(12,3)), 'g'),
    ('D0967', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0967', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('D0977', '고구마', CAST(165 AS NUMERIC(12,3)), 'g'),
    ('D0977', '렌틸콩', CAST(150 AS NUMERIC(12,3)), 'g'),
    ('D0977', '브로콜리', CAST(85 AS NUMERIC(12,3)), 'g'),
    ('D0977', '당근', CAST(50 AS NUMERIC(12,3)), 'g'),
    ('D0977', '올리브유', CAST(7 AS NUMERIC(12,3)), 'g'),
    ('D0977', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0977', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('D0987', '고구마', CAST(165 AS NUMERIC(12,3)), 'g'),
    ('D0987', '렌틸콩', CAST(150 AS NUMERIC(12,3)), 'g'),
    ('D0987', '애호박', CAST(75 AS NUMERIC(12,3)), 'g'),
    ('D0987', '양송이버섯', CAST(65 AS NUMERIC(12,3)), 'g'),
    ('D0987', '올리브유', CAST(7 AS NUMERIC(12,3)), 'g'),
    ('D0987', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0987', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g'),
    ('D0997', '고구마', CAST(165 AS NUMERIC(12,3)), 'g'),
    ('D0997', '렌틸콩', CAST(150 AS NUMERIC(12,3)), 'g'),
    ('D0997', '시금치', CAST(60 AS NUMERIC(12,3)), 'g'),
    ('D0997', '토마토', CAST(80 AS NUMERIC(12,3)), 'g'),
    ('D0997', '올리브유', CAST(7 AS NUMERIC(12,3)), 'g'),
    ('D0997', '깻잎', CAST(4 AS NUMERIC(12,3)), 'g'),
    ('D0997', '레몬즙', CAST(8 AS NUMERIC(12,3)), 'g')
) AS v(recipe_code, ingredient_name, required_qty, unit) ON r.recipe_code = v.recipe_code;

INSERT INTO recipe_steps (recipe_id, step_order, description)
SELECT r.id, v.step_order, v.description FROM recipes r JOIN (VALUES
    ('B0002', 0, '통밀 식빵을 토스터나 마른 팬에 구움.'),
    ('B0002', 1, '팬에 조리용 올리브유를 두르고 달걀을 풀어 완전히 익힘.'),
    ('B0002', 2, '양배추와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0002', 3, '후추 1 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('B0002', 4, '식빵 위에 익힌 재료를 올림. 양념을 곁들임.'),
    ('B0004', 0, '통밀 식빵을 토스터나 마른 팬에 구움.'),
    ('B0004', 1, '팬에 조리용 올리브유를 두르고 달걀을 풀어 완전히 익힘.'),
    ('B0004', 2, '양배추와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0004', 3, '다진 마늘 3 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('B0004', 4, '식빵 위에 익힌 재료를 올림. 양념을 곁들임.'),
    ('B0007', 0, '통밀 식빵을 토스터나 마른 팬에 구움.'),
    ('B0007', 1, '팬에 조리용 올리브유를 두르고 달걀을 풀어 완전히 익힘.'),
    ('B0007', 2, '양배추와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0007', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('B0007', 4, '식빵 위에 익힌 재료를 올림. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0012', 0, '통밀 식빵을 토스터나 마른 팬에 구움.'),
    ('B0012', 1, '팬에 조리용 올리브유를 두르고 달걀을 풀어 완전히 익힘.'),
    ('B0012', 2, '브로콜리와 양파를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0012', 3, '후추 1 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('B0012', 4, '식빵 위에 익힌 재료를 올림. 양념을 곁들임.'),
    ('B0014', 0, '통밀 식빵을 토스터나 마른 팬에 구움.'),
    ('B0014', 1, '팬에 조리용 올리브유를 두르고 달걀을 풀어 완전히 익힘.'),
    ('B0014', 2, '브로콜리와 양파를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0014', 3, '다진 마늘 3 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('B0014', 4, '식빵 위에 익힌 재료를 올림. 양념을 곁들임.'),
    ('B0017', 0, '통밀 식빵을 토스터나 마른 팬에 구움.'),
    ('B0017', 1, '팬에 조리용 올리브유를 두르고 달걀을 풀어 완전히 익힘.'),
    ('B0017', 2, '브로콜리와 양파를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0017', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('B0017', 4, '식빵 위에 익힌 재료를 올림. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0022', 0, '통밀 식빵을 토스터나 마른 팬에 구움.'),
    ('B0022', 1, '팬에 조리용 올리브유를 두르고 달걀을 풀어 완전히 익힘.'),
    ('B0022', 2, '애호박과 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0022', 3, '후추 1 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('B0022', 4, '식빵 위에 익힌 재료를 올림. 양념을 곁들임.'),
    ('B0024', 0, '통밀 식빵을 토스터나 마른 팬에 구움.'),
    ('B0024', 1, '팬에 조리용 올리브유를 두르고 달걀을 풀어 완전히 익힘.'),
    ('B0024', 2, '애호박과 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0024', 3, '다진 마늘 3 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('B0024', 4, '식빵 위에 익힌 재료를 올림. 양념을 곁들임.'),
    ('B0027', 0, '통밀 식빵을 토스터나 마른 팬에 구움.'),
    ('B0027', 1, '팬에 조리용 올리브유를 두르고 달걀을 풀어 완전히 익힘.'),
    ('B0027', 2, '애호박과 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0027', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('B0027', 4, '식빵 위에 익힌 재료를 올림. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0032', 0, '통밀 식빵을 토스터나 마른 팬에 구움.'),
    ('B0032', 1, '팬에 조리용 올리브유를 두르고 달걀을 풀어 완전히 익힘.'),
    ('B0032', 2, '시금치와 느타리버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0032', 3, '후추 1 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('B0032', 4, '식빵 위에 익힌 재료를 올림. 양념을 곁들임.'),
    ('B0034', 0, '통밀 식빵을 토스터나 마른 팬에 구움.'),
    ('B0034', 1, '팬에 조리용 올리브유를 두르고 달걀을 풀어 완전히 익힘.'),
    ('B0034', 2, '시금치와 느타리버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0034', 3, '다진 마늘 3 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('B0034', 4, '식빵 위에 익힌 재료를 올림. 양념을 곁들임.'),
    ('B0037', 0, '통밀 식빵을 토스터나 마른 팬에 구움.'),
    ('B0037', 1, '팬에 조리용 올리브유를 두르고 달걀을 풀어 완전히 익힘.'),
    ('B0037', 2, '시금치와 느타리버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0037', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('B0037', 4, '식빵 위에 익힌 재료를 올림. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0042', 0, '통밀 식빵을 토스터나 마른 팬에 구움.'),
    ('B0042', 1, '팬에 조리용 올리브유를 두르고 달걀을 풀어 완전히 익힘.'),
    ('B0042', 2, '청경채와 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0042', 3, '후추 1 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('B0042', 4, '식빵 위에 익힌 재료를 올림. 양념을 곁들임.'),
    ('B0044', 0, '통밀 식빵을 토스터나 마른 팬에 구움.'),
    ('B0044', 1, '팬에 조리용 올리브유를 두르고 달걀을 풀어 완전히 익힘.'),
    ('B0044', 2, '청경채와 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0044', 3, '다진 마늘 3 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('B0044', 4, '식빵 위에 익힌 재료를 올림. 양념을 곁들임.'),
    ('B0047', 0, '통밀 식빵을 토스터나 마른 팬에 구움.'),
    ('B0047', 1, '팬에 조리용 올리브유를 두르고 달걀을 풀어 완전히 익힘.'),
    ('B0047', 2, '청경채와 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0047', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('B0047', 4, '식빵 위에 익힌 재료를 올림. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0052', 0, '통밀 식빵을 토스터나 마른 팬에 구움.'),
    ('B0052', 1, '팬에 조리용 올리브유를 두르고 달걀을 풀어 완전히 익힘.'),
    ('B0052', 2, '가지와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0052', 3, '후추 1 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('B0052', 4, '식빵 위에 익힌 재료를 올림. 양념을 곁들임.'),
    ('B0054', 0, '통밀 식빵을 토스터나 마른 팬에 구움.'),
    ('B0054', 1, '팬에 조리용 올리브유를 두르고 달걀을 풀어 완전히 익힘.'),
    ('B0054', 2, '가지와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0054', 3, '다진 마늘 3 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('B0054', 4, '식빵 위에 익힌 재료를 올림. 양념을 곁들임.'),
    ('B0057', 0, '통밀 식빵을 토스터나 마른 팬에 구움.'),
    ('B0057', 1, '팬에 조리용 올리브유를 두르고 달걀을 풀어 완전히 익힘.'),
    ('B0057', 2, '가지와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0057', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('B0057', 4, '식빵 위에 익힌 재료를 올림. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0062', 0, '통밀 식빵을 토스터나 마른 팬에 구움.'),
    ('B0062', 1, '팬에 조리용 올리브유를 두르고 달걀을 풀어 완전히 익힘.'),
    ('B0062', 2, '양배추와 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0062', 3, '후추 1 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('B0062', 4, '식빵 위에 익힌 재료를 올림. 양념을 곁들임.'),
    ('B0064', 0, '통밀 식빵을 토스터나 마른 팬에 구움.'),
    ('B0064', 1, '팬에 조리용 올리브유를 두르고 달걀을 풀어 완전히 익힘.'),
    ('B0064', 2, '양배추와 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0064', 3, '다진 마늘 3 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('B0064', 4, '식빵 위에 익힌 재료를 올림. 양념을 곁들임.'),
    ('B0067', 0, '통밀 식빵을 토스터나 마른 팬에 구움.'),
    ('B0067', 1, '팬에 조리용 올리브유를 두르고 달걀을 풀어 완전히 익힘.'),
    ('B0067', 2, '양배추와 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0067', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('B0067', 4, '식빵 위에 익힌 재료를 올림. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0072', 0, '통밀 식빵을 토스터나 마른 팬에 구움.'),
    ('B0072', 1, '팬에 조리용 올리브유를 두르고 달걀을 풀어 완전히 익힘.'),
    ('B0072', 2, '브로콜리와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0072', 3, '후추 1 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('B0072', 4, '식빵 위에 익힌 재료를 올림. 양념을 곁들임.'),
    ('B0074', 0, '통밀 식빵을 토스터나 마른 팬에 구움.'),
    ('B0074', 1, '팬에 조리용 올리브유를 두르고 달걀을 풀어 완전히 익힘.'),
    ('B0074', 2, '브로콜리와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0074', 3, '다진 마늘 3 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('B0074', 4, '식빵 위에 익힌 재료를 올림. 양념을 곁들임.'),
    ('B0077', 0, '통밀 식빵을 토스터나 마른 팬에 구움.'),
    ('B0077', 1, '팬에 조리용 올리브유를 두르고 달걀을 풀어 완전히 익힘.'),
    ('B0077', 2, '브로콜리와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0077', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('B0077', 4, '식빵 위에 익힌 재료를 올림. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0082', 0, '통밀 식빵을 토스터나 마른 팬에 구움.'),
    ('B0082', 1, '팬에 조리용 올리브유를 두르고 달걀을 풀어 완전히 익힘.'),
    ('B0082', 2, '애호박과 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0082', 3, '후추 1 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('B0082', 4, '식빵 위에 익힌 재료를 올림. 양념을 곁들임.'),
    ('B0084', 0, '통밀 식빵을 토스터나 마른 팬에 구움.'),
    ('B0084', 1, '팬에 조리용 올리브유를 두르고 달걀을 풀어 완전히 익힘.'),
    ('B0084', 2, '애호박과 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0084', 3, '다진 마늘 3 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('B0084', 4, '식빵 위에 익힌 재료를 올림. 양념을 곁들임.'),
    ('B0087', 0, '통밀 식빵을 토스터나 마른 팬에 구움.'),
    ('B0087', 1, '팬에 조리용 올리브유를 두르고 달걀을 풀어 완전히 익힘.'),
    ('B0087', 2, '애호박과 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0087', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('B0087', 4, '식빵 위에 익힌 재료를 올림. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0092', 0, '통밀 식빵을 토스터나 마른 팬에 구움.'),
    ('B0092', 1, '팬에 조리용 올리브유를 두르고 달걀을 풀어 완전히 익힘.'),
    ('B0092', 2, '시금치와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0092', 3, '후추 1 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('B0092', 4, '식빵 위에 익힌 재료를 올림. 양념을 곁들임.'),
    ('B0094', 0, '통밀 식빵을 토스터나 마른 팬에 구움.'),
    ('B0094', 1, '팬에 조리용 올리브유를 두르고 달걀을 풀어 완전히 익힘.'),
    ('B0094', 2, '시금치와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0094', 3, '다진 마늘 3 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('B0094', 4, '식빵 위에 익힌 재료를 올림. 양념을 곁들임.'),
    ('B0097', 0, '통밀 식빵을 토스터나 마른 팬에 구움.'),
    ('B0097', 1, '팬에 조리용 올리브유를 두르고 달걀을 풀어 완전히 익힘.'),
    ('B0097', 2, '시금치와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0097', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('B0097', 4, '식빵 위에 익힌 재료를 올림. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0101', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0101', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('B0101', 2, '양배추와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0101', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0101', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0102', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0102', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('B0102', 2, '양배추와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0102', 3, '들기름 4 g, 소금 0.5 g을 섞어 양념을 만듦.'),
    ('B0102', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0104', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0104', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('B0104', 2, '양배추와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0104', 3, '다진 마늘 3 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0104', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0107', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0107', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('B0107', 2, '양배추와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0107', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0107', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0108', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0108', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('B0108', 2, '양배추와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0108', 3, '대파 8 g, 참기름 4 g을 섞어 양념을 만듦.'),
    ('B0108', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0110', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0110', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('B0110', 2, '양배추와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0110', 3, '김가루 2 g, 들기름 4 g을 섞어 양념을 만듦.'),
    ('B0110', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0111', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0111', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('B0111', 2, '브로콜리와 양파를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0111', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0111', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0112', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0112', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('B0112', 2, '브로콜리와 양파를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0112', 3, '들기름 4 g, 소금 0.5 g을 섞어 양념을 만듦.'),
    ('B0112', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0114', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0114', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('B0114', 2, '브로콜리와 양파를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0114', 3, '다진 마늘 3 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0114', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0117', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0117', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('B0117', 2, '브로콜리와 양파를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0117', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0117', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0118', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0118', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('B0118', 2, '브로콜리와 양파를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0118', 3, '대파 8 g, 참기름 4 g을 섞어 양념을 만듦.'),
    ('B0118', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0120', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0120', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('B0120', 2, '브로콜리와 양파를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0120', 3, '김가루 2 g, 들기름 4 g을 섞어 양념을 만듦.'),
    ('B0120', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0121', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0121', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('B0121', 2, '애호박과 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0121', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0121', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0122', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0122', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('B0122', 2, '애호박과 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0122', 3, '들기름 4 g, 소금 0.5 g을 섞어 양념을 만듦.'),
    ('B0122', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0124', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0124', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('B0124', 2, '애호박과 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0124', 3, '다진 마늘 3 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0124', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0127', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0127', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('B0127', 2, '애호박과 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0127', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0127', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0128', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0128', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('B0128', 2, '애호박과 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0128', 3, '대파 8 g, 참기름 4 g을 섞어 양념을 만듦.'),
    ('B0128', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0130', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0130', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('B0130', 2, '애호박과 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0130', 3, '김가루 2 g, 들기름 4 g을 섞어 양념을 만듦.'),
    ('B0130', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0131', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0131', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('B0131', 2, '시금치와 느타리버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0131', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0131', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0132', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0132', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('B0132', 2, '시금치와 느타리버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0132', 3, '들기름 4 g, 소금 0.5 g을 섞어 양념을 만듦.'),
    ('B0132', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0134', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0134', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('B0134', 2, '시금치와 느타리버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0134', 3, '다진 마늘 3 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0134', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0137', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0137', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('B0137', 2, '시금치와 느타리버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0137', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0137', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0138', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0138', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('B0138', 2, '시금치와 느타리버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0138', 3, '대파 8 g, 참기름 4 g을 섞어 양념을 만듦.'),
    ('B0138', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0140', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0140', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('B0140', 2, '시금치와 느타리버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0140', 3, '김가루 2 g, 들기름 4 g을 섞어 양념을 만듦.'),
    ('B0140', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0141', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0141', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('B0141', 2, '청경채와 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0141', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0141', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0142', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0142', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('B0142', 2, '청경채와 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0142', 3, '들기름 4 g, 소금 0.5 g을 섞어 양념을 만듦.'),
    ('B0142', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0144', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0144', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('B0144', 2, '청경채와 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0144', 3, '다진 마늘 3 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0144', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0147', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0147', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('B0147', 2, '청경채와 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0147', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0147', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0148', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0148', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('B0148', 2, '청경채와 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0148', 3, '대파 8 g, 참기름 4 g을 섞어 양념을 만듦.'),
    ('B0148', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0150', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0150', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('B0150', 2, '청경채와 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0150', 3, '김가루 2 g, 들기름 4 g을 섞어 양념을 만듦.'),
    ('B0150', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0151', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0151', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('B0151', 2, '가지와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0151', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0151', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0152', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0152', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('B0152', 2, '가지와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0152', 3, '들기름 4 g, 소금 0.5 g을 섞어 양념을 만듦.'),
    ('B0152', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0154', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0154', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('B0154', 2, '가지와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0154', 3, '다진 마늘 3 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0154', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0157', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0157', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('B0157', 2, '가지와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0157', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0157', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0158', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0158', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('B0158', 2, '가지와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0158', 3, '대파 8 g, 참기름 4 g을 섞어 양념을 만듦.'),
    ('B0158', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0160', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0160', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('B0160', 2, '가지와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0160', 3, '김가루 2 g, 들기름 4 g을 섞어 양념을 만듦.'),
    ('B0160', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0161', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0161', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('B0161', 2, '양배추와 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0161', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0161', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0162', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0162', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('B0162', 2, '양배추와 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0162', 3, '들기름 4 g, 소금 0.5 g을 섞어 양념을 만듦.'),
    ('B0162', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0164', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0164', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('B0164', 2, '양배추와 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0164', 3, '다진 마늘 3 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0164', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0167', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0167', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('B0167', 2, '양배추와 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0167', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0167', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0168', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0168', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('B0168', 2, '양배추와 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0168', 3, '대파 8 g, 참기름 4 g을 섞어 양념을 만듦.'),
    ('B0168', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0170', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0170', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('B0170', 2, '양배추와 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0170', 3, '김가루 2 g, 들기름 4 g을 섞어 양념을 만듦.'),
    ('B0170', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0171', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0171', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('B0171', 2, '브로콜리와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0171', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0171', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0172', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0172', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('B0172', 2, '브로콜리와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0172', 3, '들기름 4 g, 소금 0.5 g을 섞어 양념을 만듦.'),
    ('B0172', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0174', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0174', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('B0174', 2, '브로콜리와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0174', 3, '다진 마늘 3 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0174', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0177', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0177', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('B0177', 2, '브로콜리와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0177', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0177', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0178', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0178', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('B0178', 2, '브로콜리와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0178', 3, '대파 8 g, 참기름 4 g을 섞어 양념을 만듦.'),
    ('B0178', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0180', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0180', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('B0180', 2, '브로콜리와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0180', 3, '김가루 2 g, 들기름 4 g을 섞어 양념을 만듦.'),
    ('B0180', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0181', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0181', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('B0181', 2, '애호박과 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0181', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0181', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0182', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0182', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('B0182', 2, '애호박과 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0182', 3, '들기름 4 g, 소금 0.5 g을 섞어 양념을 만듦.'),
    ('B0182', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0184', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0184', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('B0184', 2, '애호박과 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0184', 3, '다진 마늘 3 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0184', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0187', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0187', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('B0187', 2, '애호박과 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0187', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0187', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0188', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0188', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('B0188', 2, '애호박과 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0188', 3, '대파 8 g, 참기름 4 g을 섞어 양념을 만듦.'),
    ('B0188', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0190', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0190', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('B0190', 2, '애호박과 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0190', 3, '김가루 2 g, 들기름 4 g을 섞어 양념을 만듦.'),
    ('B0190', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0191', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0191', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('B0191', 2, '시금치와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0191', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0191', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0192', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0192', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('B0192', 2, '시금치와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0192', 3, '들기름 4 g, 소금 0.5 g을 섞어 양념을 만듦.'),
    ('B0192', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0194', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0194', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('B0194', 2, '시금치와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0194', 3, '다진 마늘 3 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0194', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0197', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0197', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('B0197', 2, '시금치와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0197', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0197', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0198', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0198', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('B0198', 2, '시금치와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0198', 3, '대파 8 g, 참기름 4 g을 섞어 양념을 만듦.'),
    ('B0198', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0200', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0200', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('B0200', 2, '시금치와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0200', 3, '김가루 2 g, 들기름 4 g을 섞어 양념을 만듦.'),
    ('B0200', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0207', 0, '고구마를 작게 썰고 속까지 부드러워질 때까지 찜.'),
    ('B0207', 1, '팬에 조리용 올리브유를 두르고 달걀을 풀어 완전히 익힘.'),
    ('B0207', 2, '양배추와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0207', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('B0207', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0217', 0, '고구마를 작게 썰고 속까지 부드러워질 때까지 찜.'),
    ('B0217', 1, '팬에 조리용 올리브유를 두르고 달걀을 풀어 완전히 익힘.'),
    ('B0217', 2, '브로콜리와 양파를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0217', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('B0217', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0227', 0, '고구마를 작게 썰고 속까지 부드러워질 때까지 찜.'),
    ('B0227', 1, '팬에 조리용 올리브유를 두르고 달걀을 풀어 완전히 익힘.'),
    ('B0227', 2, '애호박과 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0227', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('B0227', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0237', 0, '고구마를 작게 썰고 속까지 부드러워질 때까지 찜.'),
    ('B0237', 1, '팬에 조리용 올리브유를 두르고 달걀을 풀어 완전히 익힘.'),
    ('B0237', 2, '시금치와 느타리버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0237', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('B0237', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0247', 0, '고구마를 작게 썰고 속까지 부드러워질 때까지 찜.'),
    ('B0247', 1, '팬에 조리용 올리브유를 두르고 달걀을 풀어 완전히 익힘.'),
    ('B0247', 2, '청경채와 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0247', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('B0247', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0257', 0, '고구마를 작게 썰고 속까지 부드러워질 때까지 찜.'),
    ('B0257', 1, '팬에 조리용 올리브유를 두르고 달걀을 풀어 완전히 익힘.'),
    ('B0257', 2, '가지와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0257', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('B0257', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0267', 0, '고구마를 작게 썰고 속까지 부드러워질 때까지 찜.'),
    ('B0267', 1, '팬에 조리용 올리브유를 두르고 달걀을 풀어 완전히 익힘.'),
    ('B0267', 2, '양배추와 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0267', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('B0267', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0277', 0, '고구마를 작게 썰고 속까지 부드러워질 때까지 찜.'),
    ('B0277', 1, '팬에 조리용 올리브유를 두르고 달걀을 풀어 완전히 익힘.'),
    ('B0277', 2, '브로콜리와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0277', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('B0277', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0287', 0, '고구마를 작게 썰고 속까지 부드러워질 때까지 찜.'),
    ('B0287', 1, '팬에 조리용 올리브유를 두르고 달걀을 풀어 완전히 익힘.'),
    ('B0287', 2, '애호박과 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0287', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('B0287', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0297', 0, '고구마를 작게 썰고 속까지 부드러워질 때까지 찜.'),
    ('B0297', 1, '팬에 조리용 올리브유를 두르고 달걀을 풀어 완전히 익힘.'),
    ('B0297', 2, '시금치와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0297', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('B0297', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0307', 0, '감자를 한입 크기로 썰고 속까지 부드러워질 때까지 찜.'),
    ('B0307', 1, '닭가슴살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('B0307', 2, '양배추와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0307', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('B0307', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0317', 0, '감자를 한입 크기로 썰고 속까지 부드러워질 때까지 찜.'),
    ('B0317', 1, '닭가슴살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('B0317', 2, '브로콜리와 양파를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0317', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('B0317', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0327', 0, '감자를 한입 크기로 썰고 속까지 부드러워질 때까지 찜.'),
    ('B0327', 1, '닭가슴살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('B0327', 2, '애호박과 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0327', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('B0327', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0337', 0, '감자를 한입 크기로 썰고 속까지 부드러워질 때까지 찜.'),
    ('B0337', 1, '닭가슴살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('B0337', 2, '시금치와 느타리버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0337', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('B0337', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0347', 0, '감자를 한입 크기로 썰고 속까지 부드러워질 때까지 찜.'),
    ('B0347', 1, '닭가슴살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('B0347', 2, '청경채와 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0347', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('B0347', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0357', 0, '감자를 한입 크기로 썰고 속까지 부드러워질 때까지 찜.'),
    ('B0357', 1, '닭가슴살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('B0357', 2, '가지와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0357', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('B0357', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0367', 0, '감자를 한입 크기로 썰고 속까지 부드러워질 때까지 찜.'),
    ('B0367', 1, '닭가슴살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('B0367', 2, '양배추와 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0367', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('B0367', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0377', 0, '감자를 한입 크기로 썰고 속까지 부드러워질 때까지 찜.'),
    ('B0377', 1, '닭가슴살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('B0377', 2, '브로콜리와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0377', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('B0377', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0387', 0, '감자를 한입 크기로 썰고 속까지 부드러워질 때까지 찜.'),
    ('B0387', 1, '닭가슴살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('B0387', 2, '애호박과 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0387', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('B0387', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0397', 0, '감자를 한입 크기로 썰고 속까지 부드러워질 때까지 찜.'),
    ('B0397', 1, '닭가슴살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('B0397', 2, '시금치와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0397', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('B0397', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0407', 0, '익힌 잡곡밥을 데움.'),
    ('B0407', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('B0407', 2, '양배추와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0407', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0407', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0417', 0, '익힌 잡곡밥을 데움.'),
    ('B0417', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('B0417', 2, '브로콜리와 양파를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0417', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0417', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0427', 0, '익힌 잡곡밥을 데움.'),
    ('B0427', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('B0427', 2, '애호박과 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0427', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0427', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0437', 0, '익힌 잡곡밥을 데움.'),
    ('B0437', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('B0437', 2, '시금치와 느타리버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0437', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0437', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0447', 0, '익힌 잡곡밥을 데움.'),
    ('B0447', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('B0447', 2, '청경채와 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0447', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0447', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0457', 0, '익힌 잡곡밥을 데움.'),
    ('B0457', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('B0457', 2, '가지와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0457', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0457', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0467', 0, '익힌 잡곡밥을 데움.'),
    ('B0467', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('B0467', 2, '양배추와 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0467', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0467', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0477', 0, '익힌 잡곡밥을 데움.'),
    ('B0477', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('B0477', 2, '브로콜리와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0477', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0477', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0487', 0, '익힌 잡곡밥을 데움.'),
    ('B0487', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('B0487', 2, '애호박과 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0487', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0487', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0497', 0, '익힌 잡곡밥을 데움.'),
    ('B0497', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('B0497', 2, '시금치와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0497', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0497', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0507', 0, '통밀 또띠아를 마른 팬에서 살짝 데움.'),
    ('B0507', 1, '닭가슴살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('B0507', 2, '양배추와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0507', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('B0507', 4, '또띠아에 속재료를 담고 말아줌. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0517', 0, '통밀 또띠아를 마른 팬에서 살짝 데움.'),
    ('B0517', 1, '닭가슴살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('B0517', 2, '브로콜리와 양파를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0517', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('B0517', 4, '또띠아에 속재료를 담고 말아줌. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0527', 0, '통밀 또띠아를 마른 팬에서 살짝 데움.'),
    ('B0527', 1, '닭가슴살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('B0527', 2, '애호박과 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0527', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('B0527', 4, '또띠아에 속재료를 담고 말아줌. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0537', 0, '통밀 또띠아를 마른 팬에서 살짝 데움.'),
    ('B0537', 1, '닭가슴살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('B0537', 2, '시금치와 느타리버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0537', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('B0537', 4, '또띠아에 속재료를 담고 말아줌. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0547', 0, '통밀 또띠아를 마른 팬에서 살짝 데움.'),
    ('B0547', 1, '닭가슴살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('B0547', 2, '청경채와 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0547', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('B0547', 4, '또띠아에 속재료를 담고 말아줌. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0557', 0, '통밀 또띠아를 마른 팬에서 살짝 데움.'),
    ('B0557', 1, '닭가슴살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('B0557', 2, '가지와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0557', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('B0557', 4, '또띠아에 속재료를 담고 말아줌. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0567', 0, '통밀 또띠아를 마른 팬에서 살짝 데움.'),
    ('B0567', 1, '닭가슴살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('B0567', 2, '양배추와 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0567', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('B0567', 4, '또띠아에 속재료를 담고 말아줌. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0577', 0, '통밀 또띠아를 마른 팬에서 살짝 데움.'),
    ('B0577', 1, '닭가슴살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('B0577', 2, '브로콜리와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0577', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('B0577', 4, '또띠아에 속재료를 담고 말아줌. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0587', 0, '통밀 또띠아를 마른 팬에서 살짝 데움.'),
    ('B0587', 1, '닭가슴살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('B0587', 2, '애호박과 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0587', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('B0587', 4, '또띠아에 속재료를 담고 말아줌. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0597', 0, '통밀 또띠아를 마른 팬에서 살짝 데움.'),
    ('B0597', 1, '닭가슴살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('B0597', 2, '시금치와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0597', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('B0597', 4, '또띠아에 속재료를 담고 말아줌. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0607', 0, '익힌 현미밥을 데움.'),
    ('B0607', 1, '참치 통조림의 물기를 빼고 먹기 좋은 크기로 풂.'),
    ('B0607', 2, '양배추와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0607', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0607', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0617', 0, '익힌 현미밥을 데움.'),
    ('B0617', 1, '참치 통조림의 물기를 빼고 먹기 좋은 크기로 풂.'),
    ('B0617', 2, '브로콜리와 양파를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0617', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0617', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0627', 0, '익힌 현미밥을 데움.'),
    ('B0627', 1, '참치 통조림의 물기를 빼고 먹기 좋은 크기로 풂.'),
    ('B0627', 2, '애호박과 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0627', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0627', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0637', 0, '익힌 현미밥을 데움.'),
    ('B0637', 1, '참치 통조림의 물기를 빼고 먹기 좋은 크기로 풂.'),
    ('B0637', 2, '시금치와 느타리버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0637', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0637', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0647', 0, '익힌 현미밥을 데움.'),
    ('B0647', 1, '참치 통조림의 물기를 빼고 먹기 좋은 크기로 풂.'),
    ('B0647', 2, '청경채와 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0647', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0647', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0657', 0, '익힌 현미밥을 데움.'),
    ('B0657', 1, '참치 통조림의 물기를 빼고 먹기 좋은 크기로 풂.'),
    ('B0657', 2, '가지와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0657', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0657', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0667', 0, '익힌 현미밥을 데움.'),
    ('B0667', 1, '참치 통조림의 물기를 빼고 먹기 좋은 크기로 풂.'),
    ('B0667', 2, '양배추와 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0667', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0667', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0677', 0, '익힌 현미밥을 데움.'),
    ('B0677', 1, '참치 통조림의 물기를 빼고 먹기 좋은 크기로 풂.'),
    ('B0677', 2, '브로콜리와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0677', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0677', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0687', 0, '익힌 현미밥을 데움.'),
    ('B0687', 1, '참치 통조림의 물기를 빼고 먹기 좋은 크기로 풂.'),
    ('B0687', 2, '애호박과 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0687', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0687', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0697', 0, '익힌 현미밥을 데움.'),
    ('B0697', 1, '참치 통조림의 물기를 빼고 먹기 좋은 크기로 풂.'),
    ('B0697', 2, '시금치와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0697', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0697', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0707', 0, '익힌 퀴노아를 데움.'),
    ('B0707', 1, '삶은 병아리콩의 물기를 빼고 데움.'),
    ('B0707', 2, '양배추와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0707', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('B0707', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0717', 0, '익힌 퀴노아를 데움.'),
    ('B0717', 1, '삶은 병아리콩의 물기를 빼고 데움.'),
    ('B0717', 2, '브로콜리와 양파를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0717', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('B0717', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0727', 0, '익힌 퀴노아를 데움.'),
    ('B0727', 1, '삶은 병아리콩의 물기를 빼고 데움.'),
    ('B0727', 2, '애호박과 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0727', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('B0727', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0737', 0, '익힌 퀴노아를 데움.'),
    ('B0737', 1, '삶은 병아리콩의 물기를 빼고 데움.'),
    ('B0737', 2, '시금치와 느타리버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0737', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('B0737', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0747', 0, '익힌 퀴노아를 데움.'),
    ('B0747', 1, '삶은 병아리콩의 물기를 빼고 데움.'),
    ('B0747', 2, '청경채와 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0747', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('B0747', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0757', 0, '익힌 퀴노아를 데움.'),
    ('B0757', 1, '삶은 병아리콩의 물기를 빼고 데움.'),
    ('B0757', 2, '가지와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0757', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('B0757', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0767', 0, '익힌 퀴노아를 데움.'),
    ('B0767', 1, '삶은 병아리콩의 물기를 빼고 데움.'),
    ('B0767', 2, '양배추와 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0767', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('B0767', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0777', 0, '익힌 퀴노아를 데움.'),
    ('B0777', 1, '삶은 병아리콩의 물기를 빼고 데움.'),
    ('B0777', 2, '브로콜리와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0777', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('B0777', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0787', 0, '익힌 퀴노아를 데움.'),
    ('B0787', 1, '삶은 병아리콩의 물기를 빼고 데움.'),
    ('B0787', 2, '애호박과 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0787', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('B0787', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0797', 0, '익힌 퀴노아를 데움.'),
    ('B0797', 1, '삶은 병아리콩의 물기를 빼고 데움.'),
    ('B0797', 2, '시금치와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0797', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('B0797', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0807', 0, '익힌 보리밥을 데움.'),
    ('B0807', 1, '팬에 조리용 올리브유를 두르고 달걀을 풀어 완전히 익힘.'),
    ('B0807', 2, '양배추와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0807', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0807', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0817', 0, '익힌 보리밥을 데움.'),
    ('B0817', 1, '팬에 조리용 올리브유를 두르고 달걀을 풀어 완전히 익힘.'),
    ('B0817', 2, '브로콜리와 양파를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0817', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0817', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0827', 0, '익힌 보리밥을 데움.'),
    ('B0827', 1, '팬에 조리용 올리브유를 두르고 달걀을 풀어 완전히 익힘.'),
    ('B0827', 2, '애호박과 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0827', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0827', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0837', 0, '익힌 보리밥을 데움.'),
    ('B0837', 1, '팬에 조리용 올리브유를 두르고 달걀을 풀어 완전히 익힘.'),
    ('B0837', 2, '시금치와 느타리버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0837', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0837', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0847', 0, '익힌 보리밥을 데움.'),
    ('B0847', 1, '팬에 조리용 올리브유를 두르고 달걀을 풀어 완전히 익힘.'),
    ('B0847', 2, '청경채와 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0847', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0847', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0857', 0, '익힌 보리밥을 데움.'),
    ('B0857', 1, '팬에 조리용 올리브유를 두르고 달걀을 풀어 완전히 익힘.'),
    ('B0857', 2, '가지와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0857', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0857', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0867', 0, '익힌 보리밥을 데움.'),
    ('B0867', 1, '팬에 조리용 올리브유를 두르고 달걀을 풀어 완전히 익힘.'),
    ('B0867', 2, '양배추와 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0867', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0867', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0877', 0, '익힌 보리밥을 데움.'),
    ('B0877', 1, '팬에 조리용 올리브유를 두르고 달걀을 풀어 완전히 익힘.'),
    ('B0877', 2, '브로콜리와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0877', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0877', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0887', 0, '익힌 보리밥을 데움.'),
    ('B0887', 1, '팬에 조리용 올리브유를 두르고 달걀을 풀어 완전히 익힘.'),
    ('B0887', 2, '애호박과 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0887', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0887', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0897', 0, '익힌 보리밥을 데움.'),
    ('B0897', 1, '팬에 조리용 올리브유를 두르고 달걀을 풀어 완전히 익힘.'),
    ('B0897', 2, '시금치와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0897', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0897', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0901', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0901', 1, '삶은 렌틸콩의 물기를 빼고 데움.'),
    ('B0901', 2, '양배추와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0901', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0901', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0902', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0902', 1, '삶은 렌틸콩의 물기를 빼고 데움.'),
    ('B0902', 2, '양배추와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0902', 3, '들기름 4 g, 소금 0.5 g을 섞어 양념을 만듦.'),
    ('B0902', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0904', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0904', 1, '삶은 렌틸콩의 물기를 빼고 데움.'),
    ('B0904', 2, '양배추와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0904', 3, '다진 마늘 3 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0904', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0907', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0907', 1, '삶은 렌틸콩의 물기를 빼고 데움.'),
    ('B0907', 2, '양배추와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0907', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0907', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0908', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0908', 1, '삶은 렌틸콩의 물기를 빼고 데움.'),
    ('B0908', 2, '양배추와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0908', 3, '대파 8 g, 참기름 4 g을 섞어 양념을 만듦.'),
    ('B0908', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0910', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0910', 1, '삶은 렌틸콩의 물기를 빼고 데움.'),
    ('B0910', 2, '양배추와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0910', 3, '김가루 2 g, 들기름 4 g을 섞어 양념을 만듦.'),
    ('B0910', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0911', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0911', 1, '삶은 렌틸콩의 물기를 빼고 데움.'),
    ('B0911', 2, '브로콜리와 양파를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0911', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0911', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0912', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0912', 1, '삶은 렌틸콩의 물기를 빼고 데움.'),
    ('B0912', 2, '브로콜리와 양파를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0912', 3, '들기름 4 g, 소금 0.5 g을 섞어 양념을 만듦.'),
    ('B0912', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0914', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0914', 1, '삶은 렌틸콩의 물기를 빼고 데움.'),
    ('B0914', 2, '브로콜리와 양파를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0914', 3, '다진 마늘 3 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0914', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0917', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0917', 1, '삶은 렌틸콩의 물기를 빼고 데움.'),
    ('B0917', 2, '브로콜리와 양파를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0917', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0917', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0918', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0918', 1, '삶은 렌틸콩의 물기를 빼고 데움.'),
    ('B0918', 2, '브로콜리와 양파를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0918', 3, '대파 8 g, 참기름 4 g을 섞어 양념을 만듦.'),
    ('B0918', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0920', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0920', 1, '삶은 렌틸콩의 물기를 빼고 데움.'),
    ('B0920', 2, '브로콜리와 양파를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0920', 3, '김가루 2 g, 들기름 4 g을 섞어 양념을 만듦.'),
    ('B0920', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0921', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0921', 1, '삶은 렌틸콩의 물기를 빼고 데움.'),
    ('B0921', 2, '애호박과 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0921', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0921', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0922', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0922', 1, '삶은 렌틸콩의 물기를 빼고 데움.'),
    ('B0922', 2, '애호박과 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0922', 3, '들기름 4 g, 소금 0.5 g을 섞어 양념을 만듦.'),
    ('B0922', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0924', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0924', 1, '삶은 렌틸콩의 물기를 빼고 데움.'),
    ('B0924', 2, '애호박과 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0924', 3, '다진 마늘 3 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0924', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0927', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0927', 1, '삶은 렌틸콩의 물기를 빼고 데움.'),
    ('B0927', 2, '애호박과 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0927', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0927', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0928', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0928', 1, '삶은 렌틸콩의 물기를 빼고 데움.'),
    ('B0928', 2, '애호박과 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0928', 3, '대파 8 g, 참기름 4 g을 섞어 양념을 만듦.'),
    ('B0928', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0930', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0930', 1, '삶은 렌틸콩의 물기를 빼고 데움.'),
    ('B0930', 2, '애호박과 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0930', 3, '김가루 2 g, 들기름 4 g을 섞어 양념을 만듦.'),
    ('B0930', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0931', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0931', 1, '삶은 렌틸콩의 물기를 빼고 데움.'),
    ('B0931', 2, '시금치와 느타리버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0931', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0931', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0932', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0932', 1, '삶은 렌틸콩의 물기를 빼고 데움.'),
    ('B0932', 2, '시금치와 느타리버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0932', 3, '들기름 4 g, 소금 0.5 g을 섞어 양념을 만듦.'),
    ('B0932', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0934', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0934', 1, '삶은 렌틸콩의 물기를 빼고 데움.'),
    ('B0934', 2, '시금치와 느타리버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0934', 3, '다진 마늘 3 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0934', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0937', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0937', 1, '삶은 렌틸콩의 물기를 빼고 데움.'),
    ('B0937', 2, '시금치와 느타리버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0937', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0937', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0938', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0938', 1, '삶은 렌틸콩의 물기를 빼고 데움.'),
    ('B0938', 2, '시금치와 느타리버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0938', 3, '대파 8 g, 참기름 4 g을 섞어 양념을 만듦.'),
    ('B0938', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0940', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0940', 1, '삶은 렌틸콩의 물기를 빼고 데움.'),
    ('B0940', 2, '시금치와 느타리버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0940', 3, '김가루 2 g, 들기름 4 g을 섞어 양념을 만듦.'),
    ('B0940', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0941', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0941', 1, '삶은 렌틸콩의 물기를 빼고 데움.'),
    ('B0941', 2, '청경채와 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0941', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0941', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0942', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0942', 1, '삶은 렌틸콩의 물기를 빼고 데움.'),
    ('B0942', 2, '청경채와 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0942', 3, '들기름 4 g, 소금 0.5 g을 섞어 양념을 만듦.'),
    ('B0942', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0944', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0944', 1, '삶은 렌틸콩의 물기를 빼고 데움.'),
    ('B0944', 2, '청경채와 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0944', 3, '다진 마늘 3 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0944', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0947', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0947', 1, '삶은 렌틸콩의 물기를 빼고 데움.'),
    ('B0947', 2, '청경채와 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0947', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0947', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0948', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0948', 1, '삶은 렌틸콩의 물기를 빼고 데움.'),
    ('B0948', 2, '청경채와 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0948', 3, '대파 8 g, 참기름 4 g을 섞어 양념을 만듦.'),
    ('B0948', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0950', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0950', 1, '삶은 렌틸콩의 물기를 빼고 데움.'),
    ('B0950', 2, '청경채와 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0950', 3, '김가루 2 g, 들기름 4 g을 섞어 양념을 만듦.'),
    ('B0950', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0951', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0951', 1, '삶은 렌틸콩의 물기를 빼고 데움.'),
    ('B0951', 2, '가지와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0951', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0951', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0952', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0952', 1, '삶은 렌틸콩의 물기를 빼고 데움.'),
    ('B0952', 2, '가지와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0952', 3, '들기름 4 g, 소금 0.5 g을 섞어 양념을 만듦.'),
    ('B0952', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0954', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0954', 1, '삶은 렌틸콩의 물기를 빼고 데움.'),
    ('B0954', 2, '가지와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0954', 3, '다진 마늘 3 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0954', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0957', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0957', 1, '삶은 렌틸콩의 물기를 빼고 데움.'),
    ('B0957', 2, '가지와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0957', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0957', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0958', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0958', 1, '삶은 렌틸콩의 물기를 빼고 데움.'),
    ('B0958', 2, '가지와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0958', 3, '대파 8 g, 참기름 4 g을 섞어 양념을 만듦.'),
    ('B0958', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0960', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0960', 1, '삶은 렌틸콩의 물기를 빼고 데움.'),
    ('B0960', 2, '가지와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0960', 3, '김가루 2 g, 들기름 4 g을 섞어 양념을 만듦.'),
    ('B0960', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0961', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0961', 1, '삶은 렌틸콩의 물기를 빼고 데움.'),
    ('B0961', 2, '양배추와 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0961', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0961', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0962', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0962', 1, '삶은 렌틸콩의 물기를 빼고 데움.'),
    ('B0962', 2, '양배추와 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0962', 3, '들기름 4 g, 소금 0.5 g을 섞어 양념을 만듦.'),
    ('B0962', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0964', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0964', 1, '삶은 렌틸콩의 물기를 빼고 데움.'),
    ('B0964', 2, '양배추와 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0964', 3, '다진 마늘 3 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0964', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0967', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0967', 1, '삶은 렌틸콩의 물기를 빼고 데움.'),
    ('B0967', 2, '양배추와 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0967', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0967', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0968', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0968', 1, '삶은 렌틸콩의 물기를 빼고 데움.'),
    ('B0968', 2, '양배추와 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0968', 3, '대파 8 g, 참기름 4 g을 섞어 양념을 만듦.'),
    ('B0968', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0970', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0970', 1, '삶은 렌틸콩의 물기를 빼고 데움.'),
    ('B0970', 2, '양배추와 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0970', 3, '김가루 2 g, 들기름 4 g을 섞어 양념을 만듦.'),
    ('B0970', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0971', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0971', 1, '삶은 렌틸콩의 물기를 빼고 데움.'),
    ('B0971', 2, '브로콜리와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0971', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0971', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0972', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0972', 1, '삶은 렌틸콩의 물기를 빼고 데움.'),
    ('B0972', 2, '브로콜리와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0972', 3, '들기름 4 g, 소금 0.5 g을 섞어 양념을 만듦.'),
    ('B0972', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0974', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0974', 1, '삶은 렌틸콩의 물기를 빼고 데움.'),
    ('B0974', 2, '브로콜리와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0974', 3, '다진 마늘 3 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0974', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0977', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0977', 1, '삶은 렌틸콩의 물기를 빼고 데움.'),
    ('B0977', 2, '브로콜리와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0977', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0977', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0978', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0978', 1, '삶은 렌틸콩의 물기를 빼고 데움.'),
    ('B0978', 2, '브로콜리와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0978', 3, '대파 8 g, 참기름 4 g을 섞어 양념을 만듦.'),
    ('B0978', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0980', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0980', 1, '삶은 렌틸콩의 물기를 빼고 데움.'),
    ('B0980', 2, '브로콜리와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0980', 3, '김가루 2 g, 들기름 4 g을 섞어 양념을 만듦.'),
    ('B0980', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0981', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0981', 1, '삶은 렌틸콩의 물기를 빼고 데움.'),
    ('B0981', 2, '애호박과 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0981', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0981', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0982', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0982', 1, '삶은 렌틸콩의 물기를 빼고 데움.'),
    ('B0982', 2, '애호박과 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0982', 3, '들기름 4 g, 소금 0.5 g을 섞어 양념을 만듦.'),
    ('B0982', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0984', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0984', 1, '삶은 렌틸콩의 물기를 빼고 데움.'),
    ('B0984', 2, '애호박과 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0984', 3, '다진 마늘 3 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0984', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0987', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0987', 1, '삶은 렌틸콩의 물기를 빼고 데움.'),
    ('B0987', 2, '애호박과 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0987', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0987', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0988', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0988', 1, '삶은 렌틸콩의 물기를 빼고 데움.'),
    ('B0988', 2, '애호박과 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0988', 3, '대파 8 g, 참기름 4 g을 섞어 양념을 만듦.'),
    ('B0988', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0990', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0990', 1, '삶은 렌틸콩의 물기를 빼고 데움.'),
    ('B0990', 2, '애호박과 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0990', 3, '김가루 2 g, 들기름 4 g을 섞어 양념을 만듦.'),
    ('B0990', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0991', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0991', 1, '삶은 렌틸콩의 물기를 빼고 데움.'),
    ('B0991', 2, '시금치와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0991', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0991', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0992', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0992', 1, '삶은 렌틸콩의 물기를 빼고 데움.'),
    ('B0992', 2, '시금치와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0992', 3, '들기름 4 g, 소금 0.5 g을 섞어 양념을 만듦.'),
    ('B0992', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0994', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0994', 1, '삶은 렌틸콩의 물기를 빼고 데움.'),
    ('B0994', 2, '시금치와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0994', 3, '다진 마늘 3 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0994', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B0997', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0997', 1, '삶은 렌틸콩의 물기를 빼고 데움.'),
    ('B0997', 2, '시금치와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0997', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('B0997', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('B0998', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B0998', 1, '삶은 렌틸콩의 물기를 빼고 데움.'),
    ('B0998', 2, '시금치와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B0998', 3, '대파 8 g, 참기름 4 g을 섞어 양념을 만듦.'),
    ('B0998', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('B1000', 0, '오트밀과 물을 냄비에 넣고 저으며 걸쭉해질 때까지 끓임.'),
    ('B1000', 1, '삶은 렌틸콩의 물기를 빼고 데움.'),
    ('B1000', 2, '시금치와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('B1000', 3, '김가루 2 g, 들기름 4 g을 섞어 양념을 만듦.'),
    ('B1000', 4, '오트죽에 익힌 재료를 넣어 섞음. 양념을 곁들임.'),
    ('L0007', 0, '익힌 현미밥을 데움.'),
    ('L0007', 1, '닭가슴살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('L0007', 2, '양배추와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0007', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('L0007', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0017', 0, '익힌 현미밥을 데움.'),
    ('L0017', 1, '닭가슴살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('L0017', 2, '브로콜리와 양파를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0017', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('L0017', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0027', 0, '익힌 현미밥을 데움.'),
    ('L0027', 1, '닭가슴살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('L0027', 2, '애호박과 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0027', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('L0027', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0037', 0, '익힌 현미밥을 데움.'),
    ('L0037', 1, '닭가슴살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('L0037', 2, '시금치와 느타리버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0037', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('L0037', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0047', 0, '익힌 현미밥을 데움.'),
    ('L0047', 1, '닭가슴살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('L0047', 2, '청경채와 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0047', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('L0047', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0057', 0, '익힌 현미밥을 데움.'),
    ('L0057', 1, '닭가슴살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('L0057', 2, '가지와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0057', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('L0057', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0067', 0, '익힌 현미밥을 데움.'),
    ('L0067', 1, '닭가슴살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('L0067', 2, '양배추와 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0067', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('L0067', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0077', 0, '익힌 현미밥을 데움.'),
    ('L0077', 1, '닭가슴살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('L0077', 2, '브로콜리와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0077', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('L0077', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0087', 0, '익힌 현미밥을 데움.'),
    ('L0087', 1, '닭가슴살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('L0087', 2, '애호박과 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0087', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('L0087', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0097', 0, '익힌 현미밥을 데움.'),
    ('L0097', 1, '닭가슴살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('L0097', 2, '시금치와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0097', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('L0097', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0107', 0, '익힌 잡곡밥을 데움.'),
    ('L0107', 1, '돼지 안심을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('L0107', 2, '양배추와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0107', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('L0107', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0117', 0, '익힌 잡곡밥을 데움.'),
    ('L0117', 1, '돼지 안심을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('L0117', 2, '브로콜리와 양파를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0117', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('L0117', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0127', 0, '익힌 잡곡밥을 데움.'),
    ('L0127', 1, '돼지 안심을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('L0127', 2, '애호박과 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0127', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('L0127', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0137', 0, '익힌 잡곡밥을 데움.'),
    ('L0137', 1, '돼지 안심을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('L0137', 2, '시금치와 느타리버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0137', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('L0137', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0147', 0, '익힌 잡곡밥을 데움.'),
    ('L0147', 1, '돼지 안심을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('L0147', 2, '청경채와 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0147', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('L0147', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0157', 0, '익힌 잡곡밥을 데움.'),
    ('L0157', 1, '돼지 안심을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('L0157', 2, '가지와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0157', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('L0157', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0167', 0, '익힌 잡곡밥을 데움.'),
    ('L0167', 1, '돼지 안심을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('L0167', 2, '양배추와 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0167', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('L0167', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0177', 0, '익힌 잡곡밥을 데움.'),
    ('L0177', 1, '돼지 안심을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('L0177', 2, '브로콜리와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0177', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('L0177', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0187', 0, '익힌 잡곡밥을 데움.'),
    ('L0187', 1, '돼지 안심을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('L0187', 2, '애호박과 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0187', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('L0187', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0197', 0, '익힌 잡곡밥을 데움.'),
    ('L0197', 1, '돼지 안심을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('L0197', 2, '시금치와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0197', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('L0197', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0207', 0, '통밀 또띠아를 마른 팬에서 살짝 데움.'),
    ('L0207', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('L0207', 2, '양배추와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0207', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('L0207', 4, '또띠아에 속재료를 담고 말아줌. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0217', 0, '통밀 또띠아를 마른 팬에서 살짝 데움.'),
    ('L0217', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('L0217', 2, '브로콜리와 양파를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0217', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('L0217', 4, '또띠아에 속재료를 담고 말아줌. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0227', 0, '통밀 또띠아를 마른 팬에서 살짝 데움.'),
    ('L0227', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('L0227', 2, '애호박과 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0227', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('L0227', 4, '또띠아에 속재료를 담고 말아줌. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0237', 0, '통밀 또띠아를 마른 팬에서 살짝 데움.'),
    ('L0237', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('L0237', 2, '시금치와 느타리버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0237', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('L0237', 4, '또띠아에 속재료를 담고 말아줌. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0247', 0, '통밀 또띠아를 마른 팬에서 살짝 데움.'),
    ('L0247', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('L0247', 2, '청경채와 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0247', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('L0247', 4, '또띠아에 속재료를 담고 말아줌. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0257', 0, '통밀 또띠아를 마른 팬에서 살짝 데움.'),
    ('L0257', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('L0257', 2, '가지와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0257', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('L0257', 4, '또띠아에 속재료를 담고 말아줌. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0267', 0, '통밀 또띠아를 마른 팬에서 살짝 데움.'),
    ('L0267', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('L0267', 2, '양배추와 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0267', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('L0267', 4, '또띠아에 속재료를 담고 말아줌. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0277', 0, '통밀 또띠아를 마른 팬에서 살짝 데움.'),
    ('L0277', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('L0277', 2, '브로콜리와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0277', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('L0277', 4, '또띠아에 속재료를 담고 말아줌. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0287', 0, '통밀 또띠아를 마른 팬에서 살짝 데움.'),
    ('L0287', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('L0287', 2, '애호박과 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0287', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('L0287', 4, '또띠아에 속재료를 담고 말아줌. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0297', 0, '통밀 또띠아를 마른 팬에서 살짝 데움.'),
    ('L0297', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('L0297', 2, '시금치와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0297', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('L0297', 4, '또띠아에 속재료를 담고 말아줌. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0307', 0, '메밀면을 포장 조리법대로 삶고 찬물로 헹군 뒤 물기를 뺌.'),
    ('L0307', 1, '새우를 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('L0307', 2, '양배추와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0307', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('L0307', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0317', 0, '메밀면을 포장 조리법대로 삶고 찬물로 헹군 뒤 물기를 뺌.'),
    ('L0317', 1, '새우를 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('L0317', 2, '브로콜리와 양파를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0317', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('L0317', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0327', 0, '메밀면을 포장 조리법대로 삶고 찬물로 헹군 뒤 물기를 뺌.'),
    ('L0327', 1, '새우를 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('L0327', 2, '애호박과 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0327', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('L0327', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0337', 0, '메밀면을 포장 조리법대로 삶고 찬물로 헹군 뒤 물기를 뺌.'),
    ('L0337', 1, '새우를 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('L0337', 2, '시금치와 느타리버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0337', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('L0337', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0347', 0, '메밀면을 포장 조리법대로 삶고 찬물로 헹군 뒤 물기를 뺌.'),
    ('L0347', 1, '새우를 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('L0347', 2, '청경채와 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0347', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('L0347', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0357', 0, '메밀면을 포장 조리법대로 삶고 찬물로 헹군 뒤 물기를 뺌.'),
    ('L0357', 1, '새우를 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('L0357', 2, '가지와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0357', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('L0357', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0367', 0, '메밀면을 포장 조리법대로 삶고 찬물로 헹군 뒤 물기를 뺌.'),
    ('L0367', 1, '새우를 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('L0367', 2, '양배추와 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0367', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('L0367', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0377', 0, '메밀면을 포장 조리법대로 삶고 찬물로 헹군 뒤 물기를 뺌.'),
    ('L0377', 1, '새우를 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('L0377', 2, '브로콜리와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0377', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('L0377', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0387', 0, '메밀면을 포장 조리법대로 삶고 찬물로 헹군 뒤 물기를 뺌.'),
    ('L0387', 1, '새우를 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('L0387', 2, '애호박과 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0387', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('L0387', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0397', 0, '메밀면을 포장 조리법대로 삶고 찬물로 헹군 뒤 물기를 뺌.'),
    ('L0397', 1, '새우를 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('L0397', 2, '시금치와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0397', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('L0397', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0407', 0, '감자를 한입 크기로 썰고 속까지 부드러워질 때까지 찜.'),
    ('L0407', 1, '참치 통조림의 물기를 빼고 먹기 좋은 크기로 풂.'),
    ('L0407', 2, '양배추와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0407', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('L0407', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0417', 0, '감자를 한입 크기로 썰고 속까지 부드러워질 때까지 찜.'),
    ('L0417', 1, '참치 통조림의 물기를 빼고 먹기 좋은 크기로 풂.'),
    ('L0417', 2, '브로콜리와 양파를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0417', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('L0417', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0427', 0, '감자를 한입 크기로 썰고 속까지 부드러워질 때까지 찜.'),
    ('L0427', 1, '참치 통조림의 물기를 빼고 먹기 좋은 크기로 풂.'),
    ('L0427', 2, '애호박과 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0427', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('L0427', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0437', 0, '감자를 한입 크기로 썰고 속까지 부드러워질 때까지 찜.'),
    ('L0437', 1, '참치 통조림의 물기를 빼고 먹기 좋은 크기로 풂.'),
    ('L0437', 2, '시금치와 느타리버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0437', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('L0437', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0447', 0, '감자를 한입 크기로 썰고 속까지 부드러워질 때까지 찜.'),
    ('L0447', 1, '참치 통조림의 물기를 빼고 먹기 좋은 크기로 풂.'),
    ('L0447', 2, '청경채와 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0447', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('L0447', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0457', 0, '감자를 한입 크기로 썰고 속까지 부드러워질 때까지 찜.'),
    ('L0457', 1, '참치 통조림의 물기를 빼고 먹기 좋은 크기로 풂.'),
    ('L0457', 2, '가지와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0457', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('L0457', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0467', 0, '감자를 한입 크기로 썰고 속까지 부드러워질 때까지 찜.'),
    ('L0467', 1, '참치 통조림의 물기를 빼고 먹기 좋은 크기로 풂.'),
    ('L0467', 2, '양배추와 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0467', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('L0467', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0477', 0, '감자를 한입 크기로 썰고 속까지 부드러워질 때까지 찜.'),
    ('L0477', 1, '참치 통조림의 물기를 빼고 먹기 좋은 크기로 풂.'),
    ('L0477', 2, '브로콜리와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0477', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('L0477', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0487', 0, '감자를 한입 크기로 썰고 속까지 부드러워질 때까지 찜.'),
    ('L0487', 1, '참치 통조림의 물기를 빼고 먹기 좋은 크기로 풂.'),
    ('L0487', 2, '애호박과 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0487', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('L0487', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0497', 0, '감자를 한입 크기로 썰고 속까지 부드러워질 때까지 찜.'),
    ('L0497', 1, '참치 통조림의 물기를 빼고 먹기 좋은 크기로 풂.'),
    ('L0497', 2, '시금치와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0497', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('L0497', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0507', 0, '익힌 퀴노아를 데움.'),
    ('L0507', 1, '연어를 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('L0507', 2, '양배추와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0507', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('L0507', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0517', 0, '익힌 퀴노아를 데움.'),
    ('L0517', 1, '연어를 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('L0517', 2, '브로콜리와 양파를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0517', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('L0517', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0527', 0, '익힌 퀴노아를 데움.'),
    ('L0527', 1, '연어를 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('L0527', 2, '애호박과 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0527', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('L0527', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0537', 0, '익힌 퀴노아를 데움.'),
    ('L0537', 1, '연어를 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('L0537', 2, '시금치와 느타리버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0537', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('L0537', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0547', 0, '익힌 퀴노아를 데움.'),
    ('L0547', 1, '연어를 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('L0547', 2, '청경채와 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0547', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('L0547', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0557', 0, '익힌 퀴노아를 데움.'),
    ('L0557', 1, '연어를 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('L0557', 2, '가지와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0557', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('L0557', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0567', 0, '익힌 퀴노아를 데움.'),
    ('L0567', 1, '연어를 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('L0567', 2, '양배추와 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0567', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('L0567', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0577', 0, '익힌 퀴노아를 데움.'),
    ('L0577', 1, '연어를 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('L0577', 2, '브로콜리와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0577', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('L0577', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0587', 0, '익힌 퀴노아를 데움.'),
    ('L0587', 1, '연어를 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('L0587', 2, '애호박과 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0587', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('L0587', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0597', 0, '익힌 퀴노아를 데움.'),
    ('L0597', 1, '연어를 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('L0597', 2, '시금치와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0597', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('L0597', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0607', 0, '익힌 보리밥을 데움.'),
    ('L0607', 1, '소고기 우둔살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('L0607', 2, '양배추와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0607', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('L0607', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0617', 0, '익힌 보리밥을 데움.'),
    ('L0617', 1, '소고기 우둔살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('L0617', 2, '브로콜리와 양파를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0617', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('L0617', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0627', 0, '익힌 보리밥을 데움.'),
    ('L0627', 1, '소고기 우둔살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('L0627', 2, '애호박과 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0627', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('L0627', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0637', 0, '익힌 보리밥을 데움.'),
    ('L0637', 1, '소고기 우둔살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('L0637', 2, '시금치와 느타리버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0637', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('L0637', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0647', 0, '익힌 보리밥을 데움.'),
    ('L0647', 1, '소고기 우둔살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('L0647', 2, '청경채와 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0647', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('L0647', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0657', 0, '익힌 보리밥을 데움.'),
    ('L0657', 1, '소고기 우둔살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('L0657', 2, '가지와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0657', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('L0657', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0667', 0, '익힌 보리밥을 데움.'),
    ('L0667', 1, '소고기 우둔살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('L0667', 2, '양배추와 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0667', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('L0667', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0677', 0, '익힌 보리밥을 데움.'),
    ('L0677', 1, '소고기 우둔살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('L0677', 2, '브로콜리와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0677', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('L0677', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0687', 0, '익힌 보리밥을 데움.'),
    ('L0687', 1, '소고기 우둔살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('L0687', 2, '애호박과 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0687', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('L0687', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0697', 0, '익힌 보리밥을 데움.'),
    ('L0697', 1, '소고기 우둔살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('L0697', 2, '시금치와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0697', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('L0697', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0707', 0, '익힌 현미밥을 데움.'),
    ('L0707', 1, '삶은 렌틸콩의 물기를 빼고 데움.'),
    ('L0707', 2, '양배추와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0707', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('L0707', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0717', 0, '익힌 현미밥을 데움.'),
    ('L0717', 1, '삶은 렌틸콩의 물기를 빼고 데움.'),
    ('L0717', 2, '브로콜리와 양파를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0717', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('L0717', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0727', 0, '익힌 현미밥을 데움.'),
    ('L0727', 1, '삶은 렌틸콩의 물기를 빼고 데움.'),
    ('L0727', 2, '애호박과 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0727', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('L0727', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0737', 0, '익힌 현미밥을 데움.'),
    ('L0737', 1, '삶은 렌틸콩의 물기를 빼고 데움.'),
    ('L0737', 2, '시금치와 느타리버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0737', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('L0737', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0747', 0, '익힌 현미밥을 데움.'),
    ('L0747', 1, '삶은 렌틸콩의 물기를 빼고 데움.'),
    ('L0747', 2, '청경채와 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0747', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('L0747', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0757', 0, '익힌 현미밥을 데움.'),
    ('L0757', 1, '삶은 렌틸콩의 물기를 빼고 데움.'),
    ('L0757', 2, '가지와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0757', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('L0757', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0767', 0, '익힌 현미밥을 데움.'),
    ('L0767', 1, '삶은 렌틸콩의 물기를 빼고 데움.'),
    ('L0767', 2, '양배추와 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0767', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('L0767', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0777', 0, '익힌 현미밥을 데움.'),
    ('L0777', 1, '삶은 렌틸콩의 물기를 빼고 데움.'),
    ('L0777', 2, '브로콜리와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0777', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('L0777', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0787', 0, '익힌 현미밥을 데움.'),
    ('L0787', 1, '삶은 렌틸콩의 물기를 빼고 데움.'),
    ('L0787', 2, '애호박과 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0787', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('L0787', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0797', 0, '익힌 현미밥을 데움.'),
    ('L0797', 1, '삶은 렌틸콩의 물기를 빼고 데움.'),
    ('L0797', 2, '시금치와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0797', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('L0797', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0807', 0, '익힌 잡곡밥을 데움.'),
    ('L0807', 1, '삶은 병아리콩의 물기를 빼고 데움.'),
    ('L0807', 2, '양배추와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0807', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('L0807', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0817', 0, '익힌 잡곡밥을 데움.'),
    ('L0817', 1, '삶은 병아리콩의 물기를 빼고 데움.'),
    ('L0817', 2, '브로콜리와 양파를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0817', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('L0817', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0827', 0, '익힌 잡곡밥을 데움.'),
    ('L0827', 1, '삶은 병아리콩의 물기를 빼고 데움.'),
    ('L0827', 2, '애호박과 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0827', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('L0827', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0837', 0, '익힌 잡곡밥을 데움.'),
    ('L0837', 1, '삶은 병아리콩의 물기를 빼고 데움.'),
    ('L0837', 2, '시금치와 느타리버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0837', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('L0837', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0847', 0, '익힌 잡곡밥을 데움.'),
    ('L0847', 1, '삶은 병아리콩의 물기를 빼고 데움.'),
    ('L0847', 2, '청경채와 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0847', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('L0847', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0857', 0, '익힌 잡곡밥을 데움.'),
    ('L0857', 1, '삶은 병아리콩의 물기를 빼고 데움.'),
    ('L0857', 2, '가지와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0857', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('L0857', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0867', 0, '익힌 잡곡밥을 데움.'),
    ('L0867', 1, '삶은 병아리콩의 물기를 빼고 데움.'),
    ('L0867', 2, '양배추와 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0867', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('L0867', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0877', 0, '익힌 잡곡밥을 데움.'),
    ('L0877', 1, '삶은 병아리콩의 물기를 빼고 데움.'),
    ('L0877', 2, '브로콜리와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0877', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('L0877', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0887', 0, '익힌 잡곡밥을 데움.'),
    ('L0887', 1, '삶은 병아리콩의 물기를 빼고 데움.'),
    ('L0887', 2, '애호박과 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0887', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('L0887', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0897', 0, '익힌 잡곡밥을 데움.'),
    ('L0897', 1, '삶은 병아리콩의 물기를 빼고 데움.'),
    ('L0897', 2, '시금치와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0897', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('L0897', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0902', 0, '통밀 식빵을 토스터나 마른 팬에 구움.'),
    ('L0902', 1, '닭가슴살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('L0902', 2, '양배추와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0902', 3, '후추 1 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('L0902', 4, '식빵 위에 익힌 재료를 올림. 양념을 곁들임.'),
    ('L0904', 0, '통밀 식빵을 토스터나 마른 팬에 구움.'),
    ('L0904', 1, '닭가슴살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('L0904', 2, '양배추와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0904', 3, '다진 마늘 3 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('L0904', 4, '식빵 위에 익힌 재료를 올림. 양념을 곁들임.'),
    ('L0907', 0, '통밀 식빵을 토스터나 마른 팬에 구움.'),
    ('L0907', 1, '닭가슴살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('L0907', 2, '양배추와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0907', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('L0907', 4, '식빵 위에 익힌 재료를 올림. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0912', 0, '통밀 식빵을 토스터나 마른 팬에 구움.'),
    ('L0912', 1, '닭가슴살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('L0912', 2, '브로콜리와 양파를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0912', 3, '후추 1 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('L0912', 4, '식빵 위에 익힌 재료를 올림. 양념을 곁들임.'),
    ('L0914', 0, '통밀 식빵을 토스터나 마른 팬에 구움.'),
    ('L0914', 1, '닭가슴살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('L0914', 2, '브로콜리와 양파를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0914', 3, '다진 마늘 3 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('L0914', 4, '식빵 위에 익힌 재료를 올림. 양념을 곁들임.'),
    ('L0917', 0, '통밀 식빵을 토스터나 마른 팬에 구움.'),
    ('L0917', 1, '닭가슴살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('L0917', 2, '브로콜리와 양파를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0917', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('L0917', 4, '식빵 위에 익힌 재료를 올림. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0922', 0, '통밀 식빵을 토스터나 마른 팬에 구움.'),
    ('L0922', 1, '닭가슴살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('L0922', 2, '애호박과 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0922', 3, '후추 1 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('L0922', 4, '식빵 위에 익힌 재료를 올림. 양념을 곁들임.'),
    ('L0924', 0, '통밀 식빵을 토스터나 마른 팬에 구움.'),
    ('L0924', 1, '닭가슴살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('L0924', 2, '애호박과 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0924', 3, '다진 마늘 3 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('L0924', 4, '식빵 위에 익힌 재료를 올림. 양념을 곁들임.'),
    ('L0927', 0, '통밀 식빵을 토스터나 마른 팬에 구움.'),
    ('L0927', 1, '닭가슴살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('L0927', 2, '애호박과 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0927', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('L0927', 4, '식빵 위에 익힌 재료를 올림. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0932', 0, '통밀 식빵을 토스터나 마른 팬에 구움.'),
    ('L0932', 1, '닭가슴살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('L0932', 2, '시금치와 느타리버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0932', 3, '후추 1 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('L0932', 4, '식빵 위에 익힌 재료를 올림. 양념을 곁들임.'),
    ('L0934', 0, '통밀 식빵을 토스터나 마른 팬에 구움.'),
    ('L0934', 1, '닭가슴살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('L0934', 2, '시금치와 느타리버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0934', 3, '다진 마늘 3 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('L0934', 4, '식빵 위에 익힌 재료를 올림. 양념을 곁들임.'),
    ('L0937', 0, '통밀 식빵을 토스터나 마른 팬에 구움.'),
    ('L0937', 1, '닭가슴살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('L0937', 2, '시금치와 느타리버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0937', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('L0937', 4, '식빵 위에 익힌 재료를 올림. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0942', 0, '통밀 식빵을 토스터나 마른 팬에 구움.'),
    ('L0942', 1, '닭가슴살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('L0942', 2, '청경채와 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0942', 3, '후추 1 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('L0942', 4, '식빵 위에 익힌 재료를 올림. 양념을 곁들임.'),
    ('L0944', 0, '통밀 식빵을 토스터나 마른 팬에 구움.'),
    ('L0944', 1, '닭가슴살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('L0944', 2, '청경채와 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0944', 3, '다진 마늘 3 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('L0944', 4, '식빵 위에 익힌 재료를 올림. 양념을 곁들임.'),
    ('L0947', 0, '통밀 식빵을 토스터나 마른 팬에 구움.'),
    ('L0947', 1, '닭가슴살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('L0947', 2, '청경채와 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0947', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('L0947', 4, '식빵 위에 익힌 재료를 올림. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0952', 0, '통밀 식빵을 토스터나 마른 팬에 구움.'),
    ('L0952', 1, '닭가슴살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('L0952', 2, '가지와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0952', 3, '후추 1 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('L0952', 4, '식빵 위에 익힌 재료를 올림. 양념을 곁들임.'),
    ('L0954', 0, '통밀 식빵을 토스터나 마른 팬에 구움.'),
    ('L0954', 1, '닭가슴살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('L0954', 2, '가지와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0954', 3, '다진 마늘 3 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('L0954', 4, '식빵 위에 익힌 재료를 올림. 양념을 곁들임.'),
    ('L0957', 0, '통밀 식빵을 토스터나 마른 팬에 구움.'),
    ('L0957', 1, '닭가슴살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('L0957', 2, '가지와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0957', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('L0957', 4, '식빵 위에 익힌 재료를 올림. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0962', 0, '통밀 식빵을 토스터나 마른 팬에 구움.'),
    ('L0962', 1, '닭가슴살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('L0962', 2, '양배추와 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0962', 3, '후추 1 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('L0962', 4, '식빵 위에 익힌 재료를 올림. 양념을 곁들임.'),
    ('L0964', 0, '통밀 식빵을 토스터나 마른 팬에 구움.'),
    ('L0964', 1, '닭가슴살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('L0964', 2, '양배추와 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0964', 3, '다진 마늘 3 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('L0964', 4, '식빵 위에 익힌 재료를 올림. 양념을 곁들임.'),
    ('L0967', 0, '통밀 식빵을 토스터나 마른 팬에 구움.'),
    ('L0967', 1, '닭가슴살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('L0967', 2, '양배추와 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0967', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('L0967', 4, '식빵 위에 익힌 재료를 올림. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0972', 0, '통밀 식빵을 토스터나 마른 팬에 구움.'),
    ('L0972', 1, '닭가슴살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('L0972', 2, '브로콜리와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0972', 3, '후추 1 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('L0972', 4, '식빵 위에 익힌 재료를 올림. 양념을 곁들임.'),
    ('L0974', 0, '통밀 식빵을 토스터나 마른 팬에 구움.'),
    ('L0974', 1, '닭가슴살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('L0974', 2, '브로콜리와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0974', 3, '다진 마늘 3 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('L0974', 4, '식빵 위에 익힌 재료를 올림. 양념을 곁들임.'),
    ('L0977', 0, '통밀 식빵을 토스터나 마른 팬에 구움.'),
    ('L0977', 1, '닭가슴살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('L0977', 2, '브로콜리와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0977', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('L0977', 4, '식빵 위에 익힌 재료를 올림. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0982', 0, '통밀 식빵을 토스터나 마른 팬에 구움.'),
    ('L0982', 1, '닭가슴살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('L0982', 2, '애호박과 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0982', 3, '후추 1 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('L0982', 4, '식빵 위에 익힌 재료를 올림. 양념을 곁들임.'),
    ('L0984', 0, '통밀 식빵을 토스터나 마른 팬에 구움.'),
    ('L0984', 1, '닭가슴살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('L0984', 2, '애호박과 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0984', 3, '다진 마늘 3 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('L0984', 4, '식빵 위에 익힌 재료를 올림. 양념을 곁들임.'),
    ('L0987', 0, '통밀 식빵을 토스터나 마른 팬에 구움.'),
    ('L0987', 1, '닭가슴살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('L0987', 2, '애호박과 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0987', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('L0987', 4, '식빵 위에 익힌 재료를 올림. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('L0992', 0, '통밀 식빵을 토스터나 마른 팬에 구움.'),
    ('L0992', 1, '닭가슴살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('L0992', 2, '시금치와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0992', 3, '후추 1 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('L0992', 4, '식빵 위에 익힌 재료를 올림. 양념을 곁들임.'),
    ('L0994', 0, '통밀 식빵을 토스터나 마른 팬에 구움.'),
    ('L0994', 1, '닭가슴살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('L0994', 2, '시금치와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0994', 3, '다진 마늘 3 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('L0994', 4, '식빵 위에 익힌 재료를 올림. 양념을 곁들임.'),
    ('L0997', 0, '통밀 식빵을 토스터나 마른 팬에 구움.'),
    ('L0997', 1, '닭가슴살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('L0997', 2, '시금치와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('L0997', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('L0997', 4, '식빵 위에 익힌 재료를 올림. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0007', 0, '고구마를 작게 썰고 속까지 부드러워질 때까지 찜.'),
    ('D0007', 1, '연어를 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('D0007', 2, '양배추와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0007', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('D0007', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0017', 0, '고구마를 작게 썰고 속까지 부드러워질 때까지 찜.'),
    ('D0017', 1, '연어를 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('D0017', 2, '브로콜리와 양파를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0017', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('D0017', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0027', 0, '고구마를 작게 썰고 속까지 부드러워질 때까지 찜.'),
    ('D0027', 1, '연어를 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('D0027', 2, '애호박과 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0027', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('D0027', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0037', 0, '고구마를 작게 썰고 속까지 부드러워질 때까지 찜.'),
    ('D0037', 1, '연어를 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('D0037', 2, '시금치와 느타리버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0037', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('D0037', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0047', 0, '고구마를 작게 썰고 속까지 부드러워질 때까지 찜.'),
    ('D0047', 1, '연어를 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('D0047', 2, '청경채와 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0047', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('D0047', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0057', 0, '고구마를 작게 썰고 속까지 부드러워질 때까지 찜.'),
    ('D0057', 1, '연어를 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('D0057', 2, '가지와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0057', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('D0057', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0067', 0, '고구마를 작게 썰고 속까지 부드러워질 때까지 찜.'),
    ('D0067', 1, '연어를 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('D0067', 2, '양배추와 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0067', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('D0067', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0077', 0, '고구마를 작게 썰고 속까지 부드러워질 때까지 찜.'),
    ('D0077', 1, '연어를 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('D0077', 2, '브로콜리와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0077', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('D0077', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0087', 0, '고구마를 작게 썰고 속까지 부드러워질 때까지 찜.'),
    ('D0087', 1, '연어를 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('D0087', 2, '애호박과 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0087', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('D0087', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0097', 0, '고구마를 작게 썰고 속까지 부드러워질 때까지 찜.'),
    ('D0097', 1, '연어를 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('D0097', 2, '시금치와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0097', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('D0097', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0107', 0, '익힌 잡곡밥을 데움.'),
    ('D0107', 1, '고등어를 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('D0107', 2, '양배추와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0107', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('D0107', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0117', 0, '익힌 잡곡밥을 데움.'),
    ('D0117', 1, '고등어를 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('D0117', 2, '브로콜리와 양파를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0117', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('D0117', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0127', 0, '익힌 잡곡밥을 데움.'),
    ('D0127', 1, '고등어를 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('D0127', 2, '애호박과 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0127', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('D0127', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0137', 0, '익힌 잡곡밥을 데움.'),
    ('D0137', 1, '고등어를 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('D0137', 2, '시금치와 느타리버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0137', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('D0137', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0147', 0, '익힌 잡곡밥을 데움.'),
    ('D0147', 1, '고등어를 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('D0147', 2, '청경채와 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0147', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('D0147', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0157', 0, '익힌 잡곡밥을 데움.'),
    ('D0157', 1, '고등어를 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('D0157', 2, '가지와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0157', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('D0157', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0167', 0, '익힌 잡곡밥을 데움.'),
    ('D0167', 1, '고등어를 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('D0167', 2, '양배추와 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0167', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('D0167', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0177', 0, '익힌 잡곡밥을 데움.'),
    ('D0177', 1, '고등어를 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('D0177', 2, '브로콜리와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0177', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('D0177', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0187', 0, '익힌 잡곡밥을 데움.'),
    ('D0187', 1, '고등어를 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('D0187', 2, '애호박과 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0187', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('D0187', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0197', 0, '익힌 잡곡밥을 데움.'),
    ('D0197', 1, '고등어를 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('D0197', 2, '시금치와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0197', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('D0197', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0207', 0, '익힌 현미밥을 데움.'),
    ('D0207', 1, '대구를 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('D0207', 2, '양배추와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0207', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('D0207', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0217', 0, '익힌 현미밥을 데움.'),
    ('D0217', 1, '대구를 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('D0217', 2, '브로콜리와 양파를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0217', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('D0217', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0227', 0, '익힌 현미밥을 데움.'),
    ('D0227', 1, '대구를 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('D0227', 2, '애호박과 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0227', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('D0227', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0237', 0, '익힌 현미밥을 데움.'),
    ('D0237', 1, '대구를 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('D0237', 2, '시금치와 느타리버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0237', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('D0237', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0247', 0, '익힌 현미밥을 데움.'),
    ('D0247', 1, '대구를 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('D0247', 2, '청경채와 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0247', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('D0247', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0257', 0, '익힌 현미밥을 데움.'),
    ('D0257', 1, '대구를 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('D0257', 2, '가지와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0257', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('D0257', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0267', 0, '익힌 현미밥을 데움.'),
    ('D0267', 1, '대구를 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('D0267', 2, '양배추와 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0267', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('D0267', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0277', 0, '익힌 현미밥을 데움.'),
    ('D0277', 1, '대구를 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('D0277', 2, '브로콜리와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0277', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('D0277', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0287', 0, '익힌 현미밥을 데움.'),
    ('D0287', 1, '대구를 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('D0287', 2, '애호박과 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0287', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('D0287', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0297', 0, '익힌 현미밥을 데움.'),
    ('D0297', 1, '대구를 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('D0297', 2, '시금치와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0297', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('D0297', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0307', 0, '감자를 한입 크기로 썰고 속까지 부드러워질 때까지 찜.'),
    ('D0307', 1, '돼지 안심을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('D0307', 2, '양배추와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0307', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('D0307', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0317', 0, '감자를 한입 크기로 썰고 속까지 부드러워질 때까지 찜.'),
    ('D0317', 1, '돼지 안심을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('D0317', 2, '브로콜리와 양파를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0317', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('D0317', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0327', 0, '감자를 한입 크기로 썰고 속까지 부드러워질 때까지 찜.'),
    ('D0327', 1, '돼지 안심을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('D0327', 2, '애호박과 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0327', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('D0327', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0337', 0, '감자를 한입 크기로 썰고 속까지 부드러워질 때까지 찜.'),
    ('D0337', 1, '돼지 안심을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('D0337', 2, '시금치와 느타리버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0337', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('D0337', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0347', 0, '감자를 한입 크기로 썰고 속까지 부드러워질 때까지 찜.'),
    ('D0347', 1, '돼지 안심을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('D0347', 2, '청경채와 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0347', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('D0347', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0357', 0, '감자를 한입 크기로 썰고 속까지 부드러워질 때까지 찜.'),
    ('D0357', 1, '돼지 안심을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('D0357', 2, '가지와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0357', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('D0357', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0367', 0, '감자를 한입 크기로 썰고 속까지 부드러워질 때까지 찜.'),
    ('D0367', 1, '돼지 안심을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('D0367', 2, '양배추와 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0367', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('D0367', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0377', 0, '감자를 한입 크기로 썰고 속까지 부드러워질 때까지 찜.'),
    ('D0377', 1, '돼지 안심을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('D0377', 2, '브로콜리와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0377', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('D0377', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0387', 0, '감자를 한입 크기로 썰고 속까지 부드러워질 때까지 찜.'),
    ('D0387', 1, '돼지 안심을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('D0387', 2, '애호박과 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0387', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('D0387', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0397', 0, '감자를 한입 크기로 썰고 속까지 부드러워질 때까지 찜.'),
    ('D0397', 1, '돼지 안심을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('D0397', 2, '시금치와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0397', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('D0397', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0407', 0, '익힌 퀴노아를 데움.'),
    ('D0407', 1, '소고기 우둔살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('D0407', 2, '양배추와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0407', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('D0407', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0417', 0, '익힌 퀴노아를 데움.'),
    ('D0417', 1, '소고기 우둔살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('D0417', 2, '브로콜리와 양파를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0417', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('D0417', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0427', 0, '익힌 퀴노아를 데움.'),
    ('D0427', 1, '소고기 우둔살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('D0427', 2, '애호박과 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0427', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('D0427', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0437', 0, '익힌 퀴노아를 데움.'),
    ('D0437', 1, '소고기 우둔살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('D0437', 2, '시금치와 느타리버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0437', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('D0437', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0447', 0, '익힌 퀴노아를 데움.'),
    ('D0447', 1, '소고기 우둔살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('D0447', 2, '청경채와 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0447', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('D0447', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0457', 0, '익힌 퀴노아를 데움.'),
    ('D0457', 1, '소고기 우둔살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('D0457', 2, '가지와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0457', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('D0457', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0467', 0, '익힌 퀴노아를 데움.'),
    ('D0467', 1, '소고기 우둔살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('D0467', 2, '양배추와 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0467', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('D0467', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0477', 0, '익힌 퀴노아를 데움.'),
    ('D0477', 1, '소고기 우둔살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('D0477', 2, '브로콜리와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0477', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('D0477', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0487', 0, '익힌 퀴노아를 데움.'),
    ('D0487', 1, '소고기 우둔살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('D0487', 2, '애호박과 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0487', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('D0487', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0497', 0, '익힌 퀴노아를 데움.'),
    ('D0497', 1, '소고기 우둔살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('D0497', 2, '시금치와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0497', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('D0497', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0507', 0, '익힌 보리밥을 데움.'),
    ('D0507', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('D0507', 2, '양배추와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0507', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('D0507', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0517', 0, '익힌 보리밥을 데움.'),
    ('D0517', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('D0517', 2, '브로콜리와 양파를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0517', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('D0517', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0527', 0, '익힌 보리밥을 데움.'),
    ('D0527', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('D0527', 2, '애호박과 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0527', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('D0527', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0537', 0, '익힌 보리밥을 데움.'),
    ('D0537', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('D0537', 2, '시금치와 느타리버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0537', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('D0537', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0547', 0, '익힌 보리밥을 데움.'),
    ('D0547', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('D0547', 2, '청경채와 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0547', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('D0547', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0557', 0, '익힌 보리밥을 데움.'),
    ('D0557', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('D0557', 2, '가지와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0557', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('D0557', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0567', 0, '익힌 보리밥을 데움.'),
    ('D0567', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('D0567', 2, '양배추와 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0567', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('D0567', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0577', 0, '익힌 보리밥을 데움.'),
    ('D0577', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('D0577', 2, '브로콜리와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0577', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('D0577', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0587', 0, '익힌 보리밥을 데움.'),
    ('D0587', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('D0587', 2, '애호박과 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0587', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('D0587', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0597', 0, '익힌 보리밥을 데움.'),
    ('D0597', 1, '두부 물기를 빼고 썬 뒤 조리용 올리브유를 두른 팬에서 구움.'),
    ('D0597', 2, '시금치와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0597', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('D0597', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0607', 0, '메밀면을 포장 조리법대로 삶고 찬물로 헹군 뒤 물기를 뺌.'),
    ('D0607', 1, '닭가슴살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('D0607', 2, '양배추와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0607', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('D0607', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0617', 0, '메밀면을 포장 조리법대로 삶고 찬물로 헹군 뒤 물기를 뺌.'),
    ('D0617', 1, '닭가슴살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('D0617', 2, '브로콜리와 양파를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0617', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('D0617', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0627', 0, '메밀면을 포장 조리법대로 삶고 찬물로 헹군 뒤 물기를 뺌.'),
    ('D0627', 1, '닭가슴살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('D0627', 2, '애호박과 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0627', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('D0627', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0637', 0, '메밀면을 포장 조리법대로 삶고 찬물로 헹군 뒤 물기를 뺌.'),
    ('D0637', 1, '닭가슴살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('D0637', 2, '시금치와 느타리버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0637', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('D0637', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0647', 0, '메밀면을 포장 조리법대로 삶고 찬물로 헹군 뒤 물기를 뺌.'),
    ('D0647', 1, '닭가슴살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('D0647', 2, '청경채와 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0647', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('D0647', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0657', 0, '메밀면을 포장 조리법대로 삶고 찬물로 헹군 뒤 물기를 뺌.'),
    ('D0657', 1, '닭가슴살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('D0657', 2, '가지와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0657', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('D0657', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0667', 0, '메밀면을 포장 조리법대로 삶고 찬물로 헹군 뒤 물기를 뺌.'),
    ('D0667', 1, '닭가슴살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('D0667', 2, '양배추와 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0667', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('D0667', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0677', 0, '메밀면을 포장 조리법대로 삶고 찬물로 헹군 뒤 물기를 뺌.'),
    ('D0677', 1, '닭가슴살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('D0677', 2, '브로콜리와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0677', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('D0677', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0687', 0, '메밀면을 포장 조리법대로 삶고 찬물로 헹군 뒤 물기를 뺌.'),
    ('D0687', 1, '닭가슴살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('D0687', 2, '애호박과 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0687', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('D0687', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0697', 0, '메밀면을 포장 조리법대로 삶고 찬물로 헹군 뒤 물기를 뺌.'),
    ('D0697', 1, '닭가슴살을 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('D0697', 2, '시금치와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0697', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('D0697', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0707', 0, '익힌 잡곡밥을 데움.'),
    ('D0707', 1, '새우를 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('D0707', 2, '양배추와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0707', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('D0707', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0717', 0, '익힌 잡곡밥을 데움.'),
    ('D0717', 1, '새우를 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('D0717', 2, '브로콜리와 양파를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0717', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('D0717', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0727', 0, '익힌 잡곡밥을 데움.'),
    ('D0727', 1, '새우를 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('D0727', 2, '애호박과 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0727', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('D0727', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0737', 0, '익힌 잡곡밥을 데움.'),
    ('D0737', 1, '새우를 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('D0737', 2, '시금치와 느타리버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0737', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('D0737', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0747', 0, '익힌 잡곡밥을 데움.'),
    ('D0747', 1, '새우를 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('D0747', 2, '청경채와 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0747', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('D0747', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0757', 0, '익힌 잡곡밥을 데움.'),
    ('D0757', 1, '새우를 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('D0757', 2, '가지와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0757', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('D0757', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0767', 0, '익힌 잡곡밥을 데움.'),
    ('D0767', 1, '새우를 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('D0767', 2, '양배추와 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0767', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('D0767', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0777', 0, '익힌 잡곡밥을 데움.'),
    ('D0777', 1, '새우를 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('D0777', 2, '브로콜리와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0777', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('D0777', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0787', 0, '익힌 잡곡밥을 데움.'),
    ('D0787', 1, '새우를 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('D0787', 2, '애호박과 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0787', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('D0787', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0797', 0, '익힌 잡곡밥을 데움.'),
    ('D0797', 1, '새우를 한입 크기로 잘라 조리용 올리브유를 두른 팬에서 속까지 완전히 익힘.'),
    ('D0797', 2, '시금치와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0797', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('D0797', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0807', 0, '익힌 현미밥을 데움.'),
    ('D0807', 1, '삶은 병아리콩의 물기를 빼고 데움.'),
    ('D0807', 2, '양배추와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0807', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('D0807', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0817', 0, '익힌 현미밥을 데움.'),
    ('D0817', 1, '삶은 병아리콩의 물기를 빼고 데움.'),
    ('D0817', 2, '브로콜리와 양파를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0817', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('D0817', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0827', 0, '익힌 현미밥을 데움.'),
    ('D0827', 1, '삶은 병아리콩의 물기를 빼고 데움.'),
    ('D0827', 2, '애호박과 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0827', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('D0827', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0837', 0, '익힌 현미밥을 데움.'),
    ('D0837', 1, '삶은 병아리콩의 물기를 빼고 데움.'),
    ('D0837', 2, '시금치와 느타리버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0837', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('D0837', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0847', 0, '익힌 현미밥을 데움.'),
    ('D0847', 1, '삶은 병아리콩의 물기를 빼고 데움.'),
    ('D0847', 2, '청경채와 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0847', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('D0847', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0857', 0, '익힌 현미밥을 데움.'),
    ('D0857', 1, '삶은 병아리콩의 물기를 빼고 데움.'),
    ('D0857', 2, '가지와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0857', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('D0857', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0867', 0, '익힌 현미밥을 데움.'),
    ('D0867', 1, '삶은 병아리콩의 물기를 빼고 데움.'),
    ('D0867', 2, '양배추와 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0867', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('D0867', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0877', 0, '익힌 현미밥을 데움.'),
    ('D0877', 1, '삶은 병아리콩의 물기를 빼고 데움.'),
    ('D0877', 2, '브로콜리와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0877', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('D0877', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0887', 0, '익힌 현미밥을 데움.'),
    ('D0887', 1, '삶은 병아리콩의 물기를 빼고 데움.'),
    ('D0887', 2, '애호박과 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0887', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('D0887', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0897', 0, '익힌 현미밥을 데움.'),
    ('D0897', 1, '삶은 병아리콩의 물기를 빼고 데움.'),
    ('D0897', 2, '시금치와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0897', 3, '들기름 4 g, 간장 5 g을 섞어 양념을 만듦.'),
    ('D0897', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0907', 0, '고구마를 작게 썰고 속까지 부드러워질 때까지 찜.'),
    ('D0907', 1, '삶은 렌틸콩의 물기를 빼고 데움.'),
    ('D0907', 2, '양배추와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0907', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('D0907', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0917', 0, '고구마를 작게 썰고 속까지 부드러워질 때까지 찜.'),
    ('D0917', 1, '삶은 렌틸콩의 물기를 빼고 데움.'),
    ('D0917', 2, '브로콜리와 양파를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0917', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('D0917', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0927', 0, '고구마를 작게 썰고 속까지 부드러워질 때까지 찜.'),
    ('D0927', 1, '삶은 렌틸콩의 물기를 빼고 데움.'),
    ('D0927', 2, '애호박과 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0927', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('D0927', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0937', 0, '고구마를 작게 썰고 속까지 부드러워질 때까지 찜.'),
    ('D0937', 1, '삶은 렌틸콩의 물기를 빼고 데움.'),
    ('D0937', 2, '시금치와 느타리버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0937', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('D0937', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0947', 0, '고구마를 작게 썰고 속까지 부드러워질 때까지 찜.'),
    ('D0947', 1, '삶은 렌틸콩의 물기를 빼고 데움.'),
    ('D0947', 2, '청경채와 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0947', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('D0947', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0957', 0, '고구마를 작게 썰고 속까지 부드러워질 때까지 찜.'),
    ('D0957', 1, '삶은 렌틸콩의 물기를 빼고 데움.'),
    ('D0957', 2, '가지와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0957', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('D0957', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0967', 0, '고구마를 작게 썰고 속까지 부드러워질 때까지 찜.'),
    ('D0967', 1, '삶은 렌틸콩의 물기를 빼고 데움.'),
    ('D0967', 2, '양배추와 파프리카를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0967', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('D0967', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0977', 0, '고구마를 작게 썰고 속까지 부드러워질 때까지 찜.'),
    ('D0977', 1, '삶은 렌틸콩의 물기를 빼고 데움.'),
    ('D0977', 2, '브로콜리와 당근을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0977', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('D0977', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0987', 0, '고구마를 작게 썰고 속까지 부드러워질 때까지 찜.'),
    ('D0987', 1, '삶은 렌틸콩의 물기를 빼고 데움.'),
    ('D0987', 2, '애호박과 양송이버섯을 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0987', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('D0987', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.'),
    ('D0997', 0, '고구마를 작게 썰고 속까지 부드러워질 때까지 찜.'),
    ('D0997', 1, '삶은 렌틸콩의 물기를 빼고 데움.'),
    ('D0997', 2, '시금치와 토마토를 먹기 좋게 썰고 올리브유 3 g으로 충분히 볶음.'),
    ('D0997', 3, '레몬즙 8 g, 올리브유 4 g을 섞어 양념을 만듦.'),
    ('D0997', 4, '준비한 재료를 한 그릇에 담음. 양념을 곁들임. 깻잎 4 g은 채 썰어 위에 올림.')
) AS v(recipe_code, step_order, description) ON r.recipe_code = v.recipe_code;
