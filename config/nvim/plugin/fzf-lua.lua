-- vscode-neovim brings its own; nothing here is wanted there
if vim.g.vscode then
  return
end

-- Matching is done by the fzf binary, listing by fd and grepping by rg

-- Dependency directories, build output and lock files, shared by files and
-- grep. Both tools take a plain name for either a file or a directory.
-- Lock files are committed, so .gitignore does not cover them
local exclude = {
  "node_modules",
  "miniprogram_npm",
  "unpackage",
  "dist",
  "build",
  "coverage",
  ".git",
  ".next",
  ".nuxt",
  ".output",
  ".cache",
  "yarn.lock",
  "package-lock.json",
  "Gemfile.lock",
}

-- dotfiles are ordinary files in a dotfiles-heavy tree, hence --hidden
-- .gitignore is still honoured, which is what keeps build output out
local function fd_opts()
  local o = "--color=never --type f --type l --hidden"
  for _, name in ipairs(exclude) do
    o = o .. " --exclude " .. name
  end
  return o
end

-- ripgrep paints its own output and knows nothing of the colorscheme; left to
-- itself it uses magenta paths and green line numbers. It takes decimal RGB, so
-- the groups are read back out of the loaded theme rather than repeated here.
-- The theme has to be set by then, which holds because Nvim sources plugin/
-- alphabetically and colorscheme.lua sorts before this file; renaming either
-- one silently falls back to the hardcoded values below.
local function rg_colors()
  local function rgb(group, fallback)
    local fg = vim.api.nvim_get_hl(0, { name = group, link = false }).fg or fallback
    return string.format("%d,%d,%d", math.floor(fg / 65536) % 256, math.floor(fg / 256) % 256, fg % 256)
  end

  return table.concat({
    " --colors=path:fg:" .. rgb("StatusLine", 0xaaaaaa),
    " --colors=line:fg:" .. rgb("Comment", 0x808080),
    " --colors=column:fg:" .. rgb("Comment", 0x808080),
    " --colors=match:fg:" .. rgb("Keyword", 0xffc600),
    " --colors=match:style:bold",
  })
end

local function rg_opts()
  local o = "--column --line-number --no-heading --color=always --smart-case --hidden"
  for _, name in ipairs(exclude) do
    o = o .. " --glob '!" .. name .. "'"
  end
  return o .. rg_colors()
end

-- <leader>j jumps straight to a directory these projects tend to have, so the
-- path never has to be typed; fzf still matches within it
-- The letters come from the old vimrc, where selecta filled this role
-- fd errors out on a path that is not a directory, hence the check
local jump_dirs = {
  a = "admin/functions",
  b = "backend",
}

-- The lhs are the LazyVim ones these hands already know
local map = vim.keymap.set
map("n", "<leader>ff", "<cmd>FzfLua files<cr>", { desc = "Find files" })
map("n", "<leader>fb", "<cmd>FzfLua buffers<cr>", { desc = "Buffers" })
map("n", "<leader>fr", "<cmd>FzfLua oldfiles<cr>", { desc = "Recent files" })
map("n", "<leader>sg", "<cmd>FzfLua live_grep<cr>", { desc = "Grep" })
map("n", "<leader>sw", "<cmd>FzfLua grep_cword<cr>", { desc = "Grep word under cursor" })
map("n", "<leader>sh", "<cmd>FzfLua helptags<cr>", { desc = "Help pages" })

for key, dir in pairs(jump_dirs) do
  map("n", "<leader>j" .. key, function()
    if vim.fn.isdirectory(dir) == 0 then
      vim.notify(dir .. " not in this project", vim.log.levels.WARN)
      return
    end
    require("fzf-lua").files({ cwd = dir })
  end, { desc = dir })
end

require("fzf-lua").setup({
  -- fzf is a separate process painting its own window; without this it
  -- keeps its built-in palette and the panel does not match the editor
  fzf_colors = true,
  -- The prompt otherwise carries the whole cwd, which never changes here
  files = { fd_opts = fd_opts(), cwd_prompt = false },
  grep = { rg_opts = rg_opts() },
})
