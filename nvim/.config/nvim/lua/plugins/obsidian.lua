return {
  {
    "obsidian-nvim/obsidian.nvim",
    ft = "markdown",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      ui = {
        enable = false,
      },
      workspaces = {
        {
          name = "Cave",
          path = "~/Public/OneDrive/Cave",
        },
      },
      templates = {
        -- folder = "Daily",
        -- date_format = "%Y-%m-%d",
        -- time_format = "%H:%M",
      },
      daily_notes = {
        folter = "Daily",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
        default_tags = { "daily-notes" },
        template = nil,
      },
      completion = {
        nvim_cmp = false,
        min_chars = 2,
      },
      follow_url_func = function(url)
        vim.ui.open(url)
      end,
    },
  },
}
