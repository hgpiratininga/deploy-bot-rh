# Atendimento de candidatos pelo WhatsApp: guia de uso para o RH

Este guia explica como a equipe de Recrutamento e Seleção vai atender os candidatos que escrevem para o WhatsApp da empresa, pelo **computador** e pelo **celular**.

> O endereço de acesso, os usuários e a senha inicial serão passados pelo TI. Algumas telas podem mudar um pouco quando o sistema for instalado no servidor da empresa.

---

## 1. Como funciona, em uma página

1. O candidato manda uma mensagem para o **WhatsApp de Recrutamento e Seleção**.
2. Um **robô** responde na hora com um menu:
   1. Ver vagas abertas
   2. Cadastrar currículo
   3. Acompanhar processo
   4. Falar com o RH
3. O robô resolve sozinho as opções **1** (mostra as vagas) e **2** (faz o cadastro em 6 perguntas).
4. Nas opções **3** e **4**, o robô avisa o candidato e **passa a conversa para o RH**. Daí em diante, quem responde é uma pessoa, e o robô não interfere mais.
5. O RH atende por um sistema chamado **Chatwoot**, no navegador do computador ou no app do celular. **As conversas não aparecem no WhatsApp do celular**: tudo acontece no Chatwoot.

O desenho completo das respostas do robô está em [Roteiro do chatbot](diagrama-roteiro-chatbot.md).

## 2. O que o robô faz e o que chega para o RH

| O candidato escolhe | O robô faz | O que chega para o RH |
|---|---|---|
| 1. Ver vagas abertas | Mostra as vagas e oferece "Quero me candidatar" | Nada (o robô resolve) |
| 2. Cadastrar currículo | Pergunta nome, cidade, vaga, experiência, turno e currículo (arquivo ou "pular"), mostra um resumo e pede confirmação | Uma **nota privada** 📋 com os dados do cadastro, na conversa. A conversa **continua com o robô** (status Pendente) |
| 3. Acompanhar processo | Pede nome completo e vaga, avisa que o RH vai responder em até 2 dias úteis | A conversa vai para a **fila do RH** (Aberta), com uma nota privada 🔎 com o pedido |
| 4. Falar com o RH | Avisa o horário de atendimento e que uma pessoa vai responder | A conversa vai para a **fila do RH** (Aberta) |

O candidato também pode digitar "rh", "atendente" ou "humano" no menu para falar com o RH, "menu" para voltar ao início e "sair" para encerrar.

## 3. Os estados de uma conversa

Toda conversa tem um **status**. Ele indica com quem a conversa está:

| Status | Significa | O que o RH faz |
|---|---|---|
| **Pendentes** | Está com o **robô** | Normalmente nada. Exceção: cadastros concluídos (nota 📋) ficam aqui |
| **Abertas** | Está esperando ou em atendimento por uma **pessoa do RH** | Atender |
| **Resolvidas** | Atendimento encerrado | Nada. Se o candidato escrever de novo, o robô recomeça pelo menu |
| **Adiadas** | Alguém do RH pausou para retomar depois | Retomar na data escolhida |

E três abas, que indicam **de quem** é a conversa:

| Aba | Mostra |
|---|---|
| **Minhas** | Conversas atribuídas a você |
| **Não atribuídas** | Conversas sem responsável |
| **Todos** | Todas as conversas |

**Onde olhar no dia a dia:**
- **Novos pedidos de atendimento:** aba **Não atribuídas** com o filtro **Abertas**.
- **Seus atendimentos:** aba **Minhas** com o filtro **Abertas**.
- **Cadastros feitos pelo robô:** aba **Todos** com o filtro **Pendentes**. Procure as conversas com a nota 📋.

Dependendo de como o TI configurar, o Chatwoot pode **distribuir automaticamente** as conversas abertas entre os atendentes disponíveis. Nesse caso, elas já aparecem direto em **Minhas**.

---

## 4. No computador

### Primeiro acesso
1. Você recebe um convite por e-mail. Crie sua senha pelo link.
2. Acesse o endereço passado pelo TI (algo como `https://atendimento.<dominio-da-empresa>`) e entre com seu e-mail corporativo e senha.
3. A tela deve aparecer em português. Se estiver em inglês, peça ao administrador para ajustar o **Idioma do site** nas configurações da conta. Seus dados pessoais (nome, foto, senha) ficam em **Configurações do Perfil**: clique na sua foto, no canto inferior esquerdo.

### Rotina de atendimento
1. Abra **Conversas**, aba **Não atribuídas**, filtro **Abertas**.
2. Clique na conversa. Leia o histórico: o que o candidato escreveu, o que o robô respondeu e as **notas privadas** (fundo amarelo).
3. **Atribua a conversa a você**: no painel à direita, em agente atribuído, escolha seu nome (**Atribuir**). Isso evita que duas pessoas respondam o mesmo candidato.
4. Responda na caixa de texto, aba **Responder**, e clique em **Enviar**. Para mandar um arquivo, use o clipe (**Anexar arquivos**).
5. Para deixar um recado interno que o candidato **não vê**, use a aba **Mensagem Privada**.
6. Terminou? Clique em **Resolver** (canto superior direito). Se precisar retomar depois, use a setinha ao lado de Resolver e escolha **Adiar**.

### Assumir uma conversa que ainda está com o robô
Às vezes vale a pena falar com um candidato que está no meio do cadastro ou que já cadastrou (conversa **Pendente**).

1. Abra a conversa.
2. **Atribua a conversa a você** (painel à direita). Ao atribuir, ela passa para **Aberta** e o **robô para de responder**.
3. Só então responda.

**Atenção:** responder uma conversa Pendente **sem** atribuí-la antes não tira a conversa do robô, e ele continua respondendo o candidato.

### Respostas prontas
Para mensagens que se repetem ("Recebemos seu currículo…", "Sua entrevista está marcada para…"), crie **respostas prontas** em Configurações > **Respostas Prontas**. Na hora de responder, digite **/** seguido do atalho.

### Regra das 24 horas do WhatsApp
O WhatsApp só permite mensagens livres até **24 horas depois da última mensagem do candidato**. Passado esse prazo, o Chatwoot mostra o aviso "Restrições de janela de mensagem de 24 horas". Para retomar o contato, use o botão **Modelos do Whatsapp** e escolha um modelo aprovado. Os modelos são preparados com o TI, porque precisam de aprovação da Meta.

**Dica:** responda os pedidos do mesmo dia sempre que possível, para não cair nessa regra.

---

## 5. No celular

### Instalar
1. Instale o app **Chatwoot** pela Play Store (Android) ou App Store (iPhone).
2. Ao abrir, escolha a opção de **usar outro servidor** (instalação própria) e digite o endereço passado pelo TI.
3. Entre com o mesmo e-mail e senha do computador.
4. Permita as **notificações** para ser avisado de novas mensagens.

Também dá para usar pelo navegador do celular, no mesmo endereço do computador.

### O que dá para fazer no celular
- Ver as conversas com as mesmas abas e filtros (**Minhas**, **Não atribuídas**, **Todos** / **Abertas**, **Pendentes**, **Resolvidas**).
- Responder, mandar mensagem privada, anexar arquivos e fotos.
- Atribuir, resolver e adiar conversas.

### Cuidados
- **Não use o WhatsApp do celular para o número da empresa.** O número é atendido pelo Chatwoot; o TI confirma se haverá alguma exceção.
- O celular mostra dados pessoais de candidatos: use bloqueio de tela e não encaminhe conversas ou currículos para fora do Chatwoot.
- Se o acesso for só pela rede da empresa (VPN), o app só funciona conectado a ela. O TI informa.

---

## 6. Boas práticas da equipe

- **Atribua antes de responder.** Uma conversa, uma pessoa responsável.
- Verifique **Não atribuídas + Abertas** algumas vezes por dia.
- Use **Mensagem Privada** para combinar coisas com colegas dentro da própria conversa.
- **Resolva** a conversa ao terminar. Assim a fila mostra só o que está pendente de verdade.
- Peça ao TI para ajustar os textos do robô (vagas, horário de atendimento, prazo de retorno). A mudança é simples e não exige programação nova.

## 7. Perguntas frequentes

**O candidato falou com o robô e eu não vejo a conversa.**
Ela está em **Pendentes**. Troque a aba para **Todos** e o filtro para **Pendentes**.

**Respondi e o robô respondeu junto.**
A conversa ainda estava Pendente. Atribua a conversa a você: ela passa para Aberta e o robô para.

**O candidato voltou a escrever depois que resolvi a conversa.**
O robô atende de novo com o menu. Se ele escolher falar com o RH, a conversa volta para a fila.

**Minha mensagem aparece como "falhou".**
Pode ser a regra das 24 horas (use um **Modelo do Whatsapp**) ou um problema com o número na Meta. Se persistir, avise o TI.

**Onde fica o currículo que o candidato mandou?**
Na própria conversa, como arquivo, e citado na nota privada 📋 do cadastro.

## 8. Glossário

| Termo | Significado |
|---|---|
| Chatwoot | Sistema onde o RH lê e responde as conversas do WhatsApp |
| Caixa de entrada | O canal do WhatsApp de Recrutamento e Seleção dentro do Chatwoot |
| Conversa | Um atendimento com um candidato |
| Contato | O candidato (nome e telefone) |
| Robô | Atendimento automático com o menu de opções |
| Mensagem Privada (nota privada) | Recado interno, que o candidato não vê |
| Atribuir | Tornar uma pessoa responsável pela conversa |
| Resolver | Encerrar o atendimento |
| Modelos do WhatsApp | Mensagens pré-aprovadas pela Meta, usadas depois de 24 horas sem resposta do candidato |
