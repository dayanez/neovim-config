-- Minimal, fast, monochrome config. Black/white text, red-only syntax
-- highlighting, animated cursor trail, and huge files open without lag.

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
map("n", "<C-q>", "<C-v>") -- Ctrl+V above claims visual-block's usual key; use this instead

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
      cursor_color = "#ff3333",
      normal_bg = "#0a0a0a",
      stiffness = 0.6,
      trailing_stiffness = 0.3,
      trailing_exponent = 4,
      gamma = 1,
    },
  },
}, {
  ui = { border = "none" },
  checker = { enabled = false },
})

vim.cmd.colorscheme("redwrite")
