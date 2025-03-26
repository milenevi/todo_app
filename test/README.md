# Testes do Todo App

Este diretório contém todos os testes automatizados da aplicação, organizados por camadas da arquitetura Clean.

## Estrutura de Testes

```
test/
├── data/                 # Testes da camada de dados
│   ├── datasources/      # Testes dos data sources (API)
│   └── repositories/     # Testes das implementações de repositórios
├── domain/               # Testes da camada de domínio
│   ├── models/           # Testes dos modelos de dados
│   └── usecases/         # Testes dos casos de uso
├── integration/          # Testes de integração
│   └── app/              # Fluxo completo de usuário
└── presentation/         # Testes da camada de apresentação
    ├── providers/        # Testes dos providers
    └── screens/          # Testes dos widgets e telas
```

## Características dos Testes

### Abordagem da Aplicação

O Todo App utiliza uma estratégia específica:
1. **Carregamento inicial**: Dados são carregados da API remota apenas uma vez
2. **Operações CRUD**: Todas as operações de criação, atualização e exclusão são realizadas localmente

### Testes de Data Sources

- `todo_remote_datasource_test.dart`: Testa apenas o método `getTodos()`, pois é o único utilizado na aplicação real.
- Os métodos `getTodoById()` e `createTodo()` não são testados pois são mantidos apenas para compatibilidade com a interface.

### Testes de Repositórios

- `todo_repository_test.dart`: Testa apenas a funcionalidade `getTodos()`, verificando a comunicação com o data source.
- Os outros métodos do repositório são stubs, não implementados realmente, pois a lógica CRUD está na classe `TodoUseCases`.

### Testes de Casos de Uso

- `todo_usecases_test.dart`: Testa toda a lógica de negócio, incluindo operações CRUD locais.
- Enfatiza o comportamento onde as operações são realizadas na lista local gerenciada por `TodoUseCases`.

### Testes de Integração

- `app_flow_test.dart`: Testa o fluxo completo do usuário, desde adicionar uma tarefa até excluí-la.
- Simula o comportamento completo do app com um mock de repositório.

## Executando os Testes

```bash
# Executar todos os testes
flutter test

# Executar com cobertura
flutter test --coverage

# Executar testes específicos
flutter test test/domain/usecases/todo_usecases_test.dart
```

## Observações

As modificações realizadas nos arquivos de implementação foram feitas para clarificar a arquitetura real da aplicação:

1. Os métodos do `TodoRemoteDataSource` que não são utilizados agora lançam `UnimplementedError`
2. Os métodos do `TodoRepository` retornam falhas `NotImplementedFailure` para operações gerenciadas localmente
3. A documentação reflete o comportamento real da aplicação: apenas carregar da API, modificar localmente