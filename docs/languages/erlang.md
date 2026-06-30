# Erlang

**LazyVim extra:** `lazyvim.plugins.extras.lang.erlang`

## Tooling

| Category  | Tool       | Managed by |
| --------- | ---------- | ---------- |
| LSP       | `erlangls` | Mason      |
| Formatter | —          | —          |
| Linter    | —          | —          |

## External Dependencies

### Homebrew

| Dependency | Install               |
| ---------- | --------------------- |
| Erlang/OTP | `brew install erlang` |
| rebar3     | `brew install rebar3` |

`rebar3` is Erlang's build tool, required by Mason to build `erlang-ls`.

### asdf

asdf allows managing multiple Erlang versions per project via
`.tool-versions`.

```sh
asdf plugin add erlang
asdf install erlang 27.3.4
asdf set --home erlang 27.3.4
```

## Known Issues

### erlang-ls does not build on Erlang 29

As of erlang-ls 1.1.0 (latest release, also unfixed on main), its dependency
`katana_code` uses a `catch` syntax deprecated in Erlang 29. The build fails
with warnings-as-errors:

```plain
'catch ...' is deprecated; please use 'try ... catch ... end' instead.
```

**Workaround:** Use Erlang 27 until erlang-ls updates `katana_code`.
