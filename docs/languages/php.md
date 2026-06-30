# PHP

**LazyVim extra:** `lazyvim.plugins.extras.lang.php`

## Tooling

| Category  | Tool                                   | Managed by |
| --------- | -------------------------------------- | ---------- |
| LSP       | `phpactor` (default) or `intelephense` | Mason      |
| Formatter | `php-cs-fixer`                         | Mason      |
| Linter    | `phpcs`                                | Mason      |
| Debugger  | `php-debug-adapter`                    | Mason      |

To switch to `intelephense`, set `vim.g.lazyvim_php_lsp = "intelephense"`.
Note that `intelephense` requires Node.js.

## External Dependencies

| Dependency | Install            |
| ---------- | ------------------ |
| PHP        | `brew install php` |
