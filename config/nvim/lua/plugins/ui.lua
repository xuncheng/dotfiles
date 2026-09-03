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
    opts = {
      options = {
        theme = "auto",
        globalstatus = true,
        section_separators = "",
        component_separators = "|",
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch" },
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "diagnostics", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
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
