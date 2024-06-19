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
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme "catppuccin-mocha"
    end
  },
  {
    "nvim-treesitter/nvim-treesitter", -- Enable incremental parser and syntax highlighter
    build = ":TSUpdate",
  },
  { 
    "norcalli/nvim-colorizer.lua", -- Just show me this colors
    lazy=false,
    config = function()
      require "colorizer".setup({"*"}, {
        names=false;
        RRGGBBAA=true;
        rgb_fn=true;
      })
    end,
  },
  "itspriddle/vim-shellcheck", -- ShellCheck wrapper, allow to analyze shell scripts
  "sheerun/vim-polyglot", -- Language packs
})

