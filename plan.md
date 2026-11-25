# Plano: protótipo local de chatbot WhatsApp com atendimento humano (RH)

## 1. Objetivo

Rodar tudo localmente, para depois apresentar ao TI e explicar o que muda ao migrar para o servidor da empresa:

1. Um **Chatwoot** próprio (self-hosted, edição Community), em Docker, como caixa de entrada onde a pessoa do RH atende.
2. Um **n8n** com o fluxo de menu que já existe ("Chatbot Recrutamento e Seleção (sem IA)"), adaptado para conversar com o Chatwoot.
3. A **WhatsApp Cloud API da Meta**, hoje com número de teste, e depois com o número real da empresa.

Comportamento desejado: toda conversa nova recebe o menu ("digite 1, 2, 3 ou 4"). Ao escolher a opção do RH, a conversa passa para um humano no Chatwoot, e o bot para de responder àquela conversa.

## 2. Arquitetura-alvo

```
Cliente (WhatsApp) -> Meta Cloud API -> [túnel HTTPS] -> Chatwoot
                                                           |  Agent Bot (webhook)
                                                           v
                                                          n8n
                                                           |  API do Chatwoot (responder, mudar status)
                                                           v
                                                        Chatwoot -> Meta -> Cliente
Atendente RH -> navegador -> Chatwoot
```

Regras desse desenho:
- A Meta aceita **um único webhook por app**. Ele deve apontar para o **Chatwoot**, e não para o n8n.
- Com um Agent Bot associado à inbox, as conversas novas nascem com status `pending` e o Chatwoot envia cada mensagem ao n8n.
- **Handoff** = o n8n muda o status da conversa de `pending` para `open`. A partir daí, o bot deixa de receber essa conversa e o RH atende.
- O n8n responde pela **API do Chatwoot**, e não pela Graph API da Meta.

## 3. Regras de segurança para o Claude Code

- Nunca grave segredos (token da Meta, token do Chatwoot, senhas) em arquivos versionados. Use `.env` e crie um `.gitignore` que o inclua.
- Não ative o workflow no n8n nem altere o workflow existente. Trabalhe em uma **cópia** com outro nome.
- Não reconfigure o webhook da Meta. Isso é feito pelo usuário (Fase 4).
- Confirme as rotas da API do Chatwoot na documentação oficial (`developers.chatwoot.com`) antes de implementar. Não use endpoints de memória.
- Peça confirmação antes de qualquer comando que apague volumes ou dados do Docker.

## 4. Fases

### Fase 0: levantar o ambiente (somente leitura)

O Claude Code deve verificar e relatar:
- Sistema operacional, versão do Docker e do Docker Compose (`docker --version`, `docker compose version`). Se faltar, orientar a instalação (Docker Desktop no Windows/macOS).
- Onde o n8n atual roda: nuvem do n8n, ou local? Perguntar ao usuário.
- Se existe a ferramenta de túnel: `cloudflared` ou `ngrok`.
- Portas livres: 3000 (Chatwoot) e 5678 (n8n).

Se o n8n atual for da nuvem, recomendar migrar para um n8n local no mesmo Docker Compose, para que nenhum dado passe por terceiros. O usuário exporta o workflow existente como JSON (n8n: menu do workflow > Download) e o Claude Code importa no n8n local.

### Fase 1: Chatwoot local

Base: guia oficial de Docker Compose em produção (https://developers.chatwoot.com/self-hosted/deployment/docker).

1. Criar a pasta `chatwoot-proto/` com `docker-compose.yml` e `.env`, partindo de `docker-compose.production.yaml` e `.env.example` do repositório oficial do Chatwoot.
2. No `.env`: definir `POSTGRES_PASSWORD` e `REDIS_PASSWORD` (gerar valores aleatórios), `SECRET_KEY_BASE` (gerar com `openssl rand -hex 64`) e `FRONTEND_URL` (a URL pública do túnel, definida na Fase 3; no início pode ser `http://localhost:3000`).
3. Usar a mesma senha do Postgres no `docker-compose.yml`.
4. Preparar o banco: `docker compose run --rm rails bundle exec rails db:chatwoot_prepare`
5. Subir: `docker compose up -d`
6. Teste: `curl -I localhost:3000/api` deve responder 200.
7. O usuário abre `http://localhost:3000` e cria a conta de administrador.

Critério de aceite: login no Chatwoot funcionando.

### Fase 2: n8n local (se aplicável)

1. Adicionar um serviço `n8n` ao Docker Compose, na mesma rede do Chatwoot, com volume persistente, na porta 5678.
2. Importar o JSON exportado do workflow existente.
3. Recriar as credenciais pelo painel do n8n (o export não leva os segredos).

Dentro da rede Docker, o Chatwoot chama o n8n em `http://n8n:5678/webhook/...`, sem precisar de túnel nesse sentido.

### Fase 3: túnel HTTPS para o Chatwoot

A Meta precisa alcançar o Chatwoot por HTTPS público.

1. Subir um túnel para a porta 3000 (Cloudflare Tunnel ou ngrok) e anotar a URL pública.
2. Atualizar `FRONTEND_URL` no `.env` com essa URL e reiniciar o Chatwoot.
3. Observação para a apresentação: o túnel é só do protótipo. No servidor da empresa, ele é substituído por um domínio próprio, Nginx e certificado TLS.

### Fase 4: inbox de WhatsApp no Chatwoot (feita pelo usuário, guiada)

O Claude Code explica, o usuário executa:
1. No Chatwoot: Settings > Inboxes > Add Inbox > WhatsApp > WhatsApp Cloud > configuração manual.
2. Informar: Phone Number ID, WhatsApp Business Account ID e token de acesso, todos do painel da Meta (app com o caso de uso WhatsApp).
3. Copiar do Chatwoot a **Callback URL** e o **Verify Token**. No painel do app da Meta (WhatsApp > Configuration), colar os dois e assinar o campo `messages`.
4. Desativar o gatilho antigo do n8n (ele deixa de receber, pois a Meta passa a enviar ao Chatwoot).
5. Atenção: o token temporário do número de teste da Meta expira em cerca de 24 horas. Para o protótipo durar mais, gerar um token permanente (usuário do sistema no Meta Business).

Critério de aceite: o checklist de conexão da inbox no Chatwoot aparece como verificado.

### Fase 5: workflow adaptado (cópia nova)

Nome sugerido: "Chatbot RH via Chatwoot (protótipo)".

| Hoje | Novo |
|---|---|
| Entrada: nó WhatsApp Trigger e "Ler mensagem" | Entrada: nó Webhook (POST). Ler `content`, `conversation.id`, `account.id`, `message_type` e o nome do contato do payload do Agent Bot |
| Chave de sessão: telefone | Chave de sessão: `conversation.id` |
| Saída: POST na Graph API | Saída: API do Chatwoot "criar mensagem" na conversa (tipo `outgoing`) |
| Handoff: grava `rh_mensagem` e encerra | Handoff: API do Chatwoot muda o status da conversa para `open` e envia aviso ao cliente |
| Menu com lista/botões interativos | Menu em **texto** ("digite 1, 2, 3 ou 4"). O código atual já aceita números |

Cuidados na implementação:
- Processar apenas eventos `message_created` de mensagens recebidas (`incoming`). Ignorar mensagens enviadas pelo próprio bot, para não entrar em loop.
- Responder apenas se a conversa estiver `pending`.
- Autenticar com o header `api_access_token` em uma credencial do n8n (tipo Header Auth), nunca no código.
- Manter o filtro do número de teste enquanto estiver em protótipo.
- Lembrar que a memória de sessão (`$getWorkflowStaticData`) só grava com o workflow **ativo**.

Opções do menu a tratar: 1 (vagas), 2 (cadastro), 3 (acompanhar), 4 (falar com o RH, que faz o handoff). As opções 1 a 3 continuam respondidas pelo bot.

### Fase 6: Agent Bot

1. No Chatwoot: Settings > Bots > Add Bot, com a URL de produção do Webhook do n8n (`http://n8n:5678/webhook/<caminho>` se ambos estiverem no Docker).
2. Abrir a inbox > Bot Configuration > escolher o bot > Salvar.
3. Ativar o workflow no n8n.

### Fase 7: testes

1. Do número de teste (que precisa estar na lista de destinatários permitidos da Meta), mandar "oi". Esperado: recebe o menu.
2. Escolher 1, 2 e 3 e conferir as respostas do bot.
3. Escolher 4. Esperado: o cliente recebe o aviso de encaminhamento, e a conversa aparece como `open` no Chatwoot.
4. Responder como atendente no Chatwoot. Esperado: a mensagem chega no WhatsApp e o bot **não** interfere.
5. Marcar a conversa como resolvida e mandar nova mensagem. Esperado: o menu volta (o código já recomeça sessões expiradas).

## 5. O que muda para rodar no servidor da empresa

Material para a reunião com o TI:

| Item | Protótipo local | Servidor da empresa |
|---|---|---|
| Exposição para a Meta | Túnel (Cloudflare/ngrok) | Domínio próprio + Nginx + TLS, porta 443 liberada |
| `FRONTEND_URL` | URL do túnel | `https://atendimento.<dominio-da-empresa>` |
| Docker Compose | Máquina do desenvolvedor | Servidor Linux, com `restart: unless-stopped` |
| Segredos | `.env` local | Gerenciados pelo TI (cofre ou variáveis do servidor) |
| Banco (PostgreSQL) | Volume Docker local | Backup agendado e restauração testada |
| Número de WhatsApp | Número de teste da Meta | Número real da empresa registrado na API |
| Token da Meta | Temporário ou permanente de teste | Permanente, de usuário do sistema, com rotação definida |
| Atualizações | Manuais | Rotina de atualização do Chatwoot e do n8n |
| Acesso do RH | `localhost` | Contas de agente com e-mail corporativo |
| Dados | Na máquina do desenvolvedor | No servidor da empresa. Observação: as mensagens continuam passando pela Meta |

Pontos a confirmar com o TI: RAM e disco do servidor, política de backup, regras de firewall para a porta 443 de entrada e a saída HTTPS para a Meta, e quem mantém as atualizações.

## 6. Entregáveis esperados do Claude Code

- `chatwoot-proto/docker-compose.yml` e `.env.example` (sem segredos reais) e `.gitignore`.
- Workflow do n8n em JSON (cópia adaptada).
- `README.md` curto com os comandos para subir, parar e testar.
- Checklist de testes da Fase 7 preenchido ao final.

## 7. Ordem de execução e pontos de parada

Fase 0 (relatório) > Fase 1 (parar e confirmar login) > Fase 2 > Fase 3 > Fase 4 (usuário) > Fase 5 > Fase 6 > Fase 7.
Em cada parada, o Claude Code resume o que fez, o que falta e o que precisa do usuário.