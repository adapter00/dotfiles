
let g:lsp_diagnostics_enabled = 0
let g:lsp_auto_enable = 1
let g:lsp_preview_float = 0
let g:lsp_async_completion=1
let g:lsp_log_verbose = 0

" let g:lsp_log_file = expand('/tmp/vim-lsp.log')
" let g:asyncomplete_log_file = expand('/tmp/vim-lsp-asyncomplete.log')
let g:lsp_format_sync_timeout = 100
function LC_maps()
    " if len(lsp#get_whitelisted_servers(&filetype))>0
       noremap <C-]> :LspDefinition<CR>
        nnoremap <C-l>lh :LspHover<CR>
        nnoremap <C-l>lr :LspRename<CR>
        nnoremap <C-l>lf :LspDocumentFormat<CR>
        nnoremap <C-l>li :LspImplementation<CR>
		nnoremap <C-l>ll :LspDocumentSymbol<CR>
        setlocal omnifunc=lsp#complete
    " endif
endfunction

autocmd Filetype * call LC_maps()
