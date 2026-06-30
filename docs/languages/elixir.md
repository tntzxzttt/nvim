# Elixir

**LazyVim extra:** `lazyvim.plugins.extras.lang.elixir`

## Tooling

| Category  | Tool         | Managed by                          |
| --------- | ------------ | ----------------------------------- |
| LSP       | `elixirls`   | Mason                               |
| Formatter | `mix format` | Elixir (built-in)                   |
| Linter    | `credo`      | Conditional (requires `.credo.exs`) |

## External Dependencies

### Homebrew

| Dependency          | Install               |
| ------------------- | --------------------- |
| Elixir + Erlang/OTP | `brew install elixir` |

Erlang/OTP is pulled in automatically as a dependency of Elixir.

### asdf

asdf allows managing both Erlang and Elixir versions together via
`.tool-versions`.

```sh
asdf plugin add erlang
asdf plugin add elixir
asdf install erlang latest
asdf install elixir latest
asdf set --home erlang latest
asdf set --home elixir latest
```
