-- mapleader has to be set before any plugin defines a mapping
vim.g.mapleader = ","

-- Archives are never edited in place here and the tutor is never opened, so
-- these runtime plugins only cost startup time
vim.g.loaded_gzip = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_tutor_mode_plugin = 1

-- Under vscode-neovim the editor owns the UI, so only plugins that are pure
-- text edits are wanted
local plugins = vim.g.vscode and { "https://github.com/kylechui/nvim-surround" }
  or {
    -- Colorschemes need nothing but the runtimepath: :colorscheme sources
    -- colors/<name>.lua itself. cobalt2 is in neither list, being a plain
    -- colors/cobalt2.lua in this config with no plugin behind it.
    "https://github.com/folke/tokyonight.nvim",
    -- The repo is literally named "nvim", which vim.pack would otherwise take
    -- as the plugin name, in the lockfile and on disk both
    { src = "https://github.com/catppuccin/nvim", name = "catppuccin" },
    "https://github.com/navarasu/onedark.nvim",
    -- Wanted for its lsp/ directory, which vim.lsp.enable() reads off the
    -- runtimepath, and really only for eslint: that server needs a few hundred
    -- lines of protocol glue that are an implementation, not config
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/nvim-treesitter/nvim-treesitter",
    "https://github.com/nvim-tree/nvim-web-devicons",
    "https://github.com/nvim-lualine/lualine.nvim",
    "https://github.com/lewis6991/gitsigns.nvim",
    "https://github.com/stevearc/conform.nvim",
    "https://github.com/ibhagwan/fzf-lua",
    "https://github.com/nvim-tree/nvim-tree.lua",
    "https://github.com/iamcco/markdown-preview.nvim",
    "https://github.com/kylechui/nvim-surround",
    "https://github.com/alexghergh/nvim-tmux-navigation",
  }

-- Everything else lives in plugin/, which Nvim sources after this file, in
-- alphabetical order and with each file's errors kept to that file
vim.pack.add(plugins)
