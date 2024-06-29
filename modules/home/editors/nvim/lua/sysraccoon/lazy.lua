local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    require("sysraccoon.telescope"),
    require("sysraccoon.harpoon"),
    require("sysraccoon.nvim-cmp"),
    require("sysraccoon.obsidian"),
    require("sysraccoon.hop"),
    require("sysraccoon.suda"),
    require("sysraccoon.vim-tmux-navigator"),
    require("sysraccoon.nvim-treesitter"),
    require("sysraccoon.nvim-lspconfig"),
    require("sysraccoon.conform"),
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
            vim.cmd.colorscheme("catppuccin-mocha")
        end,
    },
    {
        "norcalli/nvim-colorizer.lua", -- Just show me this colors
        lazy = false,
        config = function()
            require("colorizer").setup({ "*" }, {
                names = false,
                RRGGBBAA = true,
                rgb_fn = true,
            })
        end,
    },
    "itspriddle/vim-shellcheck", -- ShellCheck wrapper, allow to analyze shell scripts
    "sheerun/vim-polyglot", -- Language packs
    {
        "stevearc/oil.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },

        config = function()
            require("oil").setup({
                view_options = {
                    show_hidden = true,
                },
            })
            vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
        end,
    },
    {
        "preservim/vim-pencil",
        init = function()
            vim.cmd([[
        augroup pencil
          autocmd!
          autocmd FileType markdown,mkd call pencil#init()
        augroup END
      ]])
            vim.g["pencil#conceallevel"] = 2
            vim.g["pencil#wrapModeDefault"] = "soft"
        end,
    },
})
