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
          -- on_new_config runs after nvim-lspconfig builds the server config but
          -- before the LSP client starts.  Unlike before_init, modifications to
          -- new_config.settings here are guaranteed to reach the server in the
          -- initial workspace/configuration payload.
          on_new_config = function(new_config, root_dir)
            local python = root_dir .. "/.venv/bin/python"
            if vim.uv.fs_stat(python) then
              new_config.settings = vim.tbl_deep_extend("force", new_config.settings or {}, {
                python = { pythonPath = python },
              })
            end
          end,
          settings = {
            python = {
              -- Declarative fallback: tells basedpyright where to look for a
              -- venv even when on_new_config does not find one.
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

  -- Enable mypy only when the project has mypy configuration.
  -- Without config, mypy's defaults are too noisy and the project likely
  -- relies on basedpyright alone for type checking.
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      local has_mypy_config = vim.fs.find({
        "mypy.ini",
        ".mypy.ini",
      }, { path = vim.fn.getcwd(), upward = true })[1]
        or (function()
          local pyproject = vim.fs.find("pyproject.toml", { path = vim.fn.getcwd(), upward = true })[1]
          if not pyproject then
            return false
          end
          local content = vim.fn.readfile(pyproject)
          for _, line in ipairs(content) do
            if line:match("^%[tool%.mypy") then
              return true
            end
          end
          return false
        end)()

      if has_mypy_config then
        opts.linters_by_ft = opts.linters_by_ft or {}
        opts.linters_by_ft.python = { "mypy" }
      end
    end,
  },
}
