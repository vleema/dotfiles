-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.snacks_animate = false

vim.g.gruvbox_material_background = "hard"
vim.g.gruvbox_material_foreground = "material"
vim.g.gruvbox_material_better_performance = 1

vim.opt.spelllang = { "pt_br", "en_us" }

-- Output for vimtex
vim.g.vimtex_compiler_latexmk = {
  out_dir = "output",
}

vim.opt.foldlevelstart = 0

-- vim.cmd([[
--   augroup CustomColors
--     autocmd!
--     autocmd ColorScheme * highlight Normal guibg=#1B1B1B
--   augroup END
-- ]])
--
-- Fold
