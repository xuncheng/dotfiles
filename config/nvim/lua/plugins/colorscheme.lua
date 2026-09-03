-- cobalt2 itself is not here: it is a plain colors/cobalt2.lua on the
-- runtimepath, which :colorscheme finds without any plugin involved
return {
  -- Not the default; try them with :colorscheme
  { "navarasu/onedark.nvim", lazy = true, opts = { style = "dark" } },
  { "folke/tokyonight.nvim", lazy = true },
}
