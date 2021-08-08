" set expandtab
" function! s:gofmt_on_save()
"   let l:curw = winsaveview()
"   silent execute "0,$! gofmt"
"   try | silent undojoin | catch | endtry
"   call winrestview(l:curw)
" endfunction

" augroup vim-gofmt-autosave
"   autocmd!
"   autocmd BufWritePre *.go call s:gofmt_on_save()
" augroup END
