# Python

**LazyVim extra:** `lazyvim.plugins.extras.lang.python`

This config extends the default LazyVim Python extra with custom settings in
[`lua/plugins/python.lua`](../../lua/plugins/python.lua).

## Tooling

| Category      | Tool                                   | Managed by               |
| ------------- | -------------------------------------- | ------------------------ |
| LSP           | `basedpyright`                         | Mason                    |
| LSP (linting) | `ruff`                                 | Mason                    |
| Formatter     | `ruff_format`, `ruff_organize_imports` | Mason (via conform.nvim) |
| Linter        | `mypy` (conditional)                   | pip / project venv       |
| Debugger      | `debugpy`                              | Mason                    |

### Custom Behavior

- **basedpyright** is used instead of the default `pyright`, with
  `typeCheckingMode = "standard"` and `diagnosticMode = "openFilesOnly"`.
- **ruff** handles both formatting and import sorting (replaces `isort` and
  `black`).
- **mypy** is only enabled when the project has `mypy.ini`, `.mypy.ini`, or
  `[tool.mypy]` in `pyproject.toml`.
- **venv-selector.nvim** auto-activates `.venv` at the project root on
  `FileType python`, setting `VIRTUAL_ENV`, `PATH`, and
  `python3_host_prog`.

## External Dependencies

| Dependency         | Install                                      |
| ------------------ | -------------------------------------------- |
| Python 3           | `brew install python`                        |
| uv (recommended)   | `brew install uv`                            |
| mypy (per-project) | `pip install mypy` or `uv tool install mypy` |

`basedpyright` and `ruff` are installed by Mason. `mypy` should be installed
in each project's virtual environment or globally.
