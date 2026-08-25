-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Search highlight: no background, underline only (terminal nvim and VSCode)
-- vscode-neovim translates nvim's underline into textDecoration
local function search_hl()
  for _, group in ipairs({ "Search", "IncSearch", "CurSearch" }) do
    vim.api.nvim_set_hl(0, group, { bg = "NONE", fg = "NONE", underline = true })
  end
end

-- A colorscheme load resets highlights, hence the event; VSCode has none
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("custom_search_hl", { clear = true }),
  callback = search_hl,
})
search_hl()

-- No spell check or wrapping in markdown/text/gitcommit
-- Overrides LazyVim's wrap_spell group
pcall(vim.api.nvim_del_augroup_by_name, "lazyvim_wrap_spell")

-- A Brewfile is Homebrew's DSL, but nvim sees ft=ruby, so rubocop would
-- reformat it on save and turn Homebrew's double quotes into single ones
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  group = vim.api.nvim_create_augroup("custom_brewfile_noformat", { clear = true }),
  pattern = { "Brewfile", "*.Brewfile", "Brewfile.*" },
  callback = function(ev)
    vim.b[ev.buf].autoformat = false
  end,
})
