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
  -- A faithful port of Atom One Dark. doom-one is from the same One Dark
  -- family and shares the #282c34 background, but swaps the keyword and
  -- function colours (keywords blue #51afef, functions purple #c678dd).
  -- This one keeps the original mapping: keywords purple #c678dd, functions
  -- blue #61afef, variables salmon #e06c75.
  -- Not the default; try it with :colorscheme onedark.
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
