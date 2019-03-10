set hidden

let g:LanguageClient_serverCommands = {
            \ 'go': [$DEFAULT_GOPATH.'/bin/go-langserver','-format-tool','gofmt', '-gocodecompletion','-usebinarypkgcache'],
            \ 'ruby':['solargraph','stdio'],
            \ 'python':['pyls']
            \ }
let g:LanguageClinet_rootMarkers = {
            \ 'go':['.git','go.mod'],
            \ }

            " \ 'go':['gopls','-mode','stdio'],
            " \ 'go':['bingo','--format-style','goimports'],
let g:deoplete#enable_at_startup = 1
let g:LanguageClient_autoStart = 1
let g:LanguageClient_loggingFile = '/tmp/LSP'
let g:LanguageClient_loadSettings=$XDG_CONFIG_HOME."nvim/settings.json"


"" Keymap

noremap <C-]> :call LanguageClient#textDocument_definition()<CR>
noremap <C-T> <C-O>
nnoremap <C-l>lh :call LanguageClient_textDocument_hover()<CR>
nnoremap <C-l>lr :call LanguageClient_textDocument_rename()<CR>
nnoremap <C-l>lf :call LanguageClient_textDocument_formatting()<CR>
nnoremap <C-l>ll :call LanguageClient_textDocument_documentSymbol()()<CR>

