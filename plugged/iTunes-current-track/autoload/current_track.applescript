on run argv
    tell app "" to¬
        return (get current track's name)   & "\n"¬
            &  (get current track's album)  & "\n"¬
            &  (get current track's artist) & "\n"
end run
