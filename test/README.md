# Testes para o Todo App

Este documento descreve a estratégia de testes para o aplicativo Todo.

## Estrutura de Testes

```
test/
├── unit/                  # Testes unitários
│   ├── todo_repository_test.dart    # Testes do TodoRepository
│   ├── todo_provider_test.dart      # Testes do TodoProvider
│   ├── todo_service_test.dart       # Testes do TodoService
│   └── todo_detail_controller_test.dart  # Testes do TodoDetailController
│
├── widget/                # Testes de widgets
│   ├── todo_detail_screen_test.dart  # Stub de teste da tela de detalhes
│   └── todo_list_screen_test.dart    # Stub de teste da tela de lista
|
└── integration/           # Testes de integração
    └── app_flow_test.dart           # Teste de fluxo completo do app
```

## Tipos de Testes

### Testes Unitários

Testam unidades individuais de código (classes, funções, métodos) isoladamente.

- **TodoRepository**: Testa o repositório de dados, incluindo cache e tratamento de erros
- **TodoProvider**: Testa a lógica de gerenciamento de estado e operações CRUD
- **TodoService**: Testa as chamadas de API e tratamento de respostas/erros
- **TodoDetailController**: Testa o controller da tela de detalhes

### Testes de Widget

Inclui stubs (esboços) de testes para os principais componentes de UI.

- **TodoDetailScreen**: Stub de teste para a tela de detalhes
- **TodoListScreen**: Stub de teste para a tela de lista

### Testes de Integração

Testam fluxos completos do aplicativo.

- **App Flow**: Testa um fluxo completo: criar tarefa, marcar como concluída, visualizar detalhes e excluir

## Executando os Testes

### Executar todos os testes:

```bash
flutter test
```

### Executar testes específicos:

```bash
# Executar testes unitários
flutter test test/unit/

# Executar testes de widgets
flutter test test/widget/

# Executar testes de integração
flutter test test/integration/

# Executar um arquivo de teste específico
flutter test test/unit/todo_repository_test.dart
```

## Dependências de Teste

- **flutter_test**: Framework de teste do Flutter
- **mockito**: Para criar mocks de classes
- **build_runner**: Para gerar arquivos de mock

Certifique-se de instalar as dependências de desenvolvimento necessárias:

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  mockito: ^5.4.0
  build_runner: ^2.4.8
```

Execute o build_runner para gerar os arquivos de mock:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```