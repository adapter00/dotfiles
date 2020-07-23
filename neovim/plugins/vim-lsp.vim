let g:lsp_diagnostics_enabled = 0
let g:lsp_auto_enable = 1
let g:lsp_preview_float = 0
let g:lsp_async_completion=1
let g:lsp_log_file = expand('/tmp/vim-lsp.log')
let g:asyncomplete_log_file = expand('/tmp/vim-lsp-asyncomplete.log')

if executable('gopls')	
    au User lsp_setup call lsp#register_server({	
                \ 'name':'gopls',	
                \ 'cmd': {server_info->['gopls','-rpc.trace','-logfile','/tmp/gopls.log']},	
                \ 'whitelist':['go'],	
                \})	
endif
if executable('pyls')
    autocmd User lsp_setup call lsp#register_server({
                \ 'name': 'pyls',
                \ 'cmd': { server_info -> ['pyls'] },
                \ 'whitelist': ['python'],
                \ 'workspace_config': {'pyls': {'plugins': {
                \   'pycodestyle': {'enabled': v:false},
                \   'jedi_definition': {'follow_imports': v:true, 'follow_builtin_imports': v:true},}}}
                \})
    autocmd FileType python call s:configure_lsp()
endif


function LC_maps()
    " if len(lsp#get_whitelisted_servers(&filetype))>0
        noremap <C-]> :LspDefinition<CR>
        nnoremap <C-l>lh :LspHover<CR>
        nnoremap <C-l>lr :LspRename<CR>
        nnoremap <C-l>lf :LspDocumentFormat<CR>
        nnoremap <C-l>li :LspImplementation<CR>
		nnoremap <C-l>ll :LspDocumentSymbol<CR>
        setlocal omnifunc=lsp#complete
        " autocmd BufWritePre <buffer> LspDocumentFormat
    " endif
endfunction

autocmd Filetype * call LC_maps()

