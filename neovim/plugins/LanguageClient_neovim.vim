set hidden

let g:LanguageClient_serverCommands = {
            \ 'go': [$DEFAULT_GOPATH.'/bin/bingo'],
            \ 'python': ['pyls'],
            \ 'javascript': ['javascript-typescript-stdio']
            \ }


let g:deoplete#enable_at_startup = 1
let g:LanguageClient_autoStart = 1
let g:LanguageClient_loggingFile = '/tmp/LSP'
let g:LanguageClient_loadSettings=$XDG_CONFIG_HOME."nvim/settings.json"


"" Keymap

nnoremap <C-l>lh :call LanguageClient_textDocument_hover()<CR>
nnoremap <C-l>ld :call LanguageClient_textDocument_definition()<CR>
nnoremap <C-l>lr :call LanguageClient_textDocument_rename()<CR>
nnoremap <C-l>lf :call LanguageClient_textDocument_formatting()<CR>
nnoremap <C-l>li :call LanguageClient_textDocument_implementation()<CR>
