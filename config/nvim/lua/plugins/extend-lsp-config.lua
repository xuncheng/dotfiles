return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
      -- No diagnostic text at the end of the line, only the gutter icon
      -- (<leader>cd shows the detail for the current line)
      diagnostics = { virtual_text = false },
      servers = {
        css_variables = {
          filetypes = { "css", "scss", "less", "svelte" },
        },
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
