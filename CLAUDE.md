# CLAUDE.md

This project manages Neovim (nvim) configuration files using Git.

The configuration is based on [LazyVim](https://www.lazyvim.org/).

## Guidelines

- Understand that this repository is for managing Neovim configuration.
- The setup is built on top of LazyVim, so follow its conventions when possible.

## GitHub Workflow

### Branches

- Never push directly to `main` or work on the `main` branch
- Always create a feature branch before making changes
- Format: `<type>/N-<title>` if an issue exists, otherwise `<type>/<title>`
  - `<type>`: Conventional Commits type (e.g. `feat`, `fix`, `chore`)
  - `N`: issue number
  - `<title>`: derived from the issue title, with the scope removed (the scope should be apparent from the title itself)
- Rules: lowercase only, characters limited to `[a-z0-9]` and `/-`
- Abbreviate or omit words if the title is too long (e.g. `kubernetes` → `k8s`)

Examples:

- `feat/12-add-bdelete-command` (for issue `[commands] Add layout-preserving :Bdelete command`)
- `fix/3-resolve-keymap-conflict` (for issue `[keymaps] Resolve keymap conflict`)

### Issues

- Open an issue before making changes to document the motivation, context, and goal
- This keeps a knowledge base of why each change was made, not just what changed
- Minor adjustments that need no discussion can skip an issue, but still require a PR
- The title format and body structure are defined solely by the issue template — do not restate or maintain a separate copy here:
  - `.github/ISSUE_TEMPLATE/default.md`
- When creating an issue non-interactively (e.g. via `gh`), read that template file first and fill in its sections; do not invent a different structure

### Commit Messages

- Follow the [Conventional Commits v1.0.0 specification](https://www.conventionalcommits.org/en/v1.0.0/)
- Include scope when the change targets a specific area of the configuration
- Scopes are flexible; use the name that best represents the area being changed (e.g. `plugins`, `keymaps`, `commands`, `options`)
- Scopes should be plural to match file/directory names where applicable
- Append `(#N)` if an issue exists; omit if not

```text
<type>(<scope>): <description> (#N)
```

Examples:

- `feat(commands): add layout-preserving :Bdelete command (#12)`
- `fix(keymaps): resolve keymap conflict (#3)`
- `chore: update dependencies`  ← no scope for non-configuration changes

### Pull Requests

**If linked to an issue:**

Run the following script:

```sh
./scripts/create-pull-request.sh N
```

**If not linked to an issue:**

- Title: sentence case (first word capitalized only)
- Use `##` or lower for headings (never `#`)

**Description:**

- The body structure (the `## Overview` section and its content for both
  linked and non-linked cases) is defined solely by the PR template — do not
  restate or maintain a separate copy here:
  - `.github/pull_request_template.md`
- Note: a PR template defines the body only; it cannot set the title.
  So the title rule above is not covered by the template and must stay here.
