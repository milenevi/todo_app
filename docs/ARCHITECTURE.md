# Arquitetura do Todo App

Este documento detalha a arquitetura do aplicativo, explicando cada camada e suas responsabilidades.

## Visão Geral

O aplicativo segue uma arquitetura em camadas baseada no Clean Architecture, com uma clara separação de responsabilidades e dependências direcionadas para o centro.

```
┌─────────────────────────────────────────────────────────────┐
│                     Presentation Layer                      │
├─────────────────┬─────────────────────┬─────────────────────┤
│     Screens     │     Controllers     │      Providers      │
│                 │                     │                     │
│  TodoListScreen │ TodoDetailController│     TodoProvider    │
│ TodoDetailScreen│                     │                     │
└─────────────────┴─────────────────────┴─────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────┐
│                       Domain Layer                          │
├─────────────────┬─────────────────────┬─────────────────────┤
│     Entities    │     Use Cases       │     Interfaces      │
│                 │                     │                     │
│    TodoEntity   │    TodoUseCases     │   TodoRepository    │
└─────────────────┴─────────────────────┴─────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────┐
│                        Data Layer                           │
├─────────────────┬─────────────────────┬─────────────────────┤
│   Repositories  │   Local DataSource  │   Remote DataSource │
│                 │                     │                     │
│ TodoRepoImpl    │ TodoLocalDataSource │ TodoRemoteDataSource│
└─────────────────┴─────────────────────┴─────────────────────┘
```

## Camadas

### 1. Camada de Apresentação (Presentation Layer)

#### Screens
- Responsável pela interface do usuário.
- Não contém lógica de negócio.
- Delega eventos para controllers/providers.

#### Controllers
- Gerencia o estado local da tela e navegação.
- Coordena interações entre widgets.
- Delega operações para os Use Cases.

#### Providers
- Gerencia o estado global (UI State).
- Notifica a UI sobre mudanças nos dados.
- Não contém lógica de sincronização ou persistência.

### 2. Camada de Domínio (Domain Layer)

#### Entities
- Define as entidades de negócio.
- Imutável e independente de frameworks ou camadas externas.

#### Use Cases
- Implementa as regras de negócio da aplicação.
- **Stateless**: Não mantém dados em memória, delega a persistência para o Repository.
- Orquestra o fluxo de dados entre a UI e o Domain.

```dart
class TodoUseCases {
  final TodoRepository _repository;
  
  Future<TodoEntity?> updateTodo(TodoEntity todo) async {
    final result = await _repository.updateTodo(todo);
    return result.fold((l) => null, (r) => r);
  }
}
```

#### Interfaces
- Define os contratos (abstrações) para as camadas externas.
- Permite a Inversão de Dependência (DIP).

### 3. Camada de Dados (Data Layer)

#### Repositories (Implementações)
- Implementa as interfaces definidas no domínio.
- **Single Source of Truth**: Coordena entre múltiplas fontes de dados (Local e Remote).
- Decide quando buscar dados da rede ou do cache local.

#### DataSources
- **Remote**: Implementa a comunicação com APIs externas.
- **Local**: Gerencia a persistência local (em memória, banco de dados ou storage).

```dart
class TodoRepositoryImpl implements TodoRepository {
  final TodoRemoteDataSource remoteDataSource;
  final TodoLocalDataSource localDataSource;
  
  @override
  Future<Result<List<TodoEntity>>> getTodos() async {
    // Tenta Remote -> Cache no Local -> Retorna Local
  }
}
```

## Fluxo de Dados

1. **UI Event** → Usuário interage com a tela.
2. **Controller/Provider** → Chama um método do Use Case.
3. **Use Case** → Executa regra de negócio e chama o Repository.
4. **Repository** → Orquestra os DataSources (Local/Remote).
5. **DataSource** → Retorna os dados crus (DTOs/Entities).
6. **Provider** → Recebe o resultado, atualiza a lista de UI e notifica os ouvintes.
7. **UI** → Reage à mudança do estado e reconstrói os widgets.

## Operações Locais vs. Remotas

- **Operações de Leitura**: O Repository tenta sincronizar com a API; se falhar, fornece os dados do cache local.
- **Operações de Escrita**: Atualmente realizadas apenas no `LocalDataSource` para garantir funcionamento offline/simulado, mas estruturadas para fácil expansão para o `RemoteDataSource`.
- **Sincronização**: O Repository é o responsável por decidir a política de sincronização.

## Testes

### Testes de Widget
- Testa interação do usuário
- Verifica renderização
- Mock de dependências

### Testes de Unidade
- Testa regras de negócio
- Verifica fluxo de dados
- Mock de dependências externas

## Convenções e Boas Práticas

1. **Injeção de Dependências**
   - Use construtores para injetar dependências
   - Evite dependências concretas
   - Use factories quando necessário

2. **Tratamento de Erros**
   - Use tipos de erro específicos
   - Trate erros no nível apropriado
   - Forneça feedback ao usuário

3. **Estado**
   - Use `ValueNotifier` para estado local
   - Use `Provider` para estado global
   - Mantenha estado imutável

4. **Testes**
   - Teste cada camada isoladamente
   - Use mocks apropriadamente
   - Mantenha testes legíveis

## Benefícios da Nova Estrutura

1. **Single Source of Truth**: O estado real dos dados agora reside na camada de dados (`LocalDataSource`), evitando duplicidade de lógica no Provider e UseCase.
2. **Stateless UseCases**: Facilita testes e evita bugs onde o UseCase "esquece" de limpar dados.
3. **Extensibilidade**: Para usar um banco de dados real (SQFlite/Hive), basta trocar a implementação do `LocalDataSource` no Injection Container, sem tocar na UI ou no Domínio.
4. **Testabilidade**: Cada camada pode ser mockada de forma independente e granular.