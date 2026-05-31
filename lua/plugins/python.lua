-- Python development environment
-- Extends LazyVim's lang.python extra with project-specific tuning.
-- The extra already wires up basedpyright, ruff (LSP + conform), venv-selector,
-- nvim-dap-python, and Treesitter. This file only adjusts what differs.

return {
  -- Tune basedpyright analysis settings and enable automatic .venv detection.
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        basedpyright = {
          -- before_init fires just before the LSP server starts, giving us the
          -- LSP-resolved project root (params.rootPath) rather than just cwd.
          -- We use it to inject pythonPath so basedpyright uses the venv
          -- interpreter before it attempts any import resolution.
          before_init = function(params, config)
            local root = params.rootPath or vim.fn.getcwd()
            local python = root .. "/.venv/bin/python"
            if vim.fn.executable(python) == 1 then
              config.settings = vim.tbl_deep_extend("force", config.settings or {}, {
                python = { pythonPath = python },
              })
            end
          end,
          settings = {
            python = {
              -- Declarative fallback: even without before_init firing, pyright
              -- will resolve stubs/packages from .venv in the workspace root.
              venvPath = ".",
              venv = ".venv",
            },
            basedpyright = {
              -- "standard" catches real errors without strict-mode noise.
              -- "openFilesOnly" keeps diagnostics fast in large monorepos.
              analysis = {
                typeCheckingMode = "standard",
                autoImportCompletions = true,
                diagnosticMode = "openFilesOnly",
              },
            },
          },
        },
      },
    },
  },

  -- LazyVim defers venv-selector to the :VenvSelect command; override that so
  -- it loads when any Python file is opened.  The autocmd below then activates
  -- .venv automatically so the terminal, DAP (debugpy), and external tools
  -- (mypy, ruff) all inherit the correct interpreter without manual steps.
  {
    "linux-cultist/venv-selector.nvim",
    ft = "python",
    opts = {
      settings = {
        options = {
          activate_venv_in_terminal = true, -- propagate venv to :terminal buffers
          set_environment_variables = true, -- set VIRTUAL_ENV, etc.
        },
      },
    },
    config = function(_, opts)
      require("venv-selector").setup(opts)

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "python",
        once = true,
        callback = function()
          local venv = vim.fn.getcwd() .. "/.venv"
          if vim.fn.isdirectory(venv) == 1 then
            -- Set environment variables directly so tools launched from within
            -- Neovim (terminal, DAP, linters) inherit the right Python.
            -- Guard PATH against repeated prepends if the autocmd fires again.
            local bin = venv .. "/bin"
            if not vim.env.PATH:find(bin, 1, true) then
              vim.env.PATH = bin .. ":" .. vim.env.PATH
            end
            vim.env.VIRTUAL_ENV = venv
            vim.g.python3_host_prog = bin .. "/python"
          end
          -- Also restore any venv the user previously chose with :VenvSelect.
          pcall(require("venv-selector").retrieve_from_cache)
        end,
        desc = "Auto-activate .venv when opening a Python file",
      })
    end,
  },

  -- Ensure ruff_organize_imports runs alongside ruff_format.
  -- This replaces the need for a separate isort step.
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        python = { "ruff_format", "ruff_organize_imports" },
      },
    },
  },

  -- Add mypy for deep type checking (ruff's type checks are intentionally
  -- limited; mypy gives full PEP 484 inference).
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        python = { "mypy" },
      },
    },
  },
}
