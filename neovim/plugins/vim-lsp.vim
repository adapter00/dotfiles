
if executable('bingo')
    autocmd User lsp_setup call lsp#register_server({
                \ 'name':'bingo',
                \ 'cmd': {server_info->['bingo', '-logfile', '/tmp/gopls.log']},
                \ 'whitelist':['go'],
                \ 'workspace_config': {'bingo': {
                \ 'staticcheck':v:true,
                \     'completeUnimported': v:true,
                \     'caseSensitiveCompletion': v:true,
                \     'usePlaceholders': v:true,
                \     'completionDocumentation': v:true,
                \     'watchFileChanges': v:true,
                \     'hoverKind': 'SingleLine',
                \    }},
                \})
endif


if executable('pyls')
    autocmd User lsp_setup call lsp#register_server({
                \ 'name':'pyls',
                \ 'cmd': {server_info->['pyls']},
                \ 'whitelist':['python'],
                \ 'workspace_config': {'pyls': {'plugins': {'pydocstyle': {'enabled': v:true}}}}
                \})
endif

if executable('sourcekit-lsp')
    autocmd User lsp_setup call lsp#register_server({
                \ 'name':'sourcekit-lsp',
                \ 'cmd': {server_info->['sourcekit-lsp']},
                \ 'whitelist':['swift']
                \})
endif


if executable('javascript-typescript-stdio')
    autocmd User lsp_setup call lsp#register_server({
                \ 'name':'javascript-typescript-stdio',
                \ 'cmd': {server_info->['javascript-typescript-stdio']},
                \ 'whitelist':['javascript']
                \})
endif

let g:lsp_diagnostics_enabled = 0
" debug
let g:lsp_log_verbose = 1
let g:lsp_log_file = expand('/tmp/vim-lsp.log')
let g:asyncomplete_log_file = expand('~/asyncomplete.log')

function LC_maps()
    " if len(lsp#get_whitelisted_servers(&filetype))>0
        noremap <C-]> :LspDefinition<CR>
        noremap <C-T> <C-O>
        nnoremap <C-l>lh :LspHover<CR>
        nnoremap <C-l>lr :LspRename<CR>
        nnoremap <C-l>lf :LspDocumentFormat<CR>
        nnoremap <C-l>li :LspImplementation<CR>
		nnoremap <C-l>ll :LspDocumentSymbol<CR>
        setlocal omnifunc=lsp#complete
        autocmd BufWritePre <buffer> LspDocumentFormatSync
    " endif
endfunction

autocmd FileType * call LC_maps()
