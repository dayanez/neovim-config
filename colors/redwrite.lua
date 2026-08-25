-- redwrite: black background, white text, red-only syntax highlighting.

vim.cmd("hi clear")
if vim.fn.exists("syntax_on") == 1 then
  vim.cmd("syntax reset")
end

vim.o.background = "dark"
vim.o.termguicolors = true
vim.g.colors_name = "redwrite"

local black = "#0a0a0a"
local white = "#e6e6e6"
local grey = "#555555"
local dark_grey = "#141414"
local red = "#ff3b3b"
local red_dim = "#992222"
local red_soft = "#ff8080"

local hl = vim.api.nvim_set_hl

-- UI chrome (not "text" -- stays black/white/grey)
hl(0, "Normal", { fg = white, bg = black })
hl(0, "NormalFloat", { fg = white, bg = black })
hl(0, "FloatBorder", { fg = grey, bg = black })
hl(0, "CursorLine", { bg = dark_grey })
hl(0, "CursorLineNr", { fg = red, bold = true })
hl(0, "LineNr", { fg = grey })
hl(0, "SignColumn", { bg = black })
hl(0, "VertSplit", { fg = grey })
hl(0, "WinSeparator", { fg = grey })
hl(0, "StatusLine", { fg = white, bg = black })
hl(0, "StatusLineNC", { fg = grey, bg = black })
hl(0, "Pmenu", { fg = white, bg = dark_grey })
hl(0, "PmenuSel", { fg = black, bg = red })
hl(0, "Visual", { bg = "#3a1414" })
hl(0, "Search", { fg = black, bg = red })
hl(0, "IncSearch", { fg = black, bg = red_soft })
hl(0, "MatchParen", { fg = red, bold = true, underline = true })
hl(0, "Whitespace", { fg = "#222222" })
hl(0, "NonText", { fg = "#222222" })
hl(0, "EndOfBuffer", { fg = black })

-- Syntax: every highlighted element is a shade of red. Plain identifiers
-- (variable names) stay white so code doesn't turn into a wall of red.
hl(0, "Comment", { fg = red_dim, italic = true })
hl(0, "Constant", { fg = red })
hl(0, "String", { fg = red_soft })
hl(0, "Character", { fg = red_soft })
hl(0, "Number", { fg = red })
hl(0, "Boolean", { fg = red })
hl(0, "Float", { fg = red })
hl(0, "Identifier", { fg = white })
hl(0, "Function", { fg = red, bold = true })
hl(0, "Statement", { fg = red, bold = true })
hl(0, "Conditional", { fg = red, bold = true })
hl(0, "Repeat", { fg = red, bold = true })
hl(0, "Label", { fg = red })
hl(0, "Operator", { fg = red_soft })
hl(0, "Keyword", { fg = red, bold = true })
hl(0, "Exception", { fg = red, bold = true })
hl(0, "PreProc", { fg = red_dim })
hl(0, "Include", { fg = red_dim })
hl(0, "Define", { fg = red_dim })
hl(0, "Macro", { fg = red_dim })
hl(0, "PreCondit", { fg = red_dim })
hl(0, "Type", { fg = red })
hl(0, "StorageClass", { fg = red })
hl(0, "Structure", { fg = red })
hl(0, "Typedef", { fg = red })
hl(0, "Special", { fg = red_soft })
hl(0, "SpecialChar", { fg = red_soft })
hl(0, "Tag", { fg = red })
hl(0, "Delimiter", { fg = grey })
hl(0, "SpecialComment", { fg = red_dim })
hl(0, "Debug", { fg = red })
hl(0, "Underlined", { fg = red, underline = true })
hl(0, "Ignore", { fg = grey })
hl(0, "Error", { fg = white, bg = red_dim, bold = true })
hl(0, "Todo", { fg = black, bg = red, bold = true })

-- Treesitter groups link back to the base groups above.
local links = {
  ["@variable"] = "Identifier",
  ["@variable.builtin"] = "Constant",
  ["@function"] = "Function",
  ["@function.builtin"] = "Function",
  ["@function.call"] = "Function",
  ["@method"] = "Function",
  ["@method.call"] = "Function",
  ["@constructor"] = "Type",
  ["@keyword"] = "Keyword",
  ["@keyword.function"] = "Keyword",
  ["@keyword.return"] = "Keyword",
  ["@conditional"] = "Conditional",
  ["@repeat"] = "Repeat",
  ["@string"] = "String",
  ["@string.escape"] = "SpecialChar",
  ["@number"] = "Number",
  ["@boolean"] = "Boolean",
  ["@comment"] = "Comment",
  ["@punctuation.delimiter"] = "Delimiter",
  ["@punctuation.bracket"] = "Delimiter",
  ["@type"] = "Type",
  ["@type.builtin"] = "Type",
  ["@property"] = "Identifier",
  ["@field"] = "Identifier",
  ["@parameter"] = "Identifier",
  ["@operator"] = "Operator",
  ["@tag"] = "Tag",
  ["@tag.attribute"] = "Identifier",
  ["@module"] = "PreProc",
  ["@constant"] = "Constant",
  ["@constant.builtin"] = "Constant",
}
for from, to in pairs(links) do
  hl(0, from, { link = to, default = true })
end
