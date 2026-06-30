# Rust

**LazyVim extra:** `lazyvim.plugins.extras.lang.rust`

## Tooling

| Category  | Tool            | Managed by                |
| --------- | --------------- | ------------------------- |
| LSP       | `rust-analyzer` | **Manual** (via `rustup`) |
| Formatter | `rustfmt`       | Rust toolchain (bundled)  |
| Linter    | —               | —                         |
| Debugger  | `codelldb`      | Mason                     |

Uses `rustaceanvim` plugin instead of native lspconfig. Will error at
startup if `rust-analyzer` is not in `$PATH`.

**Important:** `rust-analyzer` is **not** Mason-managed. It must be installed
via `rustup`.

## External Dependencies

| Dependency     | Install                              |
| -------------- | ------------------------------------ |
| Rust toolchain | `brew install rustup && rustup-init` |
| rust-analyzer  | `rustup component add rust-analyzer` |

```sh
brew install rustup
rustup-init
rustup component add rust-analyzer
```
