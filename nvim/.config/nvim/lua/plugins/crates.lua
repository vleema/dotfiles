return {
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
}
