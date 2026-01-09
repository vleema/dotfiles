return {
  {
    "vague-theme/vague.nvim",
    lazy = false,
  },
  {
    "sainnhe/gruvbox-material",
    lazy = false,
    config = function()
      vim.g.gruvbox_material_background = "hard"
      vim.g.gruvbox_material_better_performance = 1
      vim.g.gruvbox_material_foreground = "original"
    end,
  },
  {
    "blazkowolf/gruber-darker.nvim",
    lazy = false,
    opts = {
      invert = {
        tabline = true,
      },
      italic = {
        strings = false,
        comments = false,
        folds = false,
      },
    },
  },
}
