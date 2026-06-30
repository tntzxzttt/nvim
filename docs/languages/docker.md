# Docker

**LazyVim extra:** `lazyvim.plugins.extras.lang.docker`

## Tooling

| Category  | Tool                                          | Managed by |
| --------- | --------------------------------------------- | ---------- |
| LSP       | `dockerls`, `docker_compose_language_service` | Mason      |
| Formatter | —                                             | —          |
| Linter    | `hadolint`                                    | Mason      |

## External Dependencies

No external runtime is required for editing Dockerfiles. To run containers
locally:

```sh
brew install --cask docker
```
