# nvim-tree NERDTree Compatibility Design

## Goal

Make the current `nvim-tree` setup preserve the user's core NERDTree workflow, including split-opening keys and resizing the tree through the existing winresizer interaction.

## Scope

- In an nvim-tree buffer, `s` opens the selected file in a vertical split.
- In an nvim-tree buffer, `i` opens the selected file in a horizontal split.
- `o` and `<CR>` open the selected file without invoking the window picker.
- `<C-n>n` remains available for toggling the tree.
- `<leader>e` also toggles the tree, and `<leader>E` toggles the tree while locating the current file.
- In an nvim-tree buffer, `<C-e>` starts the existing winresizer session. Its `h` and `l` inputs can change the tree width, Enter or Escape accepts the change, and `q` restores the original width.
- Existing winresizer behavior in non-tree windows remains unchanged.
- Existing icon-disabled rendering remains unchanged.

Full emulation of every NERDTree mapping is out of scope.

## Root Cause

`nvim-tree` marks its window with `winfixwidth`, while winresizer changes width through `:vertical resize`. Neovim therefore prevents winresizer from changing the tree width. `nvim-tree` also owns a configured width, so a raw window resize alone would not reliably survive closing and reopening the tree.

## Design

The nvim-tree `on_attach` callback will first install the plugin's default mappings and then add the compatibility mappings for `s`, `i`, `o`, `<CR>`, and `<C-e>`.

The tree-local `<C-e>` wrapper will:

1. Record the tree window, its width, and its `winfixwidth` value.
2. Temporarily clear `winfixwidth` on that specific window.
3. Invoke `WinResizerStartResize`, preserving winresizer's existing interaction and cancel behavior.
4. When winresizer returns, read the resulting tree width.
5. Restore `winfixwidth` even when the command fails or the user changes focus.
6. Persist the resulting width with `nvim-tree.api.tree.resize({ absolute = width })` when the tree window is still valid.

The wrapper will be isolated in a small Lua module so its window-state handling can be tested independently from the lazy.nvim plugin declaration. The plugin declaration will retain renderer settings and only connect `on_attach` and global toggle mappings.

## Error Handling

- If the recorded window closes during the session, the wrapper exits without attempting to resize it.
- `winfixwidth` restoration is guaranteed through protected cleanup.
- If winresizer raises an error, cleanup runs and the original error is reported.
- Width persistence occurs only for a valid nvim-tree window.

## Testing

Automated tests will cover:

- compatibility mappings call the intended nvim-tree APIs;
- a completed resize clears and restores `winfixwidth`, then persists the new width;
- a canceled resize persists the width restored by winresizer;
- an invalidated tree window is handled without an additional resize call;
- non-tree buffers keep the plugin's global `<C-e>` behavior.

A headless Neovim smoke check will load the configuration and confirm that the nvim-tree setup has no startup errors.
