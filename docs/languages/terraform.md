# Terraform

**LazyVim extra:** `lazyvim.plugins.extras.lang.terraform`

## Tooling

| Category  | Tool            | Managed by              |
| --------- | --------------- | ----------------------- |
| LSP       | `terraformls`   | Mason                   |
| Formatter | `terraform fmt` | Terraform CLI (bundled) |
| Linter    | `tflint`        | Mason                   |

`terraform fmt` is called directly by conform.nvim and is **not**
Mason-managed. The Terraform binary must be in `$PATH`.

## External Dependencies

| Dependency | Install                  |
| ---------- | ------------------------ |
| Terraform  | `brew install terraform` |
| tflint     | `brew install tflint`    |
