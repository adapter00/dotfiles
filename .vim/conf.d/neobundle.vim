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
NeoBundle 'nathanaelkane/vim-indent-guides' 
NeoBundle 'sbl/scvim'
"powerlineの設定
NeoBundle 'itchyny/lightline.vim'
" haskell関連のプラグイン
NeoBundle 'eagletmt/ghcmod-vim'
NeoBundle 'ujihisa/neco-ghc'
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'kana/vim-filetype-haskell'
NeoBundle 'osyo-manga/vim-watchdogs'
NeoBundle 'dag/vim2hs'
" Node.js関連のプラグイン
NeoBundle 'felixge/vim-nodejs-errorformat'
NeoBundle 'geekjuice/vim-mocha'
"IDE風設定用のプラグイン
NeoBundle 'rickard/project.vim'
"Markdown
NeoBundle 'kannokanno/previm'
NeoBundle 'plasticboy/vim-markdown'
"Android Development Tool
NeoBundle 'bpowell/vim-android'
"html,js関連のプラグイン
NeoBundle 'tomtom/tcomment_vim'
NeoBundle 'sjl/gundo.vim'
"colorshceme
NeoBundle 'zenorocha/dracula-theme'
NeoBundle 'Shougo/neomru.vim'
" rails
NeoBundle 'tpope/vim-rails'
NeoBundle 'basyura/unite-rails'
NeoBundle 'alpaca-tc/alpaca_tags'
NeoBundle 'tpope/vim-endwise'
NeoBundle 'whatyouhide/vim-gotham'
NeoBundle 'ajh17/Spacegray.vim'

 " swift
NeoBundle 'Keithbsmiley/swift.vim'
NeoBundle 'toyamarinyon/vim-swift'
