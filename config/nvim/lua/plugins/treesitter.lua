-- nvim bundles parsers for c, lua, markdown, query, vim and vimdoc and starts
-- them from its own ftplugins. This adds the languages actually written here;
-- the bundled ones are left alone so nvim's copies stay authoritative
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

-- VSCode colours bracket pairs by nesting depth, which is an editor feature
-- there rather than part of a theme, so these are its own defaults rather than
-- anything Cobalt2 defines. Levels past the third repeat from the top
local rainbow = {
  { "RainbowDelimiterGold", "#ffd700" },
  { "RainbowDelimiterOrchid", "#da70d6" },
  { "RainbowDelimiterBlue", "#179fff" },
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    -- Parsers are compiled by the tree-sitter CLI, a separate formula from the
    -- tree-sitter library that neovim itself depends on:
    --   brew install tree-sitter-cli
    -- Upstream does not support lazy-loading, and a plugin update that outruns
    -- the parsers breaks highlighting until they are rebuilt, hence the build
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").install(parsers)

      -- Highlighting is nvim's, not the plugin's: the plugin only supplies the
      -- parser and the queries. pcall because a filetype without a parser and a
      -- parser still compiling both raise here
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("custom_treesitter", { clear = true }),
        callback = function(ev)
          pcall(vim.treesitter.start, ev.buf)
        end,
      })
    end,
  },

  {
    "HiPhish/rainbow-delimiters.nvim",
    event = { "BufReadPost", "BufNewFile" },
    init = function()
      local names = {}
      for i, level in ipairs(rainbow) do
        names[i] = level[1]
      end
      vim.g.rainbow_delimiters = { highlight = names }
    end,
    config = function()
      -- A colorscheme clears every highlight, and these belong to no
      -- colorscheme, so they are put back each time one loads
      local function apply()
        for _, level in ipairs(rainbow) do
          vim.api.nvim_set_hl(0, level[1], { fg = level[2] })
        end
      end

      apply()
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("custom_rainbow", { clear = true }),
        callback = apply,
      })
    end,
  },
}
