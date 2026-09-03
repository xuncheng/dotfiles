return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("tokyonight")
    end,
  },
  -- Not the default; try it with :colorscheme onedark
  { "navarasu/onedark.nvim", lazy = true, opts = { style = "dark" } },
}
