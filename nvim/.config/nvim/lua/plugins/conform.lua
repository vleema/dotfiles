return {
  "stevearc/conform.nvim",
  opts = {
    default_format_opts = {
      timeout_ms = 500,
      lsp_format = "fallback",
    },
    format_on_save = {},
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "ruff" },
    },
  },
  keys = {
    {
      "<leader>cf",
      function()
        -- TODO: Define format function
        -- require("conform").format()
        vim.lsp.buf.format()
      end,
      desc = "Format buffer",
    },
  },
}
