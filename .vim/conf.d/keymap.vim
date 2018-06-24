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

" move cursor
" nnoremap <C-a> <HOME>
" nnoremap <C-l> <End>

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


"================
" Keymap for Gtags
"================

nmap <C-g> :Gtags -g
nmap <C-l> :Gtags -f %<CR>
nmap <C-j> :Gtags <C-r><C-w><CR>
nmap <C-k> :Gtags -r <C-r><C-w><CR>
nmap <C-n> :cn<CR>
nmap <C-p> :cp<CR>
