

" if executable('bingo')
"     au User lsp_setup call lsp#register_server({
"                 \ 'name': 'bingo',
"                 \ 'cmd': {server_info->['bingo', '-mode', 'stdio']},
"                 \ 'whitelist': ['go'],
"                 \ })
"     autocmd BufWritePre *.go LspDocumentFormatSync
" endif
