-- Everything that only applies under vscode-neovim
--
-- init.lua installs only nvim-surround there, so the picker, the file tree and
-- nvim-tmux-navigation never load and their keys die with them
if not vim.g.vscode then
  return
end

local vscode = require("vscode")
local map = vim.keymap.set

-- View navigation: stands in for nvim-tmux-navigation
-- navigate* moves focus across editor groups, sidebar and panel
map("n", "<C-h>", function()
  vscode.action("workbench.action.navigateLeft")
end)
map("n", "<C-j>", function()
  vscode.action("workbench.action.navigateDown")
end)
map("n", "<C-k>", function()
  vscode.action("workbench.action.navigateUp")
end)
map("n", "<C-l>", function()
  vscode.action("workbench.action.navigateRight")
end)

-- The same lhs the terminal config uses, pointed at VSCode's own commands
map("n", "<leader>e", function()
  vscode.action("workbench.action.toggleSidebarVisibility")
end)
map("n", "<leader>fe", function()
  vscode.action("workbench.view.explorer")
end)
map("n", "<leader>ff", function()
  vscode.action("workbench.action.quickOpen")
end)
map("n", "<leader>fs", function()
  vscode.action("workbench.action.findInFiles")
end)
map("n", "<leader>sw", function()
  vscode.action("workbench.action.findInFiles", { args = { query = vim.fn.expand("<cword>") } })
end)
