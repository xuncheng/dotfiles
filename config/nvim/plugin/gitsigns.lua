-- vscode-neovim brings its own; nothing here is wanted there
if vim.g.vscode then
  return
end

vim.pack.add({ "https://github.com/lewis6991/gitsigns.nvim" })

require("gitsigns").setup({
  -- A deletion is marked on the edge of a neighbouring line, which reads
  -- as if that line itself changed; leaving it unmarked is less misleading
  signs = {
    delete = { text = "" },
    topdelete = { text = "" },
  },
})
