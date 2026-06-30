# TypeScript

**LazyVim extra:** `lazyvim.plugins.extras.lang.typescript`

## Tooling

| Category  | Tool               | Managed by |
| --------- | ------------------ | ---------- |
| LSP       | `vtsls` (default)  | Mason      |
| Formatter | `prettier`         | Mason      |
| Linter    | —                  | —          |
| Debugger  | `js-debug-adapter` | Mason      |

Alternative LSPs: `tsgo`, `tsserver`, `ts_ls` (set via
`vim.g.lazyvim_ts_lsp`).

DAP supports Node, Chrome, and Edge environments. `tsx` or `ts-node` is used
as the TypeScript runtime for debugging if available in the project.

## External Dependencies

| Dependency | Install             |
| ---------- | ------------------- |
| Node.js    | `brew install node` |
