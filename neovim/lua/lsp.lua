local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- LSP 共通キーマップ
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local bopts = { buffer = ev.buf, silent = true }
    vim.keymap.set("n", "<C-]>",   vim.lsp.buf.definition,      bopts)
    vim.keymap.set("n", "<C-l>lh", vim.lsp.buf.hover,           bopts)
    vim.keymap.set("n", "<C-l>lr", vim.lsp.buf.rename,          bopts)
    vim.keymap.set("n", "<C-l>lf", vim.lsp.buf.format,          bopts)
    vim.keymap.set("n", "<C-l>li", vim.lsp.buf.implementation,  bopts)
    vim.keymap.set("n", "<C-l>ll", vim.lsp.buf.document_symbol, bopts)

    -- Go: 保存時 format + organize imports
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client.name == "gopls" then
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = ev.buf,
        callback = function()
          vim.lsp.buf.format({ async = false, timeout_ms = 1000 })
          vim.lsp.buf.code_action({
            context = { only = { "source.organizeImports" } },
            apply   = true,
          })
        end,
      })
    end
  end,
})

-- gopls
vim.lsp.config("gopls", {
  capabilities = capabilities,
  cmd          = { vim.fn.expand("~/.asdf/installs/golang/1.21.0/packages/bin/gopls"), "-rpc.trace", "-logfile", "/tmp/gopls.log" },
  filetypes    = { "go", "gomod", "gowork", "gotmpl" },
  root_markers = { "go.work", "go.mod", ".git" },
  settings     = {
    gopls = {
      analyses    = { unusedparams = true },
      staticcheck = true,
    },
  },
})
vim.lsp.enable("gopls")
