local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- mapleader has to be set before any plugin defines a mapping
vim.g.mapleader = ","

require("lazy").setup({
  spec = { { import = "plugins" } },
  defaults = {
    -- Under vscode-neovim the editor owns the UI, so only plugins that are
    -- pure text edits are wanted; they opt in with `vscode = true`
    cond = vim.g.vscode and function(plugin)
      return plugin.vscode == true
    end or nil,
  },
  install = { colorscheme = { "tokyonight", "habamax" } },
  -- Updates happen when I ask for them, not on a schedule
  checker = { enabled = false },
  change_detection = { notify = false },
  performance = {
    rtp = {
      disabled_plugins = { "gzip", "tarPlugin", "tohtml", "tutor", "zipPlugin" },
    },
  },
})
