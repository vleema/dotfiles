-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<S-m>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
vim.keymap.set("n", "<S-i>", "<cmd>bnext<cr>", { desc = "Next buffer" })

-- Function to find project root using LSP, with fallback methods
local function find_project_root()
  -- First try to get root from active LSP clients
  local clients = vim.lsp.get_clients()
  if #clients > 0 then
    -- Use the first client's root directory
    local root_dir = clients[1].config.root_dir
    if root_dir then
      return root_dir
    end
  end

  -- Fallback 1: Check workspace folders
  local workspace_folders = vim.lsp.buf.list_workspace_folders()
  if #workspace_folders > 0 then
    return workspace_folders[1]
  end

  -- Fallback 2: Look for .git directory
  local current_dir = vim.fn.expand("%:p:h")
  local git_dir = vim.fn.finddir(".git", current_dir .. ";")
  if git_dir ~= "" then
    return vim.fn.fnamemodify(git_dir, ":h")
  end

  -- Fallback 3: Use current working directory
  return vim.fn.getcwd()
end

-- Function to create .editorconfig file with template
local function create_editorconfig()
  local project_root = find_project_root()
  local editorconfig_path = project_root .. "/.editorconfig"

  -- Check if .editorconfig already exists
  if vim.fn.filereadable(editorconfig_path) == 1 then
    local choice = vim.fn.confirm(".editorconfig already exists. Overwrite?", "&Yes\n&No\n&Open existing", 2)

    if choice == 1 then
      -- Overwrite
    elseif choice == 2 then
      -- Don't overwrite, exit
      return
    else
      -- Open existing file
      vim.cmd("edit " .. editorconfig_path)
      return
    end
  end

  -- .editorconfig template
  local template = [[# EditorConfig is awesome: https://EditorConfig.org

# top-most EditorConfig file
root = true

# Unix-style newlines with a newline ending every file
[*]
charset = utf-8
end_of_line = lf
insert_final_newline = true
trim_trailing_whitespace = true

# 4 space indentation
[*.{js,jsx,ts,tsx,py,java,c,cpp,h,hpp,css,scss,html,xml,json,yaml,yml}]
indent_style = space
indent_size = 4

# 2 space indentation
[*.{vue,svelte,md,markdown}]
indent_style = space
indent_size = 2

# Tab indentation (no size specified)
[*.{go,makefile,Makefile}]
indent_style = tab

# Matches the exact files either package.json or .travis.yml
[{package.json,.travis.yml}]
indent_style = space
indent_size = 2

# Dockerfile
[Dockerfile*]
indent_style = space
indent_size = 4

# Shell scripts
[*.{sh,bash,zsh,fish}]
indent_style = space
indent_size = 4

# Python specific
[*.py]
max_line_length = 88

# Web files
[*.{html,css,scss,sass,less}]
indent_style = space
indent_size = 2

# Configuration files
[*.{toml,ini,cfg,conf}]
indent_style = space
indent_size = 4
]]

  -- Write the template to file
  local file = io.open(editorconfig_path, "w")
  if file then
    file:write(template)
    file:close()

    -- Open the created file
    vim.cmd("edit " .. editorconfig_path)
    print(".editorconfig created successfully at: " .. editorconfig_path)
  else
    print("Error: Could not create .editorconfig file")
  end
end

-- Create the keymap
vim.keymap.set("n", "<leader>cg", create_editorconfig, {
  desc = "Create .editorconfig file in project root",
  silent = true,
})
