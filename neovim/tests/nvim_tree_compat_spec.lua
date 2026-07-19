package.path = "neovim/lua/?.lua;" .. package.path

local failures = {}

local function test(name, fn)
  local ok, err = pcall(fn)
  if not ok then
    failures[#failures + 1] = name .. ": " .. tostring(err)
  end
end

local function eq(actual, expected, message)
  if actual ~= expected then
    error((message or "values differ") .. ": expected " .. tostring(expected) .. ", got " .. tostring(actual))
  end
end

test("on_attach installs compatibility mappings", function()
  local calls = {}
  local default_bufnr
  local vertical = function() end
  local horizontal = function() end
  local plain = function() end

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
    width = 30,
    fixed = true,
    valid = true,
    tree = true,
    persisted = nil,
    fixed_values = {},
    restored_width = nil,
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
      state.width = width
      state.restored_width = width
    end,
    run_resizer = function() state.width = 40 end,
    persist = function(width) state.persisted = width end,
  }
  for key, value in pairs(overrides or {}) do
    ops[key] = value
  end
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
  local state, ops = resize_ops({
    run_resizer = function() error("resize failed") end,
  })
  local ok, err = pcall(require("nvim_tree_compat").resize_tree, ops)
  eq(ok, false, "error rethrown")
  assert(tostring(err):match("resize failed"), "original error retained")
  eq(state.restored_width, 30, "original width restored")
  eq(state.fixed, true, "fixed width restored")
  eq(state.persisted, nil, "failed width not persisted")
end)

if #failures > 0 then
  error(table.concat(failures, "\n"))
end

print("PASS: nvim_tree_compat")
vim.cmd("qa!")
