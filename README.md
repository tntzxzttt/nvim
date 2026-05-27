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
