require("config.lazy")
require("config.options")
require("config.keymaps")
require("config.autocmds")

-- VSCode brings its own language servers and diagnostics
if not vim.g.vscode then
  require("config.lsp")
end
