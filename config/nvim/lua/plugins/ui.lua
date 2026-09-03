return {
  -- Icons for the tree, the picker and the statusline
  -- All three require this module by name, so no shim is involved
  {
    "nvim-tree/nvim-web-devicons",
    lazy = false,
    opts = {},
  },

  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    config = function()
      local function hl(group, attr)
        local value = vim.api.nvim_get_hl(0, { name = group, link = false })[attr]
        return value and string.format("#%06x", value) or nil
      end

      -- Every section but `a` shares one background, so the bar reads as a flat
      -- band with a single colour-coded badge at the left end rather than as a
      -- row of coloured blocks. The colours come from the loaded colorscheme
      -- rather than a fixed palette, so :colorscheme keeps the bar in step
      local function theme()
        -- Normal rather than StatusLine, so the bar sits at the same level as
        -- the text instead of floating above or below it
        local base = hl("Normal", "bg") or "#1f2335"
        local flat = { bg = base, fg = hl("Normal", "fg") }
        local dim = { bg = base, fg = hl("StatusLine", "fg") or hl("Comment", "fg") }
        local function badge(group)
          return { bg = hl(group, "fg"), fg = hl("Normal", "bg") or base, gui = "bold" }
        end
        return {
          normal = { a = badge("Keyword"), b = flat, c = dim },
          insert = { a = badge("String") },
          visual = { a = badge("Function") },
          replace = { a = badge("DiagnosticError") },
          command = { a = badge("Type") },
          inactive = { a = dim, b = dim, c = dim },
        }
      end

      local opts = {
        options = {
          theme = theme(),
          globalstatus = true,
          section_separators = "",
          component_separators = "|",
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch" },
          lualine_c = { { "filename", path = 1 } },
          -- x also carries what belongs in y and z: lualine gives those the
          -- colours of b and a, which would put coloured blocks back on the right
          lualine_x = { "diagnostics", "filetype", "location" },
          lualine_y = {},
          lualine_z = {},
        },
      }

      local lualine = require("lualine")
      lualine.setup(opts)

      vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("custom_lualine_theme", { clear = true }),
        callback = function()
          opts.options.theme = theme()
          lualine.setup(opts)
        end,
      })
    end,
  },

  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      -- A deletion is marked on the edge of a neighbouring line, which reads
      -- as if that line itself changed; leaving it unmarked is less misleading
      signs = {
        delete = { text = "" },
        topdelete = { text = "" },
      },
    },
  },

  -- The leader is a comma and there are enough mappings to forget one
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = { preset = "helix" },
  },
}
