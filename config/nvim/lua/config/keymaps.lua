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

-- Window movement goes to tmux in the terminal and to VSCode inside VSCode
-- The plugin registers its own keybindings table, but the lhs there is stored
-- literally rather than as a keycode, so these explicit maps are what fire
if vim.g.vscode then
  require("config.vscode")
else
  map("n", "<C-h>", "<cmd>NvimTmuxNavigateLeft<CR>")
  map("n", "<C-j>", "<cmd>NvimTmuxNavigateDown<CR>")
  map("n", "<C-k>", "<cmd>NvimTmuxNavigateUp<CR>")
  map("n", "<C-l>", "<cmd>NvimTmuxNavigateRight<CR>")
  map("n", "<C-\\>", "<cmd>NvimTmuxNavigateLastActive<CR>")
end

-- Buffers and quitting, the LazyVim bindings these hands already know
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })

-- Diagnostics are not drawn inline, so this is how the full text is read
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line diagnostics" })
map("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end, { desc = "Next diagnostic" })
map("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, { desc = "Previous diagnostic" })
