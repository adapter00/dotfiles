
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
            \             [ 'fugitive', 'filename'] ]
            \ },
            \ 'component_function':{
            \   'fugitive': 'Myfugitive',
            \   'readonly': 'MyReadOnly',
            \   'modified': 'MyModified',
            \   'filename': 'MyFileName'
            \ },
            \ 'separator': { 'left': "\u2b80", 'right': "\u2b82" },
            \ 'subseparator': { 'left': "\u2b81", 'right': "\u2b83" }
            \ }

" -------------------------------------------------
" lightline func
" -------------------------------------------------

function! MyModified()
    if &filetype == "help"
        return ""
    elseif &modified
        return "( ﾟДﾟ)編集中!!"
    elseif &modifiable
        return ""
    else 
        return ""
    endif
endfunction

function! MyReadOnly()
    if &filetype == "help"
        return ""
    elseif &readonly
        return "\u2b64"
    else
        return ""
    endif
endfunction

function! MyFugitive()
    if exists("*fugitive#head")
        let _=fugitive#head()
        return strlen(_) ? '⭠ '._: ''
    endif
    return ''
endfunction

function! MyFileName()
  return ('' != MyReadOnly() ? MyReadOnly() . ' ' : '') .
       \ ('' != expand('%:t') ? expand('%:t') : '[No Name]') .
       \ ('' != MyModified() ? ' ' . MyModified() : '')
endfunction


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

"-------------------------------------------
" unite.vim 
"

" Rsense用の設定
autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete

"rsenseのインストールフォルダがデフォルトと異なるので設定
let g:rsenseHome = expand("/Users/takao_maeda/.rbenv/rsense")
let g:rsenseUseOmniFunc = 1

"-------------------------
"For ObjC && C & C++
"-------------------------
let s:clang_library_path='/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib'
if isdirectory(s:clang_library_path)
    let g:clang_library_path=s:clang_library_path
endif

au BufRead,BufNewFile *.md set filetype=markdown

let g:previm_open_cmd = 'open -a Safari'


" For Rust
set hidden
let g:racer_cmd = "/path/to/racer/bin"
let g:quickrun_config = {}
let g:racer_experimental_completer = 1
let g:rustfmt_autosave = 1
let g:rustfmt_command = '$HOME/.cargo/bin/rustfmt'
autocmd BufNewFile,BufRead *.rs let g:quickrun_config.rust = {'exec' : 'cargo run'}

""" deoplete
let g:deoplete#source#attribute#is_silent = 0
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_smart_case = 1
let g:deoplete#auto_complete_start_length = 1
let g:deoplete#keyword_patterns = {}
let g:deoplete#keyword_patterns['default'] = '\h\w*'
let g:deoplete#omni#input_patterns = {}
let deoplete#tag#cache_limit_size = 5000000

" import gocode because of imstall from `github.com/nsf/gocode`


""" deoplete-go
let g:deoplete#sources#go#align_class = 1
let g:deoplete#sources#go#sort_class = ['package', 'func', 'type', 'var', 'const']

let g:tagbar_type_go = {
	\ 'ctagstype' : 'go',
	\ 'kinds'     : [
		\ 'p:package',
		\ 'i:imports:1',
		\ 'c:constants',
		\ 'v:variables',
		\ 't:types',
		\ 'n:interfaces',
		\ 'w:fields',
		\ 'e:embedded',
		\ 'm:methods',
		\ 'r:constructor',
		\ 'f:functions'
	\ ],
	\ 'sro' : '.',
	\ 'kind2scope' : {
		\ 't' : 'ctype',
		\ 'n' : 'ntype'
	\ },
	\ 'scope2kind' : {
		\ 'ctype' : 't',
		\ 'ntype' : 'n'
	\ },
	\ 'ctagsbin'  : 'gotags',
	\ 'ctagsargs' : '-sort -silent'
    \ }

""denite
if has("nvim")
    call denite#custom#var('grep', 'command', ['ag'])
    ""call denite#custom#var('file_rec', 'command', ['ag', '--follow', '--nocolor', '--nogroup', '-g', ''])
    call denite#custom#var('grep', 'default_opts',['-i', '--vimgrep'])
    call denite#custom#var('grep', 'recursive_opts', [])
    call denite#custom#var('grep', 'pattern_opt', [])
    call denite#custom#var('grep', 'separator', ['--'])
    call denite#custom#var('grep', 'final_opts', [])
    call denite#custom#option('default', 'prompt', '>')
    call denite#custom#option('default', 'direction', 'top')
endif
