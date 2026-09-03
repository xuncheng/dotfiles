-- Everything LazyVim used to set that still matters, plus the overrides that
-- were already in this file. Nothing here is carried over from the vimrc.
local opt = vim.opt

-- Indentation
opt.expandtab = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.smartindent = true
opt.shiftround = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.inccommand = "nosplit"
opt.grepprg = "rg --vimgrep"
opt.grepformat = "%f:%l:%c:%m"

-- Windows and splits
opt.laststatus = 3
opt.showtabline = 1
opt.splitbelow = true
opt.splitright = true
opt.splitkeep = "screen"
opt.winwidth = 40
opt.winminwidth = 5
opt.switchbuf = "useopen"
opt.scrolloff = 3
opt.sidescrolloff = 8
opt.cursorline = true

-- Line numbers, absolute only
opt.number = true
opt.relativenumber = false
opt.numberwidth = 5
opt.signcolumn = "yes"

-- Whitespace is shown, text is not wrapped
opt.list = true
opt.listchars = { tab = "»·", trail = "·" }

-- Blank rather than a column of ~ below the last line, and heavy box drawing
-- between windows: two splits share one background, so the edge is all there is
opt.fillchars = {
  eob = " ",
  vert = "\u{2503}",
  horiz = "\u{2501}",
  horizup = "\u{253B}",
  horizdown = "\u{2533}",
  vertleft = "\u{252B}",
  vertright = "\u{2523}",
  verthoriz = "\u{254B}",
}
opt.wrap = false
opt.linebreak = true

-- Command line and completion
opt.wildmode = "longest,list"
opt.completeopt = "menu,menuone,noselect"
opt.pumheight = 10
-- lualine already shows the mode
opt.showmode = false
opt.shortmess:append({ W = true, I = true, c = true, C = true })

-- Files
opt.autowrite = true
opt.confirm = true
opt.writebackup = false
opt.undofile = true
opt.undolevels = 10000

-- Folds exist but stay open until asked for
opt.foldenable = false

-- Matching-bracket jumping is distracting while typing
opt.showmatch = false

opt.termguicolors = true
opt.background = "dark"
opt.mouse = "a"
opt.timeoutlen = 300
opt.ttimeoutlen = 100
opt.virtualedit = "block"
opt.formatoptions = "jcroqlnt"

-- The system clipboard is reached explicitly with "+ , never implicitly
opt.clipboard = ""

-- Show text as written, nothing hidden
opt.conceallevel = 0

-- Load a .nvim.lua sitting in the directory nvim starts in
-- Nothing runs until that exact file is confirmed with :trust
opt.exrc = true

opt.modelines = 3
