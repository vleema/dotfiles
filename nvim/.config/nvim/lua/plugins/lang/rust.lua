return {
  {
    "mrcjkb/rustaceanvim",
    version = "^6",
    config = function()
      vim.g.rustaceanvim = {
        server = {
          default_settings = {
            -- root_markers = { ".git", "Cargo.toml" },
            ["rust-analyzer"] = {
              cargo = {
                target = "x86_64-unknown-linux-gnu",
              },
            },
          },
        },
      }
    end,
  },
  {
    "saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    tag = "stable",
    opts = {
      completion = {
        crates = {
          enabled = true,
        },
      },
      lsp = {
        enabled = true,
        actions = true,
        completion = true,
        hover = true,
      },
    },
  },
}
