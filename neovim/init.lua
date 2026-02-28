-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load core config
require("settings")
require("autocmds")
require("keymaps")

-- Load plugins (lazy.nvim)
require("plugins")

-- Colorscheme (must be after plugins)
vim.cmd("colorscheme spacegray")

-- Load LSP
require("lsp")

-- Load extra settings ($EXTRA_VIM / .vimrc.local)
require("extra_settings")

-- Machine-local overrides (not tracked)
local local_init = vim.fn.stdpath("config") .. "/_init.lua"
if vim.loop.fs_stat(local_init) then
  dofile(local_init)
end
