syntax on
set number
set nowrap
set modelines=1
set sidescroll=1

set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'tpope/vim-fugitive'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/nerdcommenter'
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
Plugin 'ascenator/L9', {'name': 'newL9'}
Plugin 'valloric/youcompleteme'

call vundle#end()
filetype plugin indent on

" NERDTree
" autocmd vimenter * NERDTree
map <C-n> :NERDTreeToggle<CR>
let NERDTreeShowHidden=1

" Airline Hacks
set laststatus=2
let g:airline_powerline_fonts=1
set ttimeoutlen=50
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='powerlineish'

" Molokai theme
colorscheme molokai
let g:rehash256=1
