-- Python development environment
-- Extends LazyVim's lang.python extra with project-specific tuning.
-- The extra already wires up basedpyright, ruff (LSP + conform), venv-selector,
-- nvim-dap-python, and Treesitter. This file only adjusts what differs.

--- Check whether the project already has a Pyright configuration file.
--- When present, pyright reads it natively, so auto-detected settings
--- like extraPaths should not override those.
---@param root_dir string
---@return boolean
local function has_pyright_config(root_dir)
  if vim.uv.fs_stat(root_dir .. "/pyrightconfig.json") then
    return true
  end
  local pyproject = root_dir .. "/pyproject.toml"
  if vim.uv.fs_stat(pyproject) then
    for _, line in ipairs(vim.fn.readfile(pyproject)) do
      if line:match("^%[tool%.pyright") or line:match("^%[tool%.basedpyright") then
        return true
      end
    end
  end
  return false
end

--- Find the first virtual-environment directory by walking common names.
--- Searches root_dir first, then ancestors up to the filesystem root.
---@param root_dir string
---@return string|nil venv_dir Absolute path to the venv directory, or nil.
local function find_venv(root_dir)
  local candidates = { ".venv", "venv" }
  local found = vim.fs.find(candidates, {
    path = root_dir,
    upward = true,
    type = "directory",
  })[1]
  return found
end

--- Detect venv and src layout for a given project root.
---@param root_dir string
---@param analysis_ns string  "python" or "basedpyright"
---@return table extra  Settings to merge into the server config.
local function detect_project_settings(root_dir, analysis_ns)
  local extra = {}

  local venv_dir = find_venv(root_dir)
  if venv_dir then
    local python = venv_dir .. "/bin/python"
    if vim.uv.fs_stat(python) then
      local parent = vim.fn.fnamemodify(venv_dir, ":h")
      local name = vim.fn.fnamemodify(venv_dir, ":t")
      extra = vim.tbl_deep_extend("force", extra, {
        python = { pythonPath = python, venvPath = parent, venv = name },
      })
    end
  end

  if not has_pyright_config(root_dir) then
    local src = root_dir .. "/src"
    if vim.uv.fs_stat(src) then
      extra = vim.tbl_deep_extend("force", extra, {
        [analysis_ns] = { analysis = { extraPaths = { src } } },
      })
    end
  end

  return extra
end

--- Build static settings for pyright / basedpyright.
---@param analysis_ns string  "python" or "basedpyright"
---@return table
local function make_settings(analysis_ns)
  return {
    [analysis_ns] = {
      analysis = {
        typeCheckingMode = "standard",
        autoImportCompletions = true,
        diagnosticMode = "openFilesOnly",
      },
    },
  }
end

return {
  -- Tune pyright / basedpyright analysis settings and enable automatic
  -- detection of src layout and virtual environments (Pylance-like defaults).
  -- LazyVim's lang.python extra installs one of the two servers; configure
  -- both so whichever is present picks up the settings.
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {
          settings = make_settings("python"),
        },
        basedpyright = {
          settings = make_settings("basedpyright"),
        },
      },
    },
    init = function()
      -- Inject venv/src settings into pyright's config BEFORE the server
      -- starts.  FileType fires before the LSP client is created, so
      -- calling vim.lsp.config() here ensures the settings are part of
      -- the initial configuration — no post-init notification needed.
      local pyright_names = { pyright = "python", basedpyright = "basedpyright" }
      local configured_roots = {} ---@type table<string, boolean>

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "python",
        callback = function(args)
          local bufname = vim.api.nvim_buf_get_name(args.buf)
          if bufname == "" then
            return
          end
          local root = vim.fs.root(args.buf, {
            "pyproject.toml", "setup.py", "setup.cfg",
            "requirements.txt", "Pipfile", "pyrightconfig.json",
          })
          if not root or configured_roots[root] then
            return
          end
          configured_roots[root] = true

          for server, analysis_ns in pairs(pyright_names) do
            local extra = detect_project_settings(root, analysis_ns)
            if not vim.tbl_isempty(extra) then
              vim.lsp.config(server, { settings = extra })
            end
          end
        end,
      })
    end,
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
          local venv = find_venv(vim.fn.getcwd())
          if venv then
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
