"--------------------------------------------------------------------------
" neobundle
"---------------------------------------------------------------------------
set nocompatible               " Be iMproved
filetype off                   " Required!

if has('vim_starting')
	set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#rc(expand('~/.vim/bundle/'))

filetype plugin indent on     " Required!

" Installation check.
if neobundle#exists_not_installed_bundles()
	echomsg 'Not installed bundles : ' .
			\ string(neobundle#get_not_installed_bundle_names())
	echomsg 'Please execute ":NeoBundleInstall" command.'
	"finish
endif
NeoBundle 'Shougo/neocomplete'
NeoBundle 'Shougo/neocomplcache'
NeoBundle 'Shougo/neosnippet'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'tsaleh/vim-matchit'
NeoBundle 'ecomba/vim-ruby-refactoring'
NeoBundle 'Shougo/vimproc'
NeoBundle 'ujihisa/unite-locate'
NeoBundle 'violetyk/cake.vim'
NeoBundle 'tpope/vim-surround'
NeoBundle 'taglist.vim'
NeoBundle 'ZenCoding.vim'
NeoBundle 'ref.vim'
NeoBundle 'The-NERD-tree'
NeoBundle 'The-NERD-Commenter'
NeoBundle 'fugitive.vim'
NeoBundle 'TwitVim'
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'thinca/vim-localrc'
NeoBundle 'dbext.vim'
NeoBundle 'rails.vim'
NeoBundle 'Gist.vim'
NeoBundle 'motemen/hatena-vim'
NeoBundle 'mattn/webapi-vim'
NeoBundle 'mattn/unite-advent_calendar'
NeoBundle 'open-browser.vim'
NeoBundle 'ctrlp.vim'
NeoBundle 'jelera/vim-javascript-syntax'
NeoBundle 'JavaScript-syntax'
NeoBundle 'pangloss/vim-javascript'
NeoBundle 'altercation/vim-colors-solarized'
NeoBundle 'tell-k/vim-browsereload-mac'
NeoBundle 'alpaca-tc/alpaca_powertabline'
NeoBundle 'bling/vim-airline'

"--------------------------------------------
"neocomplcache設定
"--------------------------------------------
"辞書ファイル"

autocmd BufRead *.php\|*.ctp\|*.tpl :set dictionary=~/.vim/dict/php.dict filetype=php
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

nmap <Space>bc :ChromeReloadStart<CR>
nmap <Space>bC :ChromeReloadStop<CR>
nmap <Space>bf :FirefoxReloadStart<CR>
nmap <Space>bF :FirefoxReloadStop<CR>
nmap <Space>bs :SafariReloadStart<CR>
nmap <Space>bS :SafariReloadStop<CR>
nmap <Space>bo :OperaReloadStart<CR>
nmap <Space>bO :OperaReloadStop<CR>
nmap <Space>ba :AllBrowserReloadStart<CR>
nmap <Space>bA :AllBrowserReloadStop<CR>
map <C-l> <END>
map <C-a> <HOME>
noremap <Space>t+ :set transparency+=5
noremap <Space>t- :set transparency-=5
inoremap <expr><C-l>     neocomplcache#complete_common_string()
noremap <Space>t- :set transparency-=5

filetype plugin indent on
syntax on
set wildmenu
set autoindent
set ruler
set nu
set tabstop=4
set autoindent
set expandtab
set shiftwidth=4
set showmatch
set cursorline
set noswapfile
set dictionary=dictionary/php.dict
set smartcase
set ignorecase
set laststatus=2
set gfn:Ricty\ Regular:h14
set rtp+=~/.vim/neobundle/powerline/powerline/bindings/vim

autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType javascipt set dictionary=javascript.dict
autocmd FileType php,ctp :set dictionary=~/.vim/dict/php.dict
autocmd BufNewFile *.html
autocmd FileType php :set dictionary=~/.vim/dict/vim-dict-wordpress/*.dict
autocmd FileType php set makeprg=php\ -l\ %
autocmd BufWritePost *.php silent make | if len(getqflist()) != 1 | copen | else | cclose | endif

if	'gui_macvim'

	set showtabline	"タブを常に設定
	set imdisable		"IMを無効化
	set antialias
	set gfn = Ricty\ Regular:h16

	colorscheme evening
	set smartindent
	set incsearch
	set tabstop = 4
	set expandtab
	set shiftwidth = 4
	set autoindent
    set transparency = 5
	"------------------------------
	"NERDTree
	"------------------------------
	let NERDTreeShowHidden = 1
	"引数なしで実行した時、Nerdtreeを実行する"
	let file_name = expand("%:p")
	if has('vim_starting') && file_name == ""
		autocmd VimEnter * ExecuteNERDTree()
	endif

	"カーソルが外れてるときは自動的にnerdtreeを隠す"
	function! ExecuteNERDTree()
		"b:nerdstatus=1:NERDTREE表示中
		"b:nerdstatus=2:NERDTREE非表示中
		if !exists('g:nerdstatus')
			execute 'NERDTree ./'
			let g:windowWidth=winwidth(winnr())
			let g:nerdtreebuf= bunfnr('')
			let g:nerdstatus=1
		elseif g:nerdstatus == 1
			execute 'wincmd t'
			execute 'vertical resize' 0
			execute 'wincmd p'
			let g:nerdstatus == 2
		elseif g:nerdstatus == 2
			execute 'wincmd t'
			execute 'vertical resize' g:windowWidth
			let g:nerdstatus = 1
		endif
	endfunction
	au GUIEnter set
endif
map <C-g> :Gtags 
map <C-h> :Gtags -f %<CR>
map <C-j> :GtagsCursor<CR>
map <C-n> :cn<CR>
map <C-p> :cp<CR>
