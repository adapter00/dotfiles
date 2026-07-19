# nvim-tree アイコン無効化 設計

## 目的

Ricty を端末フォントとして維持し、nvim-tree で Nerd Font 由来の文字が文字化けしないようにする。

## 変更範囲

- `neovim/lua/plugins.lua` の nvim-tree 設定だけを変更する。
- `renderer.icons.show` の全項目を無効化し、ファイル、フォルダ、展開矢印、Git、変更、非表示、診断、ブックマークの各アイコンを表示しない。
- `nvim-web-devicons` は fzf-lua でも利用しているため、依存関係から削除しない。
- iTerm2、Ricty、fzf-lua の設定は変更しない。

## 検証

- 変更前に、nvim-tree のアイコン表示設定が有効であることを headless Neovim で確認する。
- 変更後に、すべての nvim-tree アイコン表示設定が無効であることを headless Neovim で確認する。
- Neovim 設定全体がエラーなく読み込めることを確認する。
