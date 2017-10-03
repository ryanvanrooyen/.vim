
" Define all plugins
call plug#begin('~/.vim/plugins')
Plug 'scrooloose/nerdcommenter'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'henrik/vim-indexed-search'
Plug 'scrooloose/syntastic'
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

" Map leader to the ; charcter.
let mapleader = ";"

" nnoremap <leader>f :copen<CR>
" autocmd BufWinEnter quickfix map <leader>f <C-w>w
" autocmd BufLeave quickfix map <leader>f <Esc>:copen<CR>

" QuickFix window key bindings
autocmd BufWinEnter quickfix map o <CR><C-W>w

function s:FindInFiles(searchTerm)
    let ag_cmd = 'ag --hidden --nogroup --nocolor -p ~/.zsh/.agignore ' . shellescape(a:searchTerm)
    " echo ag_cmd
    lgete system(ag_cmd)
    lopen
endfunction
command! -nargs=1 Find call s:FindInFiles(<q-args>)
nnoremap <leader>f :Find<space>

function FindCurrentWord()
    let wordUnderCursor = expand("<cword>")
    call s:FindInFiles(wordUnderCursor)
endfunction
" bind K to grep word under cursor
nnoremap K :call FindCurrentWord()<CR>

nnoremap <leader>d :Files<Enter>
nnoremap <C-n> :History<Enter>

" Set leader then 'x' to quit and save changes
nnoremap <leader>x :x<Enter>
nnoremap <leader>X :xa<Enter>
" Set leader then 'q' to quit and discard changes
nnoremap <leader>q :q!<Enter>
nnoremap <leader>Q :qa!<Enter>

" Set leader then 'n' to search the current word under cursor
nnoremap <leader>n *N

" Allow double tapping leader key to toggle selected line comments
nnoremap <leader><leader> :call NERDComment('n', 'Invert')<Enter>
vnoremap <leader><leader> :call NERDComment('x', 'Invert')<Enter>

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

nnoremap <C-t> :FZF<Enter>
inoremap <C-t> <Esc> :FZF<Enter>
vnoremap <C-t> :FZF<Enter>

set clipboard=unnamed

" Remap ctrl+s to save the current file
nnoremap <C-s> :w<CR>
nnoremap <leader>s :w<CR>
vnoremap <C-s> <Esc><C-s>gv
vnoremap <leader>s <Esc><C-s>gv
inoremap <C-s> <Esc><C-s>
inoremap <leader>s <Esc><C-s>

" Remap Enter key to add new line blow current line.
" nnoremap <CR> o<ESC>
"nnoremap <S-CR> O<ESC>
"autocmd CmdwinEnter * nnoremap <CR> <CR>
"autocmd BufReadPost quickfix nnoremap <CR> <CR>


"let g:netrw_banner=0
" colorscheme vsdark
set title
colorscheme vsdark
let g:airline_theme = 'vsdark'
syntax on
set number
set numberwidth=5
set noshowcmd
" set noshowmode
set noruler
set incsearch
set hlsearch
set wrapscan
set softtabstop=4
set shiftwidth=4
set title

" display the filename in the screen/window title and set it back to "bash" on exit
autocmd BufEnter * let &titlestring = expand("%:t")
let &titleold="bash"
if &term == "screen"
set t_ts=�k
set t_fs=�\
endif
if &term == "screen" || &term == "xterm"
  set title
endif

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

" set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*

" Set custom NerdCommenter settings
let g:NERDSpaceDelims = 1

let $FZF_DEFAULT_COMMAND = 'ag --hidden -p ~/.zsh/.agignore -g ""'

" Set custom Syntastic settings
let g:syntastic_mode_map={'mode': 'passive'}
let g:syntastic_always_populate_loc_list = 1
" let g:syntastic_auto_loc_list = 1
" let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

set scroll=5
