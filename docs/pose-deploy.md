# 자세 판별 모델 배포 (운영 EC2)

모델 파일은 git과 Docker 이미지에 넣지 않는다. 서버의 `/opt/mealfit/models/pose/<버전>/`에 두고 ai-service 컨테이너에 읽기 전용으로 붙인다. 폴더가 없거나 파일이 다르면 자세 판정 요청만 503(`POSE_003`)이고 나머지 기능은 그대로 동작한다.

| 항목 | 값 |
|---|---|
| 서버 폴더 | `/opt/mealfit/models/pose/<버전>/manifest.json`과 운동별 폴더 |
| 컨테이너 폴더 | `/models/pose` (읽기 전용) |
| 버전 | `.env`의 `POSE_MODEL_VERSION` (기본 `pose-20261123-41`) |
| 원본 보관 | 유지훈 PC. 서버 밖에는 이 한 곳만 둔다 |

AI Hub 데이터로 만든 모델이다. 국외 반출과 원본·가공 데이터 공개가 금지되므로, 모델 폴더를 공개 저장소·해외 저장소·공유 드라이브에 올리지 않는다.

## 1. 파일 준비 (유지훈 PC)

1. `manifest.json`의 운동 항목마다 파일별 SHA-256(`sha256`)을 넣는다. 서버가 파일을 처음 읽을 때 대조한다.
2. 폴더를 한 파일로 묶고 값을 적어 둔다. 압축 안의 최상위 폴더 이름은 버전과 같아야 한다.

```bash
tar czf pose-20261123-41.tar.gz pose-20261123-41
sha256sum pose-20261123-41.tar.gz
```

## 2. 서버에 올리기

각자 등록된 SSH 키로 올린다. 다른 사람의 키를 주고받지 않는다.

```bash
scp pose-20261123-41.tar.gz ubuntu@<서버 IP>:~/
```

서버에서 실행한다.

```bash
sha256sum ~/pose-20261123-41.tar.gz          # 1번 값과 같은지 확인. 다르면 멈춘다
tar tzf ~/pose-20261123-41.tar.gz | head     # 최상위가 pose-20261123-41/ 인지 확인
sudo mkdir -p /opt/mealfit/models/pose
sudo tar xzf ~/pose-20261123-41.tar.gz -C /opt/mealfit/models/pose --no-same-owner
sudo chmod -R a+rX,go-w /opt/mealfit/models/pose
ls /opt/mealfit/models/pose/pose-20261123-41/manifest.json
rm ~/pose-20261123-41.tar.gz
```

## 3. 확인

파일을 넣은 뒤 첫 요청에서 읽으므로 재시작하지 않아도 된다.

```bash
docker exec mealfit-ai python -c "import json,os; d=os.environ['POSE_MODEL_DIR']; m=json.load(open(d+'/manifest.json',encoding='utf-8')); print(len([k for k in m if not k.startswith('_')]), '종')"
```

`41 종`이 나오면 된다. 이어서 화면에서 지원 운동 하나를 판정해 본다.

## 4. 버전 교체·되돌리기

1. 새 버전을 새 폴더로 올린다. 기존 폴더를 덮어쓰지 않는다.
2. 서버 `.env`의 `POSE_MODEL_VERSION`을 바꾸고 다시 만든다.

```bash
cd ~/MEALFIT_DL_LLM && docker compose -f docker-compose.prod.yml up -d --no-build ai-service
```

되돌릴 때는 이전 버전 이름으로 바꾸고 같은 명령을 실행한다. 이미 읽은 모델은 메모리에 남으므로, 같은 버전 폴더의 파일을 바꿨다면 `docker restart mealfit-ai`를 실행한다.

## 남은 것

- Spring 연동과 기능 플래그(`ai.pose.enabled`, 기본 꺼짐): 자세 판별 API·Spring 연동 작업에서 추가
- 브라우저용 MediaPipe 파일(약 30MB)의 정적 제공 경로: 자세 분석 화면 작업에서 정한 뒤 nginx에 추가
