-- mapleader has to be set before any plugin defines a mapping
vim.g.mapleader = ","

-- Archives are never edited in place here and the tutor is never opened, so
-- these runtime plugins only cost startup time
vim.g.loaded_gzip = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_tutor_mode_plugin = 1

-- Everything else lives in plugin/, which Nvim sources after this file, in
-- alphabetical order and with each file's errors kept to that file. Each of
-- those installs what it configures, so under vscode-neovim -- where all but
-- nvim-surround return early -- nothing else is downloaded either
