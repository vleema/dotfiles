return {
  { "neovim/nvim-lspconfig" },
  { "mason-org/mason.nvim", opts = {} },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        -- Python
        "basedpyright",
        "ruff",
        -- C/C++
        "clangd",
        -- Lua
        "lua_ls",
        "stylua",
      },
    },
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
  },
}
