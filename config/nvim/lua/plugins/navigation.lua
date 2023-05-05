local fn, api = vim.fn, vim.api
local highlight = as.highlight
local autocmd = api.nvim_create_autocmd

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    cmd = { "Neotree" },
    keys = { { "<C-N>", "<Cmd>Neotree toggle reveal<CR>", desc = "NeoTree" } },
    init = function()
      autocmd("BufEnter", {
        desc = "Load NeoTree if entering a directory",
        callback = function(args)
          if fn.isdirectory(api.nvim_buf_get_name(args.buf)) > 0 then
            require("lazy").load({ plugins = { "neo-tree.nvim" } })
            api.nvim_del_autocmd(args.id)
          end
        end,
      })
    end,
    config = function()
      -- highlight.plugin("NeoTree", {
      --   theme = {
      --     ["*"] = {
      --       { NeoTreeNormal = { link = "PanelBackground" } },
      --       { NeoTreeNormalNC = { link = "PanelBackground" } },
      --       { NeoTreeCursorLine = { link = "Visual" } },
      --       { NeoTreeRootName = { underline = true } },
      --       { NeoTreeStatusLine = { link = "PanelSt" } },
      --       { NeoTreeTabActive = { bg = { from = "PanelBackground" }, bold = true } },
      --       { NeoTreeTabInactive = { bg = { from = "PanelDarkBackground", alter = 0.15 }, fg = { from = "Comment" } } },
      --       { NeoTreeTabSeparatorActive = { inherit = "PanelBackground", fg = { from = "Comment" } } },
      --       -- stylua: ignore
      --       { NeoTreeTabSeparatorInactive = { inherit = 'NeoTreeTabInactive', fg = { from = 'PanelDarkBackground', attr = 'bg' } } },
      --     },
      --     horizon = {
      --       { NeoTreeWinSeparator = { link = "WinSeparator" } },
      --       { NeoTreeTabInactive = { bg = { from = "PanelBackground" }, fg = { from = "Comment" } } },
      --       { NeoTreeTabActive = { link = "VisibleTab" } },
      --       { NeoTreeTabSeparatorActive = { link = "VisibleTab" } },
      --       -- stylua: ignore
      --       { NeoTreeTabSeparatorInactive = { inherit = 'NeoTreeTabInactive', fg = { from = 'PanelBackground', attr = 'bg' } } },
      --     },
      --   },
      -- })

      vim.g.neo_tree_remove_legacy_commands = 1

      local symbols = require("lspkind").symbol_map
      local lsp_kinds = as.ui.lsp.highlights

      require("neo-tree").setup({
        sources = { "filesystem", "diagnostics", "document_symbols" },
        source_selector = {
          winbar = true,
          separator_active = "",
          sources = {
            { source = "filesystem" },
            { source = "document_symbols" },
            { source = "diagnostics", display_name = (" %s Diagnostics "):format("") },
          },
        },
        enable_git_status = true,
        git_status_async = true,
        nesting_rules = {
          ["dart"] = { "freezed.dart", "g.dart" },
        },
        event_handlers = {
          {
            event = "neo_tree_buffer_enter",
            handler = function()
              highlight.set("Cursor", { blend = 100 })
            end,
          },
          {
            event = "neo_tree_buffer_leave",
            handler = function()
              highlight.set("Cursor", { blend = 0 })
            end,
          },
          {
            event = "neo_tree_window_after_close",
            handler = function()
              highlight.set("Cursor", { blend = 0 })
            end,
          },
        },
        filesystem = {
          hijack_netrw_behavior = "open_current",
          use_libuv_file_watcher = true,
          group_empty_dirs = true,
          follow_current_file = true,
          filtered_items = {
            visible = true,
            hide_dotfiles = false,
            hide_gitignored = true,
            never_show = { ".DS_Store" },
          },
          window = {
            mappings = {
              ["/"] = "noop",
              ["g/"] = "fuzzy_finder",
            },
          },
        },
        default_component_configs = {
          icon = {
            folder_empty = "",
            folder_open = "",
          },
          name = {
            highlight_opened_files = true,
          },
          document_symbols = {
            follow_cursor = true,
            kinds = as.fold(function(acc, v, k)
              acc[k] = { icon = v, hl = lsp_kinds[k] }
              return acc
            end, symbols),
          },
          diagnostics = {
            highlights = {
              hint = "DiagnosticHint",
              info = "DiagnosticInfo",
              warn = "DiagnosticWarn",
              error = "DiagnosticError",
            },
          },
          modified = {
            symbol = "" .. " ",
          },
          git_status = {
            symbols = {
              added = "", -- '',
              deleted = "", -- '',
              modified = "",
              renamed = "",
              untracked = "",
              ignored = "",
              unstaged = "",
              staged = "",
              conflict = "",
            },
          },
        },
        window = {
          mappings = {
            -- ["o"] = "toggle_node",
            ["o"] = "open",
            ["<CR>"] = "open_with_window_picker",
            ["<c-s>"] = "split_with_window_picker",
            ["<c-v>"] = "vsplit_with_window_picker",
            ["<esc>"] = "revert_preview",
            ["P"] = { "toggle_preview", config = { use_float = true } },
          },
        },
      })
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
      { "mrbjarksen/neo-tree-diagnostics.nvim" },
      { "onsails/lspkind.nvim" },
      {
        "s1n7ax/nvim-window-picker",
        version = "*",
        opts = {
          use_winbar = "smart",
          autoselect_one = true,
          include_current = false,
          other_win_hl_color = highlight.get("Visual", "bg"),
          filter_rules = {
            bo = {
              filetype = { "neo-tree-popup", "quickfix" },
              buftype = { "terminal", "quickfix", "nofile" },
            },
          },
        },
      },
    },
  },
}
