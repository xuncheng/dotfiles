-- vscode-neovim brings its own; nothing here is wanted there
if vim.g.vscode then
  return
end

-- nvim bundles parsers for c, lua, markdown, markdown_inline, query, vim and
-- vimdoc, and starts them from its own ftplugins. This adds the languages
-- actually written here; the bundled ones are left alone so nvim's copies
-- stay authoritative
local parsers = {
  "bash",
  "css",
  "html",
  "javascript",
  "json",
  "ruby",
  "toml",
  "tsx",
  "typescript",
  "yaml",
}

-- An update outruns the compiled parsers and breaks highlighting until they
-- are rebuilt. Registered before the add below, which is what a first install
-- would fire; a fresh install needs nothing though, the install() call having
-- put the parsers there in the first place
vim.api.nvim_create_autocmd("PackChanged", {
  group = vim.api.nvim_create_augroup("custom_treesitter_build", { clear = true }),
  callback = function(ev)
    if ev.data.spec.name == "nvim-treesitter" and ev.data.kind == "update" then
      vim.cmd("TSUpdate")
    end
  end,
})

vim.pack.add({ "https://github.com/nvim-treesitter/nvim-treesitter" })

require("nvim-treesitter").install(parsers)

-- Highlighting is nvim's, not the plugin's: the plugin only supplies the
-- parser and the queries. pcall because a filetype without a parser and a
-- parser still compiling both raise here
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("custom_treesitter", { clear = true }),
  callback = function(ev)
    if not pcall(vim.treesitter.start, ev.buf) then
      return
    end

    -- Indentation is a query of its own and plenty of parsers ship without
    -- one; pointing 'indentexpr' at a parser that has none flattens the
    -- buffer instead of leaving Vim's own indent rules in place
    local lang = vim.treesitter.language.get_lang(ev.match)
    if lang and vim.treesitter.query.get(lang, "indents") then
      vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})
