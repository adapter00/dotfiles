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
NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'Shougo/unite.vim'
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
" Node.js関連のプラグイン
NeoBundle 'felixge/vim-nodejs-errorformat'
NeoBundle 'geekjuice/vim-mocha'
"IDE風設定用のプラグイン
NeoBundle 'rickard/project.vim'
NeoBundle 'Rip-Rip/clang_complete'
NeoBundle 'tokorom/clang_complete-getopts-ios' 
"Markdown
NeoBundle 'kannokanno/previm'
NeoBundle 'plasticboy/vim-markdown'
"Android Development Tool
NeoBundle 'bpowell/vim-android'
"html,js関連のプラグイン
NeoBundle 'tomtom/tcomment_vim'
NeoBundle 'sjl/gundo.vim'


"--------------------------------------------
"neocomplcache設定
"--------------------------------------------
"辞書ファイル"

autocmd BufRead *.php\|*.ctp\|*.tpl :set dictionary=~/.vim/dict/php.dict filetype=php
autocmd BufRead,BufNewFile *.md set filetype=markdown
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
let g:clang_complete_getopts_ios_sdk_directory ='/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator7.1.sdk'


"--------------------------------------------
"SuperCollider設定
"--------------------------------------------
let g:sclangPipeApp     = "~/.vim/bundle/scvim/bin/start_pipe" 
let g:sclangDispatcher  = "~/.vim/bundle/scvim/bin/sc_dispatcher" 
"--------------------------------------------
"Vimのpowerlineテーマ設定
"--------------------------------------------
let g:lightline = {
            \ 'colorscheme': 'wombat',
            \ 'active': {
            \   'left': [ [ 'mode', 'paste' ],
            \             [ 'readonly', 'filename', 'modified' ] ]
            \ },
            \ 'component': {
            \   'readonly': '%{&readonly?"\u2b64":""}',
            \   'modified': '%{&filetype=="help"?"":&modified?"✍":&modifiable?"":"✌"}',
            \   'fugitive': '%{exists("*fugitive#head")?fugitive#head():""}'
            \ },
            \ 'component_visible_condition': {
            \   'readonly': '(&filetype!="help"&& &readonly)',
            \   'modified': '(&filetype!="help"&&(&modified||!&modifiable))',
            \   'fugitive': '(exists("*fugitive#head") && ""!=fugitive#head())'
            \ },
            \ 'separator': { 'left': "\u2b80", 'right': "\u2b82" },
            \ 'subseparator': { 'left': "\u2b81", 'right': "\u2b83" }
            \ }

"--------------------------------------------
"vim-indent-guidesの設定
"--------------------------------------------
let g:indent_guides_enable_on_vim_startup =0 
let g:indent_guides_start_level = 2
let g:indent_guides_auto_colors = 0
let g:indent_guides_guide_size = 1
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd guibg=red ctermbg=gray
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=green ctermbg=darkgray
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
autocmd FileType cs setlocal omnifunc=OmniSharp#Complete
autocmd FileType javascipt set dictionary=javascript.dict
autocmd FileType php,ctp :set dictionary=~/.vim/dict/php.dict
autocmd BufNewFile *.html
autocmd FileType php :set dictionary=~/.vim/dict/vim-dict-wordpress/*.dict
autocmd FileType php set makeprg=php\ -l\ %
autocmd BufWritePost *.php silent make | if len(getqflist()) != 1 | copen | else | cclose | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif



    "-----------------------------
    "Omnisharp
    "-----------------------------
    NeoBundleLazy 'nosami/Omnisharp', {
                \   'autoload': {'filetypes': ['cs']},
                \   'build': {
                \     'mac': 'xbuild server/OmniSharp.sln',
                \     'unix': 'xbuild server/OmniSharp.sln',
                \   }
                \ }
    let g:OmniSharp_host="http://localhost:2000"
    set splitbelow
    if !exists('g:neocomplcache_force_omni_patterns')
        let g:neocomplcache_force_omni_patterns = {}
    endif
    let g:neocomplcache_force_omni_patterns.cs = '[^.]\.\%(\u\{2,}\)\?'
    filetype plugin on


    "---------------------------
    "RSense
    "---------------------------
    if !exists('g:neocomplcache_omni_patterns')
        let g:neocomplcache_omni_patterns = {}
    endif
    let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
    let g:SuperTabContextDefaultCompletionType = "<c-x><c-o>" 

    "-------------------------
    "For ObjC && C & C++
    "-------------------------
    if !exists('g:neocomplcache_force_omni_patterns')
        let g:neocomplcache_force_omni_patterns = {}
    endif
    let g:neocomplcache_force_overwrite_completefunc = 1
    let g:neocomplcache_force_omni_patterns.c =
                \ '[^.[:digit:] *\t]\%(\.\|->\)'
    let g:neocomplcache_force_omni_patterns.cpp =
                \ '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
    let g:neocomplcache_force_omni_patterns.objc =
                \ '[^.[:digit:] *\t]\%(\.\|->\)'
    let g:neocomplcache_force_omni_patterns.objcpp =
                \ '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
    let g:clang_complete_auto = 0
    let g:clang_auto_select = 0
    let g:clang_complete_include_current_directory_recursively = 1
    let g:clang_auto_user_options = 'path, .clang_complete, ios'


    map <C-g> :Gtags 
    map <C-h> :Gtags -f %<CR>
    map <C-j> :GtagsCursor<CR>
    map <C-n> :cn<CR>
    map <C-p> :cp<CR>
    "OmniSharpCompletion
    imap <C-Space> <C-x><C-o>


    "taglist用の設定
    set tags=tags
    let Tlist_Ctags_Cmd="/usr/local/bin/ctags"
    let Tlist_Show_One_File = 1
    let Tlist_Use_Left_Window = 1
    let Tlist_Exit_OnlyWindow = 1


    "no backup
    scriptencoding utf-8
    set encoding=utf-8
    set fenc=utf-8
    set fileencodings=iso-2022-jp,euc-jp,sjis,utf-8
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
    colorscheme molokai 

