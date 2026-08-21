-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- <leader><leader> switches to the previous buffer
map("n", "<leader><leader>", "<C-^>", { noremap = true, silent = true })

-- Enter clears the search highlight
map("n", "<CR>", ":nohlsearch<CR>:<CR>", { noremap = true, silent = true })

map("i", "<C-l>", "<space>=><space>", {})

-- <leader>n renames the file
function RenameFile()
  local old_name = vim.fn.expand("%")
  local new_name = vim.fn.input("New file name: ", old_name, "file")
  if new_name ~= "" and new_name ~= old_name then
    os.rename(old_name, new_name)
    vim.fn.execute(":e " .. new_name)
  end
end
map("n", "<leader>n", "<cmd>lua RenameFile()<CR>", {})

-- local Util = require("lazyvim.util")
-- vim.keymap.set("n", "<leader>t", function()
--   Util.float_term(nil, { border = "rounded", size = { width = 1, height = 0.8 } })
-- end, { desc = "Terminal (cwd)" })

-- https://github.com/LazyVim/LazyVim/discussions/4109
-- Both sides have to override LazyVim's default <C-w>hjkl bindings
if vim.g.vscode then
  require("config.vscode")
else
  map("n", "<C-h>", "<cmd>NvimTmuxNavigateLeft<CR>")
  map("n", "<C-j>", "<cmd>NvimTmuxNavigateDown<CR>")
  map("n", "<C-k>", "<cmd>NvimTmuxNavigateUp<CR>")
  map("n", "<C-l>", "<cmd>NvimTmuxNavigateRight<CR>")
  map("n", "<C-\\>", "<cmd>NvimTmuxNavigateLastActive<CR>")
end
