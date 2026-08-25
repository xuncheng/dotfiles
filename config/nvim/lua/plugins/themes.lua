return {
  {
    "akinsho/horizon.nvim",
    lazy = false,
  },
  {
    "lalitmee/cobalt2.nvim",
    lazy = false,
    dependencies = { "tjdevries/colorbuddy.nvim" },
    config = function()
      require("colorbuddy").colorscheme("cobalt2")
    end,
    enabled = false,
  },
  { "NTBBloodbath/doom-one.nvim", lazy = false },
  -- A faithful port of Atom One Dark
  -- Not the default; try it with :colorscheme onedark
  {
    "navarasu/onedark.nvim",
    lazy = false,
    opts = { style = "dark" },
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      transparent_background = true,
      color_overrides = {
        mocha = {
          base = "#000000",
          mantle = "#000000",
          crust = "#000000",
        },
      },
    },
  },
}
