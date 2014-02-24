set imdisable       "IMを無効化
set dictionary=dictionary/php.dict
set laststatus=2
set rtp+=~/.vim/neobundle/powerline/powerline/bindings/vim
set lines=999 columns=9999
if has('gui_macvim')
    set guifont=Ricty\ Regular:h16
    set transparency=5
    colorscheme molokai 
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
end
if has('gui_runnnig')
    set
    au GUIEnter set
endif
