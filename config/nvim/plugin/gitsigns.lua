-- vscode-neovim brings its own; nothing here is wanted there
if vim.g.vscode then
  return
end

require("gitsigns").setup({
  -- A deletion is marked on the edge of a neighbouring line, which reads
  -- as if that line itself changed; leaving it unmarked is less misleading
  signs = {
    delete = { text = "" },
    topdelete = { text = "" },
  },
})
