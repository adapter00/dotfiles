if executable('gopls')
    au User lsp_setup call lsp#register_server({
                \ 'name':'gopls bingo ver',
                \ 'cmd': {server_info->['gopls','-logfile','/tmp/gopls.log']},
                \ 'whitelist':['go'],
                \})
endif


let g:lsp_diagnostics_enabled = 0
" debug
let g:lsp_log_verbose = 1
let g:lsp_log_file = expand('~/vim-lsp.log')
let g:asyncomplete_log_file = expand('~/asyncomplete.log')

function LC_maps()
    " if  len(lsp#get_whitelisted_servers(&filetype))>0
        noremap <C-]> :LspDefinition<CR>
        noremap <C-T> <C-O>
        nnoremap <C-l>lh :LspHover<CR>
        nnoremap <C-l>lr :LspRename<CR>
        nnoremap <C-l>lf :LspDocumentFormat<CR>
        nnoremap <C-l>li :LspImplementation<CR>
		nnoremap <C-l>ll :LspDocumentSymbol<CR>
    " endif
endfunction

autocmd FileType * call LC_maps()
