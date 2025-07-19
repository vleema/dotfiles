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

vim.cmd([[
  augroup CustomColors
    autocmd!
    autocmd ColorScheme * highlight Normal guibg=#1A1A1A
  augroup END
]])
--
-- Fold

-- vim.opt.foldmethod = "expr"
-- vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
-- vim.opt.foldcolumn = "0"
-- vim.opt.foldtext = ""
-- vim.opt.foldlevel = 99
-- vim.opt.foldlevelstart = 1
-- vim.opt.foldnestmax = 4
