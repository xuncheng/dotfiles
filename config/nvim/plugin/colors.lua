if not as then
  return
end
local P = as.ui.palette
local highlight = as.highlight

local function general_overrides()
  highlight.all({
    -----------------------------------------------------------------------------//
    -- Native
    -----------------------------------------------------------------------------//
    { VertSplit = { fg = { from = "Comment" } } },
    { WinSeparator = { fg = { from = "Comment" } } },
    { CursorLineNr = { bg = "NONE" } },
    { iCursor = { bg = P.dark_blue } },
    -----------------------------------------------------------------------------//
    -- Created highlights
    -----------------------------------------------------------------------------//
    { Dim = { fg = { from = "Normal", attr = "bg", alter = 0.25 } } },
    { PickerBorder = { fg = P.grey, bg = "bg" } },
    { UnderlinedTitle = { bold = true, underline = true } },
    { StatusColSep = { link = "LineNr" } },
    -----------------------------------------------------------------------------//
    -- Floats
    -----------------------------------------------------------------------------//
    { NormalFloat = { bg = { from = "Normal", alter = -0.15 } } },
    { FloatBorder = { bg = { from = "NormalFloat" }, fg = { from = "Comment" } } },
    { FloatTitle = { bold = true, fg = "white", bg = { from = "FloatBorder", attr = "fg" } } },
    -----------------------------------------------------------------------------//
    { CodeBlock = { bg = { from = "Normal", alter = 0.3 } } },
    { markdownCode = { link = "CodeBlock" } },
    { markdownCodeBlock = { link = "CodeBlock" } },
    -----------------------------------------------------------------------------//
    --  Spell
    -----------------------------------------------------------------------------//
    { SpellBad = { undercurl = true, bg = "NONE", fg = "NONE", sp = "green" } },
    { SpellRare = { undercurl = true } },
    -----------------------------------------------------------------------------//
    -- Diff
    -----------------------------------------------------------------------------//
    -- { DiffAdd = { bg = '#26332c', fg = 'NONE', underline = false } },
    -- { DiffDelete = { bg = '#572E33', fg = '#5c6370', underline = false } },
    -- { DiffChange = { bg = '#273842', fg = 'NONE', underline = false } },
    -- { DiffText = { bg = '#314753', fg = 'NONE' } },
    -- these highlights are syntax groups that are set in diff.vim
    { diffAdded = { link = "DiffAdd" } },
    { diffChanged = { link = "DiffChange" } },
    { diffRemoved = { link = "DiffDelete" } },
    { diffBDiffer = { link = "WarningMsg" } },
    { diffCommon = { link = "WarningMsg" } },
    { diffDiffer = { link = "WarningMsg" } },
    { diffFile = { link = "Directory" } },
    { diffIdentical = { link = "WarningMsg" } },
    { diffIndexLine = { link = "Number" } },
    { diffIsA = { link = "WarningMsg" } },
    { diffNoEOL = { link = "WarningMsg" } },
    { diffOnly = { link = "WarningMsg" } },
    -----------------------------------------------------------------------------//
    -- colorscheme overrides
    -----------------------------------------------------------------------------//
    { Type = { italic = true, bold = true } },
    { Include = { italic = true, bold = false } },
    { QuickFixLine = { inherit = "PmenuSbar", fg = "NONE", italic = true } },
    -- Neither the sign column or end of buffer highlights require an explicit bg
    -- they should both just use the bg that is in the window they are in.
    -- if either are specified this can lead to issues when a winhighlight is set
    { SignColumn = { bg = "NONE" } },
    { EndOfBuffer = { bg = "NONE" } },
    ------------------------------------------------------------------------------//
    --  Semantic tokens
    ------------------------------------------------------------------------------//
    { ["@lsp.type.variable"] = { clear = true } },
    { ["@lsp.type.parameter"] = { italic = true, fg = { from = "Normal" } } },
    { ["@lsp.typemod.method"] = { link = "@method" } },
    { ["@lsp.typemod.variable.global"] = { bold = true, inherit = "@constant.builtin" } },
    { ["@lsp.typemod.variable.defaultLibrary"] = { italic = true } },
    { ["@lsp.typemod.variable.readonly.typescript"] = { clear = true } },
    { ["@lsp.type.type.lua"] = { clear = true } },
    { ["@lsp.typemod.number.injected"] = { link = "@number" } },
    { ["@lsp.typemod.operator.injected"] = { link = "@operator" } },
    { ["@lsp.typemod.keyword.injected"] = { link = "@keyword" } },
    { ["@lsp.typemod.string.injected"] = { link = "@string" } },
    { ["@lsp.typemod.variable.injected"] = { link = "@variable" } },
    -----------------------------------------------------------------------------//
    -- Treesitter
    -----------------------------------------------------------------------------//
    { ["@keyword.return"] = { italic = true, fg = { from = "Keyword" } } },
    { ["@type.qualifier"] = { inherit = "@keyword", italic = true } },
    { ["@variable"] = { clear = true } },
    { ["@parameter"] = { italic = true, bold = true, fg = "NONE" } },
    { ["@error"] = { fg = "fg", bg = "NONE" } },
    { ["@text.diff.add"] = { link = "DiffAdd" } },
    { ["@text.diff.delete"] = { link = "DiffDelete" } },
    { ["@text.title.markdown"] = { underdouble = true } },
    -----------------------------------------------------------------------------//
    -- LSP
    -----------------------------------------------------------------------------//
    { LspCodeLens = { inherit = "Comment", bold = true, italic = false } },
    { LspCodeLensSeparator = { bold = false, italic = false } },
    { LspReferenceText = { bg = "NONE", underline = true, sp = { from = "Comment", attr = "fg" } } },
    { LspReferenceRead = { link = "LspReferenceText" } },
    { LspReferenceWrite = { inherit = "LspReferenceText", bold = true, italic = true, underline = true } },
    { LspSignatureActiveParameter = { link = "Visual" } },
    -- Sign column line
    { DiagnosticSignInfoLine = { inherit = "DiagnosticVirtualTextInfo", fg = "NONE" } },
    { DiagnosticSignHintLine = { inherit = "DiagnosticVirtualTextHint", fg = "NONE" } },
    { DiagnosticSignErrorLine = { inherit = "DiagnosticVirtualTextError", fg = "NONE" } },
    { DiagnosticSignWarnLine = { inherit = "DiagnosticVirtualTextWarn", fg = "NONE" } },
    -- Floating windows
    { DiagnosticFloatingWarn = { link = "DiagnosticWarn" } },
    { DiagnosticFloatingInfo = { link = "DiagnosticInfo" } },
    { DiagnosticFloatingHint = { link = "DiagnosticHint" } },
    { DiagnosticFloatingError = { link = "DiagnosticError" } },
    { DiagnosticFloatTitle = { inherit = "FloatTitle", bold = true } },
    { DiagnosticFloatTitleIcon = { inherit = "FloatTitle", fg = { from = "@character" } } },
  })
end

local function set_sidebar_highlight()
  highlight.all({
    { PanelDarkBackground = { bg = { from = "Normal", alter = -0.42 } } },
    { PanelDarkHeading = { inherit = "PanelDarkBackground", bold = true } },
    { PanelBackground = { bg = { from = "Normal", alter = -0.8 } } },
    { PanelHeading = { inherit = "PanelBackground", bold = true } },
    { PanelWinSeparator = { inherit = "PanelBackground", fg = { from = "WinSeparator" } } },
    { PanelStNC = { link = "PanelWinSeparator" } },
    { PanelSt = { bg = { from = "Visual", alter = -0.2 } } },
  })
end

local sidebar_fts = {
  "packer",
  "flutterToolsOutline",
  "undotree",
  "Outline",
  "dbui",
  "neotest-summary",
  "pr",
}

local function on_sidebar_enter()
  vim.opt_local.winhighlight:append({
    Normal = "PanelBackground",
    EndOfBuffer = "PanelBackground",
    StatusLine = "PanelSt",
    StatusLineNC = "PanelStNC",
    SignColumn = "PanelBackground",
    VertSplit = "PanelVertSplit",
    WinSeparator = "PanelWinSeparator",
  })
end

local function colorscheme_overrides()
  local overrides = {
    ["doom-one"] = {
      { ["@namespace"] = { fg = P.blue } },
      { CursorLineNr = { fg = { from = "Keyword" } } },
      { LineNr = { bg = "NONE" } },
      { NeoTreeIndentMarker = { link = "Comment" } },
      { NeoTreeRootName = { bold = true, italic = true, fg = "LightMagenta" } },
    },
    ["horizon"] = {
      { Constant = { bold = true } },
      { NonText = { fg = { from = "Comment" } } },
      { TabLineSel = { fg = { from = "SpecialKey" } } },
      { ["@variable"] = { fg = { from = "Normal" } } },
      { ["@constant.comment"] = { inherit = "Constant", bold = true } },
      { ["@constructor.lua"] = { inherit = "Type", italic = false, bold = false } },
      { ["@lsp.type.parameter"] = { fg = { from = "Normal" } } },
      { VisibleTab = { bg = { from = "Normal", alter = 0.4 }, bold = true } },
      { PanelBackground = { link = "Normal" } },
      { PanelWinSeparator = { inherit = "PanelBackground", fg = { from = "WinSeparator" } } },
      { PanelHeading = { bg = "bg", bold = true, fg = { from = "Normal", alter = -0.3 } } },
      { PanelDarkBackground = { bg = { from = "Normal", alter = -0.25 } } },
      { PanelDarkHeading = { inherit = "PanelDarkBackground", bold = true } },
    },
  }
  local hls = overrides[vim.g.colors_name]
  if not hls then
    return
  end
  highlight.all(hls)
end

local function user_highlights()
  general_overrides()
  set_sidebar_highlight()
  colorscheme_overrides()
end

as.augroup("UserHighlights", {
  event = "ColorScheme",
  command = function()
    user_highlights()
  end,
}, {
  event = "FileType",
  pattern = sidebar_fts,
  command = function()
    on_sidebar_enter()
  end,
})
