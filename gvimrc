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

" Presentation mode {{{2
let g:presentation_mode_is_active=v:false
let s:on=v:true
let s:off=v:false

" Makes the font bigger
fun TogglePresentationMode() " {{{3
    if g:presentation_mode_is_active
        call TurnPresentationMode(s:off)
    else
        call TurnPresentationMode(s:on)
    endif
endfun


fun TurnPresentationMode(should_turn_it_on) " {{{3
    if a:should_turn_it_on
        execute 'se gfn=' . s:preferred_font . ':h28'
    else
        execute 'se gfn=' . s:preferred_font . ':h' . s:default_font_size
    endif
    let s:presentation_mode_is_active=a:should_turn_it_on
endfun


fun HandlePresentationModeArg(arg='toggle') " {{{3
    if a:arg == 'on'
        return TurnPresentationMode(s:on)
    elseif a:arg == 'off'
        return TurnPresentationMode(s:off)
    elseif a:arg == 'toggle'
        return TogglePresentationMode()
    endif
    throw 'Invalid argument'
endfun " }}}3

command -nargs=? -bar PresentationMode call HandlePresentationModeArg(<f-args>)

" Change font {{{2
" Probably won't work outside of MacVim
fun SetFontFamily(...)
    let no_arguments_provided = !a:0
    if no_arguments_provided
        let display_font_selection_window = 'se guifont=*'
        execute display_font_selection_window
        return
    endif
    let font_name = a:000->join('\ ')
    execute 'se guifont=' . l:font_name . ':h15'
endfun

command -nargs=* SetFontFamily call SetFontFamily(<f-args>)

" Change font size {{{2
" Probably won't work outside of MacVim
fun SetFontSizeTo(new_font_height, bang)
    let gfn_prefix=&guifont->substitute('\v.*\zs:.*', ":h", "")
    if !a:bang
        execute 'se guifont=' . gfn_prefix . a:new_font_height
        return
    endif
    let current_font_size = &guifont->substitute('\v.*:h\ze\d+$', "", "")
    call assert_false(empty(current_font_size), "Couldn't get font size.")
    let l:new_font_height = str2nr(l:current_font_size) + a:new_font_height
    execute 'se guifont=' . gfn_prefix . l:new_font_height
endfun

command -nargs=1 -bang SetFontSize call SetFontSizeTo(<args>, "<bang>" == '!')

