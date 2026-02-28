# CLAUDE.md

このファイルは、このリポジトリで作業する際に Claude Code (claude.ai/code) へのガイダンスを提供します。

## 概要

`dein.vim` をプラグインマネージャーとして使用した **VimScript + Lua ハイブリッドアーキテクチャ** の Neovim 設定です。設定は `~/.dotfiles/neovim/` に置かれ、`~/.config/nvim` にシンボリックリンクされています。

## プラグイン管理

プラグインは **dein.vim**（非同期プラグインマネージャー）で管理され、2つの TOML ファイルで定義されています：
- `dein.toml` — 起動時に即時ロードするプラグイン
- `dein_lazy.toml` — 遅延ロードするプラグイン（ファイルタイプやコマンド単位）

プラグインのインストール・更新は Neovim 内で実行：
```vim
:call dein#install()
:call dein#update()
```

dein のキャッシュは `~/.local/share/dein` に保存されます。プラグインが読み込まれない場合は `:call dein#recache_runtimepath()` を実行してください。

## ロード順序

1. `init.vim` — dein セットアップ、カラースキーム、autocmd、`runtime! conf.d/*.vim`
2. `init.lua` — `lua/settings.lua`、`lua/plugins.lua` をロードし、`dap-go.setup()` を呼び出す
3. `~/.config/nvim/_init.lua` — マシンローカルの任意オーバーライド（このリポジトリには含まれない）

## ディレクトリ構成

- `conf.d/` — `runtime!` で読み込まれる共有 VimScript 設定
  - `keymap.vim` — 全キーバインド
  - `plugin.vim` — プラグイン個別設定（ステータスライン、Denite、Rust など）
- `lua/` — Lua モジュール（`settings.lua`、`plugins.lua`、`extra_settings.lua`）
- `plugins/` — dein フックで読み込まれるプラグイン別の Lua/VimScript 設定ファイル
- `ftplugin/` — ファイルタイプ別設定（Go、Python、Ruby、Swift、YAML、JSON）
- `syntax/` と `after/syntax/` — カスタムシンタックスオーバーライド

## 主要プラグイン設定

- **`plugins/avante.lua`** — Claude AI（Avante）。デフォルトプロバイダーは `claude-3-7-sonnet`
- **`plugins/vim-lsp.vim`** — LSP 設定。Go は保存時に format + organize imports を実行
- **`plugins/ale.vim`** — ALE リンター。Go は golint+gobuild、Ruby は rubocop を使用
- **`lua/extra_settings.lua`** — `$EXTRA_VIM` 環境変数（コロン区切りのパス）から追加設定を読み込む

## 言語別メモ

**Go**: `vim-lsp` + `mattn/vim-lsp-settings`（gopls）で LSP。保存時に format と organize imports。DAP デバッグは `nvim-dap-go` と `vim-delve`（遅延ロード）。

**Python**: `init.vim` で pyenv インタープリターを設定（`$PYENV_ROOT/shims/python3`）。

**Ruby**: Rsense で omnifunc 補完。`vim-rspec` + `vim-dispatch` で RSpec テスト（遅延ロード）。

**Rust**: Racer で補完、保存時に rustfmt を実行。`conf.d/plugin.vim` で設定。

## AI 統合

2つの AI ツールが設定されています：
1. **Copilot** — `github/copilot.vim` と `zbirenbaum/copilot.lua` の両方
2. **Avante.nvim** — `plugins/avante.lua` による Claude 統合

## キーバインドアーキテクチャ

全マッピングは `conf.d/keymap.vim` に集約：
- `s` プレフィックス — ウィンドウ分割/移動（`sj/sk/sl/sh`）、タブ（`sn/sp`）
- `<Space>b` プレフィックス — ブラウザリロード（Chrome/Firefox/Safari/Opera）
- `<C-p/c/n/z>` — Denite ファジーファインダー（バッファ/ファイル/履歴/レジスタ）
- `;d` — Delve ブレークポイントトグル（Go）

## 設定の拡張

- **マシンローカル設定**: `~/.config/nvim/_init.lua` を作成（自動的に読み込まれる）
- **ディレクトリ別設定**: 任意のディレクトリに `.vimrc.local` を作成（自動ソース）
- **追加 Lua 設定**: `$EXTRA_VIM` にコロン区切りのファイルパスを設定

## パフォーマンスデバッグ

`init.vim` 内の `ProfileCursorMove()` 関数が `/tmp/vim-profile.log` を生成し、カーソル移動の遅延診断に使用できます。
