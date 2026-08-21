-- Rein in the more modern parts of LazyVim's markdown extra
return {
  -- Heading blocks, table borders, code block backgrounds and the like
  { "MeanderingProgrammer/render-markdown.nvim", enabled = false },

  -- Browser preview stays: GitHub styling built in, toggled with <leader>cp,
  -- lazy-loaded by command so it costs nothing until used
  {
    "iamcco/markdown-preview.nvim",
    init = function()
      vim.g.mkdp_theme = "light" -- matches github.com; "dark" for the dark one
    end,
  },

  -- markdownlint's style rules such as MD013 are too noisy; keep only the
  -- diagnostics from the LSP (marksman)
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        markdown = {},
      },
    },
  },
}
