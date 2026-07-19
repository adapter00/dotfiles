# nvim-tree NERDTree Compatibility Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Preserve core NERDTree split-opening and tree-resizing behavior in nvim-tree without changing winresizer in ordinary buffers.

**Architecture:** A focused `nvim_tree_compat` module owns tree-local mappings and wraps winresizer while temporarily releasing nvim-tree's fixed width. `plugins.lua` retains renderer configuration and global toggles. Resize operations are injected for deterministic headless tests.

**Tech Stack:** Neovim 0.11, Lua, lazy.nvim, nvim-tree.lua, winresizer

---

### Task 1: Add failing compatibility tests

**Files:**
- Create: `neovim/tests/nvim_tree_compat_spec.lua`

- [ ] **Step 1: Create the complete headless test script**

```lua
package.path = "neovim/lua/?.lua;" .. package.path

local failures = {}
local function test(name, fn)
  local ok, err = pcall(fn)
  if not ok then failures[#failures + 1] = name .. ": " .. tostring(err) end
end
local function eq(actual, expected, message)
  if actual ~= expected then
    error((message or "values differ") .. ": expected " .. tostring(expected) .. ", got " .. tostring(actual))
  end
end

test("on_attach installs compatibility mappings", function()
  local calls, default_bufnr = {}, nil
  local vertical, horizontal, plain = function() end, function() end, function() end
  package.loaded["nvim-tree.api"] = {
    map = { on_attach = { default = function(bufnr) default_bufnr = bufnr end } },
    node = { open = {
      vertical_no_picker = vertical,
      horizontal_no_picker = horizontal,
      no_window_picker = plain,
    } },
  }
  local original_set = vim.keymap.set
  vim.keymap.set = function(mode, lhs, rhs, opts)
    calls[lhs] = { mode = mode, rhs = rhs, opts = opts }
  end
  package.loaded.nvim_tree_compat = nil
  local compat = require("nvim_tree_compat")
  compat.on_attach(17)
  vim.keymap.set = original_set

  eq(default_bufnr, 17, "default mapping buffer")
  eq(calls.s.rhs, vertical, "s mapping")
  eq(calls.i.rhs, horizontal, "i mapping")
  eq(calls.o.rhs, plain, "o mapping")
  eq(calls["<CR>"].rhs, plain, "Enter mapping")
  eq(calls["<C-e>"].rhs, compat.resize_tree, "tree resize mapping")
  for _, lhs in ipairs({ "s", "i", "o", "<CR>", "<C-e>" }) do
    eq(calls[lhs].mode, "n", lhs .. " mode")
    eq(calls[lhs].opts.buffer, 17, lhs .. " buffer")
    eq(calls[lhs].opts.nowait, true, lhs .. " nowait")
    eq(calls[lhs].opts.silent, true, lhs .. " silent")
  end
end)

local function resize_ops(overrides)
  local state = {
    width = 30, fixed = true, valid = true, tree = true,
    persisted = nil, fixed_values = {}, restored_width = nil,
  }
  local ops = {
    current_win = function() return 4 end,
    win_buf = function() return 9 end,
    width = function() return state.width end,
    get_fixed = function() return state.fixed end,
    set_fixed = function(_, value)
      state.fixed = value
      state.fixed_values[#state.fixed_values + 1] = value
    end,
    valid = function() return state.valid end,
    is_tree = function() return state.tree end,
    set_width = function(_, width)
      state.width, state.restored_width = width, width
    end,
    run_resizer = function() state.width = 40 end,
    persist = function(width) state.persisted = width end,
  }
  for key, value in pairs(overrides or {}) do ops[key] = value end
  return state, ops
end

test("accepted resize is persisted", function()
  local state, ops = resize_ops()
  require("nvim_tree_compat").resize_tree(ops)
  eq(state.fixed_values[1], false, "fixed width released")
  eq(state.fixed_values[2], true, "fixed width restored")
  eq(state.persisted, 40, "new width persisted")
end)

test("canceled resize preserves restored width", function()
  local state, ops = resize_ops({ run_resizer = function() end })
  require("nvim_tree_compat").resize_tree(ops)
  eq(state.persisted, 30, "original width persisted")
end)

test("closed tree skips persistence", function()
  local state, ops = resize_ops()
  ops.run_resizer = function() state.valid = false end
  require("nvim_tree_compat").resize_tree(ops)
  eq(state.persisted, nil, "closed window not persisted")
end)

test("winresizer error restores state and is rethrown", function()
  local state, ops = resize_ops({ run_resizer = function() error("resize failed") end })
  local ok, err = pcall(require("nvim_tree_compat").resize_tree, ops)
  eq(ok, false, "error rethrown")
  assert(tostring(err):match("resize failed"), "original error retained")
  eq(state.restored_width, 30, "original width restored")
  eq(state.fixed, true, "fixed width restored")
  eq(state.persisted, nil, "failed width not persisted")
end)

if #failures > 0 then error(table.concat(failures, "\n")) end
print("PASS: nvim_tree_compat")
vim.cmd("qa!")
```

- [ ] **Step 2: Verify the test fails before implementation**

Run: `nvim --headless -u NONE -l neovim/tests/nvim_tree_compat_spec.lua`

Expected: non-zero exit with `module 'nvim_tree_compat' not found`.

- [ ] **Step 3: Keep the failing test for the GREEN step**

Do not commit the RED state. Carry this test into Task 2 and commit it with the passing implementation.

### Task 2: Implement the compatibility module

**Files:**
- Create: `neovim/lua/nvim_tree_compat.lua`

- [ ] **Step 1: Add the complete module**

```lua
local M = {}

local function default_resize_ops()
  return {
    current_win = vim.api.nvim_get_current_win,
    win_buf = vim.api.nvim_win_get_buf,
    width = vim.api.nvim_win_get_width,
    get_fixed = function(winid)
      return vim.api.nvim_get_option_value("winfixwidth", { win = winid })
    end,
    set_fixed = function(winid, value)
      vim.api.nvim_set_option_value("winfixwidth", value, { win = winid })
    end,
    valid = vim.api.nvim_win_is_valid,
    is_tree = function(bufnr) return vim.bo[bufnr].filetype == "NvimTree" end,
    set_width = vim.api.nvim_win_set_width,
    run_resizer = function() vim.cmd("WinResizerStartResize") end,
    persist = function(width)
      require("nvim-tree.api").tree.resize({ absolute = width })
    end,
  }
end

function M.resize_tree(ops)
  ops = ops or default_resize_ops()
  local winid = ops.current_win()
  local bufnr = ops.win_buf(winid)
  local original_width = ops.width(winid)
  local original_fixed = ops.get_fixed(winid)

  ops.set_fixed(winid, false)
  local resize_ok, resize_err = pcall(ops.run_resizer)
  local tree_is_valid = ops.valid(winid)
    and ops.win_buf(winid) == bufnr
    and ops.is_tree(bufnr)

  if not resize_ok and tree_is_valid then
    pcall(ops.set_width, winid, original_width)
  end
  local width = tree_is_valid and ops.width(winid) or nil

  local restore_ok, restore_err = true, nil
  if ops.valid(winid) then
    restore_ok, restore_err = pcall(ops.set_fixed, winid, original_fixed)
  end
  if not resize_ok then error(resize_err, 0) end
  if not restore_ok then error(restore_err, 0) end
  if tree_is_valid then ops.persist(width) end
end

function M.on_attach(bufnr)
  local api = require("nvim-tree.api")
  api.map.on_attach.default(bufnr)
  local opts = { buffer = bufnr, nowait = true, silent = true }
  vim.keymap.set("n", "s", api.node.open.vertical_no_picker, opts)
  vim.keymap.set("n", "i", api.node.open.horizontal_no_picker, opts)
  vim.keymap.set("n", "o", api.node.open.no_window_picker, opts)
  vim.keymap.set("n", "<CR>", api.node.open.no_window_picker, opts)
  vim.keymap.set("n", "<C-e>", M.resize_tree, opts)
end

return M
```

- [ ] **Step 2: Run the focused test**

Run: `nvim --headless -u NONE -l neovim/tests/nvim_tree_compat_spec.lua`

Expected: exit 0 with `PASS: nvim_tree_compat`.

- [ ] **Step 3: Commit the module**

```bash
git add neovim/lua/nvim_tree_compat.lua neovim/tests/nvim_tree_compat_spec.lua
git commit -m "fix: add nvim-tree NERDTree compatibility"
```

### Task 3: Wire the module into nvim-tree

**Files:**
- Modify: `neovim/lua/plugins.lua:6-29`

- [ ] **Step 1: Preserve icon settings and add on_attach plus global mappings**

```lua
      require("nvim-tree").setup({
        on_attach = require("nvim_tree_compat").on_attach,
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
      vim.keymap.set("n", "<C-n>n", ":NvimTreeToggle<CR>", { silent = true })
      vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { silent = true })
      vim.keymap.set("n", "<leader>E", ":NvimTreeFindFileToggle<CR>", { silent = true })
```

- [ ] **Step 2: Re-run focused tests**

Run: `nvim --headless -u NONE -l neovim/tests/nvim_tree_compat_spec.lua`

Expected: exit 0 with `PASS: nvim_tree_compat`.

- [ ] **Step 3: Load the real configuration headlessly**

```bash
nvim --headless -i NONE --cmd "set rtp^=/Users/adapter/workspaces/nvim-tree-nerdtree-compat/dotfiles/neovim" --cmd "lua package.path='/Users/adapter/workspaces/nvim-tree-nerdtree-compat/dotfiles/neovim/lua/?.lua;'..package.path" -u /Users/adapter/workspaces/nvim-tree-nerdtree-compat/dotfiles/neovim/init.lua "+lua local compat=require('nvim_tree_compat'); assert(require('nvim-tree.config').g.on_attach == compat.on_attach); assert(vim.fn.maparg('<leader>e', 'n') == ':NvimTreeToggle<CR>'); assert(vim.fn.maparg('<leader>E', 'n') == ':NvimTreeFindFileToggle<CR>'); print('PASS: integrated nvim-tree compatibility')" +qa!
```

Expected: exit 0 with `PASS: integrated nvim-tree compatibility` and no Lua errors.

- [ ] **Step 4: Check the patch**

```bash
git diff --check
git status --short --branch
```

Expected: no whitespace errors; status lists only the intended plan and `plugins.lua` changes.

- [ ] **Step 5: Commit integration**

```bash
git add neovim/lua/plugins.lua docs/superpowers/plans/2026-07-19-nvim-tree-nerdtree-compat.md
git commit -m "feat: enable nvim-tree NERDTree workflow"
```
