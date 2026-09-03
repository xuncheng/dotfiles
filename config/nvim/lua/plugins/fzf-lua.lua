-- Matching is done by the fzf binary, listing by fd and grepping by rg

-- Dependency directories and build output, shared by files and grep
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
}

local function fd_opts()
  local o = "--color=never --type f --type l --hidden"
  for _, dir in ipairs(exclude) do
    o = o .. " --exclude " .. dir
  end
  return o
end

local function rg_opts()
  local o = "--column --line-number --no-heading --color=always --smart-case --hidden"
  for _, dir in ipairs(exclude) do
    o = o .. " --glob '!" .. dir .. "'"
  end
  return o
end

-- <leader>j jumps to a directory the project layout guarantees, so the path
-- never has to be typed; fzf still matches within it
-- The letters come from the old vimrc, where selecta filled this role
-- fd errors out on a path that is not a directory, hence the check
local jump_dirs = {
  a = "admin/functions",
  b = "backend",
}

-- The lhs are the LazyVim ones these hands already know
local keys = {
  { "<leader>ff", "<cmd>FzfLua files<cr>", desc = "Find files" },
  { "<leader>fb", "<cmd>FzfLua buffers<cr>", desc = "Buffers" },
  { "<leader>fr", "<cmd>FzfLua oldfiles<cr>", desc = "Recent files" },
  { "<leader>sg", "<cmd>FzfLua live_grep<cr>", desc = "Grep" },
  { "<leader>sw", "<cmd>FzfLua grep_cword<cr>", desc = "Grep word under cursor" },
  { "<leader>sh", "<cmd>FzfLua helptags<cr>", desc = "Help pages" },
}
for key, dir in pairs(jump_dirs) do
  table.insert(keys, {
    "<leader>j" .. key,
    function()
      if vim.fn.isdirectory(dir) == 0 then
        vim.notify(dir .. " not in this project", vim.log.levels.WARN)
        return
      end
      require("fzf-lua").files({ cwd = dir })
    end,
    desc = dir,
  })
end

return {
  "ibhagwan/fzf-lua",
  cmd = "FzfLua",
  keys = keys,
  opts = {
    -- dotfiles are ordinary files in a dotfiles-heavy tree
    -- .gitignore is still honoured, which is what keeps build output out
    -- The prompt otherwise carries the whole cwd, which never changes here
    files = { fd_opts = fd_opts(), cwd_prompt = false },
    grep = { rg_opts = rg_opts() },
  },
}
