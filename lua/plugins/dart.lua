-- Flutter / Dart development environment
-- LazyVim's lang.dart extra wires up dartls (via nvim-lspconfig), the Dart
-- Treesitter parser, conform's dart_format, and neotest-dart. It does NOT
-- provide the app-runtime tooling (:FlutterRun, hot reload, device/emulator
-- management, outline). This file adds flutter-tools.nvim for that.
--
-- The Flutter SDK is managed by asdf; its shim is on PATH, so flutter-tools
-- auto-detects the SDK by invoking `flutter` — no explicit flutter_path needed.

return {
  -- flutter-tools.nvim starts and owns its own dartls client. Left as-is, the
  -- lang.dart extra would ALSO start dartls through nvim-lspconfig, producing
  -- two competing clients on every Dart buffer. Returning true from LazyVim's
  -- per-server setup handler tells LazyVim the server is handled elsewhere, so
  -- lspconfig skips it and flutter-tools remains the sole owner.
  {
    "neovim/nvim-lspconfig",
    opts = {
      setup = {
        dartls = function()
          return true
        end,
      },
    },
  },

  {
    "nvim-flutter/flutter-tools.nvim",
    -- flutter-tools registers its :Flutter* user commands inside setup(), which
    -- only runs once the plugin loads. Loading on `ft = "dart"` alone means the
    -- commands don't exist until a Dart buffer is open. Listing them under `cmd`
    -- lets lazy.nvim create loader stubs so e.g. :FlutterDevices / :FlutterRun
    -- also work from a dashboard or empty buffer before any .dart file is opened.
    ft = "dart",
    cmd = {
      "FlutterRun",
      "FlutterDebug",
      "FlutterDevices",
      "FlutterEmulators",
      "FlutterReload",
      "FlutterRestart",
      "FlutterQuit",
      "FlutterAttach",
      "FlutterDetach",
      "FlutterOutlineToggle",
      "FlutterDevTools",
      "FlutterLspRestart",
      "FlutterPubGet",
      "FlutterPubUpgrade",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      -- The asdf `flutter` shim is a wrapper script, not a symlink, so
      -- flutter-tools' default detection (resolve exepath, go two dirs up)
      -- lands on ~/.asdf instead of the SDK and derives a non-existent
      -- ~/.asdf/bin/dart — dartls then fails to spawn. `asdf where flutter`
      -- prints the real install root (~/.asdf/installs/flutter/<version>),
      -- and keeps working across version switches.
      flutter_lookup_cmd = "asdf where flutter",
      -- Use nvim-dap (dap.core extra) for :FlutterDebug; flutter-tools
      -- registers the dart adapter and configurations itself.
      debugger = {
        enabled = true,
      },
      lsp = {
        -- NOTE: flutter-tools' lsp.color is deprecated on Neovim 0.12+, which
        -- renders LSP document colors natively — so it stays disabled here.
        settings = {
          showTodos = true,
          renameFilesWithClasses = "prompt",
          updateImportsOnRename = true,
          completeFunctionCalls = true,
        },
      },
      dev_log = {
        enabled = true,
        open_cmd = "tabedit", -- show `flutter run` logs in a new tab
      },
    },
  },
}
