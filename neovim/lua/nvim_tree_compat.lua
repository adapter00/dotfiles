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
    is_tree = function(bufnr)
      return vim.bo[bufnr].filetype == "NvimTree"
    end,
    set_width = vim.api.nvim_win_set_width,
    run_resizer = function()
      vim.cmd("WinResizerStartResize")
    end,
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

  if not resize_ok then
    error(resize_err, 0)
  end
  if not restore_ok then
    error(restore_err, 0)
  end
  if tree_is_valid then
    ops.persist(width)
  end
end

function M.on_attach(bufnr)
  local api = require("nvim-tree.api")

  local opts = { buffer = bufnr, nowait = true, silent = true }
  vim.keymap.set("n", "<CR>", api.node.open.no_window_picker, opts)
  vim.keymap.set("n", "o", api.node.open.no_window_picker, opts)
  vim.keymap.set("n", "l", api.node.open.no_window_picker, opts)
  vim.keymap.set("n", "t", api.node.open.tab, opts)
  vim.keymap.set("n", "s", api.node.open.vertical_no_picker, opts)
  vim.keymap.set("n", "i", api.node.open.horizontal_no_picker, opts)
  vim.keymap.set("n", "h", api.node.navigate.parent_close, opts)
  vim.keymap.set("n", "a", api.fs.create, opts)
  vim.keymap.set("n", "r", api.fs.rename, opts)
  vim.keymap.set("n", "d", api.fs.remove, opts)
  vim.keymap.set("n", "c", api.fs.copy.node, opts)
  vim.keymap.set("n", "x", api.fs.cut, opts)
  vim.keymap.set("n", "p", api.fs.paste, opts)
  vim.keymap.set("n", "R", api.tree.reload, opts)
  vim.keymap.set("n", "q", api.tree.close, opts)
  vim.keymap.set("n", "?", api.tree.toggle_help, opts)
  vim.keymap.set("n", "<C-e>", M.resize_tree, opts)
end

return M
