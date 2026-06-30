# Ruby

**LazyVim extra:** `lazyvim.plugins.extras.lang.ruby`

## Tooling

| Category  | Tool                    | Managed by |
| --------- | ----------------------- | ---------- |
| LSP       | `ruby_lsp` (default)    | Mason      |
| Formatter | `rubocop`               | Mason      |
| Linter    | `erb-lint`              | Mason      |
| Debugger  | DAP via `nvim-dap-ruby` | Plugin     |

Alternative LSPs: `solargraph`, `rubocop`, `standardrb` (set via
`vim.g.lazyvim_ruby_lsp`).

## External Dependencies

### Homebrew (system Ruby)

| Dependency | Install               |
| ---------- | --------------------- |
| Ruby       | `brew install ruby`   |
| Bundler    | `gem install bundler` |

### rbenv

If using rbenv, `brew install ruby` is not needed.

```sh
# Install rbenv directly
brew install rbenv ruby-build

# Or via anyenv
anyenv install rbenv
```

Shell initialization (fish):

```fish
# When using rbenv directly
status --is-interactive; and rbenv init - fish | source

# When using anyenv — this initializes rbenv (and all other *envs) automatically
status --is-interactive; and anyenv init - fish | source
```

Install Ruby:

```sh
rbenv install 3.3.0   # desired version
rbenv global 3.3.0
gem install bundler
```

---

`ruby-lsp` and `rubocop` are typically installed per-project via Bundler,
though Mason can also manage them.
