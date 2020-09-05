" Display Music.app or iTunes' currently playing track
" Doesn't work yet.

" If this script stops running after you upgraded to (or downgraded
" from) Catalina, execute the following command then try again:
" call current_track#reset_script()

if !has('osxdarwin')
    " AppleScript only exists on macOS
    finish
endif

let s:ource_code = expand('<sfile>:p:r') . '.applescript'
let s:compiled   = expand('<sfile>:p:r') . '.scpt'

fun s:FileExists(file) abort  " {{{1
    return !empty(glob(a:file))
endfun

fun s:wrap(input, max_column_no, wrapchar='') abort  " {{{1
    if strdisplaywidth(a:wrapchar) >= strdisplaywidth(a:max_column_no)
        return
    elseif strdisplaywidth(a:input) <= a:max_column_no
        return a:input
    endif
    return substitute(a:input,
        \ '\v.{'
        \ . (a:max_column_no - strdisplaywidth(a:wrapchar))
        \ . '}\zs.*',
        \ a:wrapchar, '')
endfun

fun s:CompileScript() abort  " {{{1
    call s:FileExists(s:ource_code)->assert_true('current_track.applescript not found')
    if !s:FileExists(s:compiled)
        call system('open -gjb com.Apple.music')
        let app_name = v:shell_error ? '"iTunes"' : '"Music"'
        call system("sed -e 's/\"\"/" . app_name . '/g '
\           . '-i .template ' . shellescape(s:ource_code))
        call system('osacompile ' . shellescape(s:ource_code) . ' -o ' . s:compiled)
    endif
endfun  " }}}1

" Displays current track in the format 'Title[ — Album] — Artist'
fun! current_track#main(max_col_no=0) abort  " {{{1
    call s:CompileScript()
    const scpt = 'osascript ' . s:compiled
    try   | let [title, album, artist] = systemlist(scpt)
    catch | throw "Couldn't get current track info"
    endtry
    let title  = empty(title)  ? 'Unknown Title'  : title
    let album  = empty(album)  ? 'Unknown Album'  : album
    let artist = empty(artist) ? 'Unknown Artist' : artist
    const long_res = title . ' — ' . album . ' — ' . artist
    if 0 <= a:max_col_no && a:max_col_no < strdisplaywidth(long_res)
        const short_res = title . ' — ' . artist
        return s:wrap(short_res, a:max_col_no, '…')
    endif
    return long_res
endfun

fun current_track#reset_script() abort " {{{1
    call system('rm ' . s:compiled)
    call system('mv -f '. s:ource_code . '.template ' . s:ource_code)
endfun

