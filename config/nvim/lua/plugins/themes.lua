-- tokyonight ships with LazyVim and is the one in use, see plugins/core.lua
return {
  -- A faithful port of Atom One Dark
  -- Not the default; try it with :colorscheme onedark
  {
    "navarasu/onedark.nvim",
    lazy = true,
    opts = { style = "dark" },
  },
}
