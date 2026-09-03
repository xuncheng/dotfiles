local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Search highlight: no background, underline only (terminal nvim and VSCode)
-- vscode-neovim translates nvim's underline into textDecoration
-- A colorscheme load resets highlights, hence the event; VSCode has none
local function search_hl()
  for _, group in ipairs({ "Search", "IncSearch", "CurSearch" }) do
    vim.api.nvim_set_hl(0, group, { bg = "NONE", fg = "NONE", underline = true })
  end
end
autocmd("ColorScheme", { group = augroup("custom_search_hl", { clear = true }), callback = search_hl })
search_hl()

-- Reopen a file at the line it was left on
autocmd("BufReadPost", {
  group = augroup("custom_last_position", { clear = true }),
  callback = function(ev)
    local mark = vim.api.nvim_buf_get_mark(ev.buf, '"')
    if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(ev.buf) then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- A Brewfile is Homebrew's DSL, but nvim sees ft=ruby, so rubocop would
-- reformat it on save and turn Homebrew's double quotes into single ones
autocmd({ "BufReadPost", "BufNewFile" }, {
  group = augroup("custom_brewfile_noformat", { clear = true }),
  pattern = { "Brewfile", "*.Brewfile", "Brewfile.*" },
  callback = function(ev)
    vim.b[ev.buf].autoformat = false
  end,
})
