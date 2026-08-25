-- Entry point for the VSCode (vscode-neovim) config
-- Required from config/keymaps.lua when vim.g.vscode is set
--
-- LazyVim auto-loads only config.options / keymaps / autocmds, so every
-- VSCode-only module needs a line here

require("config.vscode.keymaps")
