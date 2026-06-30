# TeX / LaTeX

**LazyVim extra:** `lazyvim.plugins.extras.lang.tex`

## Tooling

| Category  | Tool     | Managed by |
| --------- | -------- | ---------- |
| LSP       | `texlab` | Mason      |
| Formatter | —        | —          |
| Linter    | —        | —          |

Uses `vimtex` plugin for compilation, preview, and motions.

## External Dependencies

| Dependency       | Install                      |
| ---------------- | ---------------------------- |
| TeX distribution | `brew install --cask mactex` |

For a smaller install:

```sh
brew install --cask basictex
```

For PDF preview:

```sh
brew install --cask skim
```

The TeX distribution provides `pdflatex`, `lualatex`, `latexmk`, etc.
`texlab` is installed by Mason but requires a TeX distribution for
compilation.
