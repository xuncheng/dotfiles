-- Rein in the more modern parts of LazyVim's markdown extra
return {
  -- Heading blocks, table borders, code block backgrounds and the like
  { "MeanderingProgrammer/render-markdown.nvim", enabled = false },

  -- Browser preview, GitHub styling, toggled with <leader>cp
  {
    "iamcco/markdown-preview.nvim",
    init = function()
      -- Matches github.com; "dark" for the dark one
      vim.g.mkdp_theme = "light"
    end,
  },

  -- Diagnostics from marksman only; markdownlint's style rules are noise
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        markdown = {},
      },
    },
  },
}
