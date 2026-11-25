# Diagrama: roteiro do chatbot (árvore de decisões)

Mostra todas as escolhas do candidato e a resposta do robô para cada uma, conforme o workflow "Chatbot RH via Chatwoot (protótipo)" (nó **Motor do fluxo**).

> Os diagramas usam **Mermaid**. Eles aparecem desenhados no GitHub, no VS Code com a extensão "Markdown Preview Mermaid Support" ou colando o bloco em https://mermaid.live.

Legenda: 🤖 = mensagem do robô · 📋/🔎 = nota privada para o RH · 👤 = atendimento humano.

---

## 1. Quem responde a mensagem

Antes da árvore do menu, o Chatwoot e o robô decidem **se** o robô deve responder.

```mermaid
flowchart TD
    MSG(["Candidato envia mensagem no WhatsApp"]) --> CONV{"Status da conversa<br/>no Chatwoot"}
    CONV -- "Não existe ou Resolvida" --> NOVA["Nova conversa<br/>status PENDENTE (com o robô)"]
    CONV -- "Pendente" --> FILTRO
    NOVA --> FILTRO
    CONV -- "Aberta (com o RH)" --> HUMANO["👤 Mensagem vai para o RH<br/>o robô não responde"]
    FILTRO{"Número liberado?<br/>(filtro só do protótipo)"}
    FILTRO -- "Não" --> IGNORA["Robô ignora<br/>a conversa fica pendente sem resposta"]
    FILTRO -- "Sim" --> REPETIDA{"Mensagem repetida?<br/>(mesmo evento reenviado)"}
    REPETIDA -- "Sim" --> DESCARTA["Ignorada"]
    REPETIDA -- "Não" --> SESSAO{"Sessão do robô<br/>nesta conversa"}
    SESSAO -- "Não existe, parada há mais de 30 min,<br/>encerrada ou já passada ao RH" --> SAUDACAO["🤖 Saudação + menu principal<br/>(ver árvore)"]
    SESSAO -- "Em andamento" --> GLOBAL{"Comando global?"}
    GLOBAL -- "menu, início, voltar, reiniciar" --> VOLTA["🤖 Voltamos ao início + menu principal"]
    GLOBAL -- "sair" --> SAIR["🤖 Atendimento encerrado + agradecimento<br/>sessão encerrada"]
    GLOBAL -- "Não" --> ETAPA["Continua na etapa atual da árvore"]

    RHASSUME(["RH atribui a si uma conversa Pendente"]) --> ABERTA["Conversa vira ABERTA<br/>o robô para de responder"]
```

## 2. Árvore do menu (todas as saídas)

```mermaid
flowchart TD
    MENU{"🤖 Menu principal<br/>1. Ver vagas abertas<br/>2. Cadastrar currículo<br/>3. Acompanhar processo<br/>4. Falar com o RH"}

    %% ---------- Opção inválida ----------
    MENU -- "Outra resposta" --> NAOENT["🤖 Não entendi sua resposta + menu"]
    NAOENT --> MENU

    %% ---------- Opção 1: vagas ----------
    MENU -- "1" --> VAGAS["🤖 Vagas abertas no momento<br/>(lista de vagas)<br/>1. Quero me candidatar<br/>2. Voltar ao menu"]
    VAGAS --> VDEC{"Resposta"}
    VDEC -- "1 ou texto com candidat..." --> CINTRO
    VDEC -- "2" --> VOLTAMENU["🤖 Menu principal"]
    VOLTAMENU --> MENU
    VDEC -- "Outra resposta" --> VAGAS

    %% ---------- Opção 2: cadastro ----------
    MENU -- "2" --> CINTRO["🤖 Vamos fazer seu cadastro. São 6 perguntas rápidas.<br/>🤖 1/6. Qual é o seu nome completo?"]
    CINTRO --> NOME{"Nome"}
    NOME -- "Nome e sobrenome" --> P2["🤖 2/6. Em qual cidade você mora?"]
    NOME -- "Só uma palavra ou menos de 5 letras" --> NOMEERR["🤖 Por favor, digite seu nome e sobrenome."]
    NOMEERR --> NOME
    NOME -- "Arquivo, foto ou áudio" --> TXT1["🤖 Por enquanto só consigo ler mensagens de texto."]
    TXT1 --> NOME

    P2 --> CIDADE{"Cidade"}
    CIDADE -- "Texto com 2 letras ou mais" --> P3["🤖 3/6. Para qual vaga? Digite o número:<br/>1 a 4 = vagas · 5 = Banco de talentos"]
    CIDADE -- "Menos de 2 letras" --> CIDERR["🤖 Por favor, digite o nome da sua cidade."]
    CIDERR --> CIDADE
    CIDADE -- "Arquivo, foto ou áudio" --> TXT2["🤖 Por enquanto só consigo ler mensagens de texto."]
    TXT2 --> CIDADE

    P3 --> VAGA{"Vaga"}
    VAGA -- "1, 2, 3 ou 4" --> P4["🤖 4/6. Você já trabalhou nessa função?<br/>1. Sim · 2. Não"]
    VAGA -- "5 = Banco de talentos" --> P4
    VAGA -- "Outra resposta" --> P3

    P4 --> EXP{"Experiência"}
    EXP -- "1, sim, s" --> P5["🤖 5/6. Qual turno você pode trabalhar?<br/>1. Manhã · 2. Tarde · 3. Noite · 4. Qualquer turno"]
    EXP -- "2, não, n" --> P5
    EXP -- "Outra resposta" --> P4

    P5 --> TURNO{"Turno"}
    TURNO -- "1 a 4 ou nome do turno" --> P6["🤖 6/6. Envie seu currículo em PDF ou Word.<br/>Se não tiver agora, digite pular."]
    TURNO -- "Outra resposta" --> P5

    P6 --> CV{"Currículo"}
    CV -- "Envia arquivo" --> RESUMO["🤖 Confira seus dados (resumo)<br/>1. Confirmar · 2. Corrigir dados"]
    CV -- "pular" --> RESUMO
    CV -- "Outra resposta" --> CVERR["🤖 Não recebi um arquivo. Envie o currículo<br/>em PDF ou Word, ou digite pular."]
    CVERR --> CV

    RESUMO --> CONF{"Confirmação"}
    CONF -- "1 ou confirmar" --> CADOK["🤖 Cadastro enviado! ✅ + agradecimento<br/>📋 Nota privada com os dados para o RH"]
    CONF -- "2 ou corrigir" --> REFAZ["🤖 Sem problemas, vamos refazer o cadastro.<br/>🤖 1/6. Qual é o seu nome completo?"]
    REFAZ --> NOME
    CONF -- "Outra resposta" --> RESUMO
    CADOK --> FIMBOT(["Fim do atendimento pelo robô<br/>conversa continua PENDENTE<br/>a próxima mensagem recomeça no menu"])

    %% ---------- Opção 3: acompanhar ----------
    MENU -- "3" --> AQ["🤖 Digite em uma mensagem seu nome completo<br/>e a vaga para a qual se candidatou."]
    AQ --> ADEC{"Resposta"}
    ADEC -- "Texto" --> AOK["🤖 Recebemos sua mensagem e encaminhamos sua conversa<br/>para a equipe de RH. Resposta em até 2 dias úteis.<br/>🔎 Nota privada com o pedido"]
    ADEC -- "Arquivo, foto ou áudio" --> TXT3["🤖 Por enquanto só consigo ler mensagens de texto."]
    TXT3 --> ADEC
    AOK --> RH

    %% ---------- Opção 4: falar com o RH ----------
    MENU -- "4, rh, atendente ou humano" --> H4["🤖 Certo! Sua conversa foi encaminhada para a equipe de RH,<br/>que atende de segunda a sexta, das 8h às 17h.<br/>Pode escrever sua mensagem aqui."]
    H4 --> RH

    RH[["👤 Conversa passa para ABERTA<br/>entra na fila do RH e o robô para"]]
    RH --> RESOLVE(["RH resolve a conversa<br/>nova mensagem do candidato volta ao robô"])
```

## 3. Mensagens do robô (textos atuais)

Os textos com **[ajustar]** são exemplos do protótipo e podem ser trocados no bloco CONFIGURAÇÃO do nó **Motor do fluxo**.

| Momento | Mensagem |
|---|---|
| Saudação (sessão nova) | Olá, *primeiro nome*! 👋 Você está no atendimento de Recrutamento e Seleção da Fazenda Nova Piratininga. Como podemos ajudar? Digite o número da opção: 1. Ver vagas abertas · 2. Cadastrar currículo · 3. Acompanhar processo · 4. Falar com o RH |
| Resposta inválida no menu | Não entendi sua resposta. + menu |
| Comando "menu" | Voltamos ao início. + menu |
| Comando "sair" | Atendimento encerrado. + agradecimento final |
| Opção 1 | Vagas abertas no momento: Trabalhador rural (Plantio, trato e colheita), Tratorista (CNH categoria C ou superior), Operador de máquinas (Experiência mínima de 1 ano), Auxiliar administrativo (Ensino médio completo) **[ajustar]**. Digite: 1. Quero me candidatar · 2. Voltar ao menu |
| Início do cadastro | Vamos fazer seu cadastro. São 6 perguntas rápidas. A qualquer momento, digite *menu* para voltar ao início ou *sair* para encerrar. |
| 1/6 | Qual é o seu nome completo? |
| 2/6 | Em qual cidade você mora? |
| 3/6 | Para qual vaga você quer se candidatar? Digite o número: (vagas numeradas) · 5. Banco de talentos (nenhuma das vagas) |
| 4/6 | Você já trabalhou nessa função? Digite: 1. Sim · 2. Não |
| 5/6 | Qual turno você pode trabalhar? Digite o número: 1. Manhã · 2. Tarde · 3. Noite · 4. Qualquer turno |
| 6/6 | Envie seu currículo em PDF ou Word por aqui. Se não tiver agora, digite *pular*. |
| Resumo | Confira seus dados: Nome, Cidade, Vaga, Experiência na função, Turno, Currículo. Está tudo certo? Digite: 1. Confirmar · 2. Corrigir dados |
| Cadastro confirmado | Cadastro enviado, *primeiro nome*! ✅ Se o seu perfil combinar com a vaga, o RH vai entrar em contato por este WhatsApp. + agradecimento final |
| Agradecimento final | Obrigado pelo contato com o Recrutamento e Seleção da Fazenda Nova Piratininga! 😊 Quando quiser falar de novo, é só mandar uma mensagem. |
| Opção 3 | Para consultar seu processo, digite em uma mensagem seu *nome completo* e a *vaga* para a qual você se candidatou. |
| Opção 3 concluída | Recebemos sua mensagem e encaminhamos sua conversa para a equipe de RH, que atende de segunda a sexta, das 8h às 17h **[ajustar]**. A resposta vem por aqui em até 2 dias úteis **[ajustar]**. |
| Opção 4 | Certo! Sua conversa foi encaminhada para a equipe de RH, que atende de segunda a sexta, das 8h às 17h **[ajustar]**. Pode escrever sua mensagem aqui. Uma pessoa do RH vai responder por esta conversa. |
| Só texto | Por enquanto só consigo ler mensagens de texto. Por favor, digite sua resposta. |

## 4. Notas privadas para o RH

| Quando | Conteúdo | Status da conversa |
|---|---|---|
| Cadastro confirmado | 📋 Cadastro recebido pelo bot: nome, cidade, vaga, experiência, turno, currículo (com link do arquivo, se enviado) | Continua **Pendente** |
| Opção 3 concluída | 🔎 Pedido de acompanhamento de processo: o texto enviado pelo candidato | Passa para **Aberta** |

## 5. Regras de sessão

| Regra | Efeito |
|---|---|
| 30 minutos sem resposta do candidato | A próxima mensagem recomeça com a saudação e o menu |
| Cadastro confirmado ou "sair" | Sessão encerrada: a próxima mensagem recomeça com a saudação |
| Opção 3 concluída ou opção 4 | A conversa vai para o RH. Se ela voltar a ficar com o robô, ele recomeça com a saudação |
| Conversa resolvida pelo RH | A próxima mensagem do candidato abre uma conversa nova, atendida pelo robô |
| Acentos e maiúsculas | Ignorados: "Não", "nao" e "NÃO" valem o mesmo |
