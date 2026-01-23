return {
  "ibhagwan/fzf-lua",
  dependencies = {
    "nvim-mini/mini.icons",
  },
  lazy = false,
  setup = { "skim" },
  opts = {
    lsp = {
      symbols = {},
    },
  },
  -- TODO: Change keybind for regex search

  -- stylua: ignore
  keys = {
    { "<leader><leader>", ":FzfLua files<cr>",                  desc = "Find files" },
    { "<leader>/",        ":FzfLua live_grep_native<cr>",       desc = "Live rg current project" },
    { "<leader>sb",       ":FzfLua grep_curbuf<cr>",            desc = "Live rg current buffer" },
    { "<leader>sf",       ":FzfLua files<cr>",                  desc = "Find files" },
    { "<leader>ff",       ":FzfLua files<cr>",                  desc = "Find files" },
    { "<leader>so",       ":FzfLua oldfiles<cr>",               desc = "Find oldfiles" },
    { "<leader>sc",       ":FzfLua files ~/.config/nvim <cr>",  desc = "Find neovim config file" },
    { "<leader>ss",       ":FzfLua lsp_document_symbols <cr>",  desc = "Find document symbols" },
    { "<leader>sS",       ":FzfLua lsp_workspace_symbols <cr>", desc = "Find workspace symbols" },
    { "<leader>sq",       ":FzfLua grep_quickfix <cr>",         desc = "Find in quickfix list" },
    { "<leader>sl",       ":FzfLua grep_loclist <cr>",          desc = "Find in location list" },
    { "<leader>sd",       ":FzfLua diagnostics_document <cr>",  desc = "Find document diagnostics" },
    { "<leader>sD",       ":FzfLua diagnostics_workspace <cr>", desc = "Find workspace diagnostics" },
    { "<leader>sk",       ":FzfLua keymaps <cr>",               desc = "Find keymaps" },
    { "<leader>sr",       ":FzfLua resume <cr>",                desc = "Resume last search" },
    { "<leader>sC",       ":FzfLua commands <cr>",              desc = "Find commands" },
    { "<leader>sa",       ":FzfLua autocmds <cr>",              desc = "Find autocmds" },
    { "<leader>uc",       ":FzfLua colorschemes <cr>",          desc = "Colorschemes" },
  },
}
