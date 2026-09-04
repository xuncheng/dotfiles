-- vscode-neovim brings its own; nothing here is wanted there
if vim.g.vscode then
  return
end

-- The keybindings table below is what registers C-hjkl
-- The same lhs under VSCode are vscode.lua's

require("nvim-tmux-navigation").setup({
  disable_when_zoomed = true,
  keybindings = {
    left = "<C-h>",
    down = "<C-j>",
    up = "<C-k>",
    right = "<C-l>",
    last_active = "<C-\\>",
    next = "<C-Space>",
  },
})
