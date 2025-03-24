# todo_app# Todo App

Um aplicativo de gerenciamento de tarefas desenvolvido com Flutter. Este aplicativo permite que você crie, visualize, edite e exclua tarefas, além de marcar tarefas como concluídas.

## Funcionalidades

- Lista de tarefas com status visual (concluídas/pendentes)
- Adição de novas tarefas
- Visualização detalhada de cada tarefa
- Edição de tarefas existentes
- Exclusão de tarefas
- Alteração do status de conclusão das tarefas
- Feedback visual com mensagens Snackbar

## Tecnologias utilizadas

- Flutter
- Provider para gerenciamento de estado
- HTTP para comunicação com API
- API DummyJSON para dados de demonstração

## Arquitetura

O aplicativo segue uma arquitetura que separa claramente responsabilidades:

- **Estado**: Gerenciado através de classes imutáveis (`TodoState`)
- **Lógica de Negócios**: Encapsulada em classes de operações puras (`TodoOperations`)
- **Acesso a Dados**: Abstraído através de repositórios (`TodoRepository`)
- **UI**: Componentes reutilizáveis organizados por funcionalidade

### Princípios de Design

- **Injeção de Dependência**: As classes aceitam suas dependências via construtor, facilitando testes e extensibilidade
- **Imutabilidade**: O estado é manipulado de forma imutável para evitar efeitos colaterais
- **Responsabilidade Única**: Cada classe tem uma única razão para mudar
- **Separação de Preocupações**: Lógica de negócios separada da apresentação e acesso a dados

## Estrutura do Projeto

O projeto está organizado nas seguintes pastas:

- **lib/models**: Contém a classe de modelo `Todo`
- **lib/providers**: Contém o `TodoProvider` para gerenciamento de estado
- **lib/screens**: Contém as telas do aplicativo
- **lib/services**: Contém o `TodoService` para comunicação com a API
- **lib/repositories**: Abstrai o acesso aos dados externos
- **lib/state**: Contém as classes relacionadas ao gerenciamento de estado
- **lib/widgets**: Componentes reutilizáveis agrupados por contexto
- **lib/controllers**: Controladores para lógica específica de tela
- **lib/theme**: Configurações de tema e cores
- **docs**: Documentação adicional do projeto

## Melhorias Futuras

- Implementação de autenticação
- Armazenamento local com SQLite
- Temas personalizáveis
- Filtros e pesquisa de tarefas
- Notificações para tarefas com prazos
- Ampliação da cobertura de testes

## Instalação e Execução

1. Clone o repositório
2. Execute `flutter pub get` para instalar as dependências
3. Execute `flutter run` para iniciar o aplicativo

## Documentação Adicional

Consulte a pasta `docs/` para documentação detalhada sobre a arquitetura do projeto.

## Contribuição

Contribuições são bem-vindas! Sinta-se à vontade para abrir um issue ou enviar um pull request.
