-- Kept only for its lsp/ directory, and really only for eslint: that server
-- needs 231 lines of protocol glue (eslint/openDoc, eslint/confirmESLintExecution,
-- flat-config detection, EslintFixAll) that is an implementation, not config.
-- This config's own lsp/ files are deep-merged on top of the ones here.
return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
}
