return {
  {
    "akinsho/flutter-tools.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim", -- optional, for vim.ui.select
    },
    opts = {
      fvm = true, -- Enable FVM support
      lsp = {},
    },
  },
}
