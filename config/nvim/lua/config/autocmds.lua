-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local format_group = vim.api.nvim_create_augroup("FormatGroup", { clear = true })

vim.api.nvim_create_autocmd(
  { "BufReadPost", "FileReadPost" },
  { pattern = "*", command = "normal zR", group = format_group }
)
