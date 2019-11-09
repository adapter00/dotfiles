set hidden

let g:LanguageClient_serverCommands = {
            \ 'ruby':['solargraph','stdio'],
            \ 'go': ['bingo','-trace','--format-style','goimports', '-logfile','/tmp/bingo.log'],
            \ 'python':['pyls']
            \ }

" \ 'go': ['gopls', '--trace','--diagnostics-style','none'  '--logfile','/tmp/gopls.log'],


let g:LanguageClinet_rootMarkers = {
            \ 'go':['.git','go.mod'],
            \ }
let g:deoplete#enable_at_startup = 1
let g:LanguageClient_autoStart = 1
let g:LanguageClient_loggingFile = '/tmp/lsp.log'
let g:LanguageClient_loggingLevel ='DEBUG'
let g:LanguageClient_diagnosticsEnable=0

"" Keymap
function LC_maps()
    if has_key(g:LanguageClient_serverCommands, &filetype)
        noremap <C-]> :call LanguageClient#textDocument_definition()<CR>
        noremap <C-T> <C-O>
        nnoremap <C-l>lh :call LanguageClient_textDocument_hover()<CR>
        nnoremap <C-l>lr :call LanguageClient_textDocument_rename()<CR>
        nnoremap <C-l>lf :call LanguageClient_textDocument_formatting()<CR>
        nnoremap <C-l>ll :call LanguageClient_textDocument_documentSymbol()<CR>
        nnoremap <C-l>lc :call LanguageClient_contextMenu()<CR>
        "" formatting on save
        autocmd BufWritePre * :call LanguageClient_textDocument_formatting()

    endif
endfunction

autocmd FileType * call LC_maps()


