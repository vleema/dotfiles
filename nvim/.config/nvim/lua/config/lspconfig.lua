local lspconfig = require("lspconfig")
lspconfig["vhdl_ls"].setup({
  on_attach = on_attach,
  capabilities = capabilities,
})
lspconfig.jdtls.setup({
  root_dir = function(fname)
    return lspconfig.util.find_git_ancestor(fname) or lspconfig.util.root_pattern("pom.xml")(fname)
  end,
})
