-- vscode-neovim paints the buffer itself
if vim.g.vscode then
  return
end

-- cobalt2 is a plain colors/cobalt2.lua in this config; :colorscheme finds it
-- without any plugin involved. tokyonight ships moon, night, storm and day,
-- catppuccin latte, frappe, macchiato and mocha; onedark is one name whose
-- variant is chosen in its setup() instead.
vim.cmd.colorscheme("catppuccin-mocha")
