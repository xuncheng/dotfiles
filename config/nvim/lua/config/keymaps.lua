-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- <leader><leader> switches to the previous buffer
map("n", "<leader><leader>", "<C-^>", { noremap = true, silent = true })

-- Enter clears the search highlight
map("n", "<CR>", ":nohlsearch<CR>:<CR>", { noremap = true, silent = true })

map("i", "<C-l>", "<space>=><space>", {})

-- Tab completes rather than a popup opening on its own, as the old vimrc did
-- nvim sets omnifunc only for servers that can complete, so an empty one means
-- <C-x><C-o> has nothing behind it and <C-p> keyword completion stands in
-- Accept with <C-y>, dismiss with <C-e>
map("i", "<Tab>", function()
  if vim.fn.pumvisible() == 1 then
    return "<C-n>"
  end
  local col = vim.fn.col(".") - 1
  if col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
    return "<Tab>"
  end
  return vim.bo.omnifunc ~= "" and "<C-x><C-o>" or "<C-p>"
end, { expr = true })

map("i", "<S-Tab>", function()
  return vim.fn.pumvisible() == 1 and "<C-p>" or "<S-Tab>"
end, { expr = true })

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

-- <leader>j jumps to a directory the project layout guarantees, so the path
-- never has to be typed; the picker still fuzzy-matches within it
-- The letters come from the old vimrc, where selecta filled this role
-- A directory the project does not have simply comes up empty
local jump_dirs = {
  a = { "admin/functions" },
  b = { "backend" },
}
for key, dirs in pairs(jump_dirs) do
  map("n", "<leader>j" .. key, function()
    Snacks.picker.files({ dirs = dirs })
  end, { desc = table.concat(dirs, " ") })
end
