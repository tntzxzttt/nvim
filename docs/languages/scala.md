# Scala

**LazyVim extra:** `lazyvim.plugins.extras.lang.scala`

## Tooling

| Category  | Tool       | Managed by                          |
| --------- | ---------- | ----------------------------------- |
| LSP       | `metals`   | `nvim-metals` plugin (via Coursier) |
| Formatter | `scalafmt` | Metals (invoked internally)         |
| Linter    | —          | —                                   |

`nvim-metals` handles Metals installation automatically via Coursier.
Metals is **not** Mason-managed.

## External Dependencies

| Dependency | Install                 |
| ---------- | ----------------------- |
| JDK        | `brew install openjdk`  |
| Coursier   | `brew install coursier` |

```sh
brew install openjdk coursier
cs setup
```
