# Todo App

Um aplicativo de gerenciamento de tarefas desenvolvido com Flutter. Este aplicativo permite que você crie, visualize, edite e exclua tarefas, além de marcar tarefas como concluídas, seguindo boas práticas de arquitetura e Clean Code.

## Tecnologias Utilizadas

- Flutter
- Provider para gerenciamento de estado
- HTTP para comunicação com API
- API DummyJSON para dados de demonstração

## Funcionalidades

O aplicativo oferece as seguintes funcionalidades:

- Lista de tarefas com status visual (concluídas/pendentes)
- Adição de novas tarefas
- Visualização detalhada de cada tarefa
- Edição de tarefas existentes
- Exclusão de tarefas
- Alteração do status de conclusão das tarefas
- Feedback visual com mensagens Snackbar

## Arquitetura

O projeto segue uma arquitetura em camadas bem definidas:

### 1. Camada de Domínio (Domain Layer)
Contém as regras de negócio centrais da aplicação.

- `domain/models/` - Entidades do domínio
    - `todo.dart` - Modelo que representa uma tarefa

- `domain/usecases/` - Casos de uso da aplicação
    - `todo_usecases.dart` - Operações disponíveis para tarefas

### 2. Camada de Dados (Data Layer)
Responsável pelo acesso e persistência de dados.

- `repositories/` - Abstração do acesso aos dados
    - `todo_repository.dart` - Repositório para operações com tarefas

- `services/` - Implementação da comunicação com APIs
    - `todo_service.dart` - Serviço para comunicação com a API de tarefas

### 3. Camada de Apresentação (Presentation Layer)
Interface do usuário e lógica de apresentação.

- `controllers/` - Lógica de apresentação
    - `todo_detail_controller.dart` - Controle da tela de detalhes
    - `todo_detail_controller_factory.dart` - Factory para criação do controller

- `providers/` - Gerenciamento de estado
    - `todo_provider.dart` - Provider global para tarefas

- `widgets/` - Componentes reutilizáveis
    - `todo_item/` - Componentes do item de tarefa
    - `todo_detail/` - Componentes da tela de detalhes
    - `todo_list/` - Componentes da lista de tarefas

- `screens/` - Telas do aplicativo
    - `todo_list_screen.dart` - Tela principal com lista de tarefas
    - `todo_detail_screen.dart` - Tela de detalhes da tarefa

## Princípios e Padrões

1. **Gerenciamento de Estado**
    - Estado gerenciado através de classes imutáveis
    - Provider para gerenciamento de estado global
    - Controllers para gerenciamento de estado local das telas
    - Estado é manipulado de forma imutável para evitar efeitos colaterais

2. **Lógica de Negócios**
    - Encapsulada em UseCases (`TodoUseCases`)
    - Operações puras e testáveis
    - Separação clara entre regras de negócio e apresentação
    - Cada UseCase tem uma única responsabilidade

3. **Acesso a Dados**
    - Abstraído através de repositórios (`TodoRepository`)
    - Serviços para comunicação com APIs (`TodoService`)
    - Separação entre dados locais e remotos
    - Interface clara para operações de dados

4. **Interface do Usuário**
    - Componentes reutilizáveis organizados por funcionalidade
    - Widgets pequenos e com responsabilidade única
    - Separação entre lógica de apresentação e estilos
    - Composição de widgets para construir interfaces

5. **Injeção de Dependência**
    - Classes recebem dependências via construtor
    - Factories para criação de objetos complexos
    - Facilita testes e extensibilidade
    - Desacopla implementações de abstrações

6. **Clean Architecture**
    - Camadas bem definidas (Domain, Data, Presentation)
    - Dependências apontam para dentro
    - Regras de negócio isoladas
    - Fácil de testar e manter
   
## Melhorias Futuras

- Implementação de autenticação
- Armazenamento local com SQLite
- Temas personalizáveis
- Filtros e pesquisa de tarefas
- Notificações para tarefas com prazos
- Ampliação da cobertura de testes

## Testes

O projeto inclui diferentes tipos de testes:

1. **Testes de Widget**
    - Testam a interface do usuário
    - Verificam interações e callbacks
    - Isolam dependências usando mocks

2. **Testes de Unidade**
    - Testam a lógica de negócio
    - Cobrem casos de sucesso e erro
    - Usam mocks para isolar dependências

3. **Testes de Integração**
    - Testam a integração entre camadas
    - Verificam o fluxo completo de dados
    - Testam a comunicação com APIs

## Como Executar

1. Clone o repositório
```bash
git clone [URL_DO_REPOSITORIO]
```

2. Instale as dependências
```bash
flutter pub get
```

3. Execute os testes
```bash
flutter test
```

4. Execute o aplicativo
```bash
flutter run
```

## Contribuindo

1. Crie uma branch para sua feature
```bash
git checkout -b feature/nome-da-feature
```

2. Faça suas alterações seguindo os padrões do projeto

3. Execute os testes
```bash
flutter test
```

4. Envie um Pull Request

## Convenções de Código

1. **Nomenclatura**
    - Classes: PascalCase
    - Métodos e variáveis: camelCase
    - Constantes: SCREAMING_SNAKE_CASE

2. **Organização**
    - Um widget por arquivo
    - Nomes de arquivos em snake_case
    - Testes seguem a estrutura do código fonte

3. **Documentação**
    - Documentar classes e métodos públicos
    - Incluir exemplos em widgets complexos
    - Manter o README atualizado
