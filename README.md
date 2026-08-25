# nvim config

Minimal, fast, monochrome. Black background, white text, and syntax
highlighting in shades of red only. No LSP, no completion, no file tree,
no bloat -- just an editor.

## What's in it

- `init.lua` -- options, keymaps, big-file handling, plugin list
- `colors/redwrite.lua` -- the colorscheme (black/white base, red syntax)

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
