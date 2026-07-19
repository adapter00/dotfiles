# nvim-tree and Telescope Keymap Simplification Design

## Goal

Make file navigation predictable by giving nvim-tree and Telescope separate, memorable global keys and reducing nvim-tree to a small NERDTree-style mapping set.

## Root Cause

The current configuration defines `<C-n>` for Telescope file search and `<C-n>n` for nvim-tree toggle. Because one mapping is a prefix of the other, Neovim waits for more input and may launch Telescope depending on the following key or timeout. QuickFix also defines `<C-n>` and `<C-p>`, while Telescope later overwrites them. nvim-tree additionally loads roughly forty default buffer mappings before adding compatibility aliases.

## Global Mappings

- `<C-n>` toggles nvim-tree.
- `<C-p>` opens Telescope file search.
- `<leader>b` opens Telescope buffer search.
- `<leader>g` opens Telescope live grep.
- `[q` and `]q` navigate to the previous and next QuickFix entries.
- `<leader>E` keeps locating the current file in nvim-tree.

The conflicting `<C-n>n` mapping and the older Telescope aliases `<C-c>`, `<C-n>`, `<C-z>`, `sB`, and `<leader><C-f>` will be removed.

## nvim-tree Buffer Mappings

nvim-tree defaults will not be installed. Only these buffer-local mappings will exist:

- `<CR>`, `o`, `l`: open without the window picker.
- `t`: open in a new tab.
- `s`: open in a vertical split.
- `i`: open in a horizontal split.
- `h`: close the current directory or navigate toward its parent.
- `a`, `r`, `d`: create, rename, and delete.
- `c`, `x`, `p`: copy, cut, and paste.
- `R`: reload the tree.
- `q`: close the tree.
- `?`: show mapping help.
- `<C-e>`: start the existing tree-compatible winresizer wrapper.

## Plugin Cleanup

Telescope remains the sole fuzzy finder. The unused `junegunn/fzf` and `ibhagwan/fzf-lua` plugin declarations will be removed. nvim-web-devicons remains because nvim-tree still declares it, while the existing icon display flags remain disabled.

## Implementation Boundaries

`neovim/lua/nvim_tree_compat.lua` remains responsible for tree buffer mappings and resize behavior. `neovim/lua/keymaps.lua` owns global Telescope and QuickFix mappings. `neovim/lua/plugins.lua` owns plugin declarations plus nvim-tree commands that must be registered after plugin setup.

## Testing

Headless tests will verify that:

- the nvim-tree default mapping installer is not called;
- every whitelisted tree key targets the intended nvim-tree API;
- `t` targets `api.node.open.tab`;
- the resize wrapper tests continue to pass;
- global tree, Telescope, and QuickFix mappings have the agreed commands;
- removed conflicting mappings and unused fuzzy-finder plugin declarations are absent;
- the real Neovim configuration loads and an actual NvimTree buffer exposes the whitelist.
