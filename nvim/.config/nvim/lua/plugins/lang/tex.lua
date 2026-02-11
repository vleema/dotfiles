return {
  {
    "lervag/vimtex",
    lazy = false,
    config = function()
      vim.g.vimtex_mappings_disable = { ["n"] = { "K" } }
      vim.g.vimtex_view_method = "zathura"
      vim.g.vimtex_compiler_latexmk = {
        aux_dir = "aux",
      }
      vim.g.vimtex_compiler_latexrun_engines = {
        _ = "lualatex",
      }
    end,
  },
}
