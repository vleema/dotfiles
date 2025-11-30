vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking text",
  group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  desc = "Wrap and check for spell text filetypes",
  group = vim.api.nvim_create_augroup("wrap_spell", { clear = true }),
  pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

local lsp_group = vim.api.nvim_create_augroup("lsp", { clear = true })

vim.api.nvim_create_autocmd("LspAttach", {
  desc = "Toggle LSP folding and formatting if available",
  group = lsp_group,
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end

    if client:supports_method("textDocument/foldingRange") then
      local win = vim.api.nvim_get_current_win()
      local fm = vim.wo[win].foldmethod
      if fm == "manual" or fm == "indent" or "expr" then
        vim.wo[win].foldmethod = "expr"
        vim.wo[win].foldexpr = "v:lua.vim.lsp.foldexpr()"
      end
    end
    if client:supports_method("textDocument/formatting") then
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = args.buf,
        callback = function()
          vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
        end,
      })
    end
  end,
})

vim.api.nvim_create_autocmd("LspAttach", {
  desc = "Change neovim root directory to be the same as the lsp",
  group = lsp_group,
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end
    local root_dir = client.config.root_dir
    if root_dir then
      vim.cmd("cd " .. root_dir)
    end
  end,
})
