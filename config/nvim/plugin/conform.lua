-- vscode-neovim brings its own; nothing here is wanted there
if vim.g.vscode then
  return
end

-- Formatting only; diagnostics come from the language servers
--
-- The binaries are not installed by anything here:
--   brew install stylua prettier   # prettier is the fallback, node_modules wins
--   gem install rubocop            # no brew formula, or via the project's Gemfile
local prettier_configs = {
  ".prettierrc",
  ".prettierrc.json",
  ".prettierrc.yml",
  ".prettierrc.yaml",
  ".prettierrc.js",
  ".prettierrc.cjs",
  ".prettierrc.mjs",
  "prettier.config.js",
  "prettier.config.cjs",
  "prettier.config.mjs",
}

-- Prettier reformats to its own defaults when a project has no opinion,
-- which silently rewrites files in projects that never asked for it
local function has_prettier_config(ctx)
  return #vim.fs.find(prettier_configs, { path = ctx.filename, upward = true }) > 0
end

vim.keymap.set("n", "<leader>cf", function()
  require("conform").format({ async = true })
end, { desc = "Format buffer" })

-- vim.b.autoformat is read by conform's format_on_save below and by the
-- eslint autocmd in lsp.lua, so this switch covers both.
-- autocmds.lua sets the same flag for the Brewfile, which is why toggling
-- it back on there formats a buffer that starts out unformatted
vim.keymap.set("n", "<leader>uf", function()
  vim.b.autoformat = not (vim.b.autoformat == nil or vim.b.autoformat)
  vim.notify("Autoformat " .. (vim.b.autoformat and "on" or "off") .. " for this buffer")
end, { desc = "Toggle autoformat" })

require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    ruby = { "rubocop" },
    css = { "prettier" },
    html = { "prettier" },
    javascript = { "prettier" },
    json = { "prettier" },
    markdown = { "prettier" },
    scss = { "prettier" },
    typescript = { "prettier" },
    yaml = { "prettier" },
  },
  formatters = {
    prettier = {
      condition = function(_, ctx)
        return has_prettier_config(ctx)
      end,
    },
  },
  format_on_save = function(buf)
    if vim.b[buf].autoformat == false then
      return nil
    end
    return { timeout_ms = 3000, lsp_format = "fallback" }
  end,
})
