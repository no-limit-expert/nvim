return {
  {
    "nvim-telescope/telescope.nvim",
    -- tag = "0.1.8", -- Pins execution to a stable git tag
    dependencies = { "nvim-lua/plenary.nvim" },
    -- The 'config' function runs *after* the plugin is loaded into the runtime path
    config = function()
      local builtin = require("telescope.builtin")

      -- Keymaps using the standard Neovim Lua API
      vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find Files" })
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live Grep" })
    end,
  }
}

