# Todo App

Um aplicativo de lista de tarefas (Todo) desenvolvido com Flutter, seguindo os princípios da Clean Architecture e SOLID.

## Características

- ✨ Interface moderna e responsiva
- 🌓 Suporte a tema claro/escuro
- 🔄 Gerenciamento de estado com Provider
- 🏗️ Arquitetura limpa e organizada
- 🧪 Testes unitários e de integração
- 🔒 Tratamento robusto de erros
- 📱 Compatível com iOS e Android
- 🔄 Operações locais para criar, editar e excluir tarefas

## Arquitetura

O projeto segue a Clean Architecture com as seguintes camadas:

- **Presentation**: Interface do usuário e controladores (Provider)
- **Domain**: Regras de negócio, entidades e operações locais
- **Data**: Acesso e manipulação de dados
- **Core**: Componentes compartilhados (GetIt)

Para mais detalhes sobre a arquitetura, consulte o arquivo [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md).

## Operações Locais vs. Remotas

- **Operações de Leitura**: Inicialmente carregadas da API, depois armazenadas localmente
- **Operações de Escrita**: Realizadas apenas localmente (criar, atualizar, excluir)
- **Sincronização**: Apenas em uma direção (API → Local) durante o carregamento inicial

## Tecnologias Utilizadas

- Flutter
- Provider (Gerenciamento de Estado)
- GetIt (Injeção de Dependência)
- HTTP (Comunicação com API)

## Estrutura do Projeto

```
lib/
├── core/                 # Componentes compartilhados
│   ├── di/              # Injeção de dependência (GetIt)
│   ├── error/           # Tratamento de erros
│   └── network/         # Configuração de rede
├── data/                # Camada de dados
├── domain/              # Camada de domínio
│   ├── entities/        # Entidades e interfaces
│   ├── models/          # Implementações de entidades
│   ├── repositories/    # Interfaces de repositório
│   └── usecases/        # Regras de negócio e operações locais
└── presentation/        # Camada de apresentação
    ├── controllers/     # Controladores locais
    ├── providers/       # Gerenciamento de estado global
    ├── screens/         # Telas do aplicativo
    ├── theme/           # Configuração de temas
    └── widgets/         # Componentes reutilizáveis
```

## Funcionalidades

- [x] Listar todas as tarefas
- [x] Adicionar nova tarefa
- [x] Marcar tarefa como concluída
- [x] Editar tarefa existente
- [x] Excluir tarefa
- [x] Tema claro/escuro
- [x] Tratamento de erros
- [x] Feedback visual de ações

## Como Executar

1. Clone o repositório:
```bash
git clone https://github.com/seu-usuario/todo_app.git
```

2. Instale as dependências:
```bash
flutter pub get
```

3. Execute o aplicativo:
```bash
flutter run
```

## Testes

Para executar os testes:

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

Link do Projeto: [https://github.com/seu-usuario/todo_app](https://github.com/seu-usuario/todo_app)
