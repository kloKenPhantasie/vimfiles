" NOTE: Many of these options only work on MacVim

se guioptions=c
se notitle

" When Vim shows a file browser, point it at the current directory
se browsedir=current

" SET FONTS {{{1
" Quickly see gVim's font size
nnoremap <leader>F :se gfn?<cr>

let s:preferred_font="mononoki"
let s:default_font_size=13
execute 'se gfn=' . s:preferred_font . ':h' . s:default_font_size

