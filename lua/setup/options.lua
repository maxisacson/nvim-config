local opt = vim.opt
local g = vim.g

-- Set indenting stuff
opt.tabstop = 4                    -- number of spaces in a <Tab>
opt.shiftwidth = 4                 -- number of spaces to use for autoindent. Should be == tabstop
opt.softtabstop = 4                -- number of spaces for <Tab> when editing
opt.expandtab = true               -- use spaces as <Tab>
opt.smarttab = true                -- insert shiftwidth worth of whitespace at beginning of line
opt.backspace = 'indent,eol,start' -- make <BS> well behaved
opt.autoindent = true              -- make sure autoindent is turned on
opt.smartindent = true
opt.cinoptions = 'l1,g0.75s,h0.25s,N-s'

-- Format options
opt.textwidth = 80
opt.formatoptions:remove { 't' }

-- status line
-- 0: never
-- 1: only if there are at least two windows
-- 2: always
-- 3: always and ONLY the last window
opt.laststatus = 3

-- block cursor
opt.guicursor = ""

-- Set incremental search
opt.incsearch = true

-- Show substitutions in split
opt.inccommand = 'split'

-- Disable hlsearch
opt.hlsearch = false

-- Always keep 2 line above and below cursor,
-- and 5 columns to the right and left
opt.scrolloff = 5
opt.sidescrolloff = 5

-- Line numbering
opt.number = true
opt.relativenumber = true

-- Show command
opt.showcmd = true

-- Set default spell language
opt.spelllang = 'en_gb'

-- Set window title
opt.title = true

-- Always use ft=tex as default for .tex-files
g.tex_flavor = 'latex'

-- Map <Space> to <Leader>
g.mapleader = ' '

-- always split the screen to the right or below
opt.splitright = true
opt.splitbelow = true

-- Always show sign column
opt.signcolumn = 'yes'

-- Highlight the current line
opt.cursorline = true

-- Highlight column
opt.colorcolumn = '+1'
vim.cmd([[highlight ColorColumn ctermbg=Black]])

-- Enable mouse
opt.mouse = 'a'

-- don't wrap lines
opt.wrap = false

-- show list chars
opt.list = true
opt.listchars = { tab = '└─', trail = '∙', nbsp = '␣', extends = '»', precedes = '«' }

-- swapfile, undo, and backup
opt.swapfile = false
opt.backup = false
opt.undofile = true

-- dark background and 24 bit colors
opt.termguicolors = true
opt.background = 'dark'

-- hide mode when using status line plugins
opt.showmode = false

-- allow buffers to be open in the background
opt.hidden = true

-- set default floating window border
opt.winborder = 'rounded'
