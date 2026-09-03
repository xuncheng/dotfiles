require("config.lazy")
require("config.options")
require("config.keymaps")
require("config.autocmds")

-- VSCode paints the buffer itself and brings its own language servers
if not vim.g.vscode then
  vim.cmd.colorscheme("cobalt2")
  require("config.lsp")
end
