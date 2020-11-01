" Some useful functions

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

