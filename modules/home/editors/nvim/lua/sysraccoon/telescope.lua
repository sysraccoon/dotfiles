return {
  "nvim-telescope/telescope.nvim", -- Awesome fuzzy finder
  branch = "0.1.x",
  lazy=false,
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  keys = {
    { mode="n", "<leader>ff", "<cmd>Telescope find_files<cr>" },
    { mode="n", "<leader>fg", "<cmd>Telescope live_grep<cr>" },
    { mode="n", "<leader>fb", "<cmd>Telescope buffers<cr>" },
  },
}
