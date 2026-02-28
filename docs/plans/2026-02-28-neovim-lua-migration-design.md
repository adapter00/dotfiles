# Neovim 完全 Lua 化 + zshrc 最適化 設計書

Date: 2026-02-28

## 概要

- `init.vim` + `dein.vim` から `init.lua` + `lazy.nvim` へ完全移行
- `vim-lsp` + `deoplete` を `nvim-lspconfig` + `nvim-cmp` に置換
- VimScript 設定ファイル（`conf.d/`）を Lua に移植
- `dein.toml` / `dein_lazy.toml` を廃止
- `.zshrc` のパフォーマンス問題・バグを修正

## 新ファイル構成

```
neovim/
├── init.lua                  # 新エントリーポイント（init.vim を廃止）
├── lua/
│   ├── settings.lua          # 既存のまま（変更なし）
│   ├── plugins.lua           # lazy.nvim 設定に完全置換
│   ├── keymaps.lua           # keymap.vim を Lua に移植
│   ├── autocmds.lua          # init.vim の autocmd を Lua に移植
│   ├── lsp.lua               # nvim-lspconfig + nvim-cmp の新設定
│   └── extra_settings.lua    # 既存のまま（変更なし）
└── plugins/
    ├── ale.lua               # ale.vim を Lua に変換
    ├── avante.lua            # 既存のまま（Lua 済み）
    └── quickrun.lua          # quickrun.vim を Lua に変換
```

削除ファイル:
- `init.vim`
- `conf.d/keymap.vim`
- `conf.d/plugin.vim`
- `dein.toml`
- `dein_lazy.toml`
- `plugins/vim-lsp.vim`

## プラグイン整理

### 削除（レガシー・重複・未使用）

| プラグイン | 理由 |
|-----------|------|
| `deoplete.nvim`、`deoplete-vim-lsp` | nvim-cmp で代替 |
| `asyncomplete.vim`、`asyncomplete-lsp.vim`、`async.vim` | nvim-cmp で代替 |
| `vim-lsp`、`vim-lsp-settings` | nvim-lspconfig で代替 |
| `Shougo/neocomplcache-rsense.vim` | 未使用 |
| `roxma/nvim-yarp`、`roxma/vim-hug-neovim-rpc` | deoplete 依存のため不要 |
| `Shougo/vimproc.vim` | 非同期処理はネイティブで対応 |
| `vim-scripts/The-NERD-tree` | nvim-tree/nvim-tree.lua で代替 |
| `vim-scripts/The-NERD-Commenter` | numToStr/Comment.nvim で代替 |
| `Shougo/neomru.vim` | Denite 依存、不要 |
| `Shougo/denite.nvim` | telescope.nvim で代替（すでに登録済み） |
| `vim-scripts/ZenCoding.vim`、`vim-scripts/ref.vim`、`rickard/project.vim` | 事実上未使用 |
| `kballard/vim-swift`、`keith/swift.vim`、`toyamarinyon/vim-swift` | 重複、`Keithbsmiley/swift.vim` のみ残す |
| `simeji/winresizer`（重複）、`roxma/vim-hug-neovim-rpc`（重複）、`dense-analysis/ale`（重複）、`tpope/vim-fugitive`（重複） | 重複エントリ削除 |

### 新規追加

| プラグイン | 用途 |
|-----------|------|
| `folke/lazy.nvim` | プラグインマネージャー |
| `neovim/nvim-lspconfig` | LSP クライアント |
| `hrsh7th/cmp-nvim-lsp` | nvim-cmp LSP ソース |
| `hrsh7th/cmp-vsnip` | nvim-cmp vsnip ソース |
| `nvim-tree/nvim-tree.lua` | NERDTree 代替 |
| `numToStr/Comment.nvim` | NERDCommenter 代替 |

## LSP 設計

`lua/lsp.lua` に集約。gopls のみ設定（現行動作を維持）。

- 保存時 format + organize imports（Go）
- キーマップ: `<C-]>` 定義ジャンプ、`<C-l>lh` Hover、`<C-l>lr` Rename、`<C-l>lf` Format

## zshrc 修正内容

| 問題 | 修正 |
|-----|------|
| `brew --prefix` を毎回実行（遅い） | `HOMEBREW_PREFIX=/opt/homebrew` にハードコード |
| `fpath` に `/usr/local/share/zsh-completions` を重複追加 | 1つに統合 |
| `kubectl completion zsh` を毎回 eval（起動遅延） | キャッシュファイル方式に変更 |
| `SCVIM_TAGFILE` の重複設定 | 1つに統合 |
| `export CLICOLOR=1` の重複 | 1つに統合 |
| `set zsh-keybind`（無効なコマンド） | 削除 |
| `if [ /usr/local/bin/kubectl ]`（常に true） | `if [ -f /usr/local/bin/kubectl ]` に修正 |
| `compinit -u`（セキュリティ警告無視） | そのまま維持（実害なし、変更リスク回避） |
