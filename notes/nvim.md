# NeoVim configuration

## Table of Contents {TOC}

<!-- toc-start -->

- [Nix home-manager module](<#Nix home-manager module>)
- [ZSH configuration](<#ZSH configuration>)
- [Lua configuration](<#Lua configuration>)
  - [General](<#General>)
  - [Plugin Manager {lazy}](<#Plugin Manager {lazy}>)
  - [Colorscheme {catppuccin}](<#Colorscheme {catppuccin}>)
  - [Fuzzy Finder {telescope.nvim}](<#Fuzzy Finder {telescope.nvim}>)
  - [LSP](<#LSP>)
  - [Treesitter](<#Treesitter>)
  - [Auto Completion {nvim-cmp}](<#Auto Completion {nvim-cmp}>)
  - [Snippets {luasnip}](<#Snippets {luasnip}>)
  - [Auto Formatting {conform.nvim}](<#Auto Formatting {conform.nvim}>)
  - [Folding {nvim-ufo}](<#Folding {nvim-ufo}>)
  - [File Explorer {oil.nvim}](<#File Explorer {oil.nvim}>)
  - [Quick Navigation {hop.nvim}](<#Quick Navigation {hop.nvim}>)
  - [Buffer Navigation {harpoon}](<#Buffer Navigation {harpoon}>)
  - [Language Specific](<#Language Specific>)
    - [Markdown](<#Markdown>)
    - [Lua](<#Lua>)
    - [Typescript](<#Typescript>)
  - [Miscellaneous](<#Miscellaneous>)
    - [Colorizer](<#Colorizer>)
    - [Save files as Root](<#Save files as Root>)
    - [Tmux integration](<#Tmux integration>)
    - [Motion Canvas custom utils](<#Motion Canvas custom utils>)

<!-- toc-end -->

## Nix home-manager module

My custom module provide all stuff related to neovim, which is not possible (or too difficult)
configure in lua config

```nix {.nix #nvim-nix file=modules/home/editors/nvim/nvim.nix}
{
  lib,
  pkgs,
  config,
  impurity,
  ...
}: let
  cfg = config.sys.home.editors.nvim;
in {
  options = {
    sys.home.editors.nvim = {
      enable = lib.mkEnableOption "custom neovim setup";
    };
  };

  config = lib.mkIf cfg.enable {
    <<nvim-nix-config>>
  };
}
```

To configure neovim packages I rely on exists `programs.neovim` that provided by home-manager.
First, enable it

```nix {.nix #nvim-nix-config}
programs.neovim = {
  enable = true;

  <<nvim-nix-python>>
  <<nvim-nix-extra-packages>>
};
```

Next, include python with pynvim to neovim env. It would available inside editor, but not outside
(this allow no pollute $PATH with dev specific stuff)

```nix {.nix #nvim-nix-python}
withPython3 = true;
extraPython3Packages = ps:
  with ps; [
    pynvim
  ];
```

Different LSP and formatters require corresponded packages installed. Let's configure it with
extraPackages (this also allow no pollute $PATH, outside editor).

```nix {.nix #nvim-nix-extra-packages}
extraPackages = with pkgs; [
  # python language server (installed as separate package,
  # because extraPython3Packages not provide bin/ folder to editor $PATH variable)
  python312Packages.jedi-language-server
  luaPackages.luarocks # package manager for lua
  tree-sitter # is optional, but allow use :TSInstallFromGrammar command
  nil # nix language server
  cargo # need for nil language server builded through mason
  stylua # lua formatter
  alejandra # nix formatter
  prettierd # markdown formatter (supported more languages, but currently I don't use them)
];
```

I don't rely on nix way of configuring tools. Instead home-manager used to manage all dependencies
and replace imperative commands (such as systemd services run, or some sort of init commands).

All configuration stored in separate files and after that symlinked to proper directory. See
[impurity.nix](https://github.com/outfoxxed/impurity.nix) for more detail.

- Lua configuration more precisely described in [[#Lua configuration]]
- Snippets folder contains snipmate-like snippets (see [[#Snippets {luasnip}]])

```nix {.nix #nvim-nix-config}
programs.neovim.extraLuaConfig = ''
  require("sysraccoon")
'';

xdg.configFile = {
  "nvim/lua".source = impurity.link ./lua;
  "nvim/snippets".source = impurity.link ./snippets;
};
```

## ZSH configuration

Set neovim as my main editor in zsh. Full configuration of zsh in [separate file](./zsh.md)

```bash {.bash file=modules/home/shells/zsh/zsh/nvim.zsh}
if [ $+commands[nvim] -eq 1 ]; then
    EDITOR=nvim;
elif [ $+commands[vim] -eq 1 ]; then
    EDITOR=vim;
elif [ $+commands[vi] -eq 1 ]; then
    EDITOR=vi;
else
  echo "Warning: editor not found"
fi

export STAT_DIR=$HOME'/.stats'
mkdir -p "$STAT_DIR/nvim"

export EDITOR
alias nvim='nvim -w $STAT_DIR/nvim/$(date "+%Y-%m-%d:%H-%M-%S")'
alias vim='$EDITOR'
alias vi='$EDITOR'
alias edit='$EDITOR'
alias nano='$EDITOR'
alias e='edit'

alias edot="tmuxinator dotfiles"
alias enotes="tmuxinator notes"
```

## Lua configuration

If you search good resource to create neovim configuration from scratch, I can recommend this
project [kickstarter.nvim](https://github.com/nvim-lua/kickstart.nvim) and
[TJ kickstarter overview on youtube](https://www.youtube.com/watch?v=m8C0Cq9Uv9o).

```lua {.lua file=modules/home/editors/nvim/lua/sysraccoon/init.lua}
<<nvim-lua-general>>
<<nvim-lua-plugins>>
```

### General

This section provide configuration, related to neovim itself, and don't rely on plugins.

I often use relative numbering in conjunction with macros to quickly estimate the number of
repetitions required to apply changes to all relevant rows at once. However, I don't rely on it for
navigation, as hop.nvim is much more powerful and versatile for such tasks.

```lua {.lua #nvim-lua-general}
vim.opt.number = true
vim.opt.relativenumber = true
```

Use 2 spaces by default for filetypes that don't configured for specific indentantion style:

```lua {.lua #nvim-lua-general}
vim.opt.autoindent = true
vim.opt.smartindent = false
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.smarttab = true
```

Yes, mouse support inside neovim. Have questions?

```lua {.lua #nvim-lua-general}
vim.opt.mouse = "a"
```

Just use utf-8 encoding by default. It's best option for most cases:

```lua {.lua #nvim-lua-general}
vim.opt.enc = "utf-8"
vim.opt.fenc = "utf-8"
```

Disable emoji. Why do you need such things in your editor?

```lua {.lua #nvim-lua-general}
vim.opt.emo = false
```

Configure search options

- `smartcase` allow you to search case insensitive when you type in lower case, and use strongly
  upper case when upper case used in search string.
- `incsearch` move the highlight as you add characters to the search string.
- `hlsearch` disable highlight after you complete typing search string.
- `mmp` maximum amount of memory (in Kbyte) to use for pattern matching.

```lua {.lua #nvim-lua-general}
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = false
vim.opt.mmp = 10240
```

Disable comment continuation:

```lua {.lua #nvim-lua-general}
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    vim.opt.formatoptions = vim.opt.formatoptions - { "c", "r", "o" }
  end,
})
```

Just disable some noise stuff

```lua {.lua #nvim-lua-general}
vim.opt.swapfile = false -- disable .swp files
vim.opt.backup = false -- disable backup
vim.opt.errorbells = false -- disable sound on errors
```

Set scroll speed

```lua {.lua #nvim-lua-general}
vim.opt.scrolloff = 10
vim.opt.scrolljump = 10
vim.opt.sidescroll = 10
```

Enable true color support

```lua {.lua #nvim-lua-general}
vim.opt.termguicolors = true
```

Use system clipboard by default

```lua {.lua #nvim-lua-general}
vim.opt.clipboard:append({ "unnamedplus" })
```

Split window to right (by default to left)

```lua {.lua #nvim-lua-general}
vim.opt.splitright = true
```

Provide highlighting when you yanking text. This snippet originally copied from kickstarter.nvim
config.

```lua {.lua #nvim-lua-general}
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("sysraccoon-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
```

Basic keybindings:

```lua {.lua #nvim-lua-general}
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
```

### Plugin Manager {lazy}

I use [lazy.nvim](https://github.com/folke/lazy.nvim) plugin manager to manage all plugins.

```lua {.lua #nvim-lua-plugins}
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
  <<nvim-lua-lazy-plugins>>
})
```

### Colorscheme {catppuccin}

Currently I use [catpuccin](https://catppuccin.com/) for all my stuff. I also use this:

```lua {.lua #nvim-lua-lazy-plugins}

{
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    vim.cmd.colorscheme("catppuccin-mocha")
    -- Tweak some colors
    <<nvim-lua-color-tweaks>>
  end,
},
```

Apply darker version of CodeBlock background, see [[#Markdown]] for more details.

```lua {.lua #nvim-lua-color-tweaks}
vim.cmd([[highlight CodeBlock guibg=#181825]])
```

### Fuzzy Finder {telescope.nvim}

[Telescope](https://github.com/nvim-telescope/telescope.nvim) is powerfull fuzzy finder for neovim.
It allow you search files by nameand content, switch between buffers and much much more. It also
have good integration with other plugins.

```lua {.lua #nvim-lua-lazy-plugins}
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
```

### LSP

Short video that explain LSP [LSP Explained by TJ](https://youtu.be/LaS32vctfOY)

```lua {.lua #nvim-lua-lazy-plugins}
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
    <<nvim-lua-lsp-config>>
  end,
},
```

Configure autocmds that apply keybindings, when any LSP loaded and clear references after unloading

```lua {.lua #nvim-lua-lsp-config}
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("sysraccoon-lsp-attach", { clear = true }),
  callback = function(event)
    vim.api.nvim_create_autocmd("LspDetach", {
      group = vim.api.nvim_create_augroup("sysraccoon-lsp-detach", { clear = true }),
      callback = function()
        vim.lsp.buf.clear_references()
      end,
    })

    <<nvim-lua-lsp-keybindings>>
  end,
})
```

Configure LSP specific keybindings

```lua {.lua #nvim-lua-lsp-keybindings}
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
```

Servers used for specific languages are described in the relevant sections:

- [[#Markdown]]
- [[#Lua]]
- [[#Typescript]]

```lua {.lua #nvim-lua-lsp-config}
local servers = {
  <<nvim-lua-lsp-markdown>>
  <<nvim-lua-lsp-lua>>
  <<nvim-lua-lsp-typescript>>
  jedi_language_server = {},
  nil_ls = {},
}
```

[Mason](https://github.com/williamboman/mason.nvim) is package manager that allow install and manage
LSP servers, linters, and formatters.

```lua {.lua #nvim-lua-lsp-config}
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
```

### Treesitter

[Treesitter](https://github.com/nvim-treesitter/nvim-treesitter) is powerful parser generator tool.
It can build syntax tree for a source file. If you want more information, watch this video:
[tree-sitter explained](https://www.youtube.com/watch?v=09-9LltqWLY)

```lua {.lua #nvim-lua-lazy-plugins}
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
      indent = { enable = false },
    })
  end,
},
```

### Auto Completion {nvim-cmp}

Provided by [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) plugin. It also used by snippet engines
(see [snippet section](#snippets-luasnip))

```lua {.lua #nvim-lua-lazy-plugins}
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
```

### Snippets {luasnip}

Use [LuaSnip](https://github.com/L3MON4D3/LuaSnip) for snippets. It support different formats
(vscode-like, snipmate-like, lua), for more information see
[LuaSnip Loaders](https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md#loaders):

```lua {.lua #nvim-lua-lazy-plugins}
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
```

### Auto Formatting {conform.nvim}

Manually formatting code is quite boring. Instead, I rely on automatic solutions that are triggered
when the buffer is saved.

[conform.nvim](https://github.com/stevearc/conform.nvim) makes it easy to specify which file types
to apply formatters to.

Formatters used for specific language, described in proper section:

- [[#Markdown]]
- [[#Lua]]

```lua {.lua #nvim-lua-lazy-plugins}
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
      <<nvim-lua-formatter-markdown>>
      <<nvim-lua-formatter-lua>>
      nix = { "alejandra" },
    },
  },
},
```

### Folding {nvim-ufo}

[nvim-ufo](https://github.com/kevinhwang91/nvim-ufo) provide good folding configuration out of the
box.

```lua {.lua #nvim-lua-lazy-plugins}
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
```

### File Explorer {oil.nvim}

[oil.nvim](https://github.com/stevearc/oil.nvim) allow edit filesystem like a normal neovim buffer.

Disable `C-l` and `C-h` keymaps, because it conflicts with [[#Tmux integration]] keybindings.

```lua {.lua #nvim-lua-lazy-plugins}
{
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("oil").setup({
      default_file_explorer = true,
      columns = {
        "icon",
      },
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
```

### Quick Navigation {hop.nvim}

[hop.nvim](https://github.com/smoka7/hop.nvim) allow me jump to any part of code on the screen, just
by typing several characters.

`opts.keys` redefined because `dvorak` keyboard layout used. See [keyboard setup](./keyboard.md) for
more information.

```lua {.lua #nvim-lua-lazy-plugins}
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
```

### Buffer Navigation {harpoon}

[harpoon](https://github.com/ThePrimeagen/harpoon/tree/harpoon2) allows you to set a mark to an open
buffer so that you can quickly switch to it. This is analogue of pinning tabs in other text editors

```lua {.lua #nvim-lua-lazy-plugins}
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
      "<leader>hm",
      function()
        require("harpoon").ui:toggle_quick_menu(require("harpoon"):list())
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
```

### Language Specific

#### Markdown

Change code block highlight and headers style. Code block color value defined in
[[#Colorscheme {catppuccin}]] section.

```lua {.lua #nvim-lua-lazy-plugins}
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
```

Auto generate table of contents (TOC). Use command `:Mtoc` to generate TOC.

```lua {.lua #nvim-lua-lazy-plugins}
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
```

My setup use [marksman](https://github.com/artempyanykh/marksman) language server. See [[#LSP]]
section for more information about LSP configuration.

```lua {.lua #nvim-lua-lsp-markdown}
marksman = {},
```

[prettierd](https://github.com/fsouza/prettierd) is used as a formatter. See
[[#Auto Formatting {conform.nvim}]] section for more information.

```lua {.lua #nvim-lua-formatter-markdown}
markdown = { { "prettierd" } },
```

Force set tab size
```lua {.lua #nvim-lua-general}
vim.cmd([[ autocmd FileType markdown :setlocal sw=2 ts=2 sts=2 ]])
```

#### Lua

[lua-ls](https://github.com/luals/lua-language-server) used as language server. See [[#LSP]] section
for more information about LSP configuration.

```lua {.lua #nvim-lua-lsp-lua}
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
```

[stylua](https://github.com/JohnnyMorganz/StyLua) used as lua formatter. See
[[#Auto Formatting {conform.nvim}]] section for more information.

```lua {.lua #nvim-lua-formatter-lua}
lua = { "stylua" },
```

#### Typescript

[tsserver](<https://github.com/microsoft/TypeScript/wiki/Standalone-Server-(tsserver)>) used as
language server. See [[#LSP]] section for more information about LSP configuration.

Orginize imports command [source](https://www.reddit.com/r/neovim/comments/rtpbpg/comment/hquiy76/)

```lua {.lua #nvim-lua-lsp-typescript}
tsserver = {
  commands = {
    OrganizeImports = {
      function()
        local params = {
          command = "_typescript.organizeImports",
          arguments = { vim.api.nvim_buf_get_name(0) },
          title = "",
        }
        vim.lsp.buf.execute_command(params)
      end,
      description = "Organize Imports",
    },
  },
},
```

### Miscellaneous

#### Colorizer

Display actual colors for specified color codes:

```lua {.lua #nvim-lua-lazy-plugins}
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
```

#### Save files as Root

Sometimes it happens that you open a config that is read-only. To avoid restarting neovim, you can
use vim-suda, which allows you to save the buffer with super user rights

```lua {.lua #nvim-lua-lazy-plugins}
{
  "lambdalisue/suda.vim", -- Allow perform sudo commands inside vim (useful when edit RO file and want save changes)
  keys = {
    { mode = "ca", "W!", "SudaWrite" },
  },
},
```

#### Tmux integration

Add seamless navigation between tmux panes and neovim windows

```lua {.lua #nvim-lua-lazy-plugins}
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
```

#### Motion Canvas custom utils

My commands to simplify creating animations in motion canvas

```lua {.lua #nvim-lua-lazy-plugins}
{
  "paw-utils",
  name = "paw-utils",
  dir = "~/.config/nvim/lua/paw-utils",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  keys = {
    {
      mode = "n",
      "<leader>ww",
      function()
        require("paw-utils"):paw_save_state()
      end,
    },
  },
},
```
