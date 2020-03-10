set rtp+=$HOME/.dotfiles/neovim/
"辞書ファイル"
let s:dein_dir=expand('$HOME/.cache/dein')
let s:dein_repo_dir=s:dein_dir . '/repos/github.com/Shougo/dein.vim'

if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
endif

execute 'set runtimepath^=' . s:dein_repo_dir

if dein#load_state(s:dein_dir)
    call dein#begin(s:dein_dir)
    let s:base = expand("$HOME/.dotfiles/neovim")
    let s:dein = s:base . "/dein.toml"
    let s:dein_lazy = s:base . "/dein_lazy.toml"
    call dein#load_toml(s:dein, { 'lazy': 0 } )
    call dein#load_toml(s:dein_lazy, { 'lazy': 1 } )
    call dein#end()
    call dein#save_state()
endif
colorscheme spacegray


if has('vim_starting') && dein#check_install()
  call dein#install()
endif

runtime! conf.d/*.vim
filetype plugin indent on
syntax enable

let g:returnApp = "iTerm"
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


"make時にquickfix開く
au QuickfixCmdPost make





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

" virtual_envでnvim用を作成
if has('nvim') && isdirectory ( $PYENV_ROOT."/versions/nvim-python3" )
    let g:python3_host_prog = $PYENV_ROOT.'/versions/nvim-python3/bin/python'
endif

let g:python_host_prog = $PYENV_ROOT . '/shims/python'
set sh=zsh
tnoremap <silent> <ESC> <C-\><C-n>
autocmd QuickFixCmdPost [^l]* nested cwindow
autocmd QuickFixCmdPost    l* nested lwindow
let g:neosnippet#snippets_directory='~/.config/nvim/snippets/'

augroup vimrc-local
  autocmd!
  autocmd BufNewFile,BufReadPost * call s:vimrc_local(expand('<afile>:p:h'))
augroup END

function! s:vimrc_local(loc)
  let files = findfile('.local.vim', escape(a:loc, ' ') . ';', -1)
  for i in reverse(filter(files, 'filereadable(v:val)'))
    source `=i`
  endfor
endfunction

