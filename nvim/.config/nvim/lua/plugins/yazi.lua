return {
  "mikavilpas/yazi.nvim",
  event = "VeryLazy",
  dependencies = {
    "folke/snacks.nvim", -- Required dependency
  },
  keys = {
    { "<leader>E", "<cmd>Yazi<cr>", desc = "Open yazi at the current file" },
    { "<leader>e", "<cmd>Yazi cwd<cr>", desc = "Open yazi in nvim's working directory" },
  },
  opts = {
    -- Optional: customize yazi.nvim behavior here
    open_for_directories = true,
    keymaps = { show_help = "<f1>" },
  },
  -- Optional: disable netrw if you want yazi to handle directories
  init = function()
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function()
        local first_arg = vim.v.argv[1]
        if first_arg and vim.fn.isdirectory(first_arg) == 1 then
          vim.cmd("Yazi cwd")
        end
      end,
    })
  end,
}
