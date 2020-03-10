let g:ale_lint_on_text_changed = 'never'
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1
let g:ale_sign_column_always = 1
let g:ale_lint_on_enter = 0
let g:ale_open_list = 1
let g:ale_keep_list_window_open = 0
let g:ale_linters = {
            \'go':['golangci-lint'],
            \}

" for go

let g:ale_statusline_format = ['⨉ %d', '⚠ %d', '⬥ ok']
let g:ale_sign_error = '⤫'
let g:ale_sign_warning = '⚠'


" for ruby
let g:ale_fixers = {
\   'ruby': ['rubocop'],
\   'go':['goimports'],
\}


let g:ale_fix_on_save=1
