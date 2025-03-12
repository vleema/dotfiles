-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node

ls.add_snippets("markdown", {
  s("obhead", {
    t({
      "---",
      "id: ",
      "aliases: []",
      "tags: []",
      "---",
    }),
  }),
})

-- Automatically disable diagnostics for markdown files
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  pattern = { "*.md", "*.markdown" },
  callback = function()
    vim.diagnostic.disable(0) -- 0 means current buffer
  end,
})

-- Switch from tabs to spaces in haskell files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "haskell",
  callback = function()
    vim.opt_local.expandtab = true
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "java",
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
  end,
})

-- Rust indentation to 2
-- vim.api.nvim_create_autocmd("FileType", {
-- 	pattern = "rust",
-- 	callback = function()
-- 		vim.opt_local.shiftwidth = 2
-- 		vim.opt_local.tabstop = 2
-- 	end,
-- })

-- Spelling for tex files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "tex",
  callback = function()
    vim.opt_local.spell = true
  end,
})

-- HACK: Cancel the snippet session when leaving insert mode.
local unlink_group = vim.api.nvim_create_augroup("UnlinkSnippet", {})
vim.api.nvim_create_autocmd("ModeChanged", {
  group = unlink_group,
  -- when going from select mode to normal and when leaving insert mode
  pattern = { "s:n", "i:*" },
  callback = function(event)
    if ls.session and ls.session.current_nodes[event.buf] and not ls.session.jump_active then
      ls.unlink_current()
    end
  end,
})
