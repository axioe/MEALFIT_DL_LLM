# HTTPS 적용 절차 (운영 EC2)

`HTTPS_DOMAIN`과 인증서가 모두 있으면 frontend 컨테이너가 HTTPS를 켠다. 하나라도 없으면 HTTP(80)로만 서비스하므로, 인증서 없이 배포해도 멈추지 않는다.

## 1. 준비 (사람이 직접)

1. 도메인을 준비하고 DNS A 레코드를 EC2 탄력적 IP로 연결한다.
2. EC2 보안 그룹 인바운드에 TCP 443(0.0.0.0/0)을 연다. 80도 인증서 발급·갱신에 필요하므로 열어 둔다.
3. 이 변경이 main에 배포돼 있어야 한다 (80 포트가 인증용 파일을 내려준다).

## 2. 인증서 발급 (서버에서 한 번)

```bash
sudo snap install --classic certbot
sudo mkdir -p /var/www/certbot
sudo certbot certonly --webroot -w /var/www/certbot -d <도메인>
```

자동 갱신 뒤 nginx가 새 인증서를 읽도록 등록한다.

```bash
echo '#!/bin/sh
docker exec mealfit-frontend nginx -s reload' | sudo tee /etc/letsencrypt/renewal-hooks/deploy/mealfit.sh
sudo chmod +x /etc/letsencrypt/renewal-hooks/deploy/mealfit.sh
sudo certbot renew --dry-run
```

## 3. 켜기

서버 `~/MEALFIT_DL_LLM/.env` (값은 서버에서만 다룬다)

```
HTTPS_DOMAIN=<도메인>
FRONTEND_BASE_URL=https://<도메인>
AUTH_ALLOWED_ORIGINS=https://<도메인>
AUTH_COOKIE_SECURE=true
```

```bash
cd ~/MEALFIT_DL_LLM
docker compose -f docker-compose.prod.yml up -d --no-build
docker logs mealfit-frontend 2>&1 | grep mealfit
```

`HTTPS를 켰습니다`가 보이면 된다. 쿠키 설정이 바뀌므로 사용자는 다시 로그인해야 할 수 있다.

## 4. 소셜 로그인 콜백 등록

| 서비스 | 콜백 주소 |
|---|---|
| Google | `https://<도메인>/login/oauth2/code/google` |
| Naver | `https://<도메인>/login/oauth2/code/naver` |
| Kakao | `https://<도메인>/login/oauth2/code/kakao` |

## 5. 확인

- `http://<도메인>`이 `https://`로 이동한다.
- 이메일 로그인, 새로고침 후 로그인 유지, 소셜 로그인 3개, 재료로 조리 완료, 1MB가 넘는 사진 업로드

## 되돌리기

`.env`에서 `HTTPS_DOMAIN`을 비우고 `FRONTEND_BASE_URL`·`AUTH_ALLOWED_ORIGINS`를 HTTP 주소로, `AUTH_COOKIE_SECURE=false`로 바꾼 뒤 3장의 명령을 다시 실행한다.
