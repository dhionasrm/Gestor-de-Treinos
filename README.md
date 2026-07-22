# Meus Treinos

App Flutter pessoal para variar os treinos A, B e C indicados pelo Cloud Gym (academia), acompanhar séries/cargas e ajustar as recomendações conforme o objetivo (perda de peso ou ganho de massa). Funciona 100% offline, direto no celular Android.

## Funcionalidades

- **Rotação automática A → B → C**: a tela inicial sugere o próximo treino com base no último registrado no histórico — mas também é possível escolher manualmente qualquer um dos três a qualquer momento.
- **Substituição de exercícios**: cada exercício do plano original tem alternativas equivalentes (mesmo padrão de movimento / grupo muscular). Toque no ícone ↔ para trocar sem perder o estímulo.
- **Vídeo de execução**: toque no ícone ▶ de um exercício para abrir a busca do YouTube pelo nome exato dele — sempre atualizado, sem depender de um vídeo fixo que pode sair do ar.
- **Objetivo configurável**: "Perda de peso" (12–15 reps, descanso 45s) ou "Ganho de massa" (6–10 reps, descanso 90s), ajustando as sugestões de reps/descanso/séries em toda a sessão.
- **Sessão de treino**: registra peso × repetições por série, com timer de descanso automático após cada série.
- **Histórico**: lista de treinos concluídos com data e detalhe de cada série; pode ser limpo por completo a qualquer momento (com confirmação).
- **Aparência**: tema em tons de azul com modo Claro, Escuro ou Automático (segue o sistema).

Tudo é armazenado localmente (SQLite + SharedPreferences) — não há login, conta ou conexão com a internet necessária (exceto para abrir os vídeos do YouTube).

## Stack técnica

- [Flutter](https://flutter.dev/) (Material 3)
- [flutter_riverpod](https://pub.dev/packages/flutter_riverpod) — gerenciamento de estado
- [sqflite](https://pub.dev/packages/sqflite) — persistência do histórico de treinos
- [shared_preferences](https://pub.dev/packages/shared_preferences) — preferências (objetivo, tema)
- [url_launcher](https://pub.dev/packages/url_launcher) — abrir vídeos no YouTube

## Estrutura do projeto

```
lib/
├── main.dart                    # entry point
├── app.dart                     # MaterialApp, tema, navegação por abas
├── data/
│   ├── models/                  # Exercise, WorkoutTemplate, GoalMode, registros de sessão
│   ├── seed/seed_data.dart      # catálogo dos treinos A/B/C e alternativas de exercícios
│   ├── db/app_database.dart     # abertura/esquema do SQLite
│   └── repositories/            # acesso a dados (histórico de treinos)
├── providers/providers.dart     # providers Riverpod (repositório, tema, objetivo, treino sugerido)
└── ui/
    ├── home/                    # tela inicial (escolha de treino, início de sessão)
    ├── session/                 # treino em andamento (séries, timer de descanso)
    ├── history/                 # histórico e detalhe de treinos concluídos
    ├── settings/                # aparência e objetivo
    └── shared/                  # utilitários compartilhados (abrir YouTube)
```

## Rodando o projeto

Pré-requisitos: [Flutter SDK](https://docs.flutter.dev/get-started/install) instalado e um dispositivo Android (físico, via USB com depuração ativada, ou emulador).

```bash
flutter pub get
flutter run
```

### Gerando um APK para instalar no celular

```bash
flutter build apk --debug
adb install -r build/app/outputs/flutter-apk/app-debug.apk
```

Para uma build de release (menor e mais rápida, mas exige configurar assinatura antes de publicar):

```bash
flutter build apk --release
```

### Testes e análise estática

```bash
flutter analyze
flutter test
```

## Personalizando o catálogo de exercícios

Os treinos e suas alternativas ficam em `lib/data/seed/seed_data.dart`. Cada `ExerciseSlot` representa uma "posição" no treino (ex: peito/crucifixo) com uma lista de exercícios equivalentes — o primeiro da lista é o exercício original indicado pelo Cloud Gym. Adicionar um novo exercício alternativo é só incluir um `Exercise(id, nome)` na lista do slot correspondente.
