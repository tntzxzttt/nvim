# Go

**LazyVim extra:** `lazyvim.plugins.extras.lang.go`

## Tooling

| Category  | Tool                   | Managed by |
| --------- | ---------------------- | ---------- |
| LSP       | `gopls`                | Mason      |
| Formatter | `goimports`, `gofumpt` | Mason      |
| Linter    | `golangci-lint`        | Mason      |
| Debugger  | `delve`                | Mason      |
| Other     | `gomodifytags`, `impl` | Mason      |

## External Dependencies

| Dependency | Install           |
| ---------- | ----------------- |
| Go         | `brew install go` |

All Go tools (`gopls`, `goimports`, `gofumpt`, `golangci-lint`, `delve`,
`gomodifytags`, `impl`) are Mason-managed. Only the Go runtime itself needs
manual installation.
