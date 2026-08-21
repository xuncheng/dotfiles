return {
  "kylechui/nvim-surround",
  version = "^3.0.0", -- Use for stability; omit to use `main` branch for the latest features
  event = "VeryLazy",
  vscode = true, -- loaded under VSCode too: pure text edits, no UI
  config = function()
    require("nvim-surround").setup({
      -- Configuration here, or leave empty to use defaults
    })
  end,
}
