return {
  "mikavilpas/yazi.nvim",
  event = "VeryLazy",
  dependencies = {
    "folke/snacks.nvim", -- Required dependency
  },
  keys = {
    { "<leader>E", "<cmd>Yazi<cr>", desc = "Open yazi at the current file" },
    { "<leader>e", "<cmd>Yazi cwd<cr>", desc = "Open yazi in nvim's working directory" },
  },
  opts = {
    -- Optional: customize yazi.nvim behavior here
    open_for_directories = true,
    keymaps = { show_help = "<f1>" },
  },
  -- Optional: disable netrw if you want yazi to handle directories
  init = function()
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
  end,
}
