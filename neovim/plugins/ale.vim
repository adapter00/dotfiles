let g:ale_enable=1
let g:ale_set_quickfix = 0
let g:ale_sign_column_always = 0
let g:ale_lint_on_enter = 1
let g:ale_open_list = 1
let g:ale_keep_list_window_open = 0
" let g:lsp_diagnostics_enabled = 0     " disable diagnostics support
let g:lsp_signs_enabled = 1           " enable signs
let g:lsp_diagnostics_echo_cursor = 1 " enable echo under cursor when in normal mode
let g:ale_fix_on_save=1
let g:ale_linters = {
            \'golangserver':['golangci-lint'],
            \}


let g:ale_statusline_format = ['⨉ %d', '⚠ %d', '⬥ ok']
let g:ale_sign_error = '⤫'
let g:ale_sign_warning = '⚠'
let g:ale_linters = {'go': ['golint','gobuild']}
" let g:ale_go_golangci_lint_options = '--fast'

let g:ale_fixers = {
\   'ruby': ['rubocop'],
\   'go':['goimports'],
\}


