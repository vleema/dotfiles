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
      pattern = { "c", "cpp", "lua", "rust", "python", "yaml" },
      group = vim.api.nvim_create_augroup("treesitter", { clear = true }),
      callback = function()
        vim.wo.foldmethod = "expr"
        vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
        vim.treesitter.start()
      end,
    })
  end,
}
