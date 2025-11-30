require("config.options")
require("config.keymaps")
require("config.lsp")
require("config.autocmds")
require("config.lazy")

vim.cmd.colorscheme("gruber-darker")

-- FIX: output from :messages is broken when opening swapfiles after entering some file with lsp
