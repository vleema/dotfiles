return {
  {
    "lervag/vimtex",
    lazy = false, -- we don't want to lazy load VimTeX
    -- tag = "v2.15", -- uncomment to pin to a specific release
    init = function()
      -- VimTeX configuration goes here, e.g.
      vim.g.vimtex_view_method = "zathura"
    end,
  }, -- { "KeitaNakamura/tex-conceal.vim" },
  {
    "obsidian-nvim/obsidian.nvim",
    ft = "markdown",
    lazy = true,
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
