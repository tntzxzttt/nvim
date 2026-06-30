# Language Support

This directory documents the external dependencies required for each LazyVim
language extra enabled in [`lazyvim.json`](../../lazyvim.json).

Mason automatically installs LSP servers, formatters, linters, and debug
adapters. However, **language runtimes and compilers must be installed
manually** on the host machine.

## Quick Reference: Required Runtimes

| Runtime      | Install                              | Languages                                                                               |
| ------------ | ------------------------------------ | --------------------------------------------------------------------------------------- |
| Node.js      | `brew install node`                  | angular, astro, markdown, php (intelephense), prisma, svelte, tailwind, typescript, vue |
| Python       | `brew install python`                | ansible, python, sql                                                                    |
| Go           | `brew install go`                    | go                                                                                      |
| Java JDK     | `brew install openjdk`               | java, kotlin, scala                                                                     |
| Rust         | `brew install rustup && rustup-init` | rust                                                                                    |
| Elixir + OTP | `brew install elixir`                | elixir, erlang                                                                          |
| Dart SDK     | `brew install dart`                  | dart                                                                                    |
| Ruby         | `brew install ruby`                  | ruby                                                                                    |
| PHP          | `brew install php`                   | php                                                                                     |
| Terraform    | `brew install terraform`             | terraform                                                                               |
| TeX Live     | `brew install --cask mactex`         | tex                                                                                     |
| Helm         | `brew install helm`                  | helm                                                                                    |
| Coursier     | `brew install coursier`              | scala                                                                                   |

## Install All Runtimes

```sh
brew install node python go openjdk rustup dart ruby php terraform helm \
             elixir erlang coursier kotlin
brew install --cask mactex
rustup-init
rustup component add rust-analyzer
cs setup
```

## Language Pages

| Language                    | Doc                                            |
| --------------------------- | ---------------------------------------------- |
| [Angular](angular.md)       | LSP, formatter, and dependency details         |
| [Ansible](ansible.md)       | LSP, linter, and dependency details            |
| [Astro](astro.md)           | LSP, formatter, and dependency details         |
| [Dart](dart.md)             | LSP, formatter, and dependency details         |
| [Docker](docker.md)         | LSP, linter, and dependency details            |
| [Elixir](elixir.md)         | LSP and dependency details                     |
| [Erlang](erlang.md)         | LSP and dependency details                     |
| [Git](git.md)               | Plugin details                                 |
| [Go](go.md)                 | LSP, formatter, linter, and dependency details |
| [Helm](helm.md)             | LSP and dependency details                     |
| [Java](java.md)             | LSP, debugger, and dependency details          |
| [JSON](json.md)             | LSP details                                    |
| [Kotlin](kotlin.md)         | LSP, formatter, linter, and dependency details |
| [Markdown](markdown.md)     | LSP, formatter, linter, and dependency details |
| [PHP](php.md)               | LSP, formatter, linter, and dependency details |
| [Prisma](prisma.md)         | LSP and dependency details                     |
| [Python](python.md)         | LSP, formatter, linter, and dependency details |
| [Ruby](ruby.md)             | LSP, formatter, linter, and dependency details |
| [Rust](rust.md)             | LSP, formatter, and dependency details         |
| [Scala](scala.md)           | LSP and dependency details                     |
| [SQL](sql.md)               | Formatter, linter, and dependency details      |
| [Svelte](svelte.md)         | LSP, formatter, and dependency details         |
| [Tailwind](tailwind.md)     | LSP and dependency details                     |
| [Terraform](terraform.md)   | LSP, formatter, linter, and dependency details |
| [TeX](tex.md)               | LSP and dependency details                     |
| [TOML](toml.md)             | LSP details                                    |
| [TypeScript](typescript.md) | LSP, formatter, and dependency details         |
| [Vue](vue.md)               | LSP, formatter, and dependency details         |
