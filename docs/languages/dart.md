# Dart

**LazyVim extra:** `lazyvim.plugins.extras.lang.dart`

## Tooling

| Category  | Tool          | Managed by         |
| --------- | ------------- | ------------------ |
| LSP       | `dartls`      | Dart SDK (bundled) |
| Formatter | `dart format` | Dart SDK (bundled) |
| Linter    | —             | —                  |

## External Dependencies

| Dependency | Install             |
| ---------- | ------------------- |
| Dart SDK   | `brew install dart` |

For Flutter development, install Flutter instead (includes Dart):

```sh
brew install --cask flutter
```

Mason does not manage `dartls` or `dart format` — both are bundled with the
Dart SDK.
