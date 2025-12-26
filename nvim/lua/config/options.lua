-- General Neovim options
local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Tabs & indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true

-- Line wrapping
opt.wrap = false

-- Search settings
opt.ignorecase = true
opt.smartcase = true

-- Cursor line
opt.cursorline = true

-- Appearance
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"

-- Backspace
opt.backspace = "indent,eol,start"

-- Clipboard
opt.clipboard:append("unnamedplus")

-- Split windows
opt.splitright = true
opt.splitbelow = true

-- Consider string-string as whole word
opt.iskeyword:append("-")

-- Disable swapfile
opt.swapfile = false

-- Undo file
opt.undofile = true

-- Update time
opt.updatetime = 250

-- Timeout
opt.timeoutlen = 300

-- Mouse support
opt.mouse = "a"

-- Scrolloff
opt.scrolloff = 8
opt.sidescrolloff = 8

-- Disable tabline (editor window tabs)
opt.showtabline = 0