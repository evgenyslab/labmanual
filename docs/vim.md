# Vim Guide

- (install in config guide)
- vundle/ plug in managmenet

- shortcuts in insert or other mode?
- entry
- exit
- nerdtree
- git integration
- how to use command line?
- how to use tabs
- what plug in has good find?
- plugin for completion
- plug in for jump to definition/declaration (javascript, c++, python)
- cmake syntax / reading


- in git tracked files, highlight line changes
- name of tabs?

Commands: [Insert | command]
- nertree go into folder?
- open in new tab?
- move to next tab? [gt] [:tabn, :tabnext]
- move to prev tab? [gT] [:tabp, :tabprev]
- move to first tab?
- move to last tab?
- comment in any mode?
- move to end of word?
- move to beginning of word?
- move to end of line
- move to start of line
- move up/down page
- delete word backwards
- delete word forwads
- delete without going into insert?
- select block with n lines
- continuous select
- copy selection
- paste selection
- undo: [command] 'u'


NERDtree:
- shift from NERDTree to file? ctrl+w,l to move to left view, ctrl+w,h to move to right, crtl+w,w flip-flop
- change root to selected folder: 'cd' -> this changes the current dir,
- how to change root folder in nerdtree view?
- how to open nerdtree in every tab?

vimrc
```
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Plugin 'tpope/vim-fugitive'
Plugin 'preservim/nerdtree'
" plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" Git plugin not hosted on GitHub
"Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
"Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
"Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
" Plugin 'ascenator/L9', {'name': 'newL9'}

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

set nu
syntax on
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
```
