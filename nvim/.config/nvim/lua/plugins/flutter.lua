return {
  {
    "akinsho/flutter-tools.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim", -- optional, for vim.ui.select
    },
    opts = {
      -- flutter_path = ".fvm/flutter_sdk/bin/flutter", -- Use FVM-managed Flutter
      fvm = true, -- Enable FVM support
      -- Additional flutter-tools.nvim options here
    },
  },
}
