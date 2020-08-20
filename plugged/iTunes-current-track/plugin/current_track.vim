" Display Music.app or iTunes' currently playing track on macOS
" Doesn't work yet.

" If this script stops running after upgrading to (or downgrading from)
" Catalina, execute the following command then try again:
" call current_track#reset_script()

if !has('osxdarwin')
    " AppleScript only exists on macOS
    finish
endif

command CurrentTrack echo current_track#main(v:echospace)
