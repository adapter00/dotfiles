let g:lsp_diagnostics_enabled = 0
let g:lsp_log_file = expand('/tmp/vim-lsp.log')
let g:asyncomplete_log_file = expand('/tmp/asyncomplete.log')

function LC_maps()
        echomsg "LS_maps"
        echomsg &filetype
    " if len(lsp#get_whitelisted_servers(&filetype))>0
        noremap <C-]> :LspDefinition<CR>
        nnoremap <C-l>lh :LspHover<CR>
        nnoremap <C-l>lr :LspRename<CR>
        nnoremap <C-l>lf :LspDocumentFormat<CR>
        nnoremap <C-l>li :LspImplementation<CR>
		nnoremap <C-l>ll :LspDocumentSymbol<CR>
        setlocal omnifunc=lsp#complete
        autocmd BufWritePre <buffer> LspDocumentFormat
    " else
    "     echomsg "filetype is" + &filetype
    " endif
endfunction

autocmd Filetype * call LC_maps()

