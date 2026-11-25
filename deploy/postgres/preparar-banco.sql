-- Preparação do PostgreSQL da empresa para o Chatwoot.
-- Executar com psql, como superusuário, no servidor PostgreSQL da empresa.
--
-- Requisitos do servidor:
--   - extensão pgvector instalada no servidor (pacote do sistema ou imagem com pgvector);
--   - o protótipo foi validado com PostgreSQL 16.
--
-- Troque a senha abaixo e use o mesmo valor em POSTGRES_PASSWORD no .env.

CREATE ROLE chatwoot LOGIN PASSWORD 'TROCAR-ESTA-SENHA';
CREATE DATABASE chatwoot_production OWNER chatwoot ENCODING 'UTF8';

\c chatwoot_production

-- Extensões exigidas pelo Chatwoot 4.20.1 (db/schema.rb)
CREATE EXTENSION IF NOT EXISTS vector;
CREATE EXTENSION IF NOT EXISTS pg_trgm;
CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE EXTENSION IF NOT EXISTS pg_stat_statements;

-- Depois disso, no servidor do Chatwoot:
--   docker compose run --rm rails bundle exec rails db:chatwoot_prepare
