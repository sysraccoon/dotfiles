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
        vim.opt.formatoptions = vim.opt.formatoptions - { "c","r","o" }
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
vim.opt.wrap = false

-- enable true color support
vim.opt.termguicolors = true

-- conceal syntax
vim.opt.conceallevel = 2

-- use system clipboard
vim.opt.clipboard:append { "unnamedplus" }

-- custom remaps
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>", "<NOP>", { noremap = true, silent = true })

require("lazy").setup({
  {
    "lunarvim/horizon.nvim", -- I use horizon colorscheme btw
    config = function()
      vim.cmd[[colorscheme horizon]]
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter", -- Enable incremental parser and syntax highlighter
    build = ":TSUpdate",
  }, 
  "norcalli/nvim-colorizer.lua", -- Just show me this colors
  {
      "nvim-telescope/telescope.nvim", -- Awesome fuzzy finder
      lazy=false,
      dependencies = {
          "nvim-lua/plenary.nvim",
      },
      keys = {
          { mode="n", "<leader>ff", "<cmd>Telescope find_files<cr>" },
          { mode="n", "<leader>fg", "<cmd>Telescope live_grep<cr>" },
          { mode="n", "<leader>fb", "<cmd>Telescope buffers<cr>" },
      },
      config = function()
        require "colorizer".setup({"*"}, { names=false; RRGGBBAA=true; rgb_fn=true; })
      end,
  },
  "SirVer/ultisnips", -- Just snippets
  "itspriddle/vim-shellcheck", -- ShellCheck wrapper, allow to analyze shell scripts
  "sheerun/vim-polyglot", -- Language packs
  {
      "ThePrimeagen/harpoon",
      branch = "harpoon2",
      lazy = false,
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
      },
      keys = {
        { mode="n", "<leader>hh", function() require("harpoon"):list():add() end, },
        { mode="n", "<leader>ha", function() require("harpoon"):list():select(4) end, },
        { mode="n", "<leader>ho", function() require("harpoon"):list():select(3) end, },
        { mode="n", "<leader>he", function() require("harpoon"):list():select(2) end, },
        { mode="n", "<leader>hu", function() require("harpoon"):list():select(1) end, },
        { mode="n", "<C-Tab>", function() require("harpoon"):list():next() end, },
        { mode="n", "<C-S-Tab>", function() require("harpoon"):list():prev() end, },
      },
      config = function()
        local harpoon = require('harpoon')
        harpoon:setup({})

        -- basic telescope configuration
        local conf = require("telescope.config").values
        local function toggle_telescope(harpoon_files)
            local file_paths = {}
            for _, item in ipairs(harpoon_files.items) do
                table.insert(file_paths, item.value)
            end

            require("telescope.pickers").new({}, {
                prompt_title = "Harpoon",
                finder = require("telescope.finders").new_table({
                    results = file_paths,
                }),
                previewer = conf.file_previewer({}),
                sorter = conf.generic_sorter({}),
            }):find()
        end

        vim.keymap.set("n", "<leader>ht", function() toggle_telescope(harpoon:list()) end,
            { desc = "Open harpoon window" })
    end

  },
  {
    "lambdalisue/suda.vim", -- Allow perform sudo commands inside vim (useful when edit RO file and want save changes)
    keys = {
      { mode="ca", "W!", "SudaWrite" },
    },
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",

      "SirVer/ultisnips",
      "quangnguyen30192/cmp-nvim-ultisnips",
    },
    config = function()
      local cmp = require "cmp"

      cmp.setup {
        snippet = {
          expand = function(args)
            vim.fn["UltiSnips#Anon"](args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources(
          {
            { name = "nvim_lsp" },
            { name = "ultisnips" },
          },
          {
            { name = 'buffer' },
          }
        ),
      }
    end,
  },
  { 
    "epwalsh/obsidian.nvim", -- Writing and navigating obsidian vaults
    version = "*",
    lazy = true,
    event = {
      "BufReadPre " .. vim.fn.expand "~" .. "/vaults/**.md",
      "BufNewFile " .. vim.fn.expand "~" .. "/vaults/**.md",
    },
    cmd = {
      "ObsidianSearch",
      "ObsidianWorkspace",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
    },
    keys = {
      { mode = "n", "<leader>oo", "<cmd>ObsidianSearch<cr>"},
      { mode = "n", "<leader>ob", "<cmd>ObsidianBacklinks<cr>"},
      { mode = "n", "<leader>ow", "<cmd>ObsidianWorkspace<cr>"},
      { mode = "n", "<leader>ot", "<cmd>ObsidianTemplate<cr>"},
      { mode = "n", "<leader>or", "<cmd>ObsidianRename<cr>"},
      { mode = "v", "<leader>oe", ":'<,'>ObsidianExtractNote<cr>"},
    },
    opts = {
      workspaces = {{
        name = "notes",
        path = "~/vaults/notes",
        overrides = {
          notes_subdir = "main",
          templates = {
            folder = "templates";
            date_format = "%Y-%m-%d",
            time_format = "%H:%M",
          },
        },
      }},

      follow_url_func = function(url)
        vim.fn.jobstart({"xdg-open", url})
      end,

      use_advanced_uri = true,
      
      completion = {
        nvim_cmp = true,
      },
    },
  },
})


