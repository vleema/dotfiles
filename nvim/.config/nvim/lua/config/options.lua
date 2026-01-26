-- vim:foldmethod=marker

local o = vim.opt
local g = vim.g

g.terminal_emulator = "alacritty"
g.mapleader = " "
g.maplocalleader = "\\"

-- line {{{
o.number = true
o.relativenumber = true
o.cursorline = true
-- }}}

-- wild {{{
o.wildmode = "longest:full,full"
o.wildignorecase = true
o.wildignore = "*.so,*.o,*.git/*,*target/*,__pycache__/*.pyc"
-- }}}

-- indent {{{
o.expandtab = true
o.tabstop = 4
o.shiftwidth = 4
-- }}}

-- fold {{{
o.foldlevelstart = 99
o.foldcolumn = "0"
o.foldnestmax = 4
-- TODO: maybe start with ident mode then fallback to treesitter and then lsp
o.foldmethod = "indent"
o.foldtext = ""
-- }}}

-- misc {{{
vim.diagnostic.config({ virtual_text = true }) -- enable inline text for diagnostics
g.netrw_banner = 0                             -- no header for netrw
vim.o.undofile = true                          -- persist undos across sessions
o.spelllang = { "pt_br", "en_us" }             -- spell language
o.clipboard = "unnamedplus"                    -- system clipboard
o.smartcase = true                             -- case insesitive search until there's one uppercase character
o.termguicolors = true                         -- true color
o.virtualedit = "block"                        -- allow cursor to move where there's no text
o.inccommand = "split"                         -- preview incremental substitute (:%s/../..)
o.list = true                                  -- show invisible characters
o.grepprg = "rg --vimgrep"                     -- change grep for ripgrep
o.fillchars = {                                -- characters to fill various things
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}
o.splitright = true
-- }}}
