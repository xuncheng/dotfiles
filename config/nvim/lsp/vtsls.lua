-- Layered on top of nvim-lspconfig's vtsls: everything else comes from there
return {
  settings = {
    -- The small "did you mean" prompts fire constantly while typing
    javascript = { suggestionActions = { enabled = false } },
    typescript = { suggestionActions = { enabled = false } },
  },
}
