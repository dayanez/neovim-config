-- bluewrite: classic old-school terminal look -- navy blue background,
-- white text, DOS/Turbo-Pascal-IDE-style syntax highlighting (yellow
-- keywords, cyan comments, green strings, magenta numbers).

vim.cmd("hi clear")
if vim.fn.exists("syntax_on") == 1 then
  vim.cmd("syntax reset")
end

vim.o.background = "dark"
vim.o.termguicolors = true
vim.g.colors_name = "bluewrite"

local blue = "#0000aa" -- classic terminal blue background
local blue_dark = "#000066" -- cursorline / dim panels
local blue_light = "#3a3aff" -- borders, split lines
local white = "#f0f0f0"
local grey = "#9a9acc" -- line numbers, delimiters (readable on blue)
local cyan = "#55ffff" -- comments
local yellow = "#ffff55" -- keywords, statements, functions
local yellow_dim = "#aaaa00" -- preproc / macros, less prominent
local green = "#55ff55" -- strings, operators, special chars
local magenta = "#ff55ff" -- numbers, booleans, constants
local cyan_light = "#aaffff" -- types, structures, tags

local hl = vim.api.nvim_set_hl

-- UI chrome
hl(0, "Normal", { fg = white, bg = blue })
hl(0, "NormalFloat", { fg = white, bg = blue })
hl(0, "FloatBorder", { fg = blue_light, bg = blue })
hl(0, "CursorLine", { bg = blue_dark })
hl(0, "CursorLineNr", { fg = yellow, bold = true })
hl(0, "LineNr", { fg = grey })
hl(0, "SignColumn", { bg = blue })
hl(0, "VertSplit", { fg = blue_light })
hl(0, "WinSeparator", { fg = blue_light })
hl(0, "StatusLine", { fg = white, bg = blue_dark })
hl(0, "StatusLineNC", { fg = grey, bg = blue_dark })
hl(0, "Pmenu", { fg = white, bg = blue_dark })
hl(0, "PmenuSel", { fg = blue, bg = yellow })
hl(0, "Visual", { bg = "#2222cc" })
hl(0, "Search", { fg = blue, bg = yellow })
hl(0, "IncSearch", { fg = blue, bg = green })
hl(0, "MatchParen", { fg = yellow, bold = true, underline = true })
hl(0, "Whitespace", { fg = blue_light })
hl(0, "NonText", { fg = blue_light })
hl(0, "EndOfBuffer", { fg = blue })

-- Syntax: classic DOS-IDE palette on a blue field, plain identifiers stay
-- white so code doesn't turn into a wall of color.
hl(0, "Comment", { fg = cyan, italic = true })
hl(0, "Constant", { fg = magenta })
hl(0, "String", { fg = green })
hl(0, "Character", { fg = green })
hl(0, "Number", { fg = magenta })
hl(0, "Boolean", { fg = magenta })
hl(0, "Float", { fg = magenta })
hl(0, "Identifier", { fg = white })
hl(0, "Function", { fg = yellow, bold = true })
hl(0, "Statement", { fg = yellow, bold = true })
hl(0, "Conditional", { fg = yellow, bold = true })
hl(0, "Repeat", { fg = yellow, bold = true })
hl(0, "Label", { fg = yellow })
hl(0, "Operator", { fg = green })
hl(0, "Keyword", { fg = yellow, bold = true })
hl(0, "Exception", { fg = yellow, bold = true })
hl(0, "PreProc", { fg = yellow_dim })
hl(0, "Include", { fg = yellow_dim })
hl(0, "Define", { fg = yellow_dim })
hl(0, "Macro", { fg = yellow_dim })
hl(0, "PreCondit", { fg = yellow_dim })
hl(0, "Type", { fg = cyan_light })
hl(0, "StorageClass", { fg = cyan_light })
hl(0, "Structure", { fg = cyan_light })
hl(0, "Typedef", { fg = cyan_light })
hl(0, "Special", { fg = green })
hl(0, "SpecialChar", { fg = green })
hl(0, "Tag", { fg = cyan_light })
hl(0, "Delimiter", { fg = grey })
hl(0, "SpecialComment", { fg = cyan })
hl(0, "Debug", { fg = yellow })
hl(0, "Underlined", { fg = yellow, underline = true })
hl(0, "Ignore", { fg = grey })
hl(0, "Error", { fg = white, bg = magenta, bold = true })
hl(0, "Todo", { fg = blue, bg = yellow, bold = true })

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
