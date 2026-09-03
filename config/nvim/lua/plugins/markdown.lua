-- Browser preview, toggled with <leader>cp
return {
  "iamcco/markdown-preview.nvim",
  cmd = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle" },
  ft = "markdown",
  -- The install helper is vimscript inside the plugin, so it has to be
  -- loaded before the build step can call it
  build = function()
    require("lazy").load({ plugins = { "markdown-preview.nvim" } })
    vim.fn["mkdp#util#install"]()
  end,
  keys = {
    { "<leader>cp", "<cmd>MarkdownPreviewToggle<cr>", ft = "markdown", desc = "Markdown preview" },
  },
  init = function()
    -- Matches github.com; "dark" for the dark one
    vim.g.mkdp_theme = "light"
  end,
}
