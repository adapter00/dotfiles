"-------------------------------------------------------------------------
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
	echomsg 'Oh NO!!!!!!'
	echomsg 'Not installed bundles : ' .
			\ string(neobundle#get_not_installed_bundle_names())
	echomsg 'Please execute ":NeoBundleInstall" command.'
	"finish
endif

"Bundle一覧
NeoBundle 'Shougo/neocomplete'
NeoBundle 'Shougo/neocomplcache'
NeoBundle 'Shougo/vimproc', {
      \ 'build' : {
      \     'windows' : 'make -f make_mingw32.mak',
      \     'cygwin' : 'make -f make_cygwin.mak',
      \     'mac' : 'make -f make_mac.mak',
      \     'unix' : 'make -f make_unix.mak',
      \    },
      \ }
NeoBundle 'Shougo/neosnippet'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'tsaleh/vim-matchit'
NeoBundle 'ecomba/vim-ruby-refactoring'
NeoBundle 'ujihisa/unite-locate'
NeoBundle 'Shougo/vimshell.vim'
NeoBundle 'violetyk/cake.vim'
NeoBundle 'tpope/vim-surround'
NeoBundle 'taglist.vim'
NeoBundle 'ZenCoding.vim'
NeoBundle 'ref.vim'
NeoBundle 'The-NERD-tree'
NeoBundle 'The-NERD-Commenter'
NeoBundle 'fugitive.vim'
NeoBundle 'thinca/vim-localrc'
NeoBundle 'motemen/hatena-vim'
NeoBundle 'mattn/webapi-vim'
NeoBundle 'mattn/unite-advent_calendar'
NeoBundle 'jelera/vim-javascript-syntax'
NeoBundle 'JavaScript-syntax'
NeoBundle 'pangloss/vim-javascript'
NeoBundle 'tell-k/vim-browsereload-mac'
NeoBundle 'bling/vim-airline'
NeoBundle 'taichouchou2/vim-rsense'
NeoBundle 'nathanaelkane/vim-indent-guides' 
"powerlineの設定
NeoBundle 'itchyny/lightline.vim'
" haskell関連のプラグイン
NeoBundle 'eagletmt/ghcmod-vim'
NeoBundle 'ujihisa/neco-ghc'
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'kana/vim-filetype-haskell'
NeoBundle 'osyo-manga/vim-watchdogs'
NeoBundle 'dag/vim2hs'
NeoBundle 'sbl/scvim' 
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
let g:rsenseHome = '/usr/local/Cellar/rsense/0.3'
let g:rsenseUseOmniFunc = 1
"--------------------------------------------
"SuperCollider設定
"--------------------------------------------
let g:sclangPipeApp     = "~/.vim/bundle/scvim/bin/start_pipe" 
let g:sclangDispatcher  = "~/.vim/bundle/scvim/bin/sc_dispatcher" 
"--------------------------------------------
"MacVimのpowerlineテーマ設定
"--------------------------------------------
let g:lightline = {
            \ 'colorscheme' : 'wombat',
            \ }

"--------------------------------------------
"vim-indent-guidesの設定
"--------------------------------------------
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_start_level = 2
let g:indent_guides_auto_colors = 0
let g:indent_guides_guide_size = 1
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd guibg=red ctermbg=66
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=green ctermbg=67
let g:indent_guides_color_change_percent = 30


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

autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType javascipt set dictionary=javascript.dict
autocmd FileType php,ctp :set dictionary=~/.vim/dict/php.dict
autocmd BufNewFile *.html
autocmd FileType php :set dictionary=~/.vim/dict/vim-dict-wordpress/*.dict
autocmd FileType php set makeprg=php\ -l\ %
autocmd BufWritePost *.php silent make | if len(getqflist()) != 1 | copen | else | cclose | endif


"---------------------------
"RSense
"---------------------------
if !exists('g:neocomplcache_omni_patterns')
    let g:neocomplcache_omni_patterns = {}
endif
let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'


map <C-g> :Gtags 
map <C-h> :Gtags -f %<CR>
map <C-j> :GtagsCursor<CR>
map <C-n> :cn<CR>
map <C-p> :cp<CR>

"no backup
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
