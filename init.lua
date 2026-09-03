-- Fast config with an old-school terminal look. Default colorscheme is
-- ambertype: a single-hue amber-phosphor theme chosen for eye strain over
-- looks (see colors/ambertype.lua for why); bluewrite/greenwrite/redwrite
-- are kept around for when punchy contrast is wanted instead. Also: LSP +
-- completion + formatting tuned for C#, a jumpy animated cursor trail, and
-- huge files still open without lag.

vim.loader.enable()

-- Point tree-sitter's parser builds at the mingw gcc on PATH instead of
-- MSVC's cl.exe, which isn't installed on this machine.
if vim.fn.has("win32") == 1 and vim.fn.executable("gcc") == 1 then
  vim.env.CC = vim.env.CC or "gcc"
end

-- [[ Options ]]
local o = vim.opt
o.termguicolors = true
o.number = true
o.relativenumber = false
o.signcolumn = "yes"
o.cursorline = true
o.wrap = false
o.scrolloff = 8
o.mouse = "a"
o.clipboard = "unnamedplus"
o.ignorecase = true
o.smartcase = true
o.splitright = true
o.splitbelow = true
o.undofile = true
o.updatetime = 250
o.timeoutlen = 400
o.synmaxcol = 300
o.redrawtime = 1500
o.lazyredraw = false -- must stay off, or the cursor trail can't animate
o.expandtab = true
o.shiftwidth = 2
o.tabstop = 2
o.spelllang = "en_us"
o.spellfile = vim.fn.stdpath("config") .. "/spell/en.utf-8.add"

vim.g.mapleader = " "

-- [[ Keymaps ]]
local map = vim.keymap.set
map("n", "<leader>w", "<cmd>w<CR>")
map("n", "<leader>q", "<cmd>q<CR>")
map("n", "<leader>s", "<cmd>set spell!<CR>")
map("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- GUI-style editing keys (Ctrl+A/Z/C/V). unnamedplus (set above) already
-- syncs y/p with the system clipboard, so copy/paste just alias yank/put.
map("n", "<C-a>", "ggVG")
map("v", "<BS>", "d")
map("n", "<C-z>", "u")
map("i", "<C-z>", "<C-o>u")
map("n", "<C-c>", "yy")
map("v", "<C-c>", "y")
map("n", "<C-v>", "p")
map("i", "<C-v>", "<C-r>+")
map("v", "<C-v>", '"_dP')
map("n", "<leader>v", "<C-v>") -- Ctrl+V above claims visual-block's usual key; Ctrl+Q below closes tabs, so use this instead

-- Telescope: fuzzy finding.
map("n", "<leader>ff", "<cmd>Telescope find_files<CR>")
map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>")
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>")
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>")

-- LSP: buffer-local keymaps set up once a server attaches (works for
-- omnisharp/C# and anything else added later).
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local o = { buffer = ev.buf }
    map("n", "gd", vim.lsp.buf.definition, o)
    map("n", "gr", vim.lsp.buf.references, o)
    map("n", "gi", vim.lsp.buf.implementation, o)
    map("n", "K", vim.lsp.buf.hover, o)
    map("n", "<leader>rn", vim.lsp.buf.rename, o)
    map("n", "<leader>ca", vim.lsp.buf.code_action, o)
    map("n", "[d", vim.diagnostic.goto_prev, o)
    map("n", "]d", vim.diagnostic.goto_next, o)
  end,
})

-- Tabs: each open file lives in its own tab (see the netrw section below,
-- which opens files via netrw_browse_split = 3, i.e. into a new tab).
for i = 1, 9 do
  map("n", "<C-" .. i .. ">", "<cmd>tabnext " .. i .. "<CR>")
end
map("n", "<C-q>", function()
  if vim.fn.tabpagenr("$") > 1 then
    vim.cmd("tabclose")
  end
end)

-- Ctrl+J: toggle a terminal split open/closed with the same key.
local term_win = nil
local function toggle_term()
  if term_win and vim.api.nvim_win_is_valid(term_win) then
    vim.api.nvim_win_close(term_win, true)
    term_win = nil
    return
  end
  vim.cmd("botright split | terminal")
  term_win = vim.api.nvim_get_current_win()
  vim.cmd("startinsert")
end
map("n", "<C-j>", toggle_term)
map("i", "<C-j>", function()
  vim.cmd("stopinsert")
  toggle_term()
end)
map("t", "<C-j>", toggle_term)

-- [[ Big files: strip anything expensive so huge files stay responsive ]]
local bigfile_bytes = 1024 * 1024 -- 1MB
vim.api.nvim_create_autocmd("BufReadPre", {
  group = vim.api.nvim_create_augroup("bigfile", { clear = true }),
  callback = function(args)
    local uv = vim.uv or vim.loop
    local ok, stats = pcall(uv.fs_stat, args.match)
    if not (ok and stats and stats.size > bigfile_bytes) then
      return
    end
    vim.b[args.buf].bigfile = true
    vim.schedule(function()
      vim.bo[args.buf].swapfile = false
      vim.bo[args.buf].undofile = false
      vim.opt_local.foldmethod = "manual"
      vim.opt_local.wrap = false
      vim.opt_local.spell = false
      vim.opt_local.cursorline = false
      vim.cmd("syntax clear")
      pcall(vim.treesitter.stop, args.buf)
    end)
  end,
})

-- [[ File explorer: netrw (built-in, no extra plugin) ]]
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
vim.g.netrw_browse_split = 3 -- opening a file from netrw puts it in a new tab

map("n", "<C-b>", "<cmd>Lexplore<CR>")

-- Directories open on a single <CR>, same as netrw's default. Files require
-- <CR> twice: the first press just arms that file, the second opens it (via
-- netrw's own <Plug>NetrwLocalBrowseCheck) so a stray keypress while browsing
-- can't accidentally load a buffer you didn't mean to edit.
local netrw_armed = nil
vim.api.nvim_create_autocmd("FileType", {
  pattern = "netrw",
  callback = function(ev)
    local open_keys = vim.api.nvim_replace_termcodes("<Plug>NetrwLocalBrowseCheck", true, false, true)
    vim.keymap.set("n", "<CR>", function()
      local word = vim.fn["netrw#Call"]("NetrwGetWord")
      local path = (vim.b.netrw_curdir or "") .. "/" .. word
      if vim.fn.isdirectory(path) == 1 or netrw_armed == path then
        netrw_armed = nil
        vim.api.nvim_feedkeys(open_keys, "m", false)
      else
        netrw_armed = path
        vim.notify("Press <CR> again to open " .. word, vim.log.levels.INFO)
      end
    end, { buffer = ev.buf, silent = true, desc = "netrw: enter dir, or arm/open file (press twice)" })

    vim.keymap.set("n", "<Esc>", function()
      netrw_armed = nil
      return "<Esc>"
    end, { buffer = ev.buf, expr = true, silent = true })
  end,
})

-- [[ Plugins: three, on purpose ]]
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup()
      require("nvim-treesitter").install({
        "c", "cpp", "lua", "python", "javascript", "typescript",
        "rust", "go", "bash", "markdown", "markdown_inline", "json",
        "c_sharp", "xml",
      })
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(ev)
          if vim.b[ev.buf].bigfile then
            return
          end
          pcall(vim.treesitter.start, ev.buf)
        end,
      })
    end,
  },
  {
    "sphamba/smear-cursor.nvim",
    opts = {
      -- "Jumpy" trail: snappy head (high stiffness) with a springy overshoot
      -- (low damping) instead of a smooth glide.
      stiffness = 0.8,
      trailing_stiffness = 0.25,
      trailing_exponent = 2,
      damping = 0.5,
      distance_stop_animating = 0.3,
      gamma = 1,
      cursor_color = "#ffb000",
      normal_bg = "#161210",
    },
    config = function(_, opts)
      require("smear_cursor").setup(opts)
      -- cursor_color/normal_bg must match the active colorscheme's actual
      -- background or the trail redraws against the wrong color.
      local per_colorscheme = {
        ambertype = { cursor_color = "#ffb000", normal_bg = "#161210" },
        bluewrite = { cursor_color = "#ff2222", normal_bg = "#0000aa" },
        greenwrite = { cursor_color = "#33ff77", normal_bg = "#0a0a0a" },
        redwrite = { cursor_color = "#ff3b3b", normal_bg = "#0a0a0a" },
      }
      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = function()
          local c = per_colorscheme[vim.g.colors_name]
          if c then
            require("smear_cursor").setup(c)
          end
        end,
      })
    end,
  },

  -- [[ C# / general LSP support ]]
  { "mason-org/mason.nvim", opts = {} },
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = { "neovim/nvim-lspconfig", "mason-org/mason.nvim" },
    opts = {
      ensure_installed = { "omnisharp" },
      automatic_enable = true,
    },
    config = function(_, opts)
      vim.lsp.config("*", { capabilities = require("blink.cmp").get_lsp_capabilities() })
      vim.lsp.config("omnisharp", {
        settings = {
          FormattingOptions = { EnableEditorConfigSupport = true, OrganizeImports = true },
          RoslynExtensionsOptions = { EnableImportCompletion = true, EnableAnalyzersSupport = true },
        },
      })
      require("mason-lspconfig").setup(opts)
    end,
  },
  {
    "saghen/blink.cmp",
    version = "1.*",
    opts = {
      keymap = { preset = "default" },
      sources = { default = { "lsp", "path", "snippets", "buffer" } },
    },
  },
  { "windwp/nvim-autopairs", opts = {} },
  { "lewis6991/gitsigns.nvim", opts = {} },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = { cs = { "csharpier" } },
      format_on_save = { timeout_ms = 2000, lsp_format = "fallback" },
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
}, {
  ui = { border = "none" },
  checker = { enabled = false },
})

vim.cmd.colorscheme("ambertype")
