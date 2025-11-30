vim.lsp.config("*", {
  root_markers = { ".git", ".gitignore" },
})

vim.lsp.config("clangd", {
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--header-insertion=iwyu",
    "--completion-style=detailed",
    "--function-arg-placeholders",
    "--fallback-style=google",
  },
})

vim.lsp.config("rust_analyze", {
  root_markers = { ".git", "Cargo.toml" },
})
