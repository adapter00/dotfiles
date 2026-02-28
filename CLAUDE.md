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

**Note:** `bootstrap` is outdated and does not manage the Neovim symlink. The symlink must be created manually:
```sh
ln -s ~/.dotfiles/neovim/init.lua ~/.config/nvim/init.lua
```

## Neovim Plugin Management

Plugins are managed by **lazy.nvim**. Run these inside Neovim:

```vim
:Lazy          " open plugin dashboard
:Lazy sync     " install/update all plugins
:Lazy clean    " remove unused plugins
```

Plugin cache is at `~/.local/share/nvim/lazy/`.

## Architecture

### Neovim (Pure Lua)

Load order:
1. `neovim/init.lua` — lazy.nvim bootstrap, loads core modules, plugins, LSP
2. `~/.config/nvim/_init.lua` — machine-local overrides (not tracked in this repo)

Key files:
- `neovim/lua/settings.lua` — editor options (clipboard, colorscheme, etc.)
- `neovim/lua/keymaps.lua` — all keybindings
- `neovim/lua/autocmds.lua` — autocommands
- `neovim/lua/plugins.lua` — lazy.nvim plugin definitions
- `neovim/lua/lsp.lua` — LSP config (gopls via `vim.lsp.config` API)
- `neovim/lua/extra_settings.lua` — loads files from `$EXTRA_VIM` (colon-separated paths) and auto-sources `.vimrc.local` per directory
- `neovim/ftplugin/` — filetype-specific settings (Go, Python, Ruby, Swift, YAML, JSON)

### AI Integration in Neovim

- **Copilot**: `github/copilot.vim` のみ（copilot.lua は Node 22+ 要件のため削除）

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

## Homebrew

`Brewfile` manages all macOS packages. After modifying:
```sh
brew bundle install --file=~/.dotfiles/Brewfile
```

## Language Notes

- **Go**: `nvim-lspconfig` + `nvim-cmp` (gopls) handles LSP; format + organize imports on save; DAP debugging via `nvim-dap-go` + `vim-delve`
- **Python**: pyenv via asdf; interpreter configured at `$PYENV_ROOT/shims/python3`
- **Ruby**: rbenv; Rsense for omnifunc; vim-rspec + vim-dispatch for tests
- **Rust**: rustfmt on save (`rust-lang/rust.vim`)
