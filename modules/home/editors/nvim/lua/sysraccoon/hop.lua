return {
  "smoka7/hop.nvim", -- EasyMotion
  version = "*",
  keys = {
    { mode={"n","v"}, "<leader>l", "<cmd>HopLineStart<CR>" },
    { mode={"n","v"}, "<leader>g", "<cmd>HopWord<CR>" },
  },
  opts = {
    keys = "oeuhtnid.c",
  },
}
