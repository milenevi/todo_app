# Todo App

Um aplicativo de lista de tarefas (Todo) desenvolvido com Flutter, seguindo os princípios da Clean Architecture e SOLID.

## Características

- ✨ Interface moderna e responsiva
- 🌓 Suporte a tema claro/escuro
- 🔄 Gerenciamento de estado com Provider
- 🏗️ Arquitetura limpa e organizada (Clean Architecture)
- 🧪 Testes unitários e de integração
- 🔒 Tratamento robusto de erros
- 📱 Compatível com iOS e Android
- 💾 Persistência em cache local (In-memory com suporte a expansão para DB)

## Arquitetura

O projeto segue a Clean Architecture com uma clara separação de responsabilidades:

- **Presentation**: Interface do usuário, Controllers (estado da tela) e Providers (estado global).
- **Domain**: Entidades de negócio e Casos de Uso (Use Cases) **stateless**.
- **Data**: Implementações de Repositórios e DataSources (Remote e Local). Coordena a sincronização de dados.
- **Core**: Componentes compartilhados, injeção de dependência (GetIt) e configurações.

Para mais detalhes sobre a arquitetura, consulte o arquivo [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md).

## Operações Locais vs. Remotas

O aplicativo utiliza o padrão **Repository** como única fonte de verdade:

- **Operações de Leitura**: O Repositório tenta buscar dados da API e os armazena no `LocalDataSource`. Se a rede falhar, os dados locais são retornados.
- **Operações de Escrita**: Atualmente persistidas no `LocalDataSource`, garantindo que as alterações do usuário sejam refletidas imediatamente na sessão, mesmo sem persistência em disco ou API.
- **Sincronização**: O Repositório coordena a política de atualização entre a fonte remota e o cache local.

## Tecnologias Utilizadas

- Flutter
- Provider (Gerenciamento de Estado)
- GetIt (Injeção de Dependência)
- HTTP (Comunicação com API)
- Mockito (Mocks para Testes)

## Estrutura do Projeto

```
lib/
├── core/                 # Componentes compartilhados e utilitários
│   ├── di/              # Injeção de dependência (GetIt)
│   ├── error/           # Definições de falhas e exceções
│   ├── network/         # Cliente API e configurações
│   └── result/          # Wrapper para resultados (Success/Failure)
├── data/                # Camada de dados (Implementações)
│   ├── datasources/     # Fontes de dados (Local e Remote)
│   ├── models/          # DTOs e mapeamento JSON
│   └── repositories/    # Implementação dos contratos de repositório
├── domain/              # Camada de domínio (Contratos e Regras)
│   ├── entities/        # Entidades puras de negócio
│   ├── repositories/    # Interfaces dos repositórios
│   └── usecases/        # Casos de uso da aplicação (Stateless)
└── presentation/        # Camada de apresentação (UI)
    ├── controllers/     # Lógica e estado das telas
    ├── providers/       # Gerenciamento de estado global da UI
    ├── screens/         # Widgets de tela cheia
    ├── theme/           # Definição de temas (Claro/Escuro)
    └── widgets/         # Componentes reutilizáveis
```

## Funcionalidades

- [x] Listar todas as tarefas (API + Cache Local)
- [x] Adicionar nova tarefa
- [x] Marcar tarefa como concluída
- [x] Editar tarefa existente
- [x] Excluir tarefa
- [x] Tema claro/escuro
- [x] Tratamento de erros de rede
- [x] Feedback visual (Loading e Success/Error messages)

## Melhorias Futuras

### Funcionalidades
- Sincronização bidirecional com a API
- Categorias para organizar tarefas
- Datas de vencimento para tarefas
- Prioridades (alta, média, baixa)
- Subtarefas
- Filtros avançados (por data, categoria, prioridade)
- Busca de tarefas
- Compartilhamento de tarefas
- Modo offline completo (Offline-first)
- Backup e restauração de dados

### UX/UI
- Animações suaves nas transições e microinterações
- Gestos para ações rápidas (swipe para completar/excluir)
- Modo de visualização em lista/grade
- Temas personalizáveis
- Suporte a diferentes tamanhos de tela (Responsividade)
- Modo de foco (Pomodoro)
- Widgets para tela inicial
- Notificações para tarefas pendentes

### Performance
- Cache local persistente com Hive ou SQLite
- Paginação na lista de tarefas
- Otimização de imagens e recursos
- Compressão de dados
- Background sync
- Lazy loading de recursos

### Testes
- Testes de widget e integração abrangentes
- Testes de performance
- Testes de acessibilidade
- Testes de usabilidade
- Testes de segurança

### Internacionalização
- Suporte a múltiplos idiomas (i18n)
- Formatação de datas e números localizados
- Suporte a RTL (Right-to-Left)
- Adaptação a diferentes fusos horários

### Segurança
- Autenticação de usuários (OAuth/Firebase)
- Criptografia de dados sensíveis
- Proteção contra injeção de dados e validação rigorosa de entrada
- Logs de auditoria

## Como Executar

1. Clone o repositório:
```bash
git clone https://github.com/seu-usuario/todo_app.git
```

2. Instale as dependências:
```bash
flutter pub get
```

3. Execute o build_runner (para mocks):
```bash
dart run build_runner build --delete-conflicting-outputs
```

4. Execute o aplicativo:
```bash
flutter run
```

## Testes

Para executar a suíte completa de testes (Unitários + Integração):

```bash
flutter test
```

## Contribuição

1. Faça um fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

## Contato

Link para contato: [Milene Vieira Lopes](https://github.com/milenevi)


## Adicionar tarefa
[add tarefa.webm](https://github.com/user-attachments/assets/406be915-c48d-409e-9169-7a290bcee070)

## Editar tarefa
[Editar tarefa.webm](https://github.com/user-attachments/assets/2dcb4db4-b0b6-4d1a-85ed-aa089a8a95c1)

## Excluir tarefa
[Excluir tarefa.webm](https://github.com/user-attachments/assets/ea48cced-8cdd-48d1-8f65-3d6c41a8b718)

## Modo Dark
[modo dark.webm](https://github.com/user-attachments/assets/2b997a89-1ef7-4af3-a082-36093b5f33d7)

## Tela sobre
[tela sobre.webm](https://github.com/user-attachments/assets/9978dbf9-3560-4bfa-ad7c-17c155cef250)


