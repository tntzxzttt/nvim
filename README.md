# 💤 LazyVim

A starter template for [LazyVim](https://github.com/LazyVim/LazyVim).
Refer to the [documentation](https://lazyvim.github.io/installation) to get started.

> [!WARNING]
>
> Inline image rendering requires a terminal with kitty graphics protocol support (e.g. Ghostty, kitty).
> iTerm2 is not supported.

## Install dependencies

Depending on the results of `:checkhealth`, install the following dependency tools.

```sh
brew install tree-sitter tree-sitter-cli ripgrep fd ghostscript tectonic
npm install -g @mermaid-js/mermaid-cli

# brew install luarocks
```

Why is the LuaRocks installation commented out? That's because it is not strictly recommended.

Given the planned transition to lux (as noted by [rocks.nvim warnings](https://github.com/lumen-oss/rocks.nvim/issues/539)), you may opt to skip installing LuaRocks until v3 is released. In that case, use the configuration below.

```lua
-- lua/config/lazy.lua
require("lazy").setup({
  rocks = {
    enabled = false,
  },
  -- ... existing config
})
```

## Development

### Commit Message Format

This repository uses [Lefthook](https://lefthook.dev/)
to run pre-commit hooks that check commit messages for compliance with
[Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/).

So you need to install Lefthook and set up the hooks before committing:

```sh
brew install lefthook
cd ~/.config/nvim
lefthook install
```

Don't forget to update `valid_scopes` in `.scripts/check-commit-msg.sh` when adding new configuration files or plugin modules.
