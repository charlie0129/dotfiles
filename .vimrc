" Basics
set nocompatible
syntax on
filetype plugin indent on

" UI
set number
set relativenumber
set cursorline
set ruler
set showcmd
set laststatus=2
set wildmenu
set wildmode=longest:full,full
set scrolloff=5
set sidescrolloff=8
set signcolumn=yes

" Search
set ignorecase
set smartcase
set incsearch
set hlsearch

" Press Space+h to clear search highlight
let mapleader=" "
nnoremap <leader>h :nohlsearch<CR>

" Indentation
set autoindent
set smartindent
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4

" Editing
set backspace=indent,eol,start
set hidden
set mouse=a
set clipboard=unnamed
set completeopt=menuone,noinsert,noselect

" Files
set autoread
set nobackup
set nowritebackup
set noswapfile

" Encoding
set encoding=utf-8
set fileencoding=utf-8

" Better splits
set splitbelow
set splitright

" Colors
set termguicolors
set background=dark
colorscheme desert
highlight Normal ctermbg=NONE guibg=NONE
highlight NonText ctermbg=NONE guibg=NONE
highlight EndOfBuffer ctermbg=NONE guibg=NONE
highlight SignColumn ctermbg=NONE guibg=NONE
highlight LineNr ctermbg=NONE guibg=NONE
highlight Folded ctermbg=NONE guibg=NONE

" Show invisible chars
set list
set listchars=tab:»\ ,trail:·,extends:>,precedes:<,nbsp:+

" Statusline
set statusline=%f\ %m%r%h%w\ [%{&ff}]\ [%Y]\ [%l,%c]\ [%p%%]

" Easier split navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Save with Ctrl-s
nnoremap <C-s> :w<CR>
inoremap <C-s> <Esc>:w<CR>a
