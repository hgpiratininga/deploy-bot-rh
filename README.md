# Chatbot de RH no WhatsApp (Chatwoot + n8n)

Atendimento de candidatos de Recrutamento e Seleção pelo WhatsApp. Um robô de menu (sem IA), feito no n8n, responde primeiro. Quando o candidato pede, a conversa passa para uma pessoa do RH, que atende pelo Chatwoot.

Esta branch (`deploy-empresa`) traz o **modelo de deploy na infraestrutura da empresa**, na pasta `deploy/`. O servidor roda o Chatwoot e o Redis; PostgreSQL e n8n são serviços da empresa. Comece por `deploy/README.md`.

O protótipo local, que roda inteiro num notebook com Docker Desktop e um túnel ngrok, continua na pasta `chatwoot-proto/` (e na branch `main`).

## Estrutura

| Caminho | Conteúdo |
|---|---|
| `deploy/README.md` | Guia do deploy na empresa: redes, pré-requisitos, passo a passo, proxy, login pelo AD |
| `deploy/docker-compose.yml` | Chatwoot (rails e sidekiq) e Redis, redes `bot-rh-interna` e `bot-rh-proxy` |
| `deploy/.env.example` | Configuração do deploy, sem segredos |
| `deploy/postgres/preparar-banco.sql` | Banco, usuário e extensões no PostgreSQL da empresa |
| `deploy/n8n/` | Fluxo do robô para o n8n da empresa e o guia de instalação |
| `chatwoot-proto/docker-compose.yml` | Chatwoot (rails e sidekiq), PostgreSQL, Redis e n8n |
| `chatwoot-proto/.env.example` | Modelo de configuração, sem segredos |
| `chatwoot-proto/README.md` | Como subir, parar, testar e atualizar |
| `chatwoot-proto/n8n/chatbot-rh-via-chatwoot.json` | Workflow do robô (importar no n8n) |
| `chatwoot-proto/TESTES-FASE7.md` | Resultado dos testes |
| `docs/RH-guia-de-uso.md` | Guia de uso para a equipe de RH |
| `docs/diagrama-arquitetura-tecnica.md` | Arquitetura e fluxos técnicos |
| `docs/diagrama-roteiro-chatbot.md` | Árvore de decisões do robô |
| `docs/diagramas/` | Diagramas em PNG e as fontes em HTML |
| `plan.md` | Plano original do protótipo |

## Como rodar o protótipo

Veja `chatwoot-proto/README.md`. Em resumo:

1. Copie `chatwoot-proto/.env.example` para `chatwoot-proto/.env` e gere os segredos.
2. `docker compose run --rm rails bundle exec rails db:chatwoot_prepare`
3. `docker compose up -d`

## Segurança

- Arquivos `.env` nunca são versionados (ver `.gitignore`).
- O filtro do workflow usa números de exemplo (`55DDDNUMERO1`, `55DDDNUMERO2`). Troque pelos números de teste no n8n depois de importar.
