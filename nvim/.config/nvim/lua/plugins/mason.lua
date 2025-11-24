return {
  {
    "mason-org/mason.nvim",
    opts = {},
  },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        "lua_ls",
      },
    },
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
      {
        "folke/lazydev.nvim",
        ft = "lua",
        library = {
          { path = "${3rd}/luv/library/", words = { "vim%.uv" } },
        },
      },
    },
  },
}
