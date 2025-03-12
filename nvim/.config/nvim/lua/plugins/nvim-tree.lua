local function get_nvim_tree_width()
  local winwidth = vim.go.columns
  if winwidth <= 100 then
    return 30
  elseif winwidth <= 200 then
    return 40
  else
    return 50
  end
end

return {
  "nvim-tree/nvim-tree.lua",
  opts = {
    view = {
      side = "right",
      -- width = get_nvim_tree_width(),
      adaptive_size = true,
    },
    renderer = {
      group_empty = true,
    },
  },
}
