# Tailwind CSS

**LazyVim extra:** `lazyvim.plugins.extras.lang.tailwind`

## Tooling

| Category  | Tool                                        | Managed by |
| --------- | ------------------------------------------- | ---------- |
| LSP       | `tailwindcss` (tailwindcss-language-server) | Mason      |
| Formatter | —                                           | —          |
| Linter    | —                                           | —          |

The language server reads the project's `tailwind.config.*` file. Includes
`tailwindcss-colorizer-cmp.nvim` for color preview in completions.

## External Dependencies

| Dependency | Install             |
| ---------- | ------------------- |
| Node.js    | `brew install node` |

Tailwind CSS itself must be installed in the project (`npm install
tailwindcss`).
