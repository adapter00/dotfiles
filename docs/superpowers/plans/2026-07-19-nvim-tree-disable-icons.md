# nvim-tree Icon Disabling Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Ricty を維持したまま、nvim-tree のすべてのアイコン表示を無効化する。

**Architecture:** nvim-tree の既存 `setup()` に `renderer.icons.show` を追加し、8種類の表示フラグを明示的に `false` にする。`nvim-web-devicons` の依存関係は fzf-lua 用に残し、他プラグインの表示には影響させない。

**Tech Stack:** Neovim, Lua, lazy.nvim, nvim-tree.lua

---

### Task 1: nvim-tree のアイコン表示を無効化する

**Files:**
- Modify: `neovim/lua/plugins.lua:6-12`
- Test: headless Neovim による実設定のアサーション

- [ ] **Step 1: 変更前にアサーションが失敗することを確認する**

Run:

```bash
nvim --headless -i NONE "+lua local show=require('nvim-tree.config').g.renderer.icons.show; for _, name in ipairs({'file','folder','folder_arrow','git','modified','hidden','diagnostics','bookmarks'}) do assert(show[name] == false, name .. ' icon is enabled') end" +qa
```

Expected: FAIL with `file icon is enabled` because nvim-tree currently uses its default icon settings.

- [ ] **Step 2: 最小の設定変更を実装する**

Replace the empty setup call with:

```lua
require("nvim-tree").setup({
  renderer = {
    icons = {
      show = {
        file = false,
        folder = false,
        folder_arrow = false,
        git = false,
        modified = false,
        hidden = false,
        diagnostics = false,
        bookmarks = false,
      },
    },
  },
})
```

- [ ] **Step 3: アサーションが成功することを確認する**

Run:

```bash
nvim --headless -i NONE "+lua local show=require('nvim-tree.config').g.renderer.icons.show; for _, name in ipairs({'file','folder','folder_arrow','git','modified','hidden','diagnostics','bookmarks'}) do assert(show[name] == false, name .. ' icon is enabled') end; print('all nvim-tree icons disabled')" +qa
```

Expected: PASS with `all nvim-tree icons disabled` and exit code 0.

- [ ] **Step 4: Neovim 設定全体を検証する**

Run:

```bash
nvim --headless -i NONE "+lua print('Neovim config loaded')" +qa
git diff --check
```

Expected: both commands exit 0; Neovim prints `Neovim config loaded`, and `git diff --check` prints nothing.

- [ ] **Step 5: 実装をコミットする**

```bash
git add neovim/lua/plugins.lua docs/superpowers/plans/2026-07-19-nvim-tree-disable-icons.md
git commit -m "fix: disable nvim-tree icons"
```
