# Java

**LazyVim extra:** `lazyvim.plugins.extras.lang.java`

## Tooling

| Category  | Tool                              | Managed by                      |
| --------- | --------------------------------- | ------------------------------- |
| LSP       | `jdtls`                           | Mason (via `nvim-jdtls` plugin) |
| Formatter | —                                 | —                               |
| Linter    | —                                 | —                               |
| Debugger  | `java-debug-adapter`, `java-test` | Mason                           |

Uses `nvim-jdtls` plugin instead of native lspconfig. Lombok support is
added automatically when Mason is available.

## External Dependencies

| Dependency | Install                |
| ---------- | ---------------------- |
| JDK        | `brew install openjdk` |

For a specific version:

```sh
brew install openjdk@21
```
