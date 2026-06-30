# Vue

**LazyVim extra:** `lazyvim.plugins.extras.lang.vue`

## Tooling

| Category  | Tool                      | Managed by |
| --------- | ------------------------- | ---------- |
| LSP       | `vue_ls` (Volar), `vtsls` | Mason      |
| Formatter | `prettier`                | Mason      |
| Linter    | —                         | —          |

`@vue/typescript-plugin` bridges Vue and TypeScript inside `vtsls`.

This extra automatically pulls in `lang.typescript`.

## External Dependencies

| Dependency | Install             |
| ---------- | ------------------- |
| Node.js    | `brew install node` |
