
	
" let g:lsp_diagnostics_enabled = 0
let g:lsp_auto_enable = 1
let g:lsp_preview_float = 0
let g:lsp_async_completion= 1
let g:lsp_log_verbose = 0
let g:lsp_log_file = expand('/tmp/vim-lsp.log')
" let g:asyncomplete_log_file = expand('/tmp/vim-lsp-asyncomplete.log')
let g:lsp_format_sync_timeout = 1000

let g:lsp_settings = {
    \ 'terraform-ls': {
    \     'root_uri_patterns': [
    \         '.terraform',         
    \         '.terraformrc',      
    \         'terraform.tfvars',  
    \         'main.tf',           
    \         'variables.tf'       
    \     ],
    \   },
    \ 'typescript-language-server': {
    \   'cmd': ['npx','typescript-language-server', '--stdio'],
    \   'whitelist': ['javascript', 'typescript', 'javascriptreact', 'typescriptreact'],
    \ },
\ }



function! s:on_lsp_buffer_enabled() abort
        augroup gopls_save
            try 
                autocmd!
                autocmd BufWritePre *.go call execute('LspDocumentFormatSync') | call execute('LspCodeActionSync source.organizeImports')
                autocmd BufWritePre *.js,*.ts,*.jsx,*.tsx,*.tf call execute('LspDocumentFormatSync')
            catch 
                echom 'Error occurred in autocmd BufWritePre'
            endtry
        augroup END
        setlocal omnifunc=lsp#complete
        noremap <C-]> :LspDefinition<CR>
        nnoremap <C-l>lh :LspHover<CR>
        nnoremap <C-l>lr :LspRename<CR>
        nnoremap <C-l>lf :LspDocumentFormat<CR>
        nnoremap <C-l>li :LspImplementation<CR>
		nnoremap <C-l>ll :LspDocumentSymbol<CR>
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

