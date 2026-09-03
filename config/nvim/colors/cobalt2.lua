-- Cobalt2, taken from the values in wesbos/cobalt2-vscode's theme/cobalt2.json
-- rather than from one of the ports, which read the same palette differently
--
-- Written out by hand because a theme is data: the ports that wrap it in a DSL
-- add a second plugin whose version has to match, and drift there fails silently

local palette = {
  bg = "#193549", -- editor.background
  bg_panel = "#122738", -- panel, tab bar
  -- VSCode's sideBar.background is #15232d, far darker than the editor; this
  -- sits between the two so the pane reads as set back without splitting the
  -- window into two different-looking halves
  bg_sidebar = "#162f40",
  bg_line = "#1f4662", -- editor.lineHighlightBackground
  bg_select = "#0050a4", -- editor.selectionBackground
  bg_match = "#0d3a58", -- editorBracketMatch, borders
  -- editor.foreground is #fff, but almost every token VSCode actually renders
  -- lands on the softer variable/punctuation colour, so that is the plain text
  fg = "#e1efff",
  fg_dim = "#aaaaaa", -- sideBar.foreground, line numbers
  fg_gutter = "#3b5364", -- editorIndentGuide.background

  yellow = "#ffc600", -- storage, cursor, git modified
  orange = "#ff9d00", -- keyword, support.function
  pale_yellow = "#ffee80", -- template expressions, parameter parens
  pink = "#ff628c", -- constant, git deleted
  green = "#a5ff90", -- string
  bright_green = "#3ad900", -- template string, git untracked
  blue = "#0088ff", -- comment
  mint = "#80ffbb", -- types
  grey = "#808080", -- gitDecoration.ignoredResourceForeground
  red = "#a22929", -- editorError.foreground
  git_add = "#3c9f4a", -- editorGutter.addedBackground
  git_conflict = "#ff7200", -- gitDecoration.conflictingResourceForeground

  -- No VSCode counterpart: its diff colours are translucent overlays, which a
  -- terminal cannot do, so these are opaque stand-ins at the same hues
  diff_add = "#1b3f2b",
  diff_change = "#1f4662",
  diff_delete = "#3f1f26",
  diff_text = "#2a5c7e",
}

--- Set every highlight group. Runs when this file is sourced, which is what
--- :colorscheme cobalt2 does.
local function load()
  vim.cmd("highlight clear")
  if vim.fn.exists("syntax_on") == 1 then
    vim.cmd("syntax reset")
  end
  vim.o.background = "dark"
  vim.g.colors_name = "cobalt2"

  local p = palette
  local groups = {
    -- Editor
    Normal = { fg = p.fg, bg = p.bg },
    NormalFloat = { fg = p.fg, bg = p.bg_panel },
    FloatBorder = { fg = p.bg_match, bg = p.bg_panel },
    FloatTitle = { fg = p.yellow, bg = p.bg_panel, bold = true },
    Cursor = { fg = p.bg, bg = p.yellow },
    CursorLine = { bg = p.bg_line },
    CursorLineNr = { fg = p.yellow, bold = true },
    LineNr = { fg = p.fg_gutter },
    SignColumn = { bg = p.bg },
    ColorColumn = { bg = p.bg_panel },
    Visual = { bg = p.bg_select },
    Search = { fg = p.bg, bg = p.yellow },
    IncSearch = { fg = p.bg, bg = p.orange },
    CurSearch = { fg = p.bg, bg = p.orange },
    MatchParen = { fg = p.yellow, bg = p.bg_match, bold = true },
    Folded = { fg = p.fg_dim, bg = p.bg_panel },
    NonText = { fg = p.fg_gutter },
    Whitespace = { fg = p.fg_gutter },
    SpecialKey = { fg = p.fg_gutter },
    WinSeparator = { fg = p.fg_gutter },
    Directory = { fg = p.blue },
    Title = { fg = p.yellow, bold = true },
    Question = { fg = p.bright_green },
    MoreMsg = { fg = p.blue },
    ModeMsg = { fg = p.fg_dim },
    WarningMsg = { fg = p.yellow },
    ErrorMsg = { fg = p.pink },
    StatusLine = { fg = p.fg_dim, bg = p.bg },
    StatusLineNC = { fg = p.fg_gutter, bg = p.bg },
    TabLine = { fg = p.fg_dim, bg = p.bg_panel },
    TabLineFill = { bg = p.bg_panel },
    TabLineSel = { fg = p.yellow, bg = p.bg },
    Pmenu = { fg = p.fg, bg = p.bg_panel },
    PmenuSel = { fg = p.fg, bg = p.bg_select },
    PmenuSbar = { bg = p.bg_panel },
    PmenuThumb = { bg = p.fg_gutter },
    WildMenu = { fg = p.bg, bg = p.yellow },
    QuickFixLine = { bg = p.bg_line },
    Conceal = { fg = p.fg_gutter },

    -- Syntax, for the languages with no parser installed. vim's regex syntax
    -- files are coarser than the VSCode grammars, so several scopes fold into
    -- one group here: storage and keyword both come out as Statement
    Comment = { fg = p.blue, italic = true },
    Constant = { fg = p.pink },
    String = { fg = p.green },
    Character = { fg = p.green },
    Number = { fg = p.pink },
    Boolean = { fg = p.pink },
    Float = { fg = p.pink },
    Identifier = { fg = p.fg },
    Function = { fg = p.orange },
    Statement = { fg = p.yellow },
    Conditional = { fg = p.yellow },
    Repeat = { fg = p.yellow },
    Label = { fg = p.yellow },
    Operator = { fg = p.fg },
    Keyword = { fg = p.yellow },
    Exception = { fg = p.orange },
    PreProc = { fg = p.orange },
    Include = { fg = p.orange },
    Define = { fg = p.orange },
    Macro = { fg = p.orange },
    Type = { fg = p.mint },
    StorageClass = { fg = p.yellow },
    Structure = { fg = p.mint },
    Typedef = { fg = p.mint },
    Special = { fg = p.pale_yellow },
    SpecialChar = { fg = p.pale_yellow },
    Delimiter = { fg = p.fg },
    Tag = { fg = p.yellow },
    Underlined = { fg = p.blue, underline = true },
    Todo = { fg = p.bg, bg = p.yellow, bold = true },
    -- White rather than the softened plain-text colour, which muddies on red
    Error = { fg = "#ffffff", bg = p.red },

    -- Treesitter, which covers every language with a parser. These captures
    -- take precedence over the classic groups above and are fine enough to
    -- follow the VSCode scopes one to one, so `local` and `return` differ the
    -- way they do there; left unset they collapse back onto @keyword
    ["@variable"] = { fg = p.fg },
    -- One capture for two VSCode scopes: `this` is variable.language, #fb94ff,
    -- while console / window / document are support, mint. Mint, because the
    -- latter are what actually turn up here
    ["@variable.builtin"] = { fg = p.mint },
    ["@variable.parameter"] = { fg = p.fg },
    ["@variable.member"] = { fg = p.fg },
    ["@constant"] = { fg = p.pink },
    ["@constant.builtin"] = { fg = p.pink },
    ["@module"] = { fg = p.fg },
    ["@string"] = { fg = p.green },
    ["@string.escape"] = { fg = p.pale_yellow },
    ["@character"] = { fg = p.green },
    ["@number"] = { fg = p.pink },
    ["@boolean"] = { fg = p.pink },
    ["@function"] = { fg = p.orange },
    ["@function.builtin"] = { fg = p.orange },
    ["@function.call"] = { fg = p.orange },
    ["@function.method"] = { fg = p.orange },
    ["@function.method.call"] = { fg = p.orange },
    ["@constructor"] = { fg = p.fg },
    ["@property"] = { fg = p.fg },
    ["@keyword"] = { fg = p.yellow },
    ["@keyword.function"] = { fg = p.orange },
    ["@keyword.return"] = { fg = p.orange },
    ["@keyword.conditional"] = { fg = p.orange },
    ["@keyword.repeat"] = { fg = p.orange },
    ["@keyword.exception"] = { fg = p.orange },
    ["@keyword.operator"] = { fg = p.orange },
    ["@keyword.coroutine"] = { fg = p.orange },
    ["@keyword.import"] = { fg = p.orange },
    ["@operator"] = { fg = p.fg },
    ["@punctuation.bracket"] = { fg = p.fg },
    ["@punctuation.delimiter"] = { fg = p.fg },
    ["@punctuation.special"] = { fg = p.pale_yellow },
    ["@type"] = { fg = p.mint },
    ["@type.builtin"] = { fg = p.mint },
    ["@attribute"] = { fg = p.yellow },
    ["@label"] = { fg = p.yellow },
    ["@comment"] = { fg = p.blue, italic = true },
    ["@tag"] = { fg = p.yellow },
    ["@tag.attribute"] = { fg = p.orange },
    ["@tag.delimiter"] = { fg = p.fg },

    -- Markdown, whose parser ships with nvim
    ["@markup.heading"] = { fg = p.yellow, bold = true },
    ["@markup.strong"] = { fg = p.mint, bold = true },
    ["@markup.italic"] = { fg = p.mint, italic = true },
    ["@markup.link"] = { fg = p.green },
    ["@markup.link.url"] = { fg = p.blue, underline = true },
    ["@markup.raw"] = { fg = p.pale_yellow },
    ["@markup.list"] = { fg = p.yellow },
    ["@markup.quote"] = { fg = p.mint, italic = true },

    -- Diff and git
    DiffAdd = { bg = p.diff_add },
    DiffChange = { bg = p.diff_change },
    DiffDelete = { bg = p.diff_delete },
    DiffText = { bg = p.diff_text },
    Added = { fg = p.bright_green },
    Changed = { fg = p.yellow },
    Removed = { fg = p.pink },

    -- Diagnostics. The lualine theme reads these for its mode badges, so they
    -- have to stay distinct from one another
    DiagnosticError = { fg = p.pink },
    DiagnosticWarn = { fg = p.yellow },
    DiagnosticInfo = { fg = p.blue },
    DiagnosticHint = { fg = p.mint },
    DiagnosticOk = { fg = p.bright_green },
    DiagnosticUnderlineError = { sp = p.pink, undercurl = true },
    DiagnosticUnderlineWarn = { sp = p.yellow, undercurl = true },
    DiagnosticUnderlineInfo = { sp = p.blue, undercurl = true },
    DiagnosticUnderlineHint = { sp = p.mint, undercurl = true },

    -- LSP
    LspReferenceText = { bg = p.bg_match },
    LspReferenceRead = { bg = p.bg_match },
    LspReferenceWrite = { bg = p.bg_match },
    LspInlayHint = { fg = p.fg_gutter, bg = p.bg_panel },

    -- nvim-tree
    NvimTreeRootFolder = { fg = p.yellow, bold = true },
    NvimTreeNormal = { fg = p.fg_dim, bg = p.bg_sidebar },
    NvimTreeNormalNC = { fg = p.fg_dim, bg = p.bg_sidebar },
    -- The tree already stands apart by its background, so it draws no edge
    NvimTreeWinSeparator = { fg = p.bg_sidebar, bg = p.bg_sidebar },
    NvimTreeCursorLine = { bg = p.bg_match },
    -- Folders read the same as files: the glyph and the git colour carry the
    -- difference, and a second blue next to the file icons had neither
    NvimTreeFolderName = { fg = p.fg_dim },
    NvimTreeOpenedFolderName = { fg = p.fg_dim },
    NvimTreeEmptyFolderName = { fg = p.fg_dim },
    NvimTreeFolderIcon = { fg = p.fg_dim },
    NvimTreeOpenedFile = { fg = p.fg },
    NvimTreeIndentMarker = { fg = p.fg_gutter },
    NvimTreeGitFileNewHL = { fg = p.bright_green },
    NvimTreeGitFileDirtyHL = { fg = p.yellow },
    NvimTreeGitFileStagedHL = { fg = p.bright_green },
    NvimTreeGitFileMergeHL = { fg = p.git_conflict },
    NvimTreeGitFileRenamedHL = { fg = p.yellow },
    NvimTreeGitFileDeletedHL = { fg = p.pink },
    NvimTreeGitFileIgnoredHL = { fg = p.grey },

    -- fzf-lua. Its own defaults are X11 names that belong to no colorscheme;
    -- the fzf process itself is coloured by `fzf_colors = true` in the spec
    FzfLuaBorder = { fg = p.fg_gutter, bg = p.bg },
    FzfLuaTitle = { fg = p.yellow, bg = p.bg, bold = true },
    FzfLuaPathColNr = { fg = p.blue },
    FzfLuaPathLineNr = { fg = p.blue },
    FzfLuaBufNr = { fg = p.fg_dim },
    FzfLuaBufFlagCur = { fg = p.yellow },
    FzfLuaBufFlagAlt = { fg = p.mint },
    FzfLuaHeaderText = { fg = p.orange },
    FzfLuaHeaderBind = { fg = p.yellow },
    FzfLuaLivePrompt = { fg = p.yellow },
    FzfLuaLiveSym = { fg = p.orange },
    FzfLuaTabTitle = { fg = p.mint },
    FzfLuaTabMarker = { fg = p.yellow },

    -- gitsigns
    GitSignsAdd = { fg = p.git_add },
    GitSignsChange = { fg = p.yellow },
    GitSignsDelete = { fg = p.red },
  }

  for group, spec in pairs(groups) do
    vim.api.nvim_set_hl(0, group, spec)
  end
end

load()
