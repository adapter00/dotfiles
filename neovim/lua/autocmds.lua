local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Filetype detection
autocmd({"BufRead", "BufNewFile"}, { pattern = "*.md",       command = "set filetype=markdown" })
autocmd({"BufRead", "BufNewFile"}, { pattern = "*.c",        command = "set filetype=c" })
autocmd({"BufRead", "BufNewFile"}, { pattern = "Fastfile",   command = "set filetype=ruby" })
autocmd({"BufRead", "BufNewFile"}, { pattern = "Podfile",    command = "set filetype=ruby" })
autocmd({"BufRead", "BufNewFile"}, { pattern = "*.swift",    command = "set filetype=swift" })
autocmd({"BufRead", "BufNewFile"}, { pattern = "*.rs",       command = "set filetype=rust" })
autocmd({"BufEnter", "BufWinEnter", "BufNewFile", "BufRead"}, {
  pattern = {"*.sc", "*.scd"},
  command = "set filetype=supercollider"
})

-- Omnifunc
autocmd("FileType", { pattern = {"html", "markdown"}, command = "setlocal omnifunc=htmlcomplete#CompleteTags" })
autocmd("FileType", { pattern = "javascript",         command = "setlocal omnifunc=javascriptcomplete#CompleteJS" })
autocmd("FileType", { pattern = "cs",                 command = "setlocal omnifunc=OmniSharp#Complete" })
autocmd("FileType", { pattern = "ruby",               command = "setlocal omnifunc=rubycomplete#Complete" })

-- NERDTree: close if last window (nvim-tree に移行後は削除予定)
-- autocmd("BufEnter", { command = "..." })  -- nvim-tree が自動対応

-- QuickFix
autocmd("QuickfixCmdPost", { pattern = "[^l]*", command = "nested cwindow" })
autocmd("QuickfixCmdPost", { pattern = "l*",    command = "nested lwindow" })

-- PHP
autocmd("FileType", { pattern = "php", command = "set makeprg=php\\ -l\\ %" })
autocmd("BufWritePost", {
  pattern = "*.php",
  command = "silent make | if len(getqflist()) != 1 | copen | else | cclose | endif"
})

-- Rust quickrun
autocmd({"BufNewFile", "BufRead"}, {
  pattern = "*.rs",
  callback = function()
    vim.g.quickrun_config = vim.g.quickrun_config or {}
    vim.g.quickrun_config.rust = { exec = "cargo run" }
  end
})

-- .vimrc.local を自動 source
local vimrc_local_group = augroup("vimrc-local", { clear = true })
autocmd({"BufNewFile", "BufReadPost"}, {
  group = vimrc_local_group,
  callback = function()
    local loc = vim.fn.expand("<afile>:p:h")
    local files = vim.fn.findfile(".vimrc.local", vim.fn.escape(loc, " ") .. ";", -1)
    for _, f in ipairs(vim.fn.reverse(vim.tbl_filter(function(v)
      return vim.fn.filereadable(v) == 1
    end, files))) do
      vim.cmd("source " .. f)
    end
  end
})

-- SuperCollider: Unite keymaps（Unite 廃止済みのため Unite 部分は除外）
autocmd("FileType", {
  pattern = "supercollider",
  callback = function()
    vim.keymap.set("n", "<CR>",  ":call SClang_block()<CR>",    { buffer = true, silent = true })
    vim.keymap.set("v", "<CR>",  ":call SClang_send()<CR>",     { buffer = true, silent = true })
    vim.keymap.set("n", ".<CR>", ":call SClangHardstop()<CR>",  { buffer = true, silent = true })
  end
})
