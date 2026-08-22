-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.mapleader = ","

-- The values below come from the old vimrc (vim/vimrc lines 81-161), keeping
-- the same feel as MacVim. Two of them were left alone because LazyVim's
-- choices are deliberate and reverting them is worse:
--   laststatus = 3 (one global status line; the old 2 was one per window)
--   timeoutlen = 300 (which-key's popup speed depends on it; 1000 feels slow)
-- foldmethod=manual was not carried over either: LazyVim sets treesitter's
-- foldexpr per window on BufReadPost, which overrides the global value, and
-- folding is switched off by foldenable=false below.
vim.opt.listchars = { tab = "»·", trail = "·" }
vim.opt.foldenable = false
vim.opt.showmatch = true
vim.opt.softtabstop = 2
vim.opt.scrolloff = 3
vim.opt.numberwidth = 5
vim.opt.winwidth = 79
vim.opt.switchbuf = "useopen"
vim.opt.showtabline = 2
vim.opt.wildmode = "longest,list"
vim.opt.writebackup = false
vim.opt.modelines = 3
vim.opt.ttimeoutlen = 100

vim.opt.background = "dark"
vim.opt.clipboard = "" -- 'unnamedplus'
vim.opt.relativenumber = false
-- LazyVim defaults to 2, which hides markdown markers such as ` and * — and
-- only on lines away from the cursor, so they flicker as you move
vim.opt.conceallevel = 0

-- Enable the option to require a Prettier config file
-- If no prettier config file is found, the formatter will not be used
vim.g.lazyvim_prettier_needs_config = true

-- Set to false to disable auto format
vim.g.lazyvim_eslint_auto_format = true

-- LSP Server to use for Ruby.
-- Set to "solargraph" to use solargraph instead of ruby_lsp.
-- vim.g.lazyvim_ruby_lsp = "ruby_lsp"
-- vim.g.lazyvim_ruby_formatter = "rubocop"
