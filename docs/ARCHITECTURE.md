# Arquitetura da Aplicação de Tarefas

## Visão Geral da Arquitetura

A aplicação foi estruturada seguindo os princípios de responsabilidade única e separação de preocupações. A arquitetura implementa um padrão híbrido que separa claramente a lógica de negócios do gerenciamento de estado.

## Padrão de Gerenciamento de Estado

### Componentes Principais

1. **TodoProvider**: Classe central para gerenciamento de estado
    - Gerencia o estado completo da aplicação (tarefas, estado de carregamento, erros)
    - Expõe getters para acessar os dados (tarefas completas, incompletas, etc.)
    - Coordena as operações e atualiza o estado conforme necessário

2. **TodoOperations**: Encapsula a lógica de negócios
    - Contém métodos puros que implementam as regras de negócio
    - Recebe um estado e retorna um novo estado com as alterações
    - Não possui estado interno ou efeitos colaterais

3. **TodoRepository**: Abstrai o acesso a dados
    - Provê acesso aos dados (API, banco de dados local, etc.)
    - Desacopla a fonte de dados da lógica de negócio

4. **TodoState**: Modelo imutável do estado
    - Representa o estado completo da aplicação
    - Possui getters para facilitar o acesso aos dados
    - Implementa o padrão "copyWith" para atualizações imutáveis

## Separação de Responsabilidades

### Gerenciamento de Estado (TodoProvider)
- Manter o estado atual da aplicação
- Fornecer acesso aos dados através de getters
- Notificar os widgets sobre mudanças no estado
- Coordenar as operações entre diferentes componentes

### Lógica de Negócios (TodoOperations)
- Implementar as regras de negócio
- Validar as entradas e saídas
- Transformar os dados conforme necessário
- Não depender do framework (Flutter)

### Acesso a Dados (TodoRepository)
- Abstrair o acesso aos dados externos
- Converter entre formatos de dados
- Lidar com erros de comunicação
- Cachear dados quando necessário

## Fluxo de Dados

1. A UI solicita uma operação ao `TodoProvider`
2. O `TodoProvider` obtém os dados necessários (se aplicável) do `TodoRepository`
3. O `TodoProvider` chama o método adequado no `TodoOperations`
4. O `TodoOperations` aplica a lógica de negócio e retorna um novo estado
5. O `TodoProvider` atualiza seu estado interno e notifica seus ouvintes
6. A UI é atualizada para refletir o novo estado

## Benefícios da Arquitetura

1. **Testabilidade**: Fácil testar a lógica de negócio isoladamente
2. **Manutenibilidade**: Organização clara e coesa do código
3. **Escalabilidade**: Facilita a adição de novos recursos
4. **Legibilidade**: Responsabilidades bem definidas para cada componente 