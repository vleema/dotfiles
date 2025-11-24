-- vim:foldmethod=marker

local map = vim.keymap.set

map("n", "<leader>pr", ":source $MYVIMRC<cr>", { desc = "Source init.lua" })
map("n", "<leader>pl", ":Lazy<cr>", { desc = "Open Lazy menu" })
map("n", "<leader>pm", ":Mason<cr>", { desc = "Open Mason menu" })

-- buffers {{{
map("n", "<leader>,", ":b <C-d>", { desc = "List open buffers for selection" })
map("n", "<leader>bd", ":bd<cr>", { desc = "Delete open buffer" })
-- }}}

-- movement {{{
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })
-- }}}


-- window {{{
map("n", "<C-w>-", "<C-w>s", { desc = "Split window below", remap = true })
map("n", "<C-w>\\", "<C-w>v", { desc = "Split window right", remap = true })
-- }}}

-- diagnostics {{{
local diagnostic_goto = function(next, severity)
  return function()
    vim.diagnostic.jump({
      count = (next and 1 or -1) * vim.v.count1,
      severity = severity and vim.diagnostic.severity[severity] or nil,
      float = true,
    })
  end
end

local toggle_diagnostic = function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end

local toggle_virtual_lines = function()
  local new_config = not vim.diagnostic.config().virtual_lines
  vim.diagnostic.config({ virtual_lines = new_config })
end

local toggle_virtual_text = function()
  local new_config = not vim.diagnostic.config().virtual_text
  vim.diagnostic.config({ virtual_text = new_config })
end

map("n", "<leader>ut", toggle_virtual_text, { desc = "Toggle virtual text" })
map("n", "<leader>ul", toggle_virtual_lines, { desc = "Toggle virtual lines" })
map("n", "<leader>ud", toggle_diagnostic, { desc = "Toggle diagnostics" })
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line diagnostics" })
map("n", "]d", diagnostic_goto(true), { desc = "Next diagnostic" })
map("n", "[d", diagnostic_goto(false), { desc = "Prev diagnostic" })
map("n", "]r", diagnostic_goto(true, "ERROR"), { desc = "Next error" })
map("n", "[r", diagnostic_goto(false, "ERROR"), { desc = "Prev error" })
map("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next warning" })
map("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev warning" })
map("n", "<leader>dl", function () vim.diagnostic.setloclist() end, { desc = "Add buffer diagnostics to the location list" })
map("n", "<leader>dq", function () vim.diagnostic.setqflist() end, { desc = "Add diagnostics to quickfix list" })
-- }}}

-- netrw {{{
local open_netrw_root = function(cmd, liststyle)
  cmd = cmd or "Explore"
  liststyle = liststyle or 0
  return function()
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    local root_dir = nil
    if #clients > 0 then
      root_dir = clients[1].workspace_folders and clients[1].workspace_folders[1].uri or clients[1].config.root_dir
      if root_dir and root_dir:match("^file://") then
        root_dir = root_dir:gsub("^file://", "")
      end
    end
    vim.g.netrw_liststyle = liststyle
    if root_dir then
      vim.cmd(cmd .. root_dir)
    else
      vim.cmd(cmd .. " .")
    end
  end
end
local open_netrw = function(cmd, liststyle)
  cmd = cmd or "Explore"
  liststyle = liststyle or 0
  return function()
    vim.g.netrw_liststyle = liststyle
    vim.cmd(cmd)
  end
end
map("n", "<leader>e", open_netrw_root(), { desc = "Open netrw on the root directory" })
map("n", "<leader>E", open_netrw(), { desc = "Open netrw on cwd" })
map("n", "<leader>fE", open_netrw_root("25Lexplore!", 3), { desc = "Open netrw on the right side (root)" })
map("n", "<leader>fe", open_netrw("25Lexplore!", 3), { desc = "Open netrw on the right side (cwd)" })
-- }}}

-- files {{{
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })
-- }}}

-- quickfix {{{
map("n", "<leader>lq", function()
  local success, err = pcall(vim.fn.getqflist({ winid = 0 }).winid ~= 0 and vim.cmd.cclose or vim.cmd.copen)
  if not success and err then
    vim.notify(err, vim.log.levels.ERROR)
  end
end, { desc = "Quickfix list" })

map("n", "[q", vim.cmd.cprev, { desc = "Previous quickfix" })
map("n", "]q", vim.cmd.cnext, { desc = "Next quickfix" })
-- }}}

-- location list {{{
map("n", "<leader>ll", function()
  local success, err = pcall(vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 and vim.cmd.lclose or vim.cmd.lopen)
  if not success and err then
    vim.notify(err, vim.log.levels.ERROR)
  end
end, { desc = "Location List" })
-- }}}

-- search {{{
map({ "i", "n", "s" }, "<esc>", function()
  vim.cmd("noh")
  return "<esc>"
end, { expr = true, desc = "Escape and clear hlsearch" })
-- }}}

-- spell {{{
local toggle_spell = function()
  local winid = vim.api.nvim_get_current_win()
  vim.wo[winid][0].spell = not vim.wo[winid][0].spell
end
map("n", "<leader>us", toggle_spell, { desc = "Toggle spell" })
-- }}}
