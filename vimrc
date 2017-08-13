
" Define all plugins
call plug#begin('~/.vim/plugins')
Plug 'scrooloose/nerdcommenter'
Plug 'kien/ctrlp.vim'
call plug#end()

" Enable mouse support
set mouse=a
" Disable auto adding comment characters
au FileType * set fo-=c fo-=r fo-=o

if $TERM_PROGRAM =~ "iTerm"
    let &t_SI = "\<Esc>]50;CursorShape=1\x7" " Vertical bar in insert mode
    let &t_EI = "\<Esc>]50;CursorShape=0\x7" " Block in normal mode
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
colorscheme vsdark
syntax on
set number
set numberwidth=5
set showcmd
set incsearch
set hlsearch
set wrapscan 
set softtabstop=4
set shiftwidth=4

" Set custom ctrlP settings
let g:ctrlp_custom_ignore='node_modules\|DS_Store\|.git\|Documents/pynalyzer/stc\|Documents/pynalyzer/local\|Documents/pynalyzer/salesforce\|Documents/pynalyzer/local/coverage\|Documents/pynalyzer/deploy'
let g:ctrlp_cache_dir='~/.vim/.ctrlpcache'
let g:ctrlp_match_window = 'bottom,order:btt,min:5,max:15,results:15'
"let g:ctrlp_match_window = 'top,order:ttb,min:2,max:15,results:15'
"let g:ctrlp_buffer_func = {
    "\ 'enter': 'Function_Name_1',
    "\ 'exit':  'Function_Name_2',
    "\ }

"func! Function_Name_1()
    "set laststatus=0
"endfunc
"func! Function_Name_2()
    "set laststatus=2
"endfunc


