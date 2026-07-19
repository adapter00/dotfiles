# nvim-tree and Telescope Keymap Simplification Plan

## Goal

Remove overlapping file-navigation mappings, expose a small NERDTree-style tree keyset including `t`, and keep Telescope as the only fuzzy finder.

## Task 1: Lock the desired tree whitelist with tests

- Update `neovim/tests/nvim_tree_compat_spec.lua` with mock API functions for tab opening, navigation, file operations, reload, close, and help.
- Assert that `api.map.on_attach.default` is not called.
- Assert the exact buffer-local mapping table from the design, including `t -> api.node.open.tab`.
- Run `nvim --headless -u NONE -l neovim/tests/nvim_tree_compat_spec.lua` and confirm it fails because defaults are still installed and `t` is absent.

## Task 2: Implement the minimal nvim-tree mappings

- Modify `neovim/lua/nvim_tree_compat.lua` to remove the default mapping installer.
- Register only the approved open, tab, split, navigation, file-operation, reload, close, help, and resize callbacks.
- Re-run the focused test and confirm it passes.
- Commit the test and implementation together.

## Task 3: Separate global file-navigation mappings

- Modify `neovim/lua/keymaps.lua`:
  - `[q` / `]q` for QuickFix.
  - `<C-p>` for Telescope files.
  - `<leader>b` for Telescope buffers.
  - `<leader>g` for Telescope live grep.
  - remove the older Telescope aliases.
- Modify `neovim/lua/plugins.lua`:
  - change nvim-tree toggle from `<C-n>n` to `<C-n>`;
  - retain `<leader>E`;
  - remove duplicate `<leader>e`;
  - remove `junegunn/fzf` and `ibhagwan/fzf-lua`.
- Run the real configuration headlessly and assert every global mapping plus absence of fzf/fzf-lua.
- Commit the global integration.

## Task 4: Final verification

- Re-run the focused Lua tests.
- Load the real configuration and open NvimTree.
- Assert the exact whitelisted buffer mappings, global mappings, and the real resize behavior.
- Run `git diff --check` and verify the worktree is clean.
