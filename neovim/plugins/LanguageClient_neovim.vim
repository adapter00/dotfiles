set hidden

let g:LanguageClient_serverCommands = {
            \'go': ['bingo','--format-style','goimports', '--logfile','/tmp/bingo.log'],
            \ 'ruby':['solargraph','stdio'],
            \ 'python':['pyls']
            \ }
            " \ 'go': ['gopls','-rpc.trace','serve','-debug','localhost:6060', '-logfile','/tmp/gopls.log'],

let g:LanguageClinet_rootMarkers = {
            \ 'go':['.git','go.mod'],
            \ }
let g:deoplete#enable_at_startup = 1
let g:LanguageClient_autoStart = 1
let g:LanguageClient_loggingFile = '/tmp/LSP.log'
let g:LanguageClient_loadSettings=$XDG_CONFIG_HOME."nvim/settings.json"
let g:LanguageClient_loggingLevel ='DEBUG'

let g:LanguageClient_diagnosticsEnable=0


"" Keymap

noremap <C-]> :call LanguageClient#textDocument_definition()<CR>
noremap <C-T> <C-O>
nnoremap <C-l>lh :call LanguageClient_textDocument_hover()<CR>
nnoremap <C-l>lr :call LanguageClient_textDocument_rename()<CR>
nnoremap <C-l>lf :call LanguageClient_textDocument_formatting()<CR>
nnoremap <C-l>ll :call LanguageClient_textDocument_documentSymbol()<CR>
nnoremap <C-l>lc :call LanguageClient_contextMenu()<CR>


"" formatting on save
autocmd BufWritePre *.py :call LanguageClient_textDocument_formatting()
autocmd BufWritePre *.go :call LanguageClient_textDocument_formatting()

