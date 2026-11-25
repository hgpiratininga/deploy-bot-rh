# Chatbot de RH no WhatsApp (Chatwoot + n8n)

Atendimento de candidatos de Recrutamento e Seleção pelo WhatsApp. Um robô de menu (sem IA), feito no n8n, responde primeiro. Quando o candidato pede, a conversa passa para uma pessoa do RH, que atende pelo Chatwoot.

Esta branch (`main`) guarda o **protótipo local**, que roda inteiro num notebook com Docker Desktop e um túnel ngrok.

## Estrutura

| Caminho | Conteúdo |
|---|---|
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
