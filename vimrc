
" Define all plugins
call plug#begin('~/.vim/plugins')
Plug 'scrooloose/nerdcommenter'
Plug 'kien/ctrlp.vim'
call plug#end()

" Enable mouse support
set mouse=a
" Disable auto adding comment characters
au FileType * set fo-=c fo-=r fo-=o

" Fixes occasional issues with backspace key
set backspace=indent,eol,start

" Set vertical bar in insert mode and block in normal mode.
if $TMUX =~ ","
    let &t_SI = "\<esc>Ptmux;\<esc>\<esc>]50;CursorShape=1\x7\<esc>\\"
    let &t_EI = "\<esc>Ptmux;\<esc>\<esc>]50;CursorShape=0\x7\<esc>\\"
elseif $TERM_PROGRAM =~ "iTerm"
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif


" Remap Ctrl + j/k keys to move lines up/down
nnoremap <C-j> <Esc>:m+<Enter>==
nnoremap <C-k> :m .-2<CR>==
inoremap <C-j> <Esc>:m .+1<CR>==gi
inoremap <C-k> <Esc>:m .-2<CR>==gi
vnoremap <C-j> :m '>+1<CR>gv=gv
vnoremap <C-k> :m '<-2<CR>gv=gv
" Remap Ctrl + h/l to move lines left/right
nnoremap <C-l> >>_
nnoremap <C-h> <<_
inoremap <C-l> <Tab>
inoremap <C-h> <C-D>
vnoremap <C-l> >gv
vnoremap <C-h> <gv

set clipboard=unnamed

" Remap ctrl+s to save the current file
nnoremap <C-s> :w<CR>
vnoremap <C-s> <Esc><C-s>gv
inoremap <C-s> <Esc><C-s>

" Remap Enter key to add new line blow current line.
nnoremap <CR> o<ESC>
"nnoremap <S-CR> O<ESC>
"autocmd CmdwinEnter * nnoremap <CR> <CR>
"autocmd BufReadPost quickfix nnoremap <CR> <CR>


" Specify theme stylings.
    "set guitablabel=\[%N\]\ %t\ %M
"autocmd BufEnter * let &titlestring = ' ' . expand("%:t")
"let g:netrw_banner=0
set title
" colorscheme vsdark
colorscheme vsdark
let g:airline_theme = 'vsdark'
syntax on
set number
set numberwidth=5
set noshowcmd
set noshowmode
set noruler
set incsearch
set hlsearch
set wrapscan
set softtabstop=4
set shiftwidth=4

" Highlight the current line in the current window
augroup CursorLine
    au!
    au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
    au WinLeave * setlocal nocursorline
augroup END

" VimDiff Settings
set diffopt+=iwhite
set diffexpr=""

" Color Codes: https://upload.wikimedia.org/wikipedia/commons/1/15/Xterm_256color_chart.svg
hi statusline ctermbg=32 ctermfg=white 

" Customize Status Line
set laststatus=2
set statusline=\ %f      " Path to the file
set statusline+=%h%m%r%w " Flags
set statusline+=%=       " Left/right separator
set statusline+=%l/%L    " Cursor line/total lines
set statusline+=\        " Space
set statusline+=\        " Space
set statusline+=%y       " Filetype
set statusline+=\        " Space


" Set custom NerdCommenter settings
let g:NERDSpaceDelims = 1

" Set custom ctrlP settings
let g:ctrlp_custom_ignore='node_modules\|DS_Store\|.git\|Documents/pynalyzer/stc\|Documents/pynalyzer/local\|Documents/pynalyzer/salesforce\|Documents/pynalyzer/local/coverage\|Documents/pynalyzer/deploy'
let g:ctrlp_cache_dir='~/.vim/.ctrlpcache'
let g:ctrlp_match_window = 'bottom,order:btt,min:5,max:15,results:15'
"let g:ctrlp_match_window = 'top,order:ttb,min:2,max:15,results:15'

