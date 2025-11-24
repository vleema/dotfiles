return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  version = false,
  build = ":TSUpdate",
  lazy = false,
  opts = {
    auto_install = true,
    indent = { enable = true },
    highlight = { enable = true },
    folds = { enable = true },
  },
  config = function()
    vim.api.nvim_create_autocmd("FileType", {
      desc = "Enable treesitter highlighting and foldmethod for supported file types",
      pattern = { "c", "cpp", "lua", "rust", "python" },
      group = vim.api.nvim_create_augroup("treesitter", { clear = true }),
      callback = function()
        vim.treesitter.start()
      end,
    })
  end,
}
