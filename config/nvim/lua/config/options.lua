-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.mapleader = ","

vim.opt.background = "dark"
vim.opt.clipboard = "" -- 'unnamedplus'
vim.opt.relativenumber = false

-- Enable the option to require a Prettier config file
-- If no prettier config file is found, the formatter will not be used
vim.g.lazyvim_prettier_needs_config = true

-- Set to false to disable auto format
vim.g.lazyvim_eslint_auto_format = true

-- LSP Server to use for Ruby.
-- Set to "solargraph" to use solargraph instead of ruby_lsp.
vim.g.lazyvim_ruby_lsp = "ruby_lsp"
vim.g.lazyvim_ruby_formatter = "rubocop"
