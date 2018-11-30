set rtp+=$HOME/.dotfiles/neovim/
"辞書ファイル"
let s:dein_dir=expand('~/.cache/dein')
let s:dein_repo_dir=s:dein_dir . '/repos/github.com/Shougo/dein.vim'

if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
endif

execute 'set runtimepath^=' . s:dein_repo_dir 
if dein#load_state(s:dein_dir)
    call dein#begin(s:dein_dir)
    let s:toml = expand("$HOME/.dotfiles/neovim/dein.toml")
    let s:toml_lazy = expand("$HOME/.dotfiles/neovim/dein_lazy.toml")

    call dein#load_toml(s:toml, { 'lazy':0 } )
    call dein#load_toml(s:toml_lazy, { 'lazy':0 } )
    call dein#end()
endif

if dein#check_install()
  call dein#install()
endif

runtime! conf.d/*.vim
filetype plugin indent on
syntax enable

let g:returnApp = "iTerm"
let g:rsenseHome = '/usr/local/Cellar/rsense/0.3'
let g:rsenseUseOmniFunc = 1
let g:unite_enable_start_insert=1


autocmd BufRead *.php\|*.ctp\|*.tpl :set dictionary=~/.vim/dict/php.dict filetype=php
autocmd BufRead,BufNewFile *.md set filetype=markdown
autocmd BufRead,BufNewFile *.c set filetype=c
autocmd BufRead,BufNewFile Fastfile set filetype=ruby
autocmd BufRead,BufNewFile Podfile set filetype=ruby
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
autocmd BufRead,BufNewFile *.swift set filetype=swift

autocmd BufRead,BufNewFile *.rs set filetype=rust
    "keymap for unite action

    "open window by split 
au FileType unite nnoremap <silent> <buffer> <expr> <C-J> unite#do_action('split')
au FileType unite inoremap <silent> <buffer> <expr> <C-J> unite#do_action('split')

"open window by vertical split 
au FileType unite nnoremap <silent> <buffer> <expr> <C-K> unite#do_action('vsplit')
au FileType unite inoremap <silent> <buffer> <expr> <C-K> unite#do_action('vsplit')


"no backup
set encoding=utf-8
set fenc=utf-8
set nobackup
set noswapfile
set nu
set cursorline
set incsearch
set smartindent
set tabstop=4
set shiftwidth=4
set autoindent
set expandtab
set ruler
set smartcase
set ignorecase
set showmatch
set wildmenu
set wildmode=longest:full,full
set laststatus=2
set noundofile
set clipboard=unnamed
set completeopt+=noinsert
set completeopt+=noselect

colorscheme spacegray


"" command
command! -nargs=? Jq call s:Jq(<f-args>)
function! s:Jq(...)
    if 0 == a:0
        let l:arg = "."
    else
        let l:arg = a:1
    endif
    execute "%! jq 95fe1a73-e2e2-4737-bea1-a44257c50fc8quot;" . l:arg . "95fe1a73-e2e2-4737-bea1-a44257c50fc8quot;"
endfunction


set hidden
let g:racer_cmd = '$HOME/.cargo/bin/racer'

let g:python3_host_prog = "/usr/local/bin/python3"

set sh=zsh
tnoremap <silent> <ESC> <C-\><C-n>

"" LSP

set hidden
let g:LanguageClient_serverCommands = {'go': [$DEFAULT_GOPATH.'/bin/go-langserver','-format-tool','gofmt','-lint-tool','golint']}
let g:LanguageClient_autoStart = 1
let g:deoplete#enable_at_startup = 1
let g:LanguageClient_loggingFile = '/tmp/LSP'
let g:LanguageClient_loadSettings=$XDG_CONFIG_HOME."nvim/settings.json"
