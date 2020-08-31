# vimfiles
A partial copy of my current .vim directory.

**Note:**
Feel free to copy any part of this repository that interests you; the
very permissive license of this repository (0BSD) was chosen to
encourage this.
However, please don't blindly clone this repository to your vimfiles: one
major advantage of using Vim is that you can adapt it to your workflow
(which is definitely different from mine).

## Cool mappings for AZERTY keyboards

As a user of an AZERTY keyboard, I've added a few mappings taking
advantage of the keys unused by Vim.
If that's interesting to you, feel free to copy the lines of code below
in your vimrc.

```
" Quickly insert a blank line
" Convenient mappings for Apple's AZERTY keyboard
nnoremap § o<Esc>k
nnoremap ¶ O<Esc>j

" Toggle casing of a single character
noremap ç ~
" Toggle casing of a word
vnoremap Ç viwç

" Typing the pipe character is inconvenient in AZERTY keyboards
cnoremap § \|
inoremap § \|
tnoremap § \|
```
