-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
local opt = vim.opt

opt.wrap = true
opt.foldlevelstart = 0
opt.shiftwidth = 2
opt.tabstop = 2
opt.expandtab = false
opt.spell = true
opt.spelllang = "en_us,pt_br"
-- opt.listchars = { trail = "·", tab = "  ", space = " " }
opt.listchars = { trail = "·", tab = "  ", space = " " }
opt.cursorline = false
-- opt.foldlevelstart = 0

-- Output for vimtex
vim.g.vimtex_compiler_latexmk = {
  options = { "-pdflua" },
  out_dir = "output",
}

vim.g.snacks_animate = false

vim.g.gruvbox_material_background = "hard"

vim.cmd([[
  augroup CustomColors
    autocmd!
    autocmd ColorScheme * highlight Normal guibg=#1A1A1A
  augroup END
]])
