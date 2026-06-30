# Svelte

**LazyVim extra:** `lazyvim.plugins.extras.lang.svelte`

## Tooling

| Category  | Tool                                       | Managed by |
| --------- | ------------------------------------------ | ---------- |
| LSP       | `svelte` (svelte-language-server), `vtsls` | Mason      |
| Formatter | `prettier`                                 | Mason      |
| Linter    | —                                          | —          |

`typescript-svelte-plugin` bridges TypeScript and Svelte inside `vtsls`.

This extra automatically pulls in `lang.typescript`.

## External Dependencies

| Dependency | Install             |
| ---------- | ------------------- |
| Node.js    | `brew install node` |
