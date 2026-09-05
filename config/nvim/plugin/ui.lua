-- vscode-neovim brings its own; nothing here is wanted there
if vim.g.vscode then
  return
end

vim.pack.add({
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/nvim-lualine/lualine.nvim",
})

require("nvim-web-devicons").setup({})

require("lualine").setup({
  options = {
    globalstatus = true,
    section_separators = "",
    component_separators = "|",
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch" },
    -- Parent directory and filename only: the full relative path is
    -- shortened a segment at a time once the window narrows, so the same
    -- file reads differently at different widths
    lualine_c = {
      { "filename", path = 4, symbols = { modified = " ●", readonly = " " } },
    },
    lualine_x = { "diagnostics", "filetype" },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
})
