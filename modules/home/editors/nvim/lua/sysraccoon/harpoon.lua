return {
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
}
