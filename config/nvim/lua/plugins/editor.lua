return {
  { "rcarriga/nvim-notify", enabled = false },
  { "folke/noice.nvim", enabled = false },
  { "goolord/alpha-nvim", enabled = false },
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        show_buffer_close_icons = false,
        show_close_icon = false,
        diagnostics = "nvim_lsp",
        -- diagnostics_indicator = function()
        --   return " "
        -- end,
        offsets = {
          {
            filetype = "neo-tree",
            text = "File Explorer",
            highlight = "Directory",
            separator = true, -- use a "true" to enable the default, or set your own character
          },
        },
      },
    },
  },

  {
    "folke/tokyonight.nvim",
    opts = {
      on_highlights = function(highlights, colors)
        -- highlights.NeoTreeNormal = { bg = "#090B10" }
      end,
    },
  },

  {
    "marko-cerovac/material.nvim",
    -- enabled = false,
    config = function()
      vim.g.material_style = "deep ocean"
      custom_highlights = {
        NeoTreeNormal = { bg = require("material/colors").contrast },
        NeoFolderIcon = {},
      }
    end,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    -- config = function()
    --   require("catppuccin").setup({
    --     flavour = "frappe", -- latte, frappe, macchiato, mocha
    --     background = { -- :h background
    --       light = "latte",
    --       dark = "frappe",
    --     },
    --   })
    --   vim.cmd("colorscheme material")
    -- end,
  },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    config = function()
      vim.o.foldcolumn = "0" -- '0' is not bad
      vim.o.foldlevel = 0 -- Using ufo provider need a large value, feel free to decrease the value
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true

      vim.keymap.set("n", "zR", require("ufo").openAllFolds)
      vim.keymap.set("n", "zM", require("ufo").closeAllFolds)

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }
      local language_servers = require("lspconfig").util.available_servers() -- or list servers manually like {'gopls', 'clangd'}
      for _, ls in ipairs(language_servers) do
        require("lspconfig")[ls].setup({
          capabilities = capabilities,
          -- you can add other fields for setting up lsp server in this table
        })
      end

      require("ufo").setup({
        -- close_fold_kinds = { "imports", "comment" },
      })
    end,
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    keys = {
      {
        "<leader>e",
        function()
          require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd() })
        end,
        desc = "Explorer NeoTree (cwd)",
      },
    },
    opts = {
      enable_diagnostics = false,
      default_component_configs = {
        icon = {
          folder_open = "",
        },
      },
      window = {
        mappings = {
          ["o"] = "open",
        },
      },
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      { "<C-p>", require("telescope.builtin").find_files, desc = "Find Files (root dir)" },
      { "<leader>,", "<C-^>", desc = "Switch to previous buffer" },
    },
    opts = {
      defaults = {
        prompt_prefix = " ",
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "bottom" },
        file_ignore_patterns = { "yarn.lock" },
      },
    },
  },

  -- Use <tab> for completion and snippets (supertab)
  -- first: disable default <tab> and <s-tab> behavior in LuaSnip
  {
    "L3MON4D3/LuaSnip",
    keys = function()
      return {}
    end,
  },
  -- then: setup supertab in cmp
  {
    "hrsh7th/nvim-cmp",
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local luasnip = require("luasnip")
      local cmp = require("cmp")

      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
            -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
            -- they way you will only jump inside the snippet region
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      })
    end,
  },
  {
    "alexghergh/nvim-tmux-navigation",
    config = function()
      local nvim_tmux_nav = require("nvim-tmux-navigation")

      nvim_tmux_nav.setup({
        disable_when_zoomed = true, -- defaults to false
      })

      vim.keymap.set("n", "<C-h>", nvim_tmux_nav.NvimTmuxNavigateLeft)
      vim.keymap.set("n", "<C-j>", nvim_tmux_nav.NvimTmuxNavigateDown)
      vim.keymap.set("n", "<C-k>", nvim_tmux_nav.NvimTmuxNavigateUp)
      vim.keymap.set("n", "<C-l>", nvim_tmux_nav.NvimTmuxNavigateRight)
      vim.keymap.set("n", "<C-\\>", nvim_tmux_nav.NvimTmuxNavigateLastActive)
      vim.keymap.set("n", "<C-Space>", nvim_tmux_nav.NvimTmuxNavigateNext)
    end,
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
  },
  { "xiyaowong/transparent.nvim" },
  {
    "NTBBloodbath/doom-one.nvim",
    init = function()
      vim.g.doom_one_pumblend_enable = true
      vim.g.doom_one_pumblend_transparency = 3
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
-- default = "",
-- symlink = "",
-- folder = {
--   default = "",
--   empty = "",
--   empty_open = "",
--   open = "",
--   symlink = "",
--   symlink_open = "",
--   arrow_open = "",
--   arrow_closed = "",
-- },
--
