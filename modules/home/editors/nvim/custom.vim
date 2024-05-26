" vim:fileencoding=utf-8:foldmethod=marker

"{{{ Vim-Plug Installer
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
"}}}

"{{{ Plugins
call plug#begin()

Plug 'lunarvim/horizon.nvim'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} " parser generator. Required by neorg

Plug 'norcalli/nvim-colorizer.lua' " color highlighter

Plug 'nvim-lua/plenary.nvim' " required by telescope and neorg
Plug 'nvim-telescope/telescope.nvim' " fuzzy finder

Plug 'SirVer/ultisnips' " awesome snippet system

Plug 'itspriddle/vim-shellcheck' " shell script linter

Plug 'tmhedberg/matchit' " more power for '%' command

Plug 'sheerun/vim-polyglot' " more languages support

Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' } " autocompletion plugin
Plug 'zchee/deoplete-jedi' " deoplete python autocompletion

Plug 'jeetsukumaran/vim-pythonsense' " additional text objects and motins for python

Plug 'lambdalisue/suda.vim'

call plug#end()
"}}}

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
set expandtab
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

" comment options
set formatoptions-=cro " disable comment continuation on new line

" disable noise
set noswapfile " disable .swp files
set nobackup " disable backup
set noerrorbells " disable sound on errors

" navigation enhanced
set scrolloff=10
set scrolljump=10
set sidescroll=10
set nowrap

" enable true color support
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
set termguicolors

" code highlighting
syntax on
" colorscheme horizon

" transparent background
highlight Normal guibg=none
highlight NonText guibg=none
highlight Normal ctermbg=none
highlight NonText ctermbg=none
highlight TelescopeNormal guibg=none

" use system clipboard
set clipboard+=unnamedplus

" open help in right split
autocmd! BufEnter * if &ft ==# 'help' | wincmd L | endif

fun! s:cabbrev(lhs, rhs)
  exe "cnoreabbrev <expr> " . a:lhs .
    \ " (getcmdtype() ==# ':' && getcmdline() ==# '" . a:lhs .
    \ "') ? '".a:rhs."' : '".a:lhs."'"
endfun
"}}}

"{{{ Custom remaps
let mapleader = " "

nnoremap <Space> <NOP>
nnoremap <leader>-r :source $MYVIMRC<cr>
"}}}

"{{{ Telescope Configuration
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>

" Fix deoplete autocompletion in telescope
autocmd FileType TelescopePrompt call deoplete#custom#buffer_option('auto_complete', v:false)
"}}}

"{{{ UltiSnips Configuration
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsListSnippets="<c-tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
"}}}

"{{{ Shellcheck Configuration
nnoremap <leader>as :ShellCheck!<cr>
"}}}

"{{{ Deoplete Configuration
let g:deoplete#enable_at_startup = 1
"}}}

"{{{ Suda.vim Configuration
call s:cabbrev('W!', 'SudaWrite')
"}}}

"{{{ Colorizer Configuration
lua require 'colorizer'.setup({'*'}, { names=false; RRGGBBAA=true; rgb_fn=true; })
"}}}
