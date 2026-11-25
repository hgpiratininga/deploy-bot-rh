# Fluxo do robô para o n8n da empresa

Arquivo: `chatbot-rh-via-chatwoot.json` (workflow "Chatbot RH via Chatwoot").

O robô atende o candidato com um menu de 4 opções. Ele recebe os eventos do Chatwoot por webhook e responde pela API do Chatwoot. O roteiro completo está em [docs/diagrama-roteiro-chatbot.md](../../docs/diagrama-roteiro-chatbot.md).

> O questionário (textos, vagas e perguntas do cadastro) será atualizado em breve. Os textos ficam no bloco CONFIGURAÇÃO do nó **Motor do fluxo**.

## Requisitos

- n8n 2.x. O fluxo foi validado na versão 2.48.8.
- O n8n precisa **receber** chamadas do servidor do Chatwoot (webhook) e **chamar** a API do Chatwoot (HTTPS).
- O workflow precisa ficar **publicado**: a memória das conversas só é gravada em execuções de produção.

## Como instalar

1. **Importar.** No n8n, use Import from file, ou pela linha de comando: `n8n import:workflow --input=chatbot-rh-via-chatwoot.json`. O workflow entra desativado.
2. **Endereço do Chatwoot.** No nó **Motor do fluxo**, troque `CHATWOOT_URL` pelo endereço do Chatwoot que este n8n alcança, por exemplo `https://atendimento.EMPRESA.com.br`.
3. **Credencial.** Crie uma credencial *Header Auth*:
   - Name: `api_access_token`
   - Value: o token do Agent Bot (no Chatwoot: Configurações > Robôs > robô > **Token de acesso**)

   Selecione essa credencial nos nós **Enviar mensagem no Chatwoot** e **Passar conversa para o RH**.
4. **Números liberados.** No nó **Ler evento do Chatwoot**, a lista `NUMEROS_LIBERADOS` vazia libera todos os números, que é o modo de produção. Para testar com poucas pessoas, preencha com os números delas (com 55 e DDD, com e sem o 9).
5. **Publicar.** Clique em Publish e copie a URL de produção do webhook: `https://<n8n-da-empresa>/webhook/chatwoot-rh-bot`.
6. **Ligar ao Chatwoot.** No Chatwoot, em Configurações > Robôs > Criar Robô, informe essa URL. Depois, na caixa do WhatsApp, aba **Configuração do Bot**, escolha o robô. Faça isso **por último**: a partir daí, toda conversa nova vai para o robô.

## Rede

| Chamada | De | Para | Observação |
|---|---|---|---|
| Evento do robô | Chatwoot (sidekiq) | `POST https://<n8n>/webhook/chatwoot-rh-bot` | O formulário de robô do Chatwoot exige um nome de host com ponto (ex.: `n8n.empresa.local`). Se o endereço resolver para um IP de rede interna, o Chatwoot precisa de `SAFE_FETCH_ALLOW_PRIVATE_NETWORK=true` |
| Respostas e passagem para o RH | n8n | `POST {CHATWOOT_URL}/api/v1/accounts/{conta}/conversations/{id}/messages` e `.../toggle_status` | Header `api_access_token` com o token do Agent Bot |

## Segurança recomendada

- Libere o caminho `/webhook/chatwoot-rh-bot` apenas para o IP do servidor do Chatwoot.
- O Chatwoot assina cada evento com `X-Chatwoot-Signature` (HMAC SHA-256 de `{timestamp}.{corpo}`, com o "Segredo do Webhook" do robô) e `X-Chatwoot-Timestamp`. Validar essa assinatura no início do fluxo impede chamadas falsas. Isso exige o segredo do robô no n8n e o módulo `crypto` liberado no nó Code (`NODE_FUNCTION_ALLOW_BUILTIN=crypto`).
- A memória do workflow guarda sessões e os últimos 500 cadastros e pedidos de acompanhamento (dados pessoais). Os mesmos dados também ficam no Chatwoot como notas privadas. Defina a retenção.

## O que esperar depois de publicar

| Candidato | Robô |
|---|---|
| Primeira mensagem | Saudação e menu (1 a 4) |
| 1 | Vagas abertas |
| 2 | Cadastro em 6 perguntas, resumo e confirmação. Deixa uma nota privada com os dados para o RH |
| 3 | Pede nome e vaga, avisa e passa a conversa para o RH (status Aberta) |
| 4, "rh", "atendente" | Avisa e passa a conversa para o RH (status Aberta) |
| "menu" / "sair" | Volta ao início / encerra |
