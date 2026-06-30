# Angular

**LazyVim extra:** `lazyvim.plugins.extras.lang.angular`

## Tooling

| Category  | Tool                 | Managed by |
| --------- | -------------------- | ---------- |
| LSP       | `angularls`, `vtsls` | Mason      |
| Formatter | `prettier`           | Mason      |
| Linter    | —                    | —          |

## External Dependencies

| Dependency | Install             |
| ---------- | ------------------- |
| Node.js    | `brew install node` |

`@angular/language-server` is expected in the project's `node_modules` via
npm/yarn/pnpm.

This extra automatically pulls in `lang.typescript`.
