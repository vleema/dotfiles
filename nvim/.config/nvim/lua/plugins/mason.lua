return {
  { "neovim/nvim-lspconfig" },
  {
    "mason-org/mason.nvim",
    opts = {},
    keys = {
      { "<leader>pm", ":Mason<cr>", desc = "Open Mason menu" },
    },
  },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {},
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
    },
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
        -- Tex
        "texlab",
        "tex-fmt",
        -- Go
        "gopls",
        "gofumpt",
        "goimports",
        "golangci-lint",
        -- Json
        "jsonls",
        -- Markdown
        "marksman",
      },
    },
  },
}
