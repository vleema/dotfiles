-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local modes = { "n", "v", "x", "o" } -- normal, visual, select, operator-pending

-- Track current layout state
local is_colemak = false

-- Function to apply Colemak mappings
local function apply_colemak()
  -- Map Colemak navigation to QWERTY
  vim.keymap.set(modes, "m", "h", { desc = "Move left (Colemak)" })
  vim.keymap.set(modes, "n", "j", { desc = "Move down (Colemak)" })
  vim.keymap.set(modes, "e", "k", { desc = "Move up (Colemak)" })
  vim.keymap.set(modes, "i", "l", { desc = "Move right (Colemak)" })

  -- Map QWERTY navigation to Colemak positions
  vim.keymap.set(modes, "h", "m", { desc = "Mark (was h)" })
  vim.keymap.set(modes, "k", "n", { desc = "Next search (was k)" })
  vim.keymap.set(modes, "j", "e", { desc = "End of word (was j)" })
  vim.keymap.set(modes, "l", "i", { desc = "Insert mode (was l)" })

  -- Uppercase versions
  vim.keymap.set(modes, "M", "H", { desc = "Move to top of screen (Colemak)" })
  vim.keymap.set(modes, "N", "J", { desc = "Join lines (Colemak)" })
  vim.keymap.set(modes, "E", "K", { desc = "Look up keyword (Colemak)" })
  vim.keymap.set(modes, "I", "L", { desc = "Move to bottom of screen (Colemak)" })

  vim.keymap.set(modes, "H", "M", { desc = "Move to middle of screen (was H)" })
  vim.keymap.set(modes, "K", "N", { desc = "Previous search (was K)" })
  vim.keymap.set(modes, "J", "E", { desc = "End of WORD (was J)" })
  vim.keymap.set(modes, "L", "I", { desc = "Insert at beginning (was L)" })
end

-- Function to remove Colemak mappings (restore QWERTY)
local function remove_colemak()
  -- Remove Colemak navigation mappings
  pcall(vim.keymap.del, modes, "m")
  pcall(vim.keymap.del, modes, "n")
  pcall(vim.keymap.del, modes, "e")
  pcall(vim.keymap.del, modes, "i")

  -- Remove QWERTY remappings
  pcall(vim.keymap.del, modes, "h")
  pcall(vim.keymap.del, modes, "k")
  pcall(vim.keymap.del, modes, "j")
  pcall(vim.keymap.del, modes, "l")

  -- Remove uppercase versions
  pcall(vim.keymap.del, modes, "M")
  pcall(vim.keymap.del, modes, "N")
  pcall(vim.keymap.del, modes, "E")
  pcall(vim.keymap.del, modes, "I")

  pcall(vim.keymap.del, modes, "H")
  pcall(vim.keymap.del, modes, "K")
  pcall(vim.keymap.del, modes, "J")
  pcall(vim.keymap.del, modes, "L")
end

-- Function to toggle between layouts
local function toggle_layout()
  if is_colemak then
    remove_colemak()
    is_colemak = false
    vim.notify("Switched to QWERTY layout", vim.log.levels.INFO)
  else
    apply_colemak()
    is_colemak = true
    vim.notify("Switched to Colemak layout", vim.log.levels.INFO)
  end
end
vim.api.nvim_create_user_command("ToggleLayout", toggle_layout, {
  desc = "Toggle between Colemak and QWERTY keyboard layouts",
})
vim.keymap.set("n", "<leader>tl", toggle_layout, { desc = "Toggle keyboard layout" })
