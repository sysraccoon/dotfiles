-- ~/~ begin <<notes/nvim.md#modules/home/editors/nvim/lua/sysraccoon/init.lua>>[init]
-- ~/~ begin <<notes/nvim.md#nvim-lua-general>>[init]
vim.opt.number = true
vim.opt.relativenumber = true
-- ~/~ end
-- ~/~ begin <<notes/nvim.md#nvim-lua-general>>[1]
vim.opt.autoindent = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.smarttab = true
-- ~/~ end
-- ~/~ begin <<notes/nvim.md#nvim-lua-general>>[2]
vim.opt.mouse = "a"
-- ~/~ end
-- ~/~ begin <<notes/nvim.md#nvim-lua-general>>[3]
vim.opt.enc = "utf-8"
vim.opt.fenc = "utf-8"
-- ~/~ end
-- ~/~ begin <<notes/nvim.md#nvim-lua-general>>[4]
vim.opt.emo = false
-- ~/~ end
-- ~/~ begin <<notes/nvim.md#nvim-lua-general>>[5]
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = false
vim.opt.mmp = 10240
-- ~/~ end
-- ~/~ begin <<notes/nvim.md#nvim-lua-general>>[6]
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    vim.opt.formatoptions = vim.opt.formatoptions - { "c", "r", "o" }
  end,
})
-- ~/~ end
-- ~/~ begin <<notes/nvim.md#nvim-lua-general>>[7]
vim.opt.swapfile = false -- disable .swp files
vim.opt.backup = false -- disable backup
vim.opt.errorbells = false -- disable sound on errors
-- ~/~ end
-- ~/~ begin <<notes/nvim.md#nvim-lua-general>>[8]
vim.opt.scrolloff = 10
vim.opt.scrolljump = 10
vim.opt.sidescroll = 10
-- ~/~ end
-- ~/~ begin <<notes/nvim.md#nvim-lua-general>>[9]
vim.opt.termguicolors = true
-- ~/~ end
-- ~/~ begin <<notes/nvim.md#nvim-lua-general>>[10]
vim.opt.clipboard:append({ "unnamedplus" })
-- ~/~ end
-- ~/~ begin <<notes/nvim.md#nvim-lua-general>>[11]
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("sysraccoon-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
-- ~/~ end
-- ~/~ begin <<notes/nvim.md#nvim-lua-general>>[12]
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
-- ~/~ end
-- ~/~ begin <<notes/nvim.md#nvim-lua-plugins>>[init]
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- ~/~ begin <<notes/nvim.md#nvim-lua-lazy-plugins>>[init]

  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("catppuccin-mocha")
      -- Tweak some colors
      -- ~/~ begin <<notes/nvim.md#nvim-lua-color-tweaks>>[init]
      vim.cmd([[highlight CodeBlock guibg=#181825]])
      -- ~/~ end
    end,
  },
  -- ~/~ end
  -- ~/~ begin <<notes/nvim.md#nvim-lua-lazy-plugins>>[1]
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = {
      { mode = "n", "<leader>ff", "<cmd>Telescope find_files no_ignore=true<cr>" },
      { mode = "n", "<leader>fg", "<cmd>Telescope live_grep<cr>" },
      { mode = "n", "<leader>fb", "<cmd>Telescope buffers<cr>" },
    },
  },
  -- ~/~ end
  -- ~/~ begin <<notes/nvim.md#nvim-lua-lazy-plugins>>[2]
  {

    "neovim/nvim-lspconfig",
    dependencies = {
      { "williamboman/mason.nvim", config = true }, -- NOTE: Must be loaded before dependants

      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",

      "nvim-telescope/telescope.nvim",

      { "j-hui/fidget.nvim", opts = {} },
      { "folke/neodev.nvim", opts = {} },
    },
    config = function()
      -- ~/~ begin <<notes/nvim.md#nvim-lua-lsp-config>>[init]
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("sysraccoon-lsp-attach", { clear = true }),
        callback = function(event)
          vim.api.nvim_create_autocmd("LspDetach", {
            group = vim.api.nvim_create_augroup("sysraccoon-lsp-detach", { clear = true }),
            callback = function()
              vim.lsp.buf.clear_references()
            end,
          })

          -- ~/~ begin <<notes/nvim.md#nvim-lua-lsp-keybindings>>[init]
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          map("gd", require("telescope.builtin").lsp_definitions, "goto definition")
          map("gD", vim.lsp.buf.declaration, "goto declaration")
          map("gr", require("telescope.builtin").lsp_references, "goto references")
          map("gI", require("telescope.builtin").lsp_implementations, "goto implementation")
          map("gs", require("telescope.builtin").lsp_document_symbols, "goto symbols")
          map("gS", require("telescope.builtin").lsp_workspace_symbols, "goto workspace symbols")
          map("<leader>rr", vim.lsp.buf.rename, "refactoring rename")
          map("K", vim.lsp.buf.hover, "hover documentation")
          map("<leader>qf", vim.lsp.buf.code_action, "quick fix")
          -- ~/~ end
        end,
      })
      -- ~/~ end
      -- ~/~ begin <<notes/nvim.md#nvim-lua-lsp-config>>[1]
      local servers = {
        -- ~/~ begin <<notes/nvim.md#nvim-lua-lsp-markdown>>[init]
        marksman = {},
        -- ~/~ end
        -- ~/~ begin <<notes/nvim.md#nvim-lua-lsp-lua>>[init]
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = "Replace",
              },
              diagnostics = {
                disable = { "missing-fields" },
              },
            },
          },
        },
        -- ~/~ end
        tsserver = {},
        jedi_language_server = {},
        nil_ls = {},
      }
      -- ~/~ end
      -- ~/~ begin <<notes/nvim.md#nvim-lua-lsp-config>>[2]
      require("mason").setup()

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

      vim.diagnostic.config({
        signs = false,
      })

      local ensure_installed = vim.tbl_keys(servers or {})
      require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
      require("mason-lspconfig").setup({
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
            require("lspconfig")[server_name].setup(server)
          end,
        },
      })
      -- ~/~ end
    end,
  },
  -- ~/~ end
  -- ~/~ begin <<notes/nvim.md#nvim-lua-lazy-plugins>>[3]
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local configs = require("nvim-treesitter.configs")

      configs.setup({
        ensure_installed = {
          "c",
          "nix",
          "lua",
          "vim",
          "vimdoc",
          "query",
          "javascript",
          "html",
          "markdown",
        },
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
  -- ~/~ end
  -- ~/~ begin <<notes/nvim.md#nvim-lua-lazy-plugins>>[4]
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-y>"] = cmp.mapping.confirm({ select = true }),

          ["<C-l>"] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { "i", "s" }),

          ["<C-h>"] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { "i", "s" }),

          ["<Tab>"] = cmp.mapping(function(fallback)
            if luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),

          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = {
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "path" },
        },
      })
    end,
  },
  -- ~/~ end
  -- ~/~ begin <<notes/nvim.md#nvim-lua-lazy-plugins>>[5]
  {
    "L3MON4D3/LuaSnip",
    build = (function()
      if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
        return
      end
      return "make install_jsregexp"
    end)(),
    dependencies = {
      {
        "rafamadriz/friendly-snippets",
        config = function()
          require("luasnip.loaders.from_vscode").lazy_load()
        end,
      },
    },
    config = function()
      require("luasnip.loaders.from_snipmate").lazy_load({ paths = "./snippets" })
    end,
  },
  -- ~/~ end
  -- ~/~ begin <<notes/nvim.md#nvim-lua-lazy-plugins>>[6]
  {
    "stevearc/conform.nvim",
    keys = {
      {
        "<leader>rf",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = "fallback",
      },
      formatters_by_ft = {
        -- ~/~ begin <<notes/nvim.md#nvim-lua-formatter-markdown>>[init]
        markdown = { { "prettierd" } },
        -- ~/~ end
        -- ~/~ begin <<notes/nvim.md#nvim-lua-formatter-lua>>[init]
        lua = { "stylua" },
        -- ~/~ end
        nix = { "alejandra" },
      },
    },
  },
  -- ~/~ end
  -- ~/~ begin <<notes/nvim.md#nvim-lua-lazy-plugins>>[7]
  {
    "kevinhwang91/nvim-ufo",
    dependencies = {
      "kevinhwang91/promise-async",
    },
    config = function()
      vim.o.foldcolumn = "0"
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true

      require("ufo").setup({
        provider_selector = function()
          return { "treesitter", "indent" }
        end,
      })
    end,
  },
  -- ~/~ end
  -- ~/~ begin <<notes/nvim.md#nvim-lua-lazy-plugins>>[8]
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("oil").setup({
        default_file_explorer = true,
        view_options = {
          show_hidden = true,
        },
        keymaps = {
          ["<C-l>"] = false,
          ["<C-h>"] = false,
        },
      })
      vim.keymap.set("n", "-", "<cmd>Oil<cr>", { desc = "Open parent directory" })
    end,
  },
  -- ~/~ end
  -- ~/~ begin <<notes/nvim.md#nvim-lua-lazy-plugins>>[9]
  {
    "smoka7/hop.nvim",
    version = "*",
    keys = {
      { mode = { "n", "v" }, "<leader>l", "<cmd>HopLineStart<CR>" },
      { mode = { "n", "v" }, "<leader>g", "<cmd>HopWord<CR>" },
    },
    opts = {
      keys = "oeuhtnid.c",
    },
  },
  -- ~/~ end
  -- ~/~ begin <<notes/nvim.md#nvim-lua-lazy-plugins>>[10]
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    keys = {
      {
        mode = "n",
        "<leader>hh",
        function()
          require("harpoon"):list():add()
        end,
      },
      {
        mode = "n",
        "<leader>ha",
        function()
          require("harpoon"):list():select(4)
        end,
      },
      {
        mode = "n",
        "<leader>ho",
        function()
          require("harpoon"):list():select(3)
        end,
      },
      {
        mode = "n",
        "<leader>he",
        function()
          require("harpoon"):list():select(2)
        end,
      },
      {
        mode = "n",
        "<leader>hu",
        function()
          require("harpoon"):list():select(1)
        end,
      },
      {
        mode = "n",
        "<C-Tab>",
        function()
          require("harpoon"):list():next()
        end,
      },
      {
        mode = "n",
        "<C-S-Tab>",
        function()
          require("harpoon"):list():prev()
        end,
      },
    },
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup({})

      local conf = require("telescope.config").values
      local function toggle_telescope(harpoon_files)
        local file_paths = {}
        for _, item in ipairs(harpoon_files.items) do
          table.insert(file_paths, item.value)
        end

        require("telescope.pickers")
          .new({}, {
            prompt_title = "Harpoon",
            finder = require("telescope.finders").new_table({
              results = file_paths,
            }),
            previewer = conf.file_previewer({}),
            sorter = conf.generic_sorter({}),
          })
          :find()
      end

      vim.keymap.set("n", "<leader>ht", function()
        toggle_telescope(harpoon:list())
      end, { desc = "Open harpoon window" })
    end,
  },
  -- ~/~ end
  -- ~/~ begin <<notes/nvim.md#nvim-lua-lazy-plugins>>[11]
  {
    "lukas-reineke/headlines.nvim",
    dependencies = "nvim-treesitter/nvim-treesitter",
    opts = {
      markdown = {
        headline_highlights = { "" },
        fat_headlines = false,
      },
    },
  },
  -- ~/~ end
  -- ~/~ begin <<notes/nvim.md#nvim-lua-lazy-plugins>>[12]
  {
    "hedyhli/markdown-toc.nvim",
    ft = "markdown",
    cmd = { "Mtoc" },
    opts = {
      toc_list = {
        markers = "-",
        item_format_string = "${indent}${marker} [${name}](<#${name}>)",
      },

      fences = {
        start_text = "toc-start",
        end_text = "toc-end",
      },
    },
  },
  -- ~/~ end
  -- ~/~ begin <<notes/nvim.md#nvim-lua-lazy-plugins>>[13]
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
  -- ~/~ end
  -- ~/~ begin <<notes/nvim.md#nvim-lua-lazy-plugins>>[14]
  {
    "lambdalisue/suda.vim", -- Allow perform sudo commands inside vim (useful when edit RO file and want save changes)
    keys = {
      { mode = "ca", "W!", "SudaWrite" },
    },
  },
  -- ~/~ end
  -- ~/~ begin <<notes/nvim.md#nvim-lua-lazy-plugins>>[15]
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
  },
  -- ~/~ end
})
-- ~/~ end
-- ~/~ end