# Fase 7: checklist de testes (23/11/2026)

Ambiente: Chatwoot Community `v4.20.1-ce` e n8n `2.48.8` em Docker local, workflow "Chatbot RH via Chatwoot (protótipo)", Agent Bot "Bot RH (protótipo)", número de teste da Meta +1 555-810-6048, túnel ngrok.

## Como foi testado

1. **Pelo celular (16:55 às 17:35).** As mensagens chegaram ao Chatwoot pela Meta e o bot respondeu a todas. As primeiras 5 respostas chegaram ao celular. Depois disso, a Meta passou a recusar a entrega (erro 131037, ver abaixo).
2. **Roteiro completo, simulando a Meta.** O Chatwoot recebeu webhooks no formato da WhatsApp Cloud API, assinados com o App Secret do app (como a Meta assina), no mesmo endereço que a Meta usa. Isso exercita todo o caminho (Chatwoot, Agent Bot, n8n, API do Chatwoot), menos a entrega final no celular.

## Resultado por teste do plano

| # | Teste | Resultado | Evidência |
|---|---|---|---|
| 1 | Mandar "oi" e receber o menu | ✅ | Conversa nova, pendente, com saudação e menu 1 a 4 (passo A1). Também visto no celular às 16:55. |
| 2 | Opções 1, 2 e 3 respondidas pelo bot | ✅ | Vagas (A2, A3). Cadastro em 6 perguntas com resumo, agradecimento e nota privada com os dados (B1 a B8). Acompanhamento com nota privada (C1 a C3). Por decisão do usuário, a opção 3 também passa a conversa para o RH. |
| 3 | Opção 4: aviso ao cliente e conversa `open` no Chatwoot | ✅ | Aviso enviado e conversa em "Abertas" (D2). |
| 4 | Atendente responde, a mensagem chega no WhatsApp e o bot não interfere | ⚠️ Parcial | O bot não respondeu à mensagem seguinte do candidato (D4) ✅. A resposta do atendente foi registrada e enviada à Meta, mas a Meta recusou a entrega (131037) ❌. |
| 5 | Resolver e mandar nova mensagem: o menu volta | ✅ | Conversa nova, pendente, com o menu (E1). |

## Limite de entrega do número de teste da Meta

**Causa confirmada em 25/11.** A documentação da Meta (Embedded Signup, seção "555 business phone numbers") diz que números 555, "until their display names are approved, they can send only 5 messages in a rolling 24-hour window". Ou seja, só 5 mensagens em qualquer período de 24 horas. Os registros batem:
- 23/11: 5 respostas entregues entre 16:55:29 e 16:56:10. A 6ª, às 16:56:20, foi recusada.
- 24/11 às 08:11: recusada, ainda dentro das 24 horas.
- 25/11 às 14:13: entregue, fora da janela.

Não é um bloqueio permanente: é uma cota até o nome de exibição ser aprovado. O roteiro completo (cerca de 20 mensagens) não cabe nessa cota.

Histórico da investigação:

- Erro: `(#131037) WhatsApp provided number needs display name approval before message can be sent.` Segundo a Meta: "The 555 business phone number used to send the request does not have an approved display name."
- No roteiro simulado, 19 de 19 respostas (18 do bot e 1 do atendente) foram recusadas por esse erro. Todo o resto funcionou.
- **Não é causado pelo Chatwoot nem pelo n8n.** O chatbot antigo, que enviava direto pela Graph API no n8n da nuvem, teve o mesmo erro em 18/11, com o mesmo padrão: as primeiras respostas saem e depois a Meta recusa.
- Situação do número: nome de exibição com `name_status = AVAILABLE_WITHOUT_REVIEW` (não `APPROVED`). Em 23/11 o número foi registrado de novo na Meta (`POST /register`) para aplicar o nome "Fazenda Nova Piratininga". O nome foi aplicado, mas o erro continuou.
- Nova tentativa em 24/11 às 08:11, pelo celular: o nome "Fazenda Nova Piratininga" já estava em uso, sem troca pendente, e o portfólio da empresa está **verificado**. Mesmo assim, a Meta recusou a resposta com o mesmo erro 131037. O bloqueio é do número de teste em si.
- No fórum de desenvolvedores da Meta há relatos do mesmo quadro com números de teste até 21/11/2026, sem solução publicada.
- **Saída proposta:** usar o número real da empresa, registrado na API e com nome de exibição aprovado pela Meta. Ponto para a reunião com o TI.

## Passos do roteiro simulado (19 de 19 OK)

| Passo | Mensagem | Esperado | Resultado |
|---|---|---|---|
| A1 | oi | Conversa nova pendente, saudação e menu | OK |
| A2 | 1 | Lista de vagas | OK |
| A3 | 2 | Volta ao menu | OK |
| B1 | 2 | Início do cadastro e pergunta 1/6 | OK |
| B2 | nome completo | Pergunta 2/6 (cidade) | OK |
| B3 | cidade | Pergunta 3/6 (vagas numeradas) | OK |
| B4 | 2 | Pergunta 4/6 (experiência) | OK |
| B5 | sim | Pergunta 5/6 (turno) | OK |
| B6 | 1 | Pergunta 6/6 (currículo) | OK |
| B7 | pular | Resumo com vaga e turno | OK |
| B8 | 1 | Agradecimento, nota privada, conversa segue pendente | OK |
| C1 | oi | Recomeça no menu | OK |
| C2 | 3 | Pede nome e vaga | OK |
| C3 | nome e vaga | Aviso, nota privada, conversa "Aberta" | OK |
| D1 | oi | Conversa nova pendente com menu | OK |
| D2 | 4 | Aviso e conversa "Aberta" | OK |
| D3 | (atendente responde) | Resposta registrada e enviada à Meta | OK (entrega recusada pela Meta) |
| D4 | ainda estou aqui | Mensagem chega e o bot não responde | OK |
| E1 | oi (após resolver) | Conversa nova com menu | OK |
