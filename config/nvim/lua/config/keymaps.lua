-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- 使用 <leader><leader> 切换到上一个缓冲区
vim.keymap.set("n", "<leader><leader>", "<C-^>", { noremap = true, silent = true })

-- 按下回车键时清除搜索高亮
vim.keymap.set("n", "<CR>", ":nohlsearch<CR>:<CR>", { noremap = true, silent = true })

vim.keymap.set("i", "<C-l>", "<space>=><space>", {})

-- 使用 <leader>n 重命名文件
function RenameFile()
  local old_name = vim.fn.expand("%")
  local new_name = vim.fn.input("New file name: ", old_name, "file")
  if new_name ~= "" and new_name ~= old_name then
    os.rename(old_name, new_name)
    vim.fn.execute(":e " .. new_name)
  end
end
vim.keymap.set("n", "<leader>n", "<cmd>lua RenameFile()<CR>", {})

local Util = require("lazyvim.util")
vim.keymap.set("n", "<leader>t", function()
  Util.float_term(nil, { border = "rounded", size = { width = 1, height = 0.8 } })
end, { desc = "Terminal (cwd)" })
