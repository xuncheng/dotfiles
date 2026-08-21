-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Search highlight: drop the background, keep only the underline (shared by
-- terminal nvim and VSCode)
-- Under VSCode, vscode-neovim translates nvim's underline attribute into
-- textDecoration
local function search_hl()
  for _, group in ipairs({ "Search", "IncSearch", "CurSearch" }) do
    vim.api.nvim_set_hl(0, group, { bg = "NONE", fg = "NONE", underline = true })
  end
end

-- Loading a colorscheme resets highlights, so hook the event; VSCode has no
-- colorscheme, so run once immediately
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("custom_search_hl", { clear = true }),
  callback = search_hl,
})
search_hl()

-- Undo the spell check and wrapping LazyVim forces on for markdown, text and
-- gitcommit (see the wrap_spell group in lazyvim/config/autocmds.lua)
pcall(vim.api.nvim_del_augroup_by_name, "lazyvim_wrap_spell")
