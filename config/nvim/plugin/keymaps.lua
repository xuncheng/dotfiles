local map = vim.keymap.set

-- <leader><leader> switches to the previous buffer
map("n", "<leader><leader>", "<C-^>", { noremap = true, silent = true })

-- Enter clears the search highlight, except where it already means something:
-- the quickfix list jumps to an entry with it, the command-line window runs
-- the line under the cursor
map("n", "<CR>", function()
  return vim.bo.buftype ~= "" and "<CR>" or "<cmd>nohlsearch<cr>"
end, { expr = true })

map("i", "<C-l>", "<space>=><space>", {})

-- Tab walks the completion menu, which 'autocomplete' opens on its own
-- Accept with <C-y>, dismiss with <C-e>
map("i", "<Tab>", function()
  return vim.fn.pumvisible() == 1 and "<C-n>" or "<Tab>"
end, { expr = true })

map("i", "<S-Tab>", function()
  return vim.fn.pumvisible() == 1 and "<C-p>" or "<S-Tab>"
end, { expr = true })

-- <leader>n renames the file and carries this buffer over to the new name;
-- opening the new name instead would leave the old one listed and pointing
-- at a file that is no longer there
local function rename_file()
  local old_name = vim.fn.expand("%")
  local new_name = vim.fn.input("New file name: ", old_name, "file")
  if new_name == "" or new_name == old_name then
    return
  end
  local ok, err = os.rename(old_name, new_name)
  if not ok then
    vim.notify("Rename failed: " .. tostring(err), vim.log.levels.ERROR)
    return
  end
  vim.api.nvim_buf_set_name(0, new_name)
  vim.cmd.write({ bang = true })
end
map("n", "<leader>n", rename_file, { desc = "Rename file" })

-- Buffers and quitting, the LazyVim bindings these hands already know
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })
