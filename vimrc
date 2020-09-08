" WARNING: I mainly use macOS, this script may or may not work on other
"          operating systems.

" 1,000 thanks to romainl for his "idiomatic vimrc" project.
" Give it a read: https://github.com/romainl/idiomatic-vimrc#readme

" GUARDS {{{1
" This vimrc isn't very useful without the +eval and +syntax features

" See `:h no-eval-feature`
silent! while 0
    echoerr "Your Vim doesn't have the +eval feature."
    finish
silent! endwhile

if !has('syntax')
    echoerr "Your Vim doesn't have the +syntax feature."
    finish
endif

" I don't know if this script will work with NeoVim
if has('nvim')
    echoerr "You are using NeoVim, not Vim."
    finish
endif

" USEFUL FUNCTIONS {{{1
fun s:FileExists(file) abort  " {{{2
    return !empty(glob(a:file))
endfun

fun s:VimFolder() abort  " {{{2
    if has('unix')
        return '~/.vim/'
    elseif has('win32')
        return '$HOME\vimfiles\'
    endif
    throw 'Unknown operating system'
endfun

" VIM-PLUG {{{1
" Install vim-plug if you don't have it yet {{{2
" This will only work on Unix machines (BSD, Linux, etc.)
" Helper functions {{{3
fun s:get_vim_plug() abort
    if !s:user_wants_to('Get vim-plug?')
        return v:false
    endif
    echomsg 'Downloading vim-plug'
    !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    echomsg 'Installing vim-plug'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    return v:true
endfun

fun s:get_vim_plug_docs() abort
    if !s:user_wants_to("Get vim-plug's docs?")
        return v:false
    endif
    echomsg "Downloading vim-plug's help file"
    !curl -fLo ~/.vim/doc/plug.txt --create-dirs
\ https://raw.githubusercontent.com/junegunn/vim-plug/master/doc/plug.txt
    echomsg "Scanning tags of vim-plug's help file"
    helptags ~/.vim/doc
    return v:true
endfun

fun s:user_wants_to(prompt) abort
    let [l:yes, l:no] = [1, 2]
    let l:res = a:prompt->confirm("&Yes\n&No")
    return l:res == l:yes
endfun
" }}}3

" UNTESTED
fun s:try_to_get_vim_plug() abort
    if !has('unix')
        " This script requires Unix to run, as it is dependent on the
        " existence of the cURL command in the path (installed natively
        " on many Unix machines), and uses Unix-style path
        " representations
        return
    endif
    if !has('dialog_' . (has('gui_running') ? 'gui' : 'con'))
        " Can't ask if the user wants to get vim-plug; default to no
        return
    endif

    let l:msg = 'Add the following line at the start of your '
    let l:msg.= 'vimrc to avoid being prompted in the future:'
    let installs = #{
\       vim_plug      : '~/.vim/autoload/plug.vim',
\       vim_plug_docs : '~/.vim/doc/plug.txt',
\   }
    for [install, path] in items(installs)
        let l:toggle_variable_name = 'skip_' . install . '_install'
        if get(s:, l:toggle_variable_name, v:false)
            " User has skipped further installs
            return
        endif
        if s:FileExists(path)
            " No need to install
            continue
        endif
        if !s:get_{install}()
            let l:ine = 'let s:skip_' . install . '_install = v:true'
            echomsg l:msg . "\n" . l:ine
            return
        endif
    endfor
endfun

call s:try_to_get_vim_plug()

" vim-plug configuration {{{2

let s:vim_plug_folder = s:VimFolder() . 'plugged'
call plug#begin(s:vim_plug_folder)

" Filetype plugins {{{3
" Golang
Plug 'fatih/vim-go', { 'do' : ':GoInstallBinaries' }
" Swift
Plug 'keith/swift.vim'
" Plugins for working with Git {{{3
Plug 'tpope/vim-fugitive'
" Git ↑
" Hub ↓
Plug 'tpope/vim-rhubarb'
" }}}3

" My default color scheme
Plug 'w0ng/vim-hybrid'

" Very dark color scheme
Plug 'whatyouhide/vim-gotham'

" Displays useful information in the statusline in a pretty way
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Displays the relevant color for an RGB hex code or CSS color name
Plug 'ap/vim-css-color'

" Keybindings for manipulating parentheses, braces, HTML/XML tags, etc.
Plug 'tpope/vim-surround'

" Add indent objects; useful for Python
Plug 'michaeljsmith/vim-indent-object'

" Aligns text using user defined patterns
Plug 'godlygeek/tabular'

" A personal wiki for Vim
Plug 'vimwiki/vimwiki'

" Helps you naviagate to any word in the line using 'f' and 't'
Plug 'unblevable/quick-scope'

" Allows to use the dot command for plugins's custom mappings
Plug 'tpope/vim-repeat'

if has('osxdarwin')
    Plug '~/.vim/plugged/iTunes-current-track'
endif

" A little video game showing off some of Vim's latest features
Plug 'vim/killersheep'

" Emmet completions for HTML/CSS, etc.
" Plug 'mattn/emmet-vim'

" Helps identify spelling mistakes in code
" Plug 'jaxbot/semantic-highlight.vim'

call plug#end()

" LEADER {{{1

let mapleader      = ' '   " 1 space
let maplocalleader = '  '  " 2 spaces

" cmus {{{2
" Playpause
nnoremap <silent> <leader>c :call system("cmus-remote -u")<cr>
" Previous
nnoremap <silent> <leader>b :call system("cmus-remote -r")<cr>
" Next
nnoremap <silent> <leader>z :call system("cmus-remote -n")<cr>
" }}}2

" Clear search highlighting
nnoremap <silent> <leader>l :<C-U>nohlsearch<cr>

nnoremap <silent> <leader>L :<C-U>AirlineRefresh<cr>

" Quickly edit your .vimrc
nnoremap <silent> <leader>v :<C-U>tabedit $MYVIMRC<cr>
" Quickly edit your gvimrc
nnoremap <silent> <leader>V :<C-U>tabedit $MYGVIMRC<cr>

" Navigate through windows {{{2
nnoremap <leader>w <C-W>w
nnoremap <leader>W <C-W>W

nnoremap <leader>o <C-W>o
nnoremap <leader>O <C-W>c

" MAPPINGS {{{1

" Quick buffer navigation {{{2
" Read https://stackoverflow.com/a/24903110
nnoremap      gb      :ls<cr>:b
tnoremap <C-W>gb <C-W>:ls<cr>:b

" Open existing buffer in new tab
nnoremap      gB      :ls<cr>:tab sbuffer<Space>
tnoremap <C-W>gB <C-W>:ls<cr>:tab sbuffer<Space>

" Quick tab navigation {{{2
" Make it easier to switch tabs
noremap       gr      gT
tnoremap <C-W>gr <C-W>gT

" Quickly close tabs
noremap  <silent>      gx      :tabclose<cr>
tnoremap <silent> <C-W>gx <C-W>:tabclose<cr>
" }}}2

" Remap ZQ to quit all
noremap  <silent>      ZQ      :qall<cr>
tnoremap <silent> <C-W>ZQ <C-W>:qall<cr>
" (since we'll set the conf option,
" a confirmation prompt will be displayed)

" Don't insert non-breaking spaces in text
noremap!        <Space>

" Automatically close braces, brackets, parentheses
inoremap {<CR> {<CR>}<C-O>O
inoremap [<CR> [<CR>]<C-O>O
inoremap (<CR> (<CR>)<C-O>O

if !empty($AZERTY) " {{{2
    " Quickly insert a blank line
    " Convenient mappings for Apple's AZERTY keyboard
    nnoremap § o<Esc>k
    nnoremap ¶ O<Esc>j

    " Toggle casing of a single character
    noremap ç ~
    " Toggle casing of a word
    vnoremap Ç viwç

    " Typing the pipe character is inconvenient in AZERTY keyboards
     noremap! § \|
    tnoremap  § \|
else
    " Quickly insert a blank line
    " Convenient mappings for Apple's English International keyboard
    nnoremap § o<Esc>k
    nnoremap ± O<Esc>j

    " § is closer to the home row than <Esc>
    onoremap  § <Esc>
    vnoremap  § <Esc>
     noremap! § <Esc>
    tnoremap  § <Esc>
endif

" THEMING {{{1

let g:hybrid_reduced_contrast = 1

if has('gui_running')
    se background=dark
endif
colorscheme hybrid
let g:airline_theme = 'hybridline'

" STORE VIM FILES INTO VIMFILES DIRECTORY {{{1
" Swap directory {{{2
let s:directory_folder = s:VimFolder() . 'tmp'
silent call execute('se directory=' . s:directory_folder)

" Create the swap directory if it doesn't exist
if has('unix') && !s:FileExists(s:directory_folder)
    silent !mkdir ~/.vim/tmp
endif

" Viminfo file {{{2
let s:viminfo_folder  = s:VimFolder() . 'viminfo'
if has('viminfo')
    silent call execute('se viminfofile=' . s:viminfo_folder)
endif

" OPTIONS {{{1
" Controversial indentation settings {{{2
se expandtab              " Prefer spaces over tabs
se tabstop=8              " Tabs are 8 columns wide
se shiftwidth=4           " Indent using 4 spaces
se softtabstop=-1         " <Tab> should insert 'sw' spaces
" }}}2

" Highlight some columns
" Helps me to avoid writing long lines
se colorcolumn=73,89,90,91,92,93,94,95,96,97,98,99

se autoindent

se autoread               " Update the file automatically when changed
                          " outside of Vim

                          " Make it so that backspace can:
se backspace=indent       " - remove a level of indentation
se backspace+=eol         " - remove new lines characters
if !has('patch-8.2.0590')
    se backspace+=start   " - backspace before the insertion point
else                      "   but if your Vim is recent enough...
    se backspace+=nostop  "   ... then <C-W> and <C-U> can remove
endif                     "   characters before the insertion point too.

se belloff=all            " Remove Vim's annoying sounds

se confirm                " Ask for confirmation when deleting an
                          " unsaved buffer

se cursorline             " Highlight the cursor's line

se encoding=utf8

if has('folding')         " Creates folds using markers
    se foldmethod=marker  " (i.e: those triple braces sprinkled all over
endif                     " this file)

se hidden                 " Switch between buffers without having to
                          " save first

se ignorecase             " Ignore casing by default in patterns
se smartcase              " unless there are any uppercased characters
                          " in them

se list                   " Render visible:
se listchars=tab:\|\      " - tabs
se listchars+=trail:·     " - trailing spaces
se listchars+=nbsp:¬      " - non-breaking spaces

se nomodeline             " Modelines are unsafe; disable them

                          " Enable <C-A> and <C-X> for:
se nrformats=bin          " - binary literals
se nrformats+=hex         " - hexadecimal literals
se nrformats+=octal       " - octal literals

se number                 " Show line number at cursor
se relativenumber         " and a line number relative to the line of
                          " the cursor for any other lines
                          " See `:h number_relativenumber`

se mouse=                 " Disable the mouse

se scrolloff=3            " There should always be at least 3 lines
                          " above and below the cursor, otherwise scroll
                          " the text if possible
                          " (the choice of the number 3 was inspired by
                          " git, which shows 3 lines of context around
                          " hunks by default)

if has('extra_search')
    set incsearch         " Update search results as you type

    if !&hlsearch         " Don't highlight results when resourcing this
                          " file
        set hlsearch      " Enable result highlighting
    endif
endif

if has('cmdline_info')
    se showcmd
endif

se noshowmode             " Don't show the mode in the last line;
                          " Airline already does

se ttimeout               " time out for key codes
se ttimeoutlen=50         " wait up to 50ms after Esc for special key

se updatetime=250

if has('wildmenu')        " Display completion matches in a status line
    se wildmenu
endif

se wildmode=longest       " Complete longest common string,
se wildmode+=full         " then each full match

" MISCELLANEOUS {{{1

packadd! matchit      " Improved % matching

" Default wikis for vimwiki
let g:vimwiki_list = [{ 'path' : $VIMWIKI_LOCATION }]

" Disable vim-surround's insert mappings
let g:surround_no_insert_mappings = v:true

augroup disableNETRWFoldColumn  " {{{2
    au!
    au BufEnter,WinEnter * if &filetype ==? 'netrw' | se foldcolumn=0
augroup END  " }}}2

