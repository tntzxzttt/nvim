local sensitive_patterns = {
  -- dotenv / direnv
  "%.env$",
  "%.env%.",
  "%.envrc$",

  -- certificates, private keys, encrypted stores
  "%.pem$",
  "%.key$",
  "%.crt$",
  "%.cer$",
  "%.pfx$",
  "%.p12$",
  "%.p8$",
  "%.ppk$",
  "%.jks$",
  "%.keystore$",
  "%.asc$",
  "%.gpg$",
  "%.age$",
  "%.kdbx$",

  -- credential directories (catches renamed keys the name patterns below miss)
  "/%.ssh/",
  "/%.aws/",
  "/%.kube/",
  "/%.gnupg/",
  "/%.docker/config%.json$",

  -- ssh material outside the standard directory
  "/id_rsa",
  "/id_ed25519",
  "/id_ecdsa",
  "/id_dsa",
  "/known_hosts$",
  "/authorized_keys$",

  -- service and registry credentials
  "/credentials$",
  "%.netrc$",
  "%.npmrc$",
  "%.pypirc$",
  "%.pgpass$",
  "%.secret$",
  "%.secrets$",
  "%.token$",

  -- terraform (state stores every attribute in plaintext)
  "%.tfstate$",
  "%.tfstate%.backup$",
  "%.tfvars$",
  "%.tfvars%.json$",
}

local allowed_patterns = {
  "%.env%.example$",
  "%.env%.template$",
  "%.env%.sample$",
}

return {
  "zbirenbaum/copilot.lua",
  opts = {
    suggestion = {
      enabled = true,
      auto_trigger = true,
      keymap = {
        accept = false, -- handled by blink.cmp
        next = "<M-]>",
        prev = "<M-[>",
      },
    },
    should_attach = function(bufnr, bufname)
      -- replaces the plugin default, so its guards have to be repeated here
      if not vim.bo[bufnr].buflisted or vim.bo[bufnr].buftype ~= "" then
        return false
      end
      for _, pattern in ipairs(allowed_patterns) do
        if bufname:match(pattern) then
          return true
        end
      end
      for _, pattern in ipairs(sensitive_patterns) do
        if bufname:match(pattern) then
          return false
        end
      end
      return true
    end,
  },
}
