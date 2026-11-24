#!/bin/sh
# 컨테이너가 시작될 때 nginx 공식 이미지가 실행한다.
# HTTPS_DOMAIN과 인증서가 모두 있으면 HTTPS를 켜고, 하나라도 없으면 지금처럼 HTTP(80)로만 서비스한다.
# 인증서가 없어도 컨테이너가 멈추지 않게 하려는 구조다. 절차는 docs/https-setup.md
set -eu

DIR=/etc/nginx/mealfit
CERT_DIR="/etc/letsencrypt/live/${HTTPS_DOMAIN:-}"

http_only() {
    echo "include $DIR/app.conf;" > "$DIR/port80.conf"
    rm -f "$DIR/https.conf"
    echo "[mealfit] HTTP로만 서비스합니다: $1"
}

if [ -z "${HTTPS_DOMAIN:-}" ]; then
    http_only "HTTPS_DOMAIN이 비어 있음"
elif ! echo "$HTTPS_DOMAIN" | grep -Eq '^[a-z0-9]([a-z0-9.-]*[a-z0-9])?$'; then
    http_only "HTTPS_DOMAIN 형식이 올바르지 않음 (소문자 도메인만)"
elif [ ! -s "$CERT_DIR/fullchain.pem" ] || [ ! -s "$CERT_DIR/privkey.pem" ]; then
    http_only "인증서가 없음"
else
    cat > "$DIR/port80.conf" <<EOF
include $DIR/acme.conf;
location / {
    return 301 https://$HTTPS_DOMAIN\$request_uri;
}
EOF
    cat > "$DIR/https.conf" <<EOF
server {
    listen 443 ssl;
    http2 on;
    server_name $HTTPS_DOMAIN;

    ssl_certificate $CERT_DIR/fullchain.pem;
    ssl_certificate_key $CERT_DIR/privkey.pem;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_session_cache shared:SSL:10m;

    access_log /var/log/nginx/access.log mealfit;
    include $DIR/app.conf;
}
EOF
    echo "[mealfit] HTTPS를 켰습니다: $HTTPS_DOMAIN"
fi
