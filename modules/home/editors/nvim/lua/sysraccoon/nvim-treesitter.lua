return {
  "nvim-treesitter/nvim-treesitter", -- Enable incremental parser and syntax highlighter
  build = ":TSUpdate",
  config = function()
    local configs = require("nvim-treesitter.configs")

    configs.setup({
      ensure_installed = {
        "c", "lua", "vim",
        "vimdoc", "query",
        "javascript", "html",
      },
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
    })
  end,
}
