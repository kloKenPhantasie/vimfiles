setlocal spell
" Open the output of git diff --cached on a preview window
nnoremap <buffer> <Localleader><Localleader> :<C-U>DiffGitCached<CR>
" Abort
nnoremap <buffer> <C-C><C-K> ggdG:wq<CR>
