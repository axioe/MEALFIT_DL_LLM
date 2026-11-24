# 운영 배포용 이미지: React 빌드 결과를 nginx로 서빙하고 /api는 backend로 넘긴다
FROM node:24-alpine AS build
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM nginx:1.27-alpine
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY nginx/*.conf /etc/nginx/mealfit/
COPY nginx/30-mealfit-https.sh /docker-entrypoint.d/30-mealfit-https.sh
RUN chmod +x /docker-entrypoint.d/30-mealfit-https.sh
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80 443
