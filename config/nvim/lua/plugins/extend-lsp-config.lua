return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
      -- Only warnings and errors get drawn, and never as text at end of line
      -- Hints and style-level info are noise; <leader>cd still lists everything
      diagnostics = {
        virtual_text = false,
        signs = { severity = { min = vim.diagnostic.severity.WARN } },
        underline = { severity = { min = vim.diagnostic.severity.WARN } },
      },
      servers = {
        -- rubocop as an LSP reports style offences on every file nvim sees as
        -- ruby, a Brewfile included; real Ruby errors come from ruby_lsp
        -- conform still formats with the rubocop binary, which is unaffected
        rubocop = { enabled = false },
        -- No LazyVim extra pulls this one in, so the entry is both what enables
        -- it and what makes mason install it on a fresh machine
        -- Its default filetypes are css, scss and less already
        css_variables = {},
        ts_ls = {
          init_options = {
            preferences = {
              disableSuggestions = true,
            },
          },
        },
        vtsls = {
          settings = {
            javascript = {
              suggestionActions = { enabled = false },
            },
            typescript = {
              suggestionActions = { enabled = false },
            },
          },
        },
      },
    },
  },
}
