-- ambertype: single-hue amber phosphor terminal, optimized for eye strain
-- rather than for looking punchy. Everything on screen is one wavelength
-- (amber, ~590nm) -- hierarchy comes only from brightness/bold/italic/
-- reverse-video, never from switching hue. This matters for two reasons:
--
-- 1. Chromatic aberration: the eye's lens focuses different wavelengths at
--    different depths, so alternating between distant hues (e.g. blue bg +
--    red fg, see bluewrite.lua) forces constant refocusing. One hue removes
--    that cost entirely.
-- 2. Blue light: amber is long-wavelength with ~no blue content, which is
--    both easier on the eyes and doesn't suppress melatonin the way
--    blue-heavy schemes do, especially at night.
--
-- This is also just how real amber phosphor terminals worked: a single-color
-- CRT tube physically couldn't render more than one hue, so intensity,
-- underline, italic, and reverse video were the only tools available for
-- emphasis. Same constraint, adopted deliberately here.

vim.cmd("hi clear")
if vim.fn.exists("syntax_on") == 1 then
  vim.cmd("syntax reset")
end

vim.o.background = "dark"
vim.o.termguicolors = true
vim.g.colors_name = "ambertype"

local bg = "#161210" -- near-black, warm-tinted (not blue-black) so it doesn't fight the amber
local bg_dark = "#221b10" -- cursorline
local bg_visual = "#3a2c14" -- visual selection
local dim = "#8a5e26" -- comments, delimiters, line numbers -- de-emphasized tier
local base = "#d9932e" -- identifiers, plain text -- the "normal" tier
local bright = "#ffb000" -- classic phosphor amber -- keywords, statements, functions
local brightest = "#ffd166" -- types, constants, literals -- top emphasis tier

local hl = vim.api.nvim_set_hl

-- UI chrome
hl(0, "Normal", { fg = base, bg = bg })
hl(0, "NormalFloat", { fg = base, bg = bg })
hl(0, "FloatBorder", { fg = dim, bg = bg })
hl(0, "CursorLine", { bg = bg_dark })
hl(0, "CursorLineNr", { fg = bright, bold = true })
hl(0, "LineNr", { fg = dim })
hl(0, "SignColumn", { bg = bg })
hl(0, "VertSplit", { fg = dim })
hl(0, "WinSeparator", { fg = dim })
hl(0, "StatusLine", { fg = bg, bg = bright }) -- reverse video, like a real terminal status bar
hl(0, "StatusLineNC", { fg = dim, bg = bg_dark })
hl(0, "Pmenu", { fg = base, bg = bg_dark })
hl(0, "PmenuSel", { fg = bg, bg = bright })
hl(0, "Visual", { bg = bg_visual })
hl(0, "Search", { fg = bg, bg = bright, bold = true })
hl(0, "IncSearch", { fg = bg, bg = brightest, bold = true })
hl(0, "MatchParen", { fg = brightest, bold = true, underline = true })
hl(0, "Whitespace", { fg = bg_dark })
hl(0, "NonText", { fg = bg_dark })
hl(0, "EndOfBuffer", { fg = bg })

-- Syntax: one hue throughout. Weight/style carries the hierarchy that color
-- would normally carry, exactly as real amber terminals had to do it.
hl(0, "Comment", { fg = dim, italic = true })
hl(0, "Constant", { fg = brightest, bold = true })
hl(0, "String", { fg = base, italic = true })
hl(0, "Character", { fg = base, italic = true })
hl(0, "Number", { fg = brightest, bold = true })
hl(0, "Boolean", { fg = brightest, bold = true })
hl(0, "Float", { fg = brightest, bold = true })
hl(0, "Identifier", { fg = base })
hl(0, "Function", { fg = bright, bold = true })
hl(0, "Statement", { fg = bright, bold = true })
hl(0, "Conditional", { fg = bright, bold = true })
hl(0, "Repeat", { fg = bright, bold = true })
hl(0, "Label", { fg = bright })
hl(0, "Operator", { fg = dim })
hl(0, "Keyword", { fg = bright, bold = true })
hl(0, "Exception", { fg = bright, bold = true })
hl(0, "PreProc", { fg = dim })
hl(0, "Include", { fg = dim })
hl(0, "Define", { fg = dim })
hl(0, "Macro", { fg = dim })
hl(0, "PreCondit", { fg = dim })
hl(0, "Type", { fg = brightest, bold = true })
hl(0, "StorageClass", { fg = brightest, bold = true })
hl(0, "Structure", { fg = brightest, bold = true })
hl(0, "Typedef", { fg = brightest, bold = true })
hl(0, "Special", { fg = base })
hl(0, "SpecialChar", { fg = base })
hl(0, "Tag", { fg = brightest, bold = true })
hl(0, "Delimiter", { fg = dim })
hl(0, "SpecialComment", { fg = dim, italic = true })
hl(0, "Debug", { fg = bright })
hl(0, "Underlined", { fg = bright, underline = true })
hl(0, "Ignore", { fg = dim })
hl(0, "Error", { fg = bg, bg = bright, bold = true }) -- reverse video, no red needed
hl(0, "Todo", { fg = bg, bg = brightest, bold = true })

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
