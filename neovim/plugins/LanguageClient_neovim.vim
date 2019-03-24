set hidden

let g:LanguageClient_rootMarkers = {
        \ 'go': ['.git', 'go.mod'],
        \ }
let g:LanguageClient_serverCommands = {
            \ 'go': ['bingo' ],
            \ 'ruby':['solargraph','stdio'],
            \ 'python':['pyls'],
            \ 'javascript': ['javascript-typescript-stdio'],
            \ 'swift': ['/Users/takao_maeda/dev/swift/sourcekit-lsp/.build/x86_64-apple-macosx10.10/release/sourcekit-lsp','--log-level','debug']
            \ }
let g:LanguageClinet_rootMarkers = {
            \ 'go':['.git','go.mod'],
            \ 'swift': ['Package.swift']
            \ }


let g:deoplete#enable_at_startup = 1
let g:LanguageClient_autoStart = 1
let g:LanguageClient_loggingFile = '/tmp/LSP.log'
let g:LanguageClient_loadSettings=$XDG_CONFIG_HOME."nvim/settings.json"


"" Keymap

function LC_maps()
    if  has_key(g:LanguageClient_serverCommands,&filetype)
        noremap <C-]> :call LanguageClient#textDocument_definition()<CR>
        noremap <C-T> <C-O>
        nnoremap <C-l>lh :call LanguageClient_textDocument_hover()<CR>
        nnoremap <C-l>lr :call LanguageClient_textDocument_rename()<CR>
        nnoremap <C-l>lf :call LanguageClient_textDocument_formatting()<CR>
        nnoremap <C-l>li :call LanguageClient_textDocument_implementation()<CR>
		nnoremap <C-l>ll :call LanguageClient_textDocument_documentSymbol()()<CR>
    endif
endfunction
autocmd FileType * call LC_maps()
