" set hidden

" let s:pyls_path = fnamemodify(g:python_host_prog, ':h') . '/'. 'pyls'
"
" let g:LanguageClient_serverCommands = {
"             \'go': ['gopls','-logfile','/tmp/gopls.log'],
"             \ 'go': ['bingo','-trace', '-logfile','/tmp/bingo.log'],
"             \ 'python':['pyls']
"             \ }
"             " \'go': ['bingo','--format-style','goimports', '--logfile','/tmp/bingo.log'],
"
" let g:LanguageClinet_rootMarkers = {
"             \ 'go':['.git','go.mod','.hg/','.vim/'],
"             \ 'swift': ['Package.swift']
"             \ }
"
"
" let g:deoplete#enable_at_startup = 1
" let g:LanguageClient_autoStart = 1
" let g:LanguageClient_loggingFile = '/tmp/LSP.log'
" let g:LanguageClient_loadSettings=$XDG_CONFIG_HOME."nvim/settings.json"
" let g:LanguageClient_loggingLevel ='DEBUG'
"
" let g:LanguageClient_diagnosticsEnable=0
"
"
"             " \ 'go': ['gopls', '-logfile','/tmp/gopls.log'],
"
"
" let g:LanguageClinet_rootMarkers = {
"             \ 'go':['.git','go.mod'],
"             \ }
" let g:deoplete#enable_at_startup = 1
" let g:LanguageClient_autoStart = 1
" let g:LanguageClient_loggingFile = '/tmp/lsp.log'
" let g:LanguageClient_loggingLevel ='DEBUG'
"
" let g:LanguageClient_diagnosticsEnable=0

"" Keymap
" function LC_maps()
"         nnoremap <C-l>lc :call LanguageClient_contextMenu()<CR>
"         "" formatting on save
"         autocmd BufWritePre * :call LanguageClient_textDocument_formatting()
"
"     endif
" endfunction
"
" autocmd FileType * call LC_maps()
"
"
