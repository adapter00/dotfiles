# Neovim Lua Migration Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Migrate Neovim config from `init.vim` + `dein.vim` to `init.lua` + `lazy.nvim`, replacing `vim-lsp`/`deoplete` with `nvim-lspconfig`/`nvim-cmp`, and fix `.zshrc` performance/bug issues.

**Architecture:** New `init.lua` bootstraps `lazy.nvim`, which manages all plugins. VimScript configs in `conf.d/` are replaced by `lua/keymaps.lua` and `lua/autocmds.lua`. LSP is handled by `nvim-lspconfig` + `nvim-cmp` in `lua/lsp.lua`.

**Tech Stack:** Neovim (Lua API), lazy.nvim, nvim-lspconfig, nvim-cmp, gopls, zsh

---

## Phase 1: lazy.nvim ブートストラップと新 init.lua

### Task 1: 新 init.lua を作成する

**Files:**
- Modify: `neovim/init.lua` (現在の内容を完全置換)

**Step 1: `neovim/init.lua` を以下の内容に書き換える**

```lua
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load core config
require("settings")
require("autocmds")
require("keymaps")

-- Load plugins (lazy.nvim)
require("plugins")

-- Load LSP
require("lsp")

-- Load extra settings ($EXTRA_VIM / .vimrc.local)
require("extra_settings")

-- Machine-local overrides (not tracked)
local local_init = vim.fn.stdpath("config") .. "/_init.lua"
if vim.loop.fs_stat(local_init) then
  dofile(local_init)
end
```

**Step 2: Neovim を起動して lazy.nvim がインストールされることを確認**

```bash
nvim --headless +qa 2>&1 | head -20
```

期待: エラーなし、または lazy.nvim のクローンメッセージのみ

**Step 3: コミット**

```bash
git add neovim/init.lua
git commit -m "feat: replace init.vim entrypoint with init.lua + lazy.nvim bootstrap"
```

---

### Task 2: lua/autocmds.lua を作成する

**Files:**
- Create: `neovim/lua/autocmds.lua`

`init.vim` の autocmd を Lua に移植。

**Step 1: `neovim/lua/autocmds.lua` を作成**

```lua
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Filetype detection
autocmd({"BufRead", "BufNewFile"}, { pattern = "*.md",       command = "set filetype=markdown" })
autocmd({"BufRead", "BufNewFile"}, { pattern = "*.c",        command = "set filetype=c" })
autocmd({"BufRead", "BufNewFile"}, { pattern = "Fastfile",   command = "set filetype=ruby" })
autocmd({"BufRead", "BufNewFile"}, { pattern = "Podfile",    command = "set filetype=ruby" })
autocmd({"BufRead", "BufNewFile"}, { pattern = "*.swift",    command = "set filetype=swift" })
autocmd({"BufRead", "BufNewFile"}, { pattern = "*.rs",       command = "set filetype=rust" })
autocmd({"BufEnter", "BufWinEnter", "BufNewFile", "BufRead"}, {
  pattern = {"*.sc", "*.scd"},
  command = "set filetype=supercollider"
})

-- Omnifunc
autocmd("FileType", { pattern = {"html", "markdown"}, command = "setlocal omnifunc=htmlcomplete#CompleteTags" })
autocmd("FileType", { pattern = "javascript",         command = "setlocal omnifunc=javascriptcomplete#CompleteJS" })
autocmd("FileType", { pattern = "cs",                 command = "setlocal omnifunc=OmniSharp#Complete" })
autocmd("FileType", { pattern = "ruby",               command = "setlocal omnifunc=rubycomplete#Complete" })

-- NERDTree: close if last window (nvim-tree に移行後は削除予定)
-- autocmd("BufEnter", { command = "..." })  -- nvim-tree が自動対応

-- QuickFix
autocmd("QuickfixCmdPost", { pattern = "[^l]*", command = "nested cwindow" })
autocmd("QuickfixCmdPost", { pattern = "l*",    command = "nested lwindow" })

-- PHP
autocmd("FileType", { pattern = "php", command = "set makeprg=php\\ -l\\ %" })
autocmd("BufWritePost", {
  pattern = "*.php",
  command = "silent make | if len(getqflist()) != 1 | copen | else | cclose | endif"
})

-- Rust quickrun
autocmd({"BufNewFile", "BufRead"}, {
  pattern = "*.rs",
  callback = function()
    vim.g.quickrun_config = vim.g.quickrun_config or {}
    vim.g.quickrun_config.rust = { exec = "cargo run" }
  end
})

-- .vimrc.local を自動 source
local vimrc_local_group = augroup("vimrc-local", { clear = true })
autocmd({"BufNewFile", "BufReadPost"}, {
  group = vimrc_local_group,
  callback = function()
    local loc = vim.fn.expand("<afile>:p:h")
    local files = vim.fn.findfile(".vimrc.local", vim.fn.escape(loc, " ") .. ";", -1)
    for _, f in ipairs(vim.fn.reverse(vim.tbl_filter(function(v)
      return vim.fn.filereadable(v) == 1
    end, files))) do
      vim.cmd("source " .. f)
    end
  end
})

-- SuperCollider: Unite keymaps（Unite 廃止済みのため Unite 部分は除外）
autocmd("FileType", {
  pattern = "supercollider",
  callback = function()
    vim.keymap.set("n", "<CR>",  ":call SClang_block()<CR>",    { buffer = true, silent = true })
    vim.keymap.set("v", "<CR>",  ":call SClang_send()<CR>",     { buffer = true, silent = true })
    vim.keymap.set("n", ".<CR>", ":call SClangHardstop()<CR>",  { buffer = true, silent = true })
  end
})
```

**Step 2: コミット**

```bash
git add neovim/lua/autocmds.lua
git commit -m "feat: add autocmds.lua migrating init.vim autocmds to Lua"
```

---

### Task 3: lua/keymaps.lua を作成する

**Files:**
- Create: `neovim/lua/keymaps.lua`

`conf.d/keymap.vim` を Lua に移植。

**Step 1: `neovim/lua/keymaps.lua` を作成**

```lua
local map = vim.keymap.set
local opts = { silent = true }

-- Terminal: ESC で normal モードへ
map("t", "<ESC>", "<C-\\><C-n>", opts)

-- ウィンドウ分割
map("n", "<C-x>1", ":only<CR>",  opts)
map("n", "<C-x>2", ":sp<CR>",    opts)
map("n", "<C-x>3", ":vsp<CR>",   opts)

-- ウィンドウ移動
map("n", "sj", "<C-w>j", opts)
map("n", "sk", "<C-w>k", opts)
map("n", "sl", "<C-w>l", opts)
map("n", "sh", "<C-w>s", opts)
map("n", "s=", "<C-w>=", opts)

-- タブ
map("n", "sn", "gt", opts)
map("n", "sp", "gT", opts)

-- QuickFix ナビゲーション
map("",  "<C-n>", ":cn<CR>", opts)
map("",  "<C-p>", ":cp<CR>", opts)

-- OmniComplete
map("i", "<C-Space>", "<C-x><C-o>", opts)

-- deoplete tab-complete (nvim-cmp 移行後は削除)
-- map("i", "<tab>", ...)  -- nvim-cmp が管理

-- Browser reload (vim-browsereload-mac)
map("n", "<Space>bc", ":ChromeReloadStart<CR>",  opts)
map("n", "<Space>bC", ":ChromeReloadStop<CR>",   opts)
map("n", "<Space>bf", ":FirefoxReloadStart<CR>", opts)
map("n", "<Space>bF", ":FirefoxReloadStop<CR>",  opts)
map("n", "<Space>bs", ":SafariReloadStart<CR>",  opts)
map("n", "<Space>bS", ":SafariReloadStop<CR>",   opts)
map("n", "<Space>bo", ":OperaReloadStart<CR>",   opts)
map("n", "<Space>bO", ":OperaReloadStop<CR>",    opts)
map("n", "<Space>ba", ":AllBrowserReloadStart<CR>", opts)
map("n", "<Space>bA", ":AllBrowserReloadStop<CR>",  opts)

-- GTags
map("n", "<Space>f", ":Gtags -f %<CR>",                        opts)
map("n", "<Space>j", ":GtagsCursor<CR>",                       opts)
map("n", "<Space>d", ":<C-u>exe('Gtags '.expand('<cword>'))<CR>", opts)
map("n", "<Space>r", ":<C-u>exe('Gtags -r '.expand('<cword>'))<CR>", opts)

-- Telescope (Denite の代替)
map("n", "<C-P>", ":Telescope buffers<CR>",   opts)
map("n", "<C-C>", ":Telescope find_files<CR>",opts)
map("n", "<C-N>", ":Telescope find_files<CR>",opts)
map("n", "<C-Z>", ":Telescope oldfiles<CR>",  opts)
map("n", "sB",    ":Telescope buffers<CR>",   opts)
map("n", "<leader><C-f>", ":Telescope live_grep<CR>", opts)

-- RSpec
map("n", "<leader>t", ":call RunCurrentSpecFile()<CR>", opts)

-- Delve (Go デバッグ)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function()
    map("n", ";d", ":DlvToggleBreakpoint<CR>", { buffer = true, silent = true })
  end
})
```

**Step 2: コミット**

```bash
git add neovim/lua/keymaps.lua
git commit -m "feat: add keymaps.lua migrating conf.d/keymap.vim to Lua"
```

---

## Phase 2: lua/plugins.lua を lazy.nvim 設定に置換

### Task 4: lua/plugins.lua を lazy.nvim 設定に書き換える

**Files:**
- Modify: `neovim/lua/plugins.lua` (packer 設定を完全置換)

**Step 1: `neovim/lua/plugins.lua` を以下に書き換える**

```lua
require("lazy").setup({

  -- ============================================================
  -- UI / ファイラー / ステータスライン
  -- ============================================================
  { "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup()
      vim.keymap.set("n", "<C-n>n", ":NvimTreeToggle<CR>", { silent = true })
    end
  },
  { "itchyny/lightline.vim" },
  { "simeji/winresizer" },
  { "sjl/gundo.vim" },

  -- ============================================================
  -- Git
  -- ============================================================
  { "tpope/vim-fugitive" },
  { "rhysd/conflict-marker.vim" },

  -- ============================================================
  -- 編集補助
  -- ============================================================
  { "tpope/vim-surround" },
  { "tpope/vim-endwise" },
  { "cohama/lexima.vim" },
  { "ConradIrwin/vim-bracketed-paste" },
  { "numToStr/Comment.nvim", config = function() require("Comment").setup() end },
  { "vim-utils/vim-man" },

  -- ============================================================
  -- ファジーファインダー
  -- ============================================================
  { "junegunn/fzf",         build = "./install --bin" },
  { "ibhagwan/fzf-lua",     dependencies = { "nvim-tree/nvim-web-devicons" } },
  { "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function() require("telescope").setup() end
  },

  -- ============================================================
  -- Treesitter
  -- ============================================================
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

  -- ============================================================
  -- LSP
  -- ============================================================
  { "neovim/nvim-lspconfig" },

  -- ============================================================
  -- 補完 (nvim-cmp)
  -- ============================================================
  { "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-vsnip",
      "hrsh7th/vim-vsnip",
      "hrsh7th/vim-vsnip-integ",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args) vim.fn["vsnip#anonymous"](args.body) end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<Tab>"]   = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
          ["<CR>"]    = cmp.mapping.confirm({ select = false }),
          ["<C-Space>"] = cmp.mapping.complete(),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "vsnip" },
        }),
      })
    end
  },

  -- ============================================================
  -- Linter
  -- ============================================================
  { "dense-analysis/ale",
    config = function()
      vim.g.ale_enable           = 1
      vim.g.ale_set_quickfix     = 0
      vim.g.ale_sign_column_always = 0
      vim.g.ale_lint_on_enter    = 1
      vim.g.ale_open_list        = 1
      vim.g.ale_keep_list_window_open = 0
      vim.g.ale_statusline_format = { "⨉ %d", "⚠ %d", "⬥ ok" }
      vim.g.ale_sign_error       = "⤫"
      vim.g.ale_sign_warning     = "⚠"
      vim.g.ale_linters          = { go = { "golint", "gobuild" } }
      vim.g.ale_fixers           = { ruby = { "rubocop" }, go = { "goimports" } }
      vim.g.ale_fix_on_save      = 0
    end
  },

  -- ============================================================
  -- DAP (デバッグ)
  -- ============================================================
  { "mfussenegger/nvim-dap" },
  { "rcarriga/nvim-dap-ui",  dependencies = { "mfussenegger/nvim-dap" } },
  { "leoluz/nvim-dap-go",
    ft = "go",
    config = function() require("dap-go").setup() end
  },
  { "sebdah/vim-delve", ft = "go" },

  -- ============================================================
  -- AI
  -- ============================================================
  { "github/copilot.vim" },
  { "zbirenbaum/copilot.lua",
    config = function() require("copilot").setup({}) end
  },
  { "yetone/avante.nvim",
    build = "make",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim",
      "nvim-treesitter/nvim-treesitter",
      "MunifTanjim/nui.nvim",
      "echasnovski/mini.pick",
      "nvim-telescope/telescope.nvim",
      "hrsh7th/nvim-cmp",
      "ibhagwan/fzf-lua",
      "nvim-tree/nvim-web-devicons",
      "zbirenbaum/copilot.lua",
      "HakonHarnes/img-clip.nvim",
    },
    config = function()
      dofile(vim.fn.expand("~/.dotfiles/neovim/plugins/avante.lua"))
    end
  },
  { "HakonHarnes/img-clip.nvim" },
  { "stevearc/dressing.nvim",   config = function() require("dressing").setup({}) end },
  { "MunifTanjim/nui.nvim" },
  { "echasnovski/mini.pick" },
  { "nvim-lua/plenary.nvim" },

  -- ============================================================
  -- Markdown / プレビュー
  -- ============================================================
  { "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "Avante" },
    config = function()
      require("render-markdown").setup({ file_types = { "markdown", "Avante" } })
    end
  },
  { "kannokanno/previm" },
  { "iamcco/markdown-preview.nvim",
    ft = "markdown",
    build = "cd app && yarn install",
    init = function() vim.g.mkdp_browser = "Safari" end
  },

  -- ============================================================
  -- 言語サポート
  -- ============================================================
  -- Rust
  { "rust-lang/rust.vim",
    ft = "rust",
    init = function()
      vim.g.rustfmt_autosave = 1
      vim.g.rustfmt_command  = "$HOME/.cargo/bin/rustfmt"
    end
  },
  { "rhysd/rust-doc.vim", ft = "rust" },

  -- Go
  { "ctrlpvim/ctrlp.vim", ft = "go" },

  -- Ruby
  { "szw/vim-tags",       ft = "ruby" },
  { "tpope/vim-dispatch", ft = "ruby" },
  { "thoughtbot/vim-rspec",
    ft = "ruby",
    init = function() vim.g.rspec_command = "Dispatch rspec {spec}" end
  },

  -- Swift
  { "Keithbsmiley/swift.vim", ft = "swift" },

  -- JavaScript
  { "pangloss/vim-javascript", ft = { "javascript", "typescript" } },
  { "prettier/vim-prettier",
    build = "npm install",
    ft = { "javascript", "typescript", "vue", "css", "scss", "json", "markdown", "graphql" }
  },

  -- SuperCollider
  { "sbl/scvim",
    ft = { "supercollider", "sc", "scd" },
    init = function()
      vim.g.sclangPipeApp    = "~/.vim/bundle/scvim/bin/start_pipe"
      vim.g.sclangDispatcher = "~/.vim/bundle/scvim/bin/sc_dispatcher"
    end
  },
  { "munshkr/vim-tidal" },

  -- その他言語
  { "uarun/vim-protobuf",   ft = "proto" },
  { "hashivim/vim-terraform", ft = { "terraform", "tf" } },
  { "aklt/plantuml-syntax", ft = { "uml", "plantuml" } },
  { "cespare/vim-toml",     ft = "toml" },
  { "kana/vim-filetype-haskell", ft = "haskell" },
  { "dag/vim2hs",           ft = "haskell" },
  { "milch/vim-fastlane" },

  -- ============================================================
  -- ユーティリティ
  -- ============================================================
  { "thinca/vim-quickrun",
    config = function()
      vim.g.quickrun_config = { supercollider = { command = "'<,'>call SClang_send()" } }
    end
  },
  { "mattn/webapi-vim" },
  { "tell-k/vim-browsereload-mac" },
  { "nathanaelkane/vim-indent-guides",
    init = function()
      vim.g.indent_guides_enable_on_vim_startup = 0
      vim.g.indent_guides_start_level           = 2
      vim.g.indent_guides_auto_colors           = 0
      vim.g.indent_guides_guide_size            = 1
    end
  },
  { "thinca/vim-localrc" },
  { "vim-scripts/Spacegray.vim" },
  { "whatyouhide/vim-gotham" },
  { "hrsh7th/vim-vsnip" },
  { "hrsh7th/vim-vsnip-integ" },

}, {
  -- lazy.nvim オプション
  install = { colorscheme = { "spacegray" } },
  checker = { enabled = false },
})
```

**Step 2: Neovim 起動確認**

```bash
nvim --headless "+Lazy sync" +qa 2>&1 | tail -5
```

**Step 3: コミット**

```bash
git add neovim/lua/plugins.lua
git commit -m "feat: replace packer plugins.lua with lazy.nvim config"
```

---

## Phase 3: LSP を nvim-lspconfig + nvim-cmp に移行

### Task 5: lua/lsp.lua を作成する

**Files:**
- Create: `neovim/lua/lsp.lua`

**Step 1: `neovim/lua/lsp.lua` を作成**

```lua
local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- LSP 共通キーマップ
local on_attach = function(client, bufnr)
  local bopts = { buffer = bufnr, silent = true }
  vim.keymap.set("n", "<C-]>",    vim.lsp.buf.definition,    bopts)
  vim.keymap.set("n", "<C-l>lh",  vim.lsp.buf.hover,         bopts)
  vim.keymap.set("n", "<C-l>lr",  vim.lsp.buf.rename,        bopts)
  vim.keymap.set("n", "<C-l>lf",  vim.lsp.buf.format,        bopts)
  vim.keymap.set("n", "<C-l>li",  vim.lsp.buf.implementation,bopts)
  vim.keymap.set("n", "<C-l>ll",  vim.lsp.buf.document_symbol, bopts)

  -- Go: 保存時 format + organize imports
  if client.name == "gopls" then
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format({ async = false, timeout_ms = 1000 })
        vim.lsp.buf.code_action({
          context = { only = { "source.organizeImports" } },
          apply   = true,
        })
      end,
    })
  end
end

-- gopls
lspconfig.gopls.setup({
  capabilities = capabilities,
  on_attach    = on_attach,
  cmd          = { "gopls", "-rpc.trace", "-logfile", "/tmp/gopls.log" },
  settings     = {
    gopls = {
      analyses        = { unusedparams = true },
      staticcheck     = true,
    }
  }
})
```

**Step 2: コミット**

```bash
git add neovim/lua/lsp.lua
git commit -m "feat: add lsp.lua with nvim-lspconfig + nvim-cmp for gopls"
```

---

## Phase 4: 旧ファイル削除

### Task 6: 旧 VimScript ファイルを削除する

**Files:**
- Delete: `neovim/init.vim`
- Delete: `neovim/conf.d/keymap.vim`
- Delete: `neovim/conf.d/plugin.vim`
- Delete: `neovim/dein.toml`
- Delete: `neovim/dein_lazy.toml`
- Delete: `neovim/plugins/vim-lsp.vim`

**Step 1: ファイルを削除**

```bash
git rm neovim/init.vim
git rm neovim/conf.d/keymap.vim
git rm neovim/conf.d/plugin.vim
git rm neovim/dein.toml
git rm neovim/dein_lazy.toml
git rm neovim/plugins/vim-lsp.vim
```

**Step 2: dein キャッシュを削除**

```bash
rm -rf ~/.local/share/dein
```

**Step 3: コミット**

```bash
git commit -m "chore: remove dein.vim configs and VimScript files replaced by Lua"
```

---

## Phase 5: 動作確認

### Task 7: Neovim の動作確認

**Step 1: Neovim を起動して lazy.nvim ダッシュボードを確認**

```bash
nvim
```

期待: エラーなし、`:Lazy` でプラグイン一覧が表示される

**Step 2: プラグインをインストール**

Neovim 内で:
```
:Lazy sync
```

期待: 全プラグインがインストールされる

**Step 3: LSP 動作確認（Go ファイルで）**

```bash
nvim /tmp/test.go
```

test.go の内容:
```go
package main

import "fmt"

func main() {
    fmt.Println("hello")
}
```

期待:
- gopls が起動する（`:LspInfo` で確認）
- `<C-]>` で定義ジャンプが動く
- `:w` 保存時に format と organize imports が実行される

**Step 4: 補完動作確認**

insert モードで `fmt.` と入力して補完候補が出ることを確認

**Step 5: Avante 動作確認**

```
:AvanteAsk
```

期待: Claude との対話が開く

**Step 6: コミット**

```bash
git add -A
git commit -m "chore: post-migration cleanup and verification"
```

---

## Phase 6: .zshrc 最適化

### Task 8: .zshrc のパフォーマンス問題とバグを修正する

**Files:**
- Modify: `.zshrc`

**Step 1: `.zshrc` を以下の差分で修正する**

修正箇所（上から順に）:

1. **`SCVIM_TAGFILE` の重複削除**（先頭の1行目を削除、137行目を残す）

2. **`fpath` の重複削除**（5行目を削除、25行目を残す）

3. **`brew --prefix` をハードコードに変更**（27行目）
   ```zsh
   # 変更前
   fpath=($(brew --prefix)/share/zsh/site-functions $fpath)
   # 変更後
   fpath=(/opt/homebrew/share/zsh/site-functions $fpath)
   ```

4. **`kubectl completion` をキャッシュ方式に変更**（144行目）
   ```zsh
   # 変更前
   if [ /usr/local/bin/kubectl ]; then source <(kubectl completion zsh); fi
   # 変更後
   if [ -f /usr/local/bin/kubectl ]; then
     _kubectl_cache="${XDG_CACHE_HOME:-$HOME/.cache}/kubectl-completion.zsh"
     if [ ! -f "$_kubectl_cache" ] || [ /usr/local/bin/kubectl -nt "$_kubectl_cache" ]; then
       kubectl completion zsh > "$_kubectl_cache"
     fi
     source "$_kubectl_cache"
   fi
   ```

5. **`set zsh-keybind` を削除**（119行目）— 無効なコマンドのため

6. **`export CLICOLOR=1` の重複を削除**（44行目の1回目を削除、62行目を残す）

**Step 2: 新しいシェルセッションで起動時間を測定**

```bash
time zsh -i -c exit
```

期待: 修正前より高速化（kubectl キャッシュが効いていれば 0.5〜1秒以上短縮される場合がある）

**Step 3: 動作確認**

```bash
# Kubernetes 補完が効くか
kubectl get <Tab>

# GCP 切り替えが効くか
gpeco

# Git ブランチ切り替えが効くか
gcop
```

**Step 4: コミット**

```bash
git add .zshrc
git commit -m "perf: optimize .zshrc startup time and fix bugs"
```

---

## 完了後

全タスク完了後:

```bash
git push origin feature/ai_rules
```

動作確認済みであれば PR を master へマージ。
