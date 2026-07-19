local map = vim.keymap.set
local opts = { silent = true }

-- Terminal: ESC で normal モードへ
map("t", "<ESC>", "<C-\\><C-n>", opts)

-- ウィンドウ分割
map("n", "<C-x>1", ":only<CR>",  opts)
map("n", "<C-x>2", ":sp<CR>",    opts)
map("n", "<C-x>3", ":vsp<CR>",   opts)

-- ウィンドウ移動
map("n", "sj", "<C-w>j", opts)
map("n", "sk", "<C-w>k", opts)
map("n", "sl", "<C-w>l", opts)
map("n", "sh", "<C-w>s", opts)
map("n", "s=", "<C-w>=", opts)

-- タブ
map("n", "sn", "gt", opts)
map("n", "sp", "gT", opts)

-- QuickFix ナビゲーション
map("n", "]q", ":cn<CR>", opts)
map("n", "[q", ":cp<CR>", opts)

-- OmniComplete
map("i", "<C-Space>", "<C-x><C-o>", opts)

-- deoplete tab-complete (nvim-cmp 移行後は削除)
-- map("i", "<tab>", ...)  -- nvim-cmp が管理

-- Browser reload (vim-browsereload-mac)
map("n", "<Space>bc", ":ChromeReloadStart<CR>",  opts)
map("n", "<Space>bC", ":ChromeReloadStop<CR>",   opts)
map("n", "<Space>bf", ":FirefoxReloadStart<CR>", opts)
map("n", "<Space>bF", ":FirefoxReloadStop<CR>",  opts)
map("n", "<Space>bs", ":SafariReloadStart<CR>",  opts)
map("n", "<Space>bS", ":SafariReloadStop<CR>",   opts)
map("n", "<Space>bo", ":OperaReloadStart<CR>",   opts)
map("n", "<Space>bO", ":OperaReloadStop<CR>",    opts)
map("n", "<Space>ba", ":AllBrowserReloadStart<CR>", opts)
map("n", "<Space>bA", ":AllBrowserReloadStop<CR>",  opts)

-- GTags
map("n", "<Space>f", ":Gtags -f %<CR>",                        opts)
map("n", "<Space>j", ":GtagsCursor<CR>",                       opts)
map("n", "<Space>d", ":<C-u>exe('Gtags '.expand('<cword>'))<CR>", opts)
map("n", "<Space>r", ":<C-u>exe('Gtags -r '.expand('<cword>'))<CR>", opts)

-- Telescope (Denite の代替)
map("n", "<C-p>", ":Telescope find_files<CR>", opts)
map("n", "<leader>b", ":Telescope buffers<CR>", opts)
map("n", "<leader>g", ":Telescope live_grep<CR>", opts)

-- RSpec
map("n", "<leader>t", ":call RunCurrentSpecFile()<CR>", opts)

-- Delve (Go デバッグ)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function()
    map("n", ";d", ":DlvToggleBreakpoint<CR>", { buffer = true, silent = true })
  end
})
