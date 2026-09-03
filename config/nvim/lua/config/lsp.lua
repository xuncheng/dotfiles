-- Server definitions come from nvim-lspconfig's lsp/ directory
-- Anything under this config's own lsp/ is deep-merged on top of them

-- Only warnings and errors get drawn, and never as text at end of line
-- Hints and style-level info are noise; <leader>cd shows the full text
vim.diagnostic.config({
  virtual_text = false,
  underline = { severity = { min = vim.diagnostic.severity.WARN } },
  signs = { severity = { min = vim.diagnostic.severity.WARN } },
  severity_sort = true,
})

-- A server whose binary is missing simply never attaches, so a machine without
-- them shows no error and no LSP either. Nothing installs them automatically:
--   brew install vscode-langservers-extracted marksman   # jsonls, eslint, marksman
--   volta install @vtsls/language-server                 # vtsls
--   gem install ruby-lsp                                 # or via the project's Gemfile
vim.lsp.enable({ "ruby_lsp", "vtsls", "jsonls", "marksman", "eslint" })

-- eslint fixes on save; conform never runs eslint, so this is the only thing
-- applying its rules. Shares vim.b.autoformat with conform's format_on_save.
vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("custom_eslint_fix", { clear = true }),
  callback = function(ev)
    if vim.b[ev.buf].autoformat == false then
      return
    end
    if #vim.lsp.get_clients({ bufnr = ev.buf, name = "eslint" }) > 0 then
      pcall(vim.cmd, "EslintFixAll")
    end
  end,
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("custom_lsp", { clear = true }),
  callback = function(ev)
    local function map(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, { buffer = ev.buf, desc = desc })
    end
    map("gd", vim.lsp.buf.definition, "Go to definition")
    map("gr", vim.lsp.buf.references, "References")
    map("K", vim.lsp.buf.hover, "Hover")
    map("<leader>cr", vim.lsp.buf.rename, "Rename")
    map("<leader>ca", vim.lsp.buf.code_action, "Code action")
  end,
})
