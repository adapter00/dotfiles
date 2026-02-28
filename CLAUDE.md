# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

Personal dotfiles for a Go-focused backend developer using Neovim as the primary editor on macOS with Zsh, tmux, and cloud-native tooling (Kubernetes/GCP).

## Setup

```sh
git clone git@github.com:adapter00/dotfiles.git ~/.dotfiles
sh ~/.dotfiles/bootstrap  # creates symlinks
```

The `bootstrap` script symlinks config files into place. Neovim config lives at `~/.dotfiles/neovim/` and is symlinked to `~/.config/nvim/`.

## Neovim Plugin Management

Plugins are managed by **dein.vim**. Run these inside Neovim (not from shell):

```vim
:call dein#install()    " install new plugins
:call dein#update()     " update all plugins
:call dein#recache_runtimepath()  " fix plugin not loading
```

Plugin cache is at `~/.local/share/dein`. Two TOML files define plugins:
- `neovim/dein.toml` — eager-loaded at startup
- `neovim/dein_lazy.toml` — lazy-loaded by filetype/command

## Architecture

### Neovim (Hybrid VimScript + Lua)

Load order:
1. `neovim/init.vim` — dein setup, colorscheme, autocmds, sources `conf.d/*.vim`
2. `neovim/init.lua` — loads `lua/settings.lua`, `lua/plugins.lua`, calls `dap-go.setup()`
3. `~/.config/nvim/_init.lua` — machine-local overrides (not tracked in this repo)

Key directories:
- `neovim/conf.d/` — VimScript configs loaded via `runtime!`; `keymap.vim` has all bindings, `plugin.vim` has per-plugin settings
- `neovim/lua/` — Lua modules; `extra_settings.lua` loads files from `$EXTRA_VIM` (colon-separated paths) and auto-sources `.vimrc.local` files per directory
- `neovim/plugins/` — per-plugin Lua/VimScript configs loaded via dein hooks
- `neovim/ftplugin/` — filetype-specific settings (Go, Python, Ruby, Swift, YAML, JSON)

### AI Integration in Neovim

- **Copilot**: `github/copilot.vim` + `zbirenbaum/copilot.lua`
- **Avante.nvim**: `neovim/plugins/avante.lua` — uses Claude (`claude-sonnet-4-6` by default)

### Shell Functions (`.zsh-func`)

Key utilities using `peco` (interactive filter):
- `gcop` — switch git branches by recency
- `ghp` — navigate to ghq-managed repos
- `gpeco` — switch GCP configurations
- `kubeswitch` — interactive kubectl context switcher
- `peco-history-selection` — bound to `Ctrl+R`

## Go Development Standards

Go is the primary language. Project structure convention:
```
cmd/        # entry points
internal/   # private packages
pkg/        # public packages
configs/    # configuration files
scripts/    # build/deploy scripts
```

Key conventions:
- Lowercase package names, no stuttering (`user.User` not `user.UserStruct`)
- Error wrapping: `fmt.Errorf("context: %w", err)`
- Structured logging with `slog` (standard library)
- Table-driven tests with Arrange-Act-Assert pattern, 80%+ coverage target
- Context as first parameter for all I/O functions

Go toolchain managed via `asdf` golang plugin.

## Rules Directory

`rules/cursor/` contains Cursor IDE rule files:
- `go.mdc` — comprehensive Go backend development standards
- `code-guidelines.mdc` — Go code quality and testing strategy
- `chat-guideline.mdc` — interaction language enforcement (Japanese)

## Homebrew

`Brewfile` manages all macOS packages. After modifying:
```sh
brew bundle install --file=~/.dotfiles/Brewfile
```

## Language Notes

- **Go**: vim-lsp (gopls) handles LSP; format + organize imports on save; DAP debugging via `nvim-dap-go` + `vim-delve`
- **Python**: pyenv via asdf; interpreter configured at `$PYENV_ROOT/shims/python3`
- **Ruby**: rbenv; Rsense for omnifunc; vim-rspec + vim-dispatch for tests
- **Rust**: Racer completion; rustfmt on save
