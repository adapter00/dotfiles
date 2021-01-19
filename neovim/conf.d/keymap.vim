"key map
"--------------------------------------------


" auto browser
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

" split windiow
nnoremap <silent> <C-x>1 :only<CR>
nnoremap <silent> <C-x>2 :sp<CR>
nnoremap <silent> <C-x>3 :vsp<CR>

" window setting
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l
nnoremap sh <C-w>s
nnoremap s= <C-w>=

" tab 
nnoremap sn gt
nnoremap sp gT


map <C-n> :cn<CR>
map <C-p> :cp<CR>
"OmniSharpCompletion
imap <C-Space> <C-x><C-o>



"==================
"Keymap for SuperCollider
"==================

au FileType supercollider nnoremap <buffer> <CR> :call SClang_block()<CR>
au Filetype supercollider vnoremap <buffer> <CR> :call SClang_send()<CR>
au Filetype supercollider nnoremap <buffer> .<CR> :call SClangHardstop()<CR>


"===================
" GTags
"===================
nnoremap <silent> <Space>f :Gtags -f %<CR>
nnoremap <silent> <Space>j :GtagsCursor<CR>
nnoremap <silent> <Space>d :<C-u>exe('Gtags '.expand('<cword>'))<CR>
nnoremap <silent> <Space>r :<C-u>exe('Gtags -r '.expand('<cword>'))<CR>



" 以下はdenite起動時に使用するキーマップ
" バッファ一覧
noremap <C-P> :Denite buffer<CR>
noremap <C-C> :Denite file/rec<CR>
" ファイル一覧
noremap <C-N> :Denite -buffer-name=file file<CR>
" 最近使ったファイルの一覧
noremap <C-Z> :Denite file/old<CR>

"バッファ一覧
nnoremap sB :<C-u>Denite buffer -buffer-name=file<CR>

"Denite でバッファ内検索 
nnoremap <silent> <Leader><C-f> :<C-u>Denite line<CR>
nnoremap <silent> <expr><Space>l ":<C-u>DeniteWithCursorWord line<CR>"

" deoplete tab-complete
inoremap <expr><tab> pumvisible() ? "\<C-n>" : "\<TAB>"
" tern
autocmd FileType go nnoremap <silent> <buffer> gb :TernDef<CR>

"RSpec
nmap <silent><leader>t :call RunCurrentSpecFile()<CR>


