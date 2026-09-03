# nvim config

Minimal, fast. Old-school terminal look: navy blue background, white text,
and DOS/Turbo-Pascal-style syntax highlighting in warm colors chosen to
contrast the blue (yellow keywords, orange comments, green strings, red
numbers, bright white types). No LSP, no completion, no bloat -- just an
editor.

## What's in it

- `init.lua` -- options, keymaps, big-file handling, plugin list
- `colors/bluewrite.lua` -- the active colorscheme (navy blue/white base,
  DOS-IDE-style syntax colors)
- `colors/greenwrite.lua`, `colors/redwrite.lua` -- other colorschemes kept
  around; switch with `:colorscheme <name>`

Three plugins total, managed by [lazy.nvim](https://github.com/folke/lazy.nvim):

- `nvim-treesitter` -- syntax highlighting
- `sphamba/smear-cursor.nvim` -- animated cursor trail
- `lazy.nvim` itself

## Big files

Any file over 1MB skips swapfile/undofile, folding, spellcheck, and
treesitter/syntax highlighting on open, so huge files stay responsive.

## Keymaps

Leader is `<Space>`.

- `<leader>w` -- save
- `<leader>q` -- quit
- `<leader>s` -- toggle spellcheck
- `<Esc>` -- clear search highlight

GUI-style editing keys (clipboard already syncs with the system clipboard via
`unnamedplus`, so these just alias yank/put):

- `<C-a>` -- select the whole buffer; `<BS>` on that selection deletes it all
- `<C-z>` -- undo (normal and insert mode)
- `<C-c>` -- copy (current line in normal mode, selection in visual mode)
- `<C-v>` -- paste (normal, insert, and visual mode)
- `<C-q>` -- visual-block select (moved here since `<C-v>` above is now paste)
- `<C-j>` -- toggle a terminal split open/closed (works from normal, insert,
  and terminal mode)
