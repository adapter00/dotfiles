if executable('gopls')
    autocmd User lsp_setup call lsp#register_server({
                \ 'name': 'go-lang',
                \ 'cmd': {server_info->['gopls', '-logfile','/tmp/gopls']},
                \ 'whitelist': ['go'],
                \ 'workspace_config': {'gopls': {
                \     'staticcheck': v:true,
                \     'completeUnimported': v:true,
                \     'caseSensitiveCompletion': v:true,
                \     'usePlaceholders': v:true,
                \     'completionDocumentation': v:true,
                \     'watchFileChanges': v:true,
                \     'hoverKind': 'SingleLine',
                \   }},
                \ })
endif

if executable('pyls')
    " Python用の設定を記載
    " workspace_configで以下の設定を記載
    " - pycodestyleの設定はALEと重複するので無効にする
    " - jediの定義ジャンプで一部無効になっている設定を有効化
    autocmd User lsp_setup call lsp#register_server({
                \ 'name': 'pyls',
                \ 'cmd': { server_info -> ['pyls'] },
                \ 'whitelist': ['python'],
                \ 'workspace_config': {'pyls': {'plugins': {
                \   'pycodestyle': {'enabled': v:false},
                \   'jedi_definition': {'follow_imports': v:true, 'follow_builtin_imports': v:true},}}}
                \})
endif

if executable('sourcekit-lsp')
    au User lsp_setup call lsp#register_server({
                \ 'name': 'sourcekit-lsp',
                \ 'cmd': {server_info->['sourcekit-lsp']},
                \ 'whitelist': ['swift'],
                \ })
endif


let g:lsp_diagnostics_enabled = 0
" debug
" let g:lsp_log_verbose = 1
let g:lsp_log_file = expand('/tmp/vim-lsp.log')
let g:asyncomplete_log_file = expand('/tmp/asyncomplete.log')

function LC_maps()
    " if len(lsp#get_whitelisted_servers(&filetype))>0
        noremap <C-]> :LspDefinition<CR>
        nnoremap <C-l>lh :LspHover<CR>
        nnoremap <C-l>lr :LspRename<CR>
        nnoremap <C-l>lf :LspDocumentFormat<CR>
        nnoremap <C-l>li :LspImplementation<CR>
		nnoremap <C-l>ll :LspDocumentSymbol<CR>
        setlocal omnifunc=lsp#complete
        autocmd BufWritePre <buffer> LspDocumentFormat
    " endif
endfunction

autocmd FileType * call LC_maps()

