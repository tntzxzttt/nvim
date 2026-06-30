# Markdown

**LazyVim extra:** `lazyvim.plugins.extras.lang.markdown`

## Tooling

| Category  | Tool                                            | Managed by |
| --------- | ----------------------------------------------- | ---------- |
| LSP       | `marksman`                                      | Mason      |
| Formatter | `prettier`, `markdownlint-cli2`, `markdown-toc` | Mason      |
| Linter    | `markdownlint-cli2`                             | Mason      |

Includes `markdown-preview.nvim` for browser preview and
`render-markdown.nvim` for in-editor rendering.

## External Dependencies

| Dependency | Install             |
| ---------- | ------------------- |
| Node.js    | `brew install node` |

Node.js is required for `prettier`, `markdownlint-cli2`, and `markdown-toc`.
