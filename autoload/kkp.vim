" Some useful functions


" Vim requires that autoloaded functions are named using the following
" pattern: filename#funcname()
" (see :h autoload)
" The {expand('<sfile>:t:r')} trick allows you to get the current file
" name and to remove its extension (see :h expand()), and to insert it
" to the function's name using curly-braces-names
" This allows us to rename the file without changing any of its contents

fun {expand('<sfile>:t:r')}#FileExists(file) abort
    return !empty(glob(a:file))
endfun

fun {expand('<sfile>:t:r')}#VimFolder() abort
    if has('unix')
        return '~/.vim/'
    elseif has('win32')
        return '$HOME\vimfiles\'
    endif
    throw 'Unknown operating system'
endfun

