-- greenwrite: black background, white text, green syntax highlighting
-- (several distinct green hues, not one flat green), blue comments.

vim.cmd("hi clear")
if vim.fn.exists("syntax_on") == 1 then
  vim.cmd("syntax reset")
end

vim.o.background = "dark"
vim.o.termguicolors = true
vim.g.colors_name = "greenwrite"

local black = "#0a0a0a"
local white = "#e6e6e6"
local grey = "#555555"
local dark_grey = "#141414"
local blue = "#4da6ff" -- comments only
local green = "#33ff77" -- keywords, statements, functions
local green_dim = "#2f9e55" -- preproc / macros, less prominent
local green_soft = "#90ffb3" -- strings, operators, special chars
local green_lime = "#aaff33" -- numbers, booleans, constants
local green_teal = "#33ffcc" -- types, structures, tags

local hl = vim.api.nvim_set_hl

-- UI chrome (not "text" -- stays black/white/grey, green as the one accent)
hl(0, "Normal", { fg = white, bg = black })
hl(0, "NormalFloat", { fg = white, bg = black })
hl(0, "FloatBorder", { fg = grey, bg = black })
hl(0, "CursorLine", { bg = dark_grey })
hl(0, "CursorLineNr", { fg = green, bold = true })
hl(0, "LineNr", { fg = grey })
hl(0, "SignColumn", { bg = black })
hl(0, "VertSplit", { fg = grey })
hl(0, "WinSeparator", { fg = grey })
hl(0, "StatusLine", { fg = white, bg = black })
hl(0, "StatusLineNC", { fg = grey, bg = black })
hl(0, "Pmenu", { fg = white, bg = dark_grey })
hl(0, "PmenuSel", { fg = black, bg = green })
hl(0, "Visual", { bg = "#123320" })
hl(0, "Search", { fg = black, bg = green })
hl(0, "IncSearch", { fg = black, bg = green_soft })
hl(0, "MatchParen", { fg = green, bold = true, underline = true })
hl(0, "Whitespace", { fg = "#222222" })
hl(0, "NonText", { fg = "#222222" })
hl(0, "EndOfBuffer", { fg = black })

-- Syntax: shades/hues of green per category, plain identifiers stay white
-- so code doesn't turn into a wall of color, comments are blue.
hl(0, "Comment", { fg = blue, italic = true })
hl(0, "Constant", { fg = green_lime })
hl(0, "String", { fg = green_soft })
hl(0, "Character", { fg = green_soft })
hl(0, "Number", { fg = green_lime })
hl(0, "Boolean", { fg = green_lime })
hl(0, "Float", { fg = green_lime })
hl(0, "Identifier", { fg = white })
hl(0, "Function", { fg = green, bold = true })
hl(0, "Statement", { fg = green, bold = true })
hl(0, "Conditional", { fg = green, bold = true })
hl(0, "Repeat", { fg = green, bold = true })
hl(0, "Label", { fg = green })
hl(0, "Operator", { fg = green_soft })
hl(0, "Keyword", { fg = green, bold = true })
hl(0, "Exception", { fg = green, bold = true })
hl(0, "PreProc", { fg = green_dim })
hl(0, "Include", { fg = green_dim })
hl(0, "Define", { fg = green_dim })
hl(0, "Macro", { fg = green_dim })
hl(0, "PreCondit", { fg = green_dim })
hl(0, "Type", { fg = green_teal })
hl(0, "StorageClass", { fg = green_teal })
hl(0, "Structure", { fg = green_teal })
hl(0, "Typedef", { fg = green_teal })
hl(0, "Special", { fg = green_soft })
hl(0, "SpecialChar", { fg = green_soft })
hl(0, "Tag", { fg = green_teal })
hl(0, "Delimiter", { fg = grey })
hl(0, "SpecialComment", { fg = blue })
hl(0, "Debug", { fg = green })
hl(0, "Underlined", { fg = green, underline = true })
hl(0, "Ignore", { fg = grey })
hl(0, "Error", { fg = white, bg = green_dim, bold = true })
hl(0, "Todo", { fg = black, bg = green_lime, bold = true })

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
