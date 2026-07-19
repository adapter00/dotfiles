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

local original_set = vim.keymap.set

test("global file navigation mappings are separated", function()
  local mappings = {}
  vim.keymap.set = function(_, lhs, rhs)
    mappings[lhs] = rhs
  end
  dofile("neovim/lua/keymaps.lua")

  eq(mappings["<C-p>"], ":Telescope find_files<CR>", "file finder")
  eq(mappings["<leader>b"], ":Telescope buffers<CR>", "buffer finder")
  eq(mappings["<leader>g"], ":Telescope live_grep<CR>", "live grep")
  eq(mappings["[q"], ":cp<CR>", "previous QuickFix")
  eq(mappings["]q"], ":cn<CR>", "next QuickFix")

  for _, lhs in ipairs({ "<C-C>", "<C-N>", "<C-Z>", "sB", "<leader><C-f>", "<C-n>" }) do
    eq(mappings[lhs], nil, "removed global mapping " .. lhs)
  end
end)

test("Telescope is the only fuzzy finder and tree toggle is unambiguous", function()
  local specs
  package.loaded.lazy = { setup = function(value) specs = value end }
  dofile("neovim/lua/plugins.lua")

  local by_name = {}
  for _, spec in ipairs(specs) do
    by_name[spec[1]] = spec
  end
  eq(by_name["junegunn/fzf"], nil, "fzf removed")
  eq(by_name["ibhagwan/fzf-lua"], nil, "fzf-lua removed")
  assert(by_name["nvim-telescope/telescope.nvim"], "Telescope remains installed")

  local mappings = {}
  vim.keymap.set = function(_, lhs, rhs)
    mappings[lhs] = rhs
  end
  package.loaded["nvim-tree"] = { setup = function() end }
  package.loaded.nvim_tree_compat = { on_attach = function() end }
  by_name["nvim-tree/nvim-tree.lua"].config()

  eq(mappings["<C-n>"], ":NvimTreeToggle<CR>", "tree toggle")
  eq(mappings["<leader>E"], ":NvimTreeFindFileToggle<CR>", "find current file")
  eq(mappings["<C-n>n"], nil, "ambiguous tree toggle removed")
  eq(mappings["<leader>e"], nil, "duplicate tree toggle removed")
end)

vim.keymap.set = original_set

if #failures > 0 then
  error(table.concat(failures, "\n"))
end

print("PASS: file navigation configuration")
vim.cmd("qa!")
