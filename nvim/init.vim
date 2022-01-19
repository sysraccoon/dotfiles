" vim:fileencoding=utf-8:foldmethod=marker

"{{{ General
set nocp " disable compatible mode
filetype plugin on

" line numbers
set number
set relativenumber

" indent options
set autoindent
set tabstop=4
set shiftwidth=4
set softtabstop=4
set smarttab

" mouse support
set mouse=a

" nvim and buffer encoding
set enc=utf-8
set fenc=utf-8
set noemo " disable emoji

" search options
set smartcase " ignore case for small characters in pattern, otherwise consider it
set incsearch " enable increment search
set nohlsearch " disable search highlight
set mmp=10240 " maximum amount of memory in Kbyte used for pattern matching

" disable noise
set noswapfile " disable .swp files
set nobackup " disable backup
set noerrorbells " disable sound on errors

" navigation enhanced
set scrolloff=10
set scrolljump=10
set sidescroll=10
set nowrap

" enable more colors
set termguicolors

" use system clipboard
set clipboard+=unnamedplus

" open help in right split
autocmd! BufEnter * if &ft ==# 'help' | wincmd L | endif

nnoremap <Space> <NOP>
let mapleader = " "
"}}}

"{{{ Plugins
call plug#begin()
Plug 'gruvbox-community/gruvbox'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'SirVer/ultisnips'
call plug#end()
"}}}

colorscheme gruvbox

nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>

let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
