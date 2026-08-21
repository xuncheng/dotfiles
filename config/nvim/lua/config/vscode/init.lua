-- Entry point for the VSCode (vscode-neovim) configuration
-- Required from config/keymaps.lua when vim.g.vscode is set
--
-- LazyVim only auto-loads config.options, config.keymaps and config.autocmds.
-- This directory is not among them and has to be pulled in explicitly; add a
-- line here for each new VSCode-only module.

require("config.vscode.keymaps")
