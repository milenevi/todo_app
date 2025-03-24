
# Arquitetura do Todo App

Este documento detalha a arquitetura do aplicativo, explicando cada camada e suas responsabilidades.

## Visão Geral

O aplicativo segue uma arquitetura em camadas que separa claramente as responsabilidades e promove a manutenibilidade e testabilidade do código.

```
┌─────────────────────────────────────────────────────────────┐
│                     Presentation Layer                       │
├─────────────────┬─────────────────────┬───────────────────┤
│     Screens     │     Controllers     │     Providers      │
│                 │                     │                    │
│  TodoListScreen │ TodoDetailController│   TodoProvider    │
│ TodoDetailScreen│                     │                    │
└─────────────────┴─────────────────────┴───────────────────┘
                           ▲
                           │
                           │
┌─────────────────────────────────────────────────────────────┐
│                       Domain Layer                           │
├─────────────────┬─────────────────────┬───────────────────┤
│     Models      │     Use Cases       │    Interfaces      │
│                 │                     │                    │
│      Todo       │   TodoUseCases     │  TodoRepository    │
└─────────────────┴─────────────────────┴───────────────────┘
```

## Camadas

### 1. Camada de Apresentação (Presentation Layer)

#### Screens
- Responsável pela interface do usuário
- Não contém lógica de negócio
- Delega eventos para controllers/providers
- Exemplo: `TodoListScreen`, `TodoDetailScreen`

```dart
class TodoDetailScreen extends StatefulWidget {
  final int todoId;
  
  @override
  State<TodoDetailScreen> createState() => _TodoDetailScreenState();
}
```

#### Controllers
- Gerencia o estado local da tela
- Coordena interações entre widgets
- Delega operações para casos de uso
- Exemplo: `TodoDetailController`

```dart
class TodoDetailController extends ChangeNotifier {
  final TodoUseCases _useCases;
  final ValueNotifier<Todo?> _todo = ValueNotifier<Todo?>(null);
  
  Future<bool> updateTodo(BuildContext context, Todo todo) async {
    // Implementação
  }
}
```

#### Providers
- Gerencia estado global
- Fornece acesso aos dados para widgets
- Delega operações para casos de uso
- Exemplo: `TodoProvider`

```dart
class TodoProvider extends ChangeNotifier {
  final TodoUseCases _useCases;
  List<Todo> get completedTodos => _todos.where((t) => t.completed).toList();
}
```

### 2. Camada de Domínio (Domain Layer)

#### Models
- Define as entidades do domínio
- Contém regras de validação
- Imutável e independente de frameworks
- Exemplo: `Todo`

```dart
class Todo {
  final int id;
  final String todo;
  final bool completed;
  
  Todo copyWith({bool? completed}) {
    return Todo(
      id: id,
      todo: todo,
      completed: completed ?? this.completed,
    );
  }
}
```

#### Use Cases
- Implementa regras de negócio
- Orquestra fluxo de dados
- Independente de UI
- Exemplo: `TodoUseCases`

```dart
class TodoUseCases {
  final TodoRepository _repository;
  
  Future<Todo> updateTodo(Todo todo) async {
    // Implementação
  }
}
```

#### Interfaces
- Define contratos para camadas externas
- Permite inversão de dependência
- Exemplo: `TodoRepository` (interface)

```dart
abstract class TodoRepository {
  Future<List<Todo>> getTodos();
  Future<Todo> getTodoById(int id);
}
```

### 3. Camada de Dados (Data Layer)

#### Repository
- Implementa interfaces do domínio
- Coordena fontes de dados
- Mapeia DTOs para modelos
- Exemplo: `TodoRepositoryImpl`

```dart
class TodoRepositoryImpl implements TodoRepository {
  final TodoService _service;
  
  Future<Todo> getTodoById(int id) async {
    // Implementação
  }
}
```

#### Services
- Implementa comunicação com APIs
- Gerencia cache e persistência
- Lida com erros de rede
- Exemplo: `TodoService`

```dart
class TodoService {
  final http.Client _client;
  
  Future<TodoDTO> getTodoById(int id) async {
    // Implementação
  }
}
```

## Fluxo de Dados

1. **UI Event** → Widget dispara evento
2. **Controller/Provider** → Processa evento
3. **Use Case** → Executa regra de negócio
4. **Repository** → Acessa dados
5. **Service** → Comunica com API
6. **Repository** → Mapeia resposta
7. **Use Case** → Valida dados
8. **Controller/Provider** → Atualiza estado
9. **UI** → Reflete mudanças

## Testes

### Testes de Widget
- Testa interação do usuário
- Verifica renderização
- Mock de dependências

```dart
testWidgets('should display todo title', (tester) async {
  await tester.pumpWidget(TodoItem(
    todo: todo,
    onToggleCompletion: () {},
    onTodoSelected: (_) {},
  ));
  
  expect(find.text('Test Todo'), findsOneWidget);
});
```

### Testes de Unidade
- Testa regras de negócio
- Verifica fluxo de dados
- Mock de dependências externas

```dart
test('should update todo successfully', () async {
  when(mockUseCases.updateTodo(any))
    .thenAnswer((_) async => testTodo);
    
  final success = await controller.updateTodo(context, testTodo);
  
  expect(success, true);
});
```

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

## Benefícios da Arquitetura

1. **Testabilidade**: Fácil testar a lógica de negócio isoladamente
2. **Manutenibilidade**: Organização clara e coesa do código
3. **Escalabilidade**: Facilita a adição de novos recursos
4. **Legibilidade**: Responsabilidades bem definidas para cada componente
5. **Robustez**: Tratamento adequado de estados assíncronos e erros 