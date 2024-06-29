return {
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
    { mode = "n", "<leader>oo", "<cmd>ObsidianSearch<cr>" },
    { mode = "n", "<leader>ob", "<cmd>ObsidianBacklinks<cr>" },
    { mode = "n", "<leader>ow", "<cmd>ObsidianWorkspace<cr>" },
    { mode = "n", "<leader>ot", "<cmd>ObsidianTemplate<cr>" },
    { mode = "n", "<leader>or", "<cmd>ObsidianRename<cr>" },
    { mode = "v", "<leader>oe", ":'<,'>ObsidianExtractNote<cr>" },
  },
  opts = {
    workspaces = { {
      name = "notes",
      path = "~/vaults/notes",
      overrides = {
        notes_subdir = "main",
        templates = {
          folder = "templates",
          date_format = "%Y-%m-%d",
          time_format = "%H:%M",
        },
      },
    } },

    follow_url_func = function(url)
      vim.fn.jobstart({ "xdg-open", url })
    end,

    use_advanced_uri = true,

    completion = {
      nvim_cmp = true,
    },
  },
}
