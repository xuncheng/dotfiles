-- vscode-neovim brings its own language servers
if vim.g.vscode then
  return
end

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

-- Diagnostics are not drawn inline, so this is how the full text is read.
-- They live here rather than in keymaps.lua because LSP is the only thing
-- that fills the list, so under VSCode they should be gone with the rest of
-- this file instead of jumping around an empty one
vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line diagnostics" })
vim.keymap.set("n", "]d", function()
  vim.diagnostic.jump({ count = 1 })
end, { desc = "Next diagnostic" })
vim.keymap.set("n", "[d", function()
  vim.diagnostic.jump({ count = -1 })
end, { desc = "Previous diagnostic" })

-- A server whose binary is missing simply never attaches, so a machine without
-- them shows no error and no LSP either. Nothing installs them automatically:
--   brew install vscode-langservers-extracted  # jsonls and eslint, one package
--   brew install marksman lua-language-server  # marksman, lua_ls
--   volta install @vtsls/language-server       # vtsls
--   gem install ruby-lsp                       # or via the project's Gemfile
vim.lsp.enable({ "ruby_lsp", "vtsls", "jsonls", "marksman", "eslint", "lua_ls" })

-- eslint fixes on save; conform never runs eslint, so this is the only thing
-- applying its rules. Shares vim.b.autoformat with conform's format_on_save.
vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("custom_eslint_fix", { clear = true }),
  callback = function(ev)
    if vim.b[ev.buf].autoformat == false then
      return
    end
    if #vim.lsp.get_clients({ bufnr = ev.buf, name = "eslint" }) > 0 then
      pcall(function()
        vim.cmd("EslintFixAll")
      end)
    end
  end,
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("custom_lsp", { clear = true }),
  callback = function(ev)
    -- 'autocomplete' already opens the menu and pulls items in through
    -- 'omnifunc', so autotrigger stays off. This is for the other half:
    -- accepting with <C-y> then expands snippets, applies the text edits that
    -- add imports, and runs whatever command the server attached to the item
    vim.lsp.completion.enable(true, ev.data.client_id, ev.buf, {})

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
