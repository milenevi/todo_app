# Arquitetura da Aplicação de Tarefas

## Visão Geral da Arquitetura

A aplicação foi estruturada seguindo os princípios de responsabilidade única e separação de preocupações. A arquitetura implementa um padrão híbrido que separa claramente a lógica de negócios do gerenciamento de estado. Uma separação clara de responsabilidades do (Clean) com um gerenciamento eficiente de estado do (MVVM).

Se o projeto crescer significativamente em complexidade, pode evoluir naturalmente para Clean Architecture pura, mas para o escopo atual, a abordagem híbrida oferece o melhor equilíbrio entre robustez e praticidade.

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

5. **Controllers**: Gerenciam a lógica de UI específica
   - Conectam a UI com a lógica de negócio
   - Não contêm elementos de UI (SnackBars, diálogos, etc.)
   - Retornam apenas resultados das operações
   - Seguem o princípio de responsabilidade única

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

### Controllers
- Gerenciar o estado local da UI
- Coordenar operações entre UI e lógica de negócio
- Retornar resultados sem manipular UI diretamente
- Evitar dependências de widgets específicos

### UI (Screens e Widgets)
- Renderizar a interface do usuário
- Gerenciar feedback visual (SnackBars, diálogos)
- Controlar navegação
- Verificar estado de montagem (mounted) em operações assíncronas

## Fluxo de Dados

1. A UI solicita uma operação ao Controller
2. O Controller coordena com o TodoProvider
3. O TodoProvider obtém os dados necessários do TodoRepository
4. O TodoProvider chama o método adequado no TodoOperations
5. O TodoOperations aplica a lógica de negócio e retorna um novo estado
6. O TodoProvider atualiza seu estado interno e notifica seus ouvintes
7. O Controller recebe o resultado e a UI decide como apresentá-lo

## Boas Práticas

1. **Separação de UI e Lógica**
   - Controllers não devem conter elementos de UI
   - UI deve gerenciar feedback visual
   - Verificar estado de montagem em operações assíncronas

2. **Gerenciamento de Estado**
   - Usar ValueNotifier para estado local
   - Implementar dispose adequadamente
   - Evitar dependências circulares

3. **Tratamento de Erros**
   - Controllers retornam resultados booleanos
   - UI decide como apresentar erros
   - Manter mensagens de erro na camada de UI

4. **Testabilidade**
   - Controllers podem ser testados isoladamente
   - UI pode ser testada com mocks de controllers
   - Lógica de negócio independente de UI

## Benefícios da Arquitetura

1. **Testabilidade**: Fácil testar a lógica de negócio isoladamente
2. **Manutenibilidade**: Organização clara e coesa do código
3. **Escalabilidade**: Facilita a adição de novos recursos
4. **Legibilidade**: Responsabilidades bem definidas para cada componente
5. **Robustez**: Tratamento adequado de estados assíncronos e erros 