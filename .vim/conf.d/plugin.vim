
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

"--------------------------------------------
"my snippet path
"-------------------------------------------
let s:my_snippet='~/.dotfiles/.vim/snippet/'
let g:neosnippet#snippets_directory=s:my_snippet
" For snippet_complete marker.
if has('conceal')
    set conceallevel=2 concealcursor=i
endif

"-------------------------------------------
" unite.vim 
"
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
let s:clang_library_path='/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib'
if isdirectory(s:clang_library_path)
    let g:clang_library_path=s:clang_library_path
endif

