return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "helix",
    spec = {
      {
        mode = { "n", "x" },
        { "<leader>c", group = "code" },
        { "<leader>f", group = "file/find" },
        { "<leader>gh", group = "hunks" },
        { "<leader>q", group = "quit/session" },
        { "<leader>s", group = "search" },
        { "<leader>u", group = "ui" },
        { "<leader>p", group = "package management" },
        { "<leader>d", group = "diagnostics" },
        { "<leader>l", group = "lists (quickfix)" },
        { "[", group = "prev" },
        { "]", group = "next" },
        { "g", group = "goto" },
        { "gs", group = "surround" },
        { "z", group = "fold" },
        {
          "<leader>b",
          group = "buffer",
          expand = function()
            return require("which-key.extras").expand.buf()
          end,
        },
        { "gx", desc = "Open with system app" },
        {
          "<c-w><space>",
          function()
            require("which-key").show({ keys = "<c-w>", loop = true })
          end,
          desc = "Window Hydra Mode (which-key)",
        },
      },
    },
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
}
