set rtp+=$HOME/.dotfiles/.vim/
runtime! conf.d/*.vim
"辞書ファイル"

autocmd BufRead *.php\|*.ctp\|*.tpl :set dictionary=~/.vim/dict/php.dict filetype=php
autocmd BufRead,BufNewFile *.md set filetype=markdown
autocmd BufRead,BufNewFile *.c set filetype=c
let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_enable_camel_case_completion = 1
let g:neocomplcache_enable_underbar_completion = 1
let g:neocomplcache_smart_case = 1
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_manual_completion_start_length = 0
let g:neocomplcache_caching_percent_in_statusline = 1
let g:neocomplcache_enable_skip_completion = 1
let g:neocomplcache_skip_input_time = '0.5'
let g:returnApp = "iTerm"
let g:rsenseHome = '/usr/local/Cellar/rsense/0.3'
let g:rsenseUseOmniFunc = 1

filetype plugin indent on
syntax on

autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType cs setlocal omnifunc=OmniSharp#Complete
autocmd FileType javascipt set dictionary=javascript.dict
autocmd FileType php,ctp :set dictionary=~/.vim/dict/php.dict
autocmd BufNewFile *.html
autocmd FileType php :set dictionary=~/.vim/dict/vim-dict-wordpress/*.dict
autocmd FileType php set makeprg=php\ -l\ %
autocmd BufWritePost *.php silent make | if len(getqflist()) != 1 | copen | else | cclose | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif




    "taglist用の設定
    set tags=tags
    let Tlist_Ctags_Cmd="/usr/local/bin/ctags"
    let Tlist_Show_One_File = 1
    let Tlist_Use_Left_Window = 1
    let Tlist_Exit_OnlyWindow = 1


    "no backup
    set encoding=utf-8
    set fenc=utf-8
    set nobackup
    set noswapfile
    set nu
    set cursorline
    set incsearch
    set antialias
    set smartindent
    set tabstop=4
    set shiftwidth=4
    set autoindent
    set expandtab
    set ruler
    set smartcase
    set ignorecase
    set wildmenu
    set showmatch
    set wildmode=longest:full,full
    set laststatus=2
    set noundofile
    set autochdir
    colorscheme dracula 
