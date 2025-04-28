
local vim = vim

-- settings.lua
local o = vim.o
local wo = vim.wo
local bo = vim.bo

-- グローバル設定
o.encoding = "utf-8"
o.fileencoding = "utf-8"
o.backup = false
o.swapfile = false
o.number = true
o.incsearch = true
o.smartindent = true
o.tabstop = 4
o.shiftwidth = 4
o.autoindent = true
o.expandtab = true
o.ruler = true
o.smartcase = true
o.ignorecase = true
o.showmatch = true
o.wildmenu = true
o.wildmode = "longest:full,full"
o.laststatus = 2
o.undofile = false
o.clipboard = "unnamedplus"
o.completeopt = "menuone,noinsert,noselect"

-- ウィンドウ固有の設定
wo.cursorline = true

-- バッファ固有の設定
bo.swapfile = false


