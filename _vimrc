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
