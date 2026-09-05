-- vscode-neovim paints the buffer itself
if vim.g.vscode then
  return
end

-- Colorschemes need nothing but the runtimepath: :colorscheme sources
-- colors/<name>.lua itself
vim.pack.add({
  "https://github.com/folke/tokyonight.nvim",
  -- The repo is literally named "nvim", which vim.pack would otherwise take
  -- as the plugin name, in the lockfile and on disk both
  { src = "https://github.com/catppuccin/nvim", name = "catppuccin" },
  "https://github.com/navarasu/onedark.nvim",
})

-- cobalt2 is a plain colors/cobalt2.lua in this config; :colorscheme finds it
-- without any plugin involved. tokyonight ships moon, night, storm and day,
-- catppuccin latte, frappe, macchiato and mocha; onedark is one name whose
-- variant is chosen in its setup() instead.
vim.cmd.colorscheme("catppuccin-mocha")
