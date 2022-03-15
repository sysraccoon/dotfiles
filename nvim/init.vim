" vim:fileencoding=utf-8:foldmethod=marker

"{{{ Plugins
call plug#begin()
Plug 'shaunsingh/nord.nvim' " nord theme
Plug 'joshdick/onedark.vim' " onedark theme

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} " parser generator. Required by neorg
Plug 'nvim-orgmode/orgmode'

Plug 'nvim-lua/plenary.nvim' " required by telescope and neorg
Plug 'nvim-telescope/telescope.nvim' " fuzzy finder

Plug 'SirVer/ultisnips' " awesome snippet system

Plug 'itspriddle/vim-shellcheck' " shell script linter

Plug 'tmhedberg/matchit' " more power for '%' command

Plug 'sheerun/vim-polyglot' " more languages support

Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' } " autocompletion plugin
Plug 'zchee/deoplete-jedi' " deoplete python autocompletion

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
colorscheme onedark

" use system clipboard
set clipboard+=unnamedplus

" open help in right split
autocmd! BufEnter * if &ft ==# 'help' | wincmd L | endif

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

"{{{ Org Mode Configuration
lua << EOF

-- Load custom tree-sitter grammar for org filetype
require('orgmode').setup_ts_grammar()

-- Tree-sitter configuration
require'nvim-treesitter.configs'.setup {
  -- If TS highlights are not enabled at all, or disabled via `disable` prop, highlighting will fallback to default Vim syntax highlighting
  highlight = {
    enable = true,
    disable = {'org'}, -- Remove this to use TS highlighter for some of the highlights (Experimental)
    additional_vim_regex_highlighting = {'org'}, -- Required since TS highlighter doesn't support all syntax features (conceal)
  },
  ensure_installed = {'org'}, -- Or run :TSUpdate org
}

require('orgmode').setup({
  org_agenda_files = {'~/Dropbox/org/*', '~/my-orgs/**/*'},
  org_default_notes_file = '~/Dropbox/org/refile.org',
})
EOF
"}}}

