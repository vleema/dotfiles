-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set
local default = { noremap = true, silent = false }

map("i", "jk", "<Esc>", default)
-- map("n", "<leader>co", ":Copilot toggle<CR>", { noremap = true, silent = true })
-- Keymap to go to next/previous line
map({ "n", "v" }, "{", "/^$<CR>", default)
map({ "n", "v" }, "}", "?^$<CR>", default)

vim.api.nvim_set_keymap("t", "<C-x>", "<C-\\><C-n>", { noremap = true, silent = true, desc = "Exit terminal mode" })

-- Obsidian
map("n", "<leader>op", ":ObsidianPasteImg<CR>", { noremap = true, silent = true, desc = "Paste image from clipboard" })
map("n", "<leader>os", ":ObsidianSearch<CR>", { noremap = true, silent = true, desc = "Grep text in this vault" })
map("n", "<leader>oo", ":ObsidianOpen<CR>", { noremap = true, silent = true, desc = "Open note in obsidian app" })
map("n", "<leader>od", ":ObsidianDailies<CR>", { noremap = true, silent = true, desc = "Open daily notes" })

-- -- Flutter
-- vim.keymap.set("n", "<leader>r", require("telescope").extensions.flutter.commands, { desc = "Open Flutter commands" })
