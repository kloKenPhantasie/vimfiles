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

" VIM-PLUG {{{1

" Install vim-plug if you don't have it yet
" This will only work on Unix machines (BSD, Linux, etc.)
if has('unix')
    source ~/.vim/scripts/install-vim-plug.vim
endif

let s:vim_plug_folder = kkp#VimFolder() . 'plugged'
call plug#begin(s:vim_plug_folder)

" Get and update vim-plug's documentation
Plug 'junegunn/vim-plug'

" Filetype plugins {{{2
" Golang
Plug 'fatih/vim-go', { 'do' : ':GoInstallBinaries' }
" Swift
Plug 'keith/swift.vim'
" Plugins for working with Git {{{2
Plug 'tpope/vim-fugitive'
" Git ↑
" Hub ↓
Plug 'tpope/vim-rhubarb'
" Color schemes {{{2
Plug 'vimoxide/vim-cinnabar'
Plug 'cormacrelf/vim-colors-github'
Plug 'whatyouhide/vim-gotham'
Plug 'w0ng/vim-hybrid'
Plug 'NLKNguyen/papercolor-theme'

" Monochrome
Plug 'beikome/cosme.vim'
Plug 'axvr/photon.vim'
Plug 'danishprakash/vim-yami'
" }}}2

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

" Helps you naviagate to any word in the line using 'f' and 't'
Plug 'unblevable/quick-scope'

" Allows to use the dot command for plugins's custom mappings
Plug 'tpope/vim-repeat'

" A little video game showing off some of Vim's latest features
Plug 'vim/killersheep'

" Allows you to swap two text objects
Plug 'tommcdo/vim-exchange'

" Allows for smooth scrolling
Plug 'psliwka/vim-smoothie'

" A plugin to ensure files are well-formatted
Plug 'editorconfig/editorconfig-vim'

" Emmet completion for HTML/CSS
Plug 'mattn/emmet-vim'

if has('osxdarwin')
    Plug '~/.vim/plugged/iTunes-current-track'
endif

call plug#end()

" LEADER {{{1

let mapleader      = ' '   " 1 space
let maplocalleader = '  '  " 2 spaces

" cmus {{{2
" Playpause
nnoremap <silent> <leader>c :call system("cmus-remote -u")<cr>
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

nnoremap ² <C-]>

" We don't use it as a leader key; how about we use it to write
" commands? It avoids the inconvenience of pressing shift to write
" ':' in QWERTY keyboards.
 noremap \      :
tnoremap <C-W>\ :

if !empty($AZERTY) " {{{2
    " Quickly insert a blank line
    " Convenient mappings for Apple's AZERTY keyboard
    nnoremap § o<Esc>kgM
    nnoremap ¶ O<Esc>jgM

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
    nnoremap § o<Esc>kgM
    nnoremap ± O<Esc>jgM

    " § is closer to the home row than <Esc>
    onoremap  § <Esc>
    vnoremap  § <Esc>
     noremap! § <Esc>
    tnoremap  § <Esc>
endif

" THEMING {{{1

" Special theming for quick-scope
augroup qs_colors
    au!

    au ColorScheme cinnabar
\       hi! link QuickScopePrimary cinnabarBlue

    au ColorScheme github
\       hi! link QuickScopeSecondary Question

    au ColorScheme PaperColor
\   if &background == 'dark'                                           |
\       hi QuickScopePrimary guifg=#00af5f ctermfg=35                  |
\   else                                                               |
\       hi QuickScopePrimary guifg=#ff8700 ctermfg=208                 |

    au ColorScheme photon
\       hi! link QuickScopePrimary Todo                                |
\       hi QuickScopeSecondary ctermfg=108 guifg=#87af87

    au ColorScheme yami
\       hi! link QuickScopePrimary Todo                                |
\       hi QuickScopeSecondary guifg=#52de97

augroup END

augroup fix_yami
    au!
    au ColorScheme yami                                                |
\       hi! link StatusLine ColorColumn
augroup END

let g:hybrid_reduced_contrast = 1

colorscheme cosme
let g:airline_theme = 'cosme'

" STORE VIMINFO INTO VIMFILES DIRECTORY {{{1
let s:viminfo_folder  = kkp#VimFolder() . 'viminfo'
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

se clipboard=             " Don't use the system clipboard as the
                          " default register

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

se nojoinspaces           " always add a single space when using J

se list                   " Render visible:
se listchars=tab:\|\      " - tabs
se listchars+=trail:·     " - trailing spaces
se listchars+=nbsp:¬      " - non-breaking spaces

se nomodeline             " Modelines are unsafe; disable them

                          " Enable <C-A> and <C-X> for:
se nrformats=bin          " - binary literals
se nrformats+=hex         " - hexadecimal literals
se nrformats+=octal       " - octal literals

se numberwidth=3          " Use 3 columns to display
se relativenumber         " the line number relative to the cursor line
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

se noswapfile             " Disable swap files, use a VCS instead

if has('termguicolors')   " Use the same colors in the terminal as the
    se termguicolors      " colors that would be used in GVim
endif

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

" Disable EditorConfig in remote files and fugitive,
" as suggested in the repo's README on GitHub
let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']

" Options for emmet-vim {{{2
let g:user_emmet_install_global = 0
autocmd FileType html,css,php EmmetInstall

augroup disableNETRWFoldColumn  " {{{2
    au!
    au BufEnter,WinEnter * if &filetype ==? 'netrw' | se foldcolumn=0
augroup END  " }}}2

