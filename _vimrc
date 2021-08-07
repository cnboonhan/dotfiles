set nocompatible
colo elflord
syntax on 
filetype plugin on
let mapleader=","

set path+=**
set wildmenu
set hidden
set mouse=a
set tabstop=4 softtabstop=4 shiftwidth=4 expandtab smarttab autoindent breakindent
set incsearch ignorecase smartcase hlsearch 
set relativenumber
set backspace=indent,eol,start
set clipboard=unnamedplus

autocmd VimLeave * call system('echo ' . shellescape(getreg('+')) . 
  \ ' | xclip -selection clipboard')

if !isdirectory("/tmp/.vim-undo-dir")
  call mkdir("/tmp/.vim-undo-dir", "", 0700)
endif
set undodir=/tmp/.vim-undo-dir
set undofile

nnoremap <leader>l :set relativenumber! nu! nonu<CR>
nmap <leader><leader> :noh<CR>
nmap <leader>r :so $HOME/.vimrc<CR> 

" Paste without setting paste/nopaste
let &t_SI .= "\<Esc>[?2004h"
let &t_EI .= "\<Esc>[?2004l"

inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()

function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ""
endfunction

source $HOME/.vimrc.plugins
