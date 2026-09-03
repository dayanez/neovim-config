# nvim config

Fast, old-school terminal look, tuned for C#. Default colorscheme is
`ambertype`: a single-hue amber-phosphor theme chosen for eye strain over
looks -- one wavelength everywhere means no chromatic-aberration refocusing
between hues, and amber carries ~no blue light. `bluewrite`, `greenwrite`,
and `redwrite` are kept around for when punchy contrast is wanted instead
(switch with `:colorscheme <name>`).

## What's in it

- `init.lua` -- options, keymaps, big-file handling, plugin list
- `colors/ambertype.lua` -- the active colorscheme (single-hue amber on
  near-black; hierarchy comes from brightness/bold/italic/reverse-video only,
  never from switching hue -- see the file's header comment for why)
- `colors/bluewrite.lua`, `colors/greenwrite.lua`, `colors/redwrite.lua` --
  higher-contrast DOS-IDE-style alternatives

Managed by [lazy.nvim](https://github.com/folke/lazy.nvim):

- `nvim-treesitter` -- syntax highlighting (includes C#/`c_sharp` and `xml`
  for `.csproj` files)
- `mason.nvim` + `mason-lspconfig.nvim` + `nvim-lspconfig` -- installs and
  wires up `omnisharp` for C#
- `blink.cmp` -- completion, fed by the LSP
- `conform.nvim` -- format on save; C# via `csharpier` (a dotnet global
  tool -- `dotnet tool install -g csharpier` if it's ever missing)
- `nvim-autopairs` -- auto-close brackets/quotes
- `gitsigns.nvim` -- git change markers in the sign column
- `telescope.nvim` -- fuzzy file/text finder
- `sphamba/smear-cursor.nvim` -- animated cursor trail, tuned for a snappy,
  springy "jump" rather than a smooth glide; its colors follow whichever
  colorscheme is active
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
- `<leader>ff` / `<leader>fg` / `<leader>fb` / `<leader>fh` -- Telescope find
  files / live grep / open buffers / help tags

LSP (active once a server attaches, e.g. in a `.cs` file):

- `gd` -- go to definition, `gr` -- references, `gi` -- implementation
- `K` -- hover docs
- `<leader>rn` -- rename, `<leader>ca` -- code action
- `[d` / `]d` -- previous/next diagnostic

GUI-style editing keys (clipboard already syncs with the system clipboard via
`unnamedplus`, so these just alias yank/put):

- `<C-a>` -- select the whole buffer; `<BS>` on that selection deletes it all
- `<C-z>` -- undo (normal and insert mode)
- `<C-c>` -- copy (current line in normal mode, selection in visual mode)
- `<C-v>` -- paste (normal, insert, and visual mode)
- `<C-q>` -- visual-block select (moved here since `<C-v>` above is now paste)
- `<C-j>` -- toggle a terminal split open/closed (works from normal, insert,
  and terminal mode)
