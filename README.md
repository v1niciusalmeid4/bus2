# bus2 — RandomUser App (Flutter)

> App Flutter que consome a API **randomuser.me** para listar pessoas, exibir **detalhes** e gerenciar **usuários persistidos** localmente — implementado em **MVVM + Repository**, com **Ticker** (não `Timer`) executando a cada **5s** na Home.

---

## 🧱 Arquitetura

**MVVM + Repository strategy**:

```
lib/
  core/               # utilidades, db provider, injeção, etc.
  app/                # App, theme, rotas
  src/
    models/           # DTOs RandomUser
    repositories/     # remote/local 
    view_models/      # Home/Details/Persisted
    views/            # HomeView, UserDetailsView, PersistedUsers
    injectors/        # fábricas de ViewModel/Repos
```

### Features

- **Home**: lista usuários e executa **Ticker 5s** para buscar/atualizar dados; atalho para **Persistidos**.
- **Details**: exibe dados completos do usuário; permite **salvar/remover** no banco local.
- **Persisted (Persistidos)**: lista usuários salvos via `sqflite`, com ações de remoção e navegação.

---

## ⚙️ Tecnologias & Dependências

- **Flutter** (stable) e **Dart** compatível (ver `environment` no `pubspec.yaml`).
- **HTTP**: `http`
- **Persistência**: `sqflite`, `path`, `path_provider`
- **DI**: `get_it`

---

## ▶️ Como rodar

```bash
flutter --version          # verifique que está no canal stable
flutter pub get            # baixar dependências
flutter run -d chrome      # Web
# ou
flutter run -d emulator-5554  # Android emulador
# ou
flutter run -d ios         # iOS (requer macOS)
```

---

### iOS (CocoaPods em Apple Silicon)
```bash
cd ios
arch --x86_64 pod install --repo-update
cd ..
```

---

## 🧠 Estado & **Ticker** (5s)

- O **Ticker** é injetado/controlado pela `HomeViewModel` (com `TickerProviderStateMixin` na *View*).
- A cada *tick* (5s), o *ViewModel* dispara `loadMore()` e atualiza o estado da lista.
- Cancelamento no `dispose()` para evitar *leaks* e atualizações após a tela ser destruída.

> **Por que Ticker e não Timer?** O requisito pede explicitamente Ticker. Ele integra com o *scheduler* do Flutter, respeitando o *lifecycle* da tela/animador e reduzindo riscos de *drift* ou *timers órfãos*.

---

## 💾 Persistência (sqflite)

- Banco mínimo com tabela `users` (apenas os campos necessários à UI).
- **Mappers** convertem o json (API) → `UserModel` → `Map<String, dynamic>` (DB).
- Operações em um repositorio `Local`/`Remoto` isolando a `sqflite` do restante do app.
- Remoção/adição refletida imediatamente nas telas (via `notifyListeners()`/estado reativo).

---



