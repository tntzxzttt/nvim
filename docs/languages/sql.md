# SQL

**LazyVim extra:** `lazyvim.plugins.extras.lang.sql`

## Tooling

| Category  | Tool       | Managed by |
| --------- | ---------- | ---------- |
| LSP       | —          | —          |
| Formatter | `sqlfluff` | Mason      |
| Linter    | `sqlfluff` | Mason      |

Database connections can be configured via `vim.g.dbs` for use with
`vim-dadbod`.

## External Dependencies

| Dependency | Install               |
| ---------- | --------------------- |
| Python     | `brew install python` |

`sqlfluff` is a Python package. Mason installs it, but Python must be
present on the system.
