local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- LSP 共通キーマップ
local on_attach = function(client, bufnr)
  local bopts = { buffer = bufnr, silent = true }
  vim.keymap.set("n", "<C-]>",    vim.lsp.buf.definition,    bopts)
  vim.keymap.set("n", "<C-l>lh",  vim.lsp.buf.hover,         bopts)
  vim.keymap.set("n", "<C-l>lr",  vim.lsp.buf.rename,        bopts)
  vim.keymap.set("n", "<C-l>lf",  vim.lsp.buf.format,        bopts)
  vim.keymap.set("n", "<C-l>li",  vim.lsp.buf.implementation,bopts)
  vim.keymap.set("n", "<C-l>ll",  vim.lsp.buf.document_symbol, bopts)

  -- Go: 保存時 format + organize imports
  if client.name == "gopls" then
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format({ async = false, timeout_ms = 1000 })
        vim.lsp.buf.code_action({
          context = { only = { "source.organizeImports" } },
          apply   = true,
        })
      end,
    })
  end
end

-- gopls
lspconfig.gopls.setup({
  capabilities = capabilities,
  on_attach    = on_attach,
  cmd          = { "gopls", "-rpc.trace", "-logfile", "/tmp/gopls.log" },
  settings     = {
    gopls = {
      analyses        = { unusedparams = true },
      staticcheck     = true,
    }
  }
})
