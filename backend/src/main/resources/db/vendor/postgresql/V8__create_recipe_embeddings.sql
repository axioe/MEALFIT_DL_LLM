-- 레시피 검색(LLM-02, SDD 6.6): 레시피 임베딩을 pgvector에 저장한다.
-- 임베딩 모델: bge-m3 (1024차원), AI 서비스에서 직접 실행. 모델을 바꾸면 model_version 기준으로 전체 재임베딩한다.
--
-- PostgreSQL 전용 경로(db/vendor/postgresql)에 둔다. 테스트용 H2에는 vector 타입이 없어 이 파일을 실행하지 않는다.
-- 확장 설치 권한: RDS에서는 관리(마스터) 계정으로 먼저 CREATE EXTENSION vector; 를 실행해 둔다.
-- 이미 설치돼 있으면 아래 IF NOT EXISTS는 권한 없이 건너뛴다. 로컬·CI 컨테이너(pgvector/pgvector)는 그대로 설치된다.
CREATE EXTENSION IF NOT EXISTS vector;

CREATE TABLE recipe_embeddings (
    recipe_id     BIGINT       NOT NULL,
    model_version VARCHAR(40)  NOT NULL, -- 예: bge-m3@<리비전>
    content_hash  CHAR(64)     NOT NULL, -- 임베딩 텍스트의 SHA-256. 바뀐 레시피만 다시 임베딩한다
    embedding     vector(1024) NOT NULL, -- 정규화된 벡터 (코사인 거리)
    created_at    TIMESTAMP(6) NOT NULL,
    updated_at    TIMESTAMP(6) NOT NULL,
    PRIMARY KEY (recipe_id),
    CONSTRAINT fk_recipe_embeddings_recipe FOREIGN KEY (recipe_id) REFERENCES recipes (id) ON DELETE CASCADE
);

-- 코사인 거리 근사 검색. 기본값(m=16, ef_construction=64)으로 시작한다. 1만 건 이하 규모 (SDD 6.6)
CREATE INDEX idx_recipe_embeddings_hnsw ON recipe_embeddings USING hnsw (embedding vector_cosine_ops);

-- 모델 교체 시 재임베딩 대상 조회용
CREATE INDEX idx_recipe_embeddings_model ON recipe_embeddings (model_version);
