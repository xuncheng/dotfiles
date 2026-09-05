-- Pure text edits, which is why this is the one plugin init.lua's note about
-- vscode-neovim exempts: it is wanted there too
vim.pack.add({ "https://github.com/kylechui/nvim-surround" })

require("nvim-surround").setup({})
