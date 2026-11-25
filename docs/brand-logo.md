# MealFit 로고

- 원본: 사용자가 제공한 초록색 M·새싹 로고(42×32 PNG).
- 서비스 자산: `frontend/public/mealfit-logo.png` — 1254×1254 투명 PNG.
- 적용: 로그인, 회원가입, 사이드바의 `BrandLogo` 공통 컴포넌트와 브라우저 파비콘.
- 기능 안내·상태 표시·AI 추천 메뉴의 아이콘은 각각의 의미를 유지한다.
- 제작: 내장 image_gen으로 원본을 참조해 고해상도로 복원했다. API 키와 새 라이브러리는 사용하지 않았다.

최종 이미지 생성 프롬프트:

```text
Faithful high-resolution restoration of the attached tiny logo. Output one perfectly clean flat 2D green logo on transparent background, 1024x1024 square. Trace the original slanted rounded M, separate round dot above and leaf tip on upper right, preserving original shapes and spacing. Use a single uniform solid mint green #3CCB7C throughout the whole mark. Absolutely NO shading, NO gradient, NO glow, NO outline, NO halo, NO noise, NO speckles, NO texture. Every pixel outside the crisp antialiased silhouette must be fully transparent. Clean professional flat vector-style raster icon. Center the mark at 80% canvas width and height. No text.
```

생성 결과의 실제 크기는 1254×1254이며, 화면에서는 비율을 유지해 축소 표시한다.
