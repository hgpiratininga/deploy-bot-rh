# Chatwoot + n8n local (protótipo de atendimento do RH)

- Chatwoot Community Edition `v4.20.1-ce` (http://localhost:3000), baseado no guia oficial:
  https://developers.chatwoot.com/self-hosted/deployment/docker
- n8n `2.48.8` (http://localhost:5678), com telemetria desligada, na mesma rede Docker.
  Dentro da rede, o Chatwoot chama `http://n8n:5678/webhook/...` e o n8n chama `http://rails:3000/api/...`.

Requisito: Docker Desktop rodando. Todos os comandos são executados dentro desta pasta.

## Primeira instalação

1. Criar o `.env` a partir do modelo e preencher os segredos:
   - `SECRET_KEY_BASE`: `openssl rand -hex 64`
   - `POSTGRES_PASSWORD` e `REDIS_PASSWORD`: `openssl rand -hex 24`
   - `N8N_ENCRYPTION_KEY`: `openssl rand -hex 32` (guarde: sem ela, as credenciais do n8n não abrem)
2. Preparar o banco: `docker compose run --rm rails bundle exec rails db:chatwoot_prepare`
3. Subir: `docker compose up -d`
4. Testar: `curl -I localhost:3000/api` (esperado: `HTTP/1.1 200 OK`) e `curl localhost:5678/healthz` (esperado: `{"status":"ok"}`)
5. Abrir http://localhost:3000 e criar a conta de administrador do Chatwoot.
6. Abrir http://localhost:5678 e criar a conta de dono do n8n.
7. Importar um workflow (o import sempre entra desativado):
   `docker compose cp arquivo.json n8n:/tmp/wf.json`, depois
   `docker compose exec n8n n8n import:workflow --input=/tmp/wf.json`

## Workflow do bot

- Arquivo: `n8n/chatbot-rh-via-chatwoot.json` ("Chatbot RH via Chatwoot (protótipo)").
- Recebe os eventos do Agent Bot do Chatwoot em `http://n8n.interno:5678/webhook/chatwoot-rh-bot`.
  O apelido `n8n.interno` existe porque o formulário de robô do Chatwoot recusa nomes de host sem ponto.
- Para o Chatwoot alcançar o n8n na rede Docker, o `.env` precisa de `SAFE_FETCH_ALLOW_PRIVATE_NETWORK=true`
  (reduz a proteção contra chamadas à rede interna; decidir com o TI antes de usar no servidor).
- Responde só a mensagens recebidas em conversas `pending`. As opções 3 (acompanhar processo, depois de coletar nome e vaga) e 4 (falar com o RH) enviam um aviso e mudam a conversa para `open` (o RH assume).
- Credencial necessária no n8n: *Header Auth*, nome `api_access_token`, valor = token do Agent Bot.

## Dia a dia

| Ação | Comando |
|---|---|
| Subir | `docker compose up -d` |
| Parar (mantém os dados) | `docker compose stop` |
| Ver status | `docker compose ps` |
| Ver logs | `docker compose logs -f rails sidekiq n8n` |
| Atualizar versão | trocar a tag no `docker-compose.yml`, depois `docker compose pull`, `docker compose up -d` e `docker compose run --rm rails bundle exec rails db:chatwoot_prepare` |

Atenção: `docker compose down -v` **apaga o banco** (volumes). Não use sem querer.

## Túnel HTTPS (só no protótipo)

A Meta precisa alcançar o Chatwoot por HTTPS público. No protótipo, isso é feito com o ngrok (domínio fixo gratuito da conta).

1. Subir o túnel: `ngrok http 3000`. Ele só funciona enquanto essa janela estiver aberta; depois de reiniciar o PC, rode de novo.
2. O `FRONTEND_URL` do `.env` deve ser a URL do túnel (`https://<seu-dominio>.ngrok-free.dev`).
3. Depois de mudar o `.env`, recriar o Chatwoot (um restart não relê o arquivo):
   `docker compose up -d --force-recreate rails sidekiq`
4. Testar: `curl -I https://<seu-dominio>.ngrok-free.dev/api` (esperado: 200).

Observação: no plano gratuito, o ngrok mostra uma página de aviso a navegadores. Chamadas da Meta não são afetadas. O RH continua usando http://localhost:3000.

No servidor da empresa, o túnel é substituído por domínio próprio, Nginx e certificado TLS.

## Segurança

- O `.env` tem os segredos e está no `.gitignore`. Versione apenas o `.env.example`.
- As portas 3000 e 5678 só escutam em `127.0.0.1`. Postgres e Redis não ficam expostos fora da rede do Docker.
