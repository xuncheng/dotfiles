-- Keymaps under VSCode
--
-- LazyVim's vscode extra trims plugins down to an allowlist: snacks' picker
-- and explorer, nvim-tmux-navigation and others never load, and the LazyVim
-- defaults that depend on them stop working.
-- The ones in daily use are wired to VSCode's own commands here, so the feel
-- matches terminal nvim.

local vscode = require("vscode")
local map = vim.keymap.set

-- View navigation: stands in for nvim-tmux-navigation in the terminal
-- VSCode's navigate* moves focus between editor groups, the sidebar and the
-- bottom panel
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

-- Restore the LazyVim keys the vscode extra switches off
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
