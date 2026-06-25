# Desperta Mulher — Adequação de UI com Acessibilidade

Adequação do código desenvolvido em sala de aula para o sistema **DespertaMulher.org**, com foco em **acessibilidade visual e inclusão de usuárias analfabetas**.

O projeto original consiste em um formulário de avaliação de risco de violência doméstica baseado no **FONAR (Formulário Nacional de Avaliação de Risco)**. Esta adequação mantém toda a lógica original e acrescenta melhorias de interface e um módulo de **Auxílio de Leitura por voz**, tornando o app utilizável por mulheres com dificuldades visuais ou que não dominam a leitura.

---

## Motivação

A violência doméstica atinge mulheres em todos os contextos sociais. Pensando nisso, esta adequação buscou remover barreiras de acesso ao formulário FONAR para dois grupos frequentemente excluídos de ferramentas digitais:

- **Mulheres com deficiência ou dificuldade visual** — beneficiadas por uma UI com alto contraste, tipografia ampliada e elementos visuais bem definidos
- **Mulheres em situação de analfabetismo** — atendidas pelo módulo de Auxílio de Leitura, que narra em voz alta todas as perguntas e alternativas do formulário

---

## Melhorias Implementadas

### 🖥Interface (UI)
- Tipografia ampliada em todos os elementos do questionário
- Alto contraste entre texto e fundo em toda a aplicação
- Cards de pergunta com bordas e sombras bem definidas para fácil distinção visual
- Indicadores de seleção grandes e animados (radio e checkbox)
- Barra de progresso de risco com cores semânticas claras (verde / amarelo / vermelho)
- Badge visual destacado para perguntas de múltipla escolha

### Auxílio de Leitura
- Botão fixo **🗣️ Auxílio de Leitura** acessível em todas as páginas do formulário
- Leitura em voz alta das perguntas, alternativas (identificadas por letra A, B, C...) e avisos
- Leitura automática ao avançar de página, sem necessidade de nova interação
- Na última página, narra também o **nível de risco atual** e as **orientações de apoio**
- Pressionar novamente o botão interrompe a leitura imediatamente

---

## Funcionalidades do Sistema

- Questionário paginado com carregamento dinâmico via JSON
- Perguntas de resposta única e múltipla escolha
- Avaliação de risco em tempo real (Baixo / Médio / Alto)
- Navegação entre páginas com indicador de progresso visual
- Tela de resultado com pontuação e orientações finais

---

## Estrutura do Projeto

```
desperta_mulher/
├── pubspec.yaml
├── assets/
│   ├── Mock/
│   │   ├── page1.json
│   │   ├── page2.json
│   │   ├── page3.json
│   │   ├── page4.json
│   │   └── page5.json
│   └── images/
│       ├── apoiador1.png
│       ├── apoiador2.png
│       └── apoiador3.png
└── lib/
    ├── main.dart
    ├── common/
    │   ├── app_colors.dart         # Paleta de cores do app
    │   ├── app_routes.dart         # Constantes de rotas
    │   ├── risk_level.dart         # Enum e lógica de nível de risco
    │   ├── route_manager.dart      # Configuração do MaterialApp e rotas
    │   └── storage_keys.dart       # Chaves de persistência local
    ├── models/
    │   ├── answer.dart             # Modelo de alternativa
    │   ├── question.dart           # Modelo de pergunta
    │   └── quiz_page_response.dart # Modelo de resposta paginada
    └── screens/
        ├── app_header.dart
        ├── quiz/
        │   ├── quiz_page.dart          # Tela principal do questionário
        │   ├── quiz_tts_mixin.dart     # Módulo de Auxílio de Leitura (TTS)
        │   ├── quiz_server.dart        # Carregamento dos JSONs de perguntas
        │   ├── question_widget.dart    # Card de pergunta individual
        │   └── risk_meter_widget.dart  # Widget de avaliação de risco
        ├── login/
        ├── photo/
        ├── profile/
        ├── registration/
        └── result/
```

---


## Paleta de Cores

| Constante        | Hex       | Uso                         |
|------------------|-----------|-----------------------------|
| `primary`        | `#AD1457` | Cor principal (rosa escuro) |
| `backgroundPage` | `#FDEEF5` | Fundo das telas             |
| `riskGreenFill`  | `#4CAF50` | Indicador de Risco Baixo    |
| `riskYellowFill` | `#FF9800` | Indicador de Risco Médio    |
| `riskRedFill`    | `#F44336` | Indicador de Risco Alto     |

---

## Lógica de Avaliação de Risco

A pontuação é calculada somando o `score` de todas as respostas selecionadas. O nível é definido como percentual da pontuação máxima (`maxScore = 200`):

| Percentual    | Nível    | Orientação                                              |
|---------------|----------|---------------------------------------------------------|
| Abaixo de 30% | 🟢 Baixo | Manter atenção; buscar apoio se necessário              |
| 30% a 64%     | 🟡 Médio | Buscar orientação com profissionais da rede de proteção |
| 65% ou mais   | 🔴 Alto  | Ligar 180 ou procurar a Delegacia da Mulher             |

---

## Módulo de Auxílio de Leitura

Implementado em `quiz_tts_mixin.dart` e integrado à `quiz_page.dart`.

**O que é narrado:**
- Número da página atual e total de páginas
- Enunciado de cada pergunta
- Todas as alternativas, identificadas por letra (A, B, C...)
- Aviso quando a pergunta permite múltipla escolha
- Na última página: nível de risco atual e orientações de apoio

**Comportamento:**
- 🗣️ Pressionar inicia a leitura da página atual
- 🔇 Pressionar novamente interrompe imediatamente
- Ao avançar de página com leitura ativa, a próxima é lida automaticamente
- Ao chegar na última página, narra as indicações finais e encerra

**Ajuste de velocidade** em `quiz_tts_mixin.dart`:
```dart
await _tts.setSpeechRate(0.48); // 0.0 = muito lento · 1.0 = máximo
```

---

##  Dependências

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_tts: ^4.0.2   # Auxílio de Leitura por voz
```

---

##  Como Rodar

```bash
# 1. Instalar dependências
flutter pub get

# 2. Rodar o app
flutter run
```


---

## Sobre o DespertaMulher.org

O sistema original **DespertaMulher.org** é uma iniciativa de apoio a mulheres em situação de violência doméstica. Esta adequação foi desenvolvida como trabalho acadêmico com o objetivo de ampliar o alcance da ferramenta, tornando-a acessível a mulheres com dificuldades visuais ou de leitura.

**Central de Atendimento à Mulher — Ligue 180** (gratuito, 24 horas)
