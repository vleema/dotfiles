return {
  {
    "folke/todo-comments.nvim",
    -- FIX: fzf grep string is clutering everything
    dependencies = { "nvim-lua/plenary.nvim" },
    lazy = false,
    opts = {},
    -- stylua: ignore
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next Todo Comment" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous Todo Comment" },
      { "<leader>lt", "<cmd>TodoQuickFix<cr>", desc = "Todo quickfix list" },
      { "<leader>st", "<cmd>TodoFzfLua keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme" },
      { "<leader>sT", "<cmd>TodoFzfLua<cr>", desc = "Todo" },
    },
  },
}
