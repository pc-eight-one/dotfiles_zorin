-- Neovim Configuration
-- Main entry point that loads all configuration modules

-- Set leader key to space before loading plugins
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Basic Neovim settings
require("config.options")

-- Bootstrap lazy.nvim plugin manager
require("config.lazy")

-- Load custom keymaps
require("config.keymaps")

-- Load autocmds and other configurations
require("config.autocmds")