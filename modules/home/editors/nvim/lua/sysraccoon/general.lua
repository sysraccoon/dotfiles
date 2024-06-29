-- line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- indent options
vim.opt.autoindent = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.smarttab = true

-- mouse support
vim.opt.mouse = "a"

-- nvim and buffer encoding
vim.opt.enc = "utf-8"
vim.opt.fenc = "utf-8"
vim.opt.emo = false

-- search options
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = false
vim.opt.mmp = 10240

-- comment options
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    vim.opt.formatoptions = vim.opt.formatoptions - { "c", "r", "o" }
  end,
})

-- disable noise
vim.opt.swapfile = false -- disable .swp files
vim.opt.backup = false -- disable backup
vim.opt.errorbells = false -- disable sound on errors

-- navigation enhanced
vim.opt.scrolloff = 10
vim.opt.scrolljump = 10
vim.opt.sidescroll = 10
-- vim.opt.wrap = false

-- enable true color support
vim.opt.termguicolors = true

-- additional visibility options
vim.opt.conceallevel = 2

-- use system clipboard
vim.opt.clipboard:append({ "unnamedplus" })

-- custom remaps
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>", "<NOP>", { noremap = true, silent = true })
vim.keymap.set("n", "j", "gj", { noremap = true, silent = true })
vim.keymap.set("n", "k", "gk", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>cf", ":e %:h/")
vim.keymap.set("n", "<leader>cc", ":e ")

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("x", "<leader>p", [["_dP]])

vim.keymap.set("n", "<PageUp>", "<C-u>zz")
vim.keymap.set("n", "<PageDown>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-d>", "<C-d>zz")

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
