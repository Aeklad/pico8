
set nu
"au BufRead,BufNewFile *.stc set filetype=pico8
"set runtimepath^=~/.vim/bundle/badwolf
"syntax on
"set syntax=pico
"set smartindent
"set ft=pico
set tabstop=4
set softtabstop=0
set shiftwidth=4
"set autoindent
"set smartindent
" BASIC SETUP:
set nocompatible
set relativenumber
syntax enable
filetype plugin on 
filetype indent on 
set path +=**
set wildmenu
let g:netrw_liststyle=3
"read jamie.txt into current file
"nnoremap ,jamie :-lread ~/.vim/jamie.txt<CR>3jwf>a 
nnoremap <F2> <Esc>:w<CR>:exec '!clear; pico8' shellescape(@%, 1) '-run' <cr>
nnoremap <F3> <Esc>:w<CR>:exec '!clear; python' shellescape(@%, 1) <cr>

colorscheme pico
"augroup VCenterCursor
" au!
" au BufEnter,WinEnter,WinNew,VimResized *,*.*
"    \ let &scrolloff=winheight(win_getid())/2
