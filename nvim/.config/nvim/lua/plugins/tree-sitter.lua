local langs = {
  "c",
  "cpp",
  "go",
  "gomod",
  "gosum",
  "hyprlang",
  "json",
  "lua",
  "markdown",
  "python",
  "rust",
  "tex",
  "toml",
  "yaml",
}

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
    ensure_installed = langs,
  },
  config = function()
    vim.api.nvim_create_autocmd("FileType", {
      desc = "Enable treesitter highlighting and foldmethod for supported file types",
      pattern = langs,
      group = vim.api.nvim_create_augroup("treesitter", { clear = true }),
      callback = function()
        local win = vim.api.nvim_get_current_win()
        local fm = vim.wo[win].foldmethod
        local fex = vim.wo[win].foldexpr
        if (fm == "indent" or fm == "manual") and (fex == nil or fex == "" or fex == "0") then
          vim.wo[win].foldmethod = "expr"
          vim.wo[win].foldexpr = "v:lua.vim.treesitter.foldexpr()"
        end
        vim.treesitter.start()
      end,
    })
  end,
}
