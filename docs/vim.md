# Vim Guide

1. Install vundle:

    TODO

2. Copy vimrc into ~/.vimrc

3. Install plugins

USAGE

MODES: NORMAL | INSERT | COMMAND | VISUAL

NORMAL mode -> key combinations execute actions

COMMAND mode -> pressing `:` in normal mode and typing command in command line

INSERT mode -> typing text into file

VISUAL mode -> selection/highlighting mode

All modes pivot through NORMAL mode, however there are multiple methods to enter VISUAL and INSERT modes from NORMAL mode.

| COMMAND | 

- shortcuts in insert or other mode?
- entry
- exit
- nerdtree
- git integration
- how to use command line? -> use different tab or window. Do not use with VIM
- how to use tabs
- what plug in has good find?
- plugin for completion
- plug in for jump to definition/declaration (javascript, c++, python)
- cmake syntax / reading


- in git tracked files, highlight line changes
- name of tabs?

Commands: [Insert | command]
- nertree go into folder?
- open in new tab? [`:tabnew <file>`]
- move to next tab? [gt] [:tabn, :tabnext]
- move to prev tab? [gT] [:tabp, :tabprev]
- move to first tab? [:ta
- move to last tab?
- comment in any mode?
- move to end of word?
- move to beginning of word?
- move to end of line
- move to start of line
- move up/down page
- delete word backwards `^w`
- delete word forwads
- delete without going into insert?
- select block with n lines -> visual block select using `crtl v`
- continuous select -
- copy selection
- paste selection
- undo: [command] `u` -> [insert mode] `^u`
- shift down half a page: `^d`
- shift half a page up: `^u`
- [Normal mode] Insert Line above: `O`, below `o`, can do `#O` or `#o` for # number of lines

To copy, go into visual mode with 'v' and select lines,

to copy selected lines into buffer use `y` and paste with `p`


NERDtree:
- shift from NERDTree to file? `^w,l` to move to left view, `^w,h` to move to right, crtl+w,w flip-flop
- change root to selected folder: `C`
- how to change root folder in nerdtree view?
- how to open nerdtree in every tab?
- Show hidden files: `SHIFT i`


