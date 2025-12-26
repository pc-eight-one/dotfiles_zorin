-- Comprehensive IntelliJ IDEA to Neovim keymaps
local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- ============================================================================
-- GENERAL EDITING
-- ============================================================================

-- Basic editing operations
keymap.set({ "n", "v" }, "<C-c>", '"+y', { desc = "Copy" })
keymap.set({ "n", "v" }, "<C-x>", '"+d', { desc = "Cut" })
keymap.set({ "n", "v" }, "<C-v>", '"+p', { desc = "Paste" })
keymap.set("i", "<C-v>", '<C-r>+', { desc = "Paste in insert mode" })
keymap.set("n", "<C-z>", "u", { desc = "Undo" })
keymap.set("n", "<C-S-z>", "<C-r>", { desc = "Redo" })
keymap.set("n", "<C-y>", "dd", { desc = "Delete line" })
keymap.set("n", "<leader>dd", "yyp", { desc = "Duplicate line" })
keymap.set("v", "<C-d>", "y'>p", { desc = "Duplicate selection" })
keymap.set("n", "<C-a>", "ggVG", { desc = "Select all" })

-- Advanced editing
keymap.set("n", "<C-S-j>", "J", { desc = "Join lines" })
keymap.set({ "i", "n" }, "<C-S-Enter>", "<Esc>A;<Esc>o", { desc = "Complete statement" })
keymap.set("n", "<C-/>", "gcc", { desc = "Comment line", remap = true })
keymap.set("v", "<C-/>", "gc", { desc = "Comment selection", remap = true })
keymap.set("n", "<C-S-/>", "gbc", { desc = "Block comment", remap = true })
keymap.set("v", "<C-S-/>", "gb", { desc = "Block comment selection", remap = true })

-- Line operations
keymap.set("n", "Home", "^", { desc = "Line start" })
keymap.set("n", "End", "$", { desc = "Line end" })
keymap.set("n", "<S-Home>", "v^", { desc = "Select to line start" })
keymap.set("n", "<S-End>", "v$", { desc = "Select to line end" })
keymap.set("i", "Home", "<C-o>^", { desc = "Line start in insert" })
keymap.set("i", "End", "<C-o>$", { desc = "Line end in insert" })

-- Indentation
keymap.set("v", "Tab", ">gv", { desc = "Indent" })
keymap.set("v", "<S-Tab>", "<gv", { desc = "Unindent" })
keymap.set("n", "<C-A-i>", "gg=G", { desc = "Auto-indent lines" })
keymap.set("v", "<C-A-i>", "=", { desc = "Auto-indent selection" })

-- ============================================================================
-- CODE NAVIGATION
-- ============================================================================

-- Caret navigation
keymap.set("n", "<C-Left>", "b", { desc = "Previous word" })
keymap.set("n", "<C-Right>", "w", { desc = "Next word" })
keymap.set("n", "<C-[>", "[{", { desc = "Code block start" })
keymap.set("n", "<C-]>", "]}", { desc = "Code block end" })

-- Page navigation
keymap.set("n", "<C-Home>", "gg", { desc = "File start" })
keymap.set("n", "<C-End>", "G", { desc = "File end" })
keymap.set("n", "<PageUp>", "<C-u>", { desc = "Page up" })
keymap.set("n", "<PageDown>", "<C-d>", { desc = "Page down" })

-- LSP Navigation (mapped in lsp.lua but reinforced here)
keymap.set("n", "<C-b>", "gd", { desc = "Go to declaration/definition", remap = true })
keymap.set("n", "<C-A-b>", "gi", { desc = "Go to implementation", remap = true })
keymap.set("n", "<leader>su", "gD", { desc = "Go to super method" })
keymap.set("n", "<F2>", "]d", { desc = "Next error", remap = true })
keymap.set("n", "<S-F2>", "[d", { desc = "Previous error", remap = true })

-- ============================================================================
-- SEARCH AND REPLACE
-- ============================================================================

keymap.set("n", "<C-f>", "/", { desc = "Find" })
keymap.set("n", "<C-r>", ":%s//gc<Left><Left><Left>", { desc = "Replace" })
keymap.set("n", "<C-S-f>", "<cmd>Telescope live_grep<cr>", { desc = "Find in path" })
keymap.set("n", "<C-S-r>", "<cmd>Telescope live_grep<cr>", { desc = "Replace in path" })
keymap.set("n", "<F3>", "n", { desc = "Find next" })
keymap.set("n", "<S-F3>", "N", { desc = "Find previous" })
keymap.set("n", "<C-F3>", "*", { desc = "Find word at caret" })
keymap.set("n", "<C-S-F3>", "#", { desc = "Find previous word at caret" })
keymap.set("n", "<A-F3>", "<cmd>Telescope grep_string<cr>", { desc = "Find selection" })

-- ============================================================================
-- USAGE SEARCH
-- ============================================================================

keymap.set("n", "<A-F7>", "<cmd>Telescope lsp_references<cr>", { desc = "Find usages", remap = true })
keymap.set("n", "<C-F7>", "<cmd>Telescope lsp_references<cr>", { desc = "Find usages in file", remap = true })
keymap.set("n", "<C-S-F7>", "<cmd>Telescope lsp_references<cr>", { desc = "Highlight usages", remap = true })
keymap.set("n", "<C-A-F7>", "<cmd>Telescope lsp_references<cr>", { desc = "Show usages", remap = true })

-- ============================================================================
-- COMPILE AND RUN
-- ============================================================================

keymap.set("n", "<C-F9>", "<cmd>lua vim.lsp.buf.format()<cr>", { desc = "Compile" })
keymap.set("n", "<S-F10>", "<cmd>!<cr>", { desc = "Run" })
keymap.set("n", "<C-S-F10>", "<cmd>!<cr>", { desc = "Run context configuration" })
keymap.set("n", "<A-S-F10>", "<cmd>!<cr>", { desc = "Choose run configuration" })
keymap.set("n", "<C-F2>", "<C-c>", { desc = "Stop" })

-- ============================================================================
-- DEBUGGING (Requires nvim-dap plugin)
-- ============================================================================

keymap.set("n", "<S-F9>", "<cmd>lua require('dap').continue()<cr>", { desc = "Debug" })
keymap.set("n", "<A-S-F9>", "<cmd>lua require('dap').run_to_cursor()<cr>", { desc = "Choose debug configuration" })
keymap.set("n", "<F8>", "<cmd>lua require('dap').step_over()<cr>", { desc = "Step over" })
keymap.set("n", "<F7>", "<cmd>lua require('dap').step_into()<cr>", { desc = "Step into" })
keymap.set("n", "<S-F8>", "<cmd>lua require('dap').step_out()<cr>", { desc = "Step out" })
keymap.set("n", "<A-F9>", "<cmd>lua require('dap').run_to_cursor()<cr>", { desc = "Run to cursor" })
keymap.set("n", "<F9>", "<cmd>lua require('dap').continue()<cr>", { desc = "Resume program" })
keymap.set("n", "<C-F8>", "<cmd>lua require('dap').toggle_breakpoint()<cr>", { desc = "Toggle breakpoint" })
keymap.set("n", "<C-S-F8>", "<cmd>lua require('dap.ui.widgets').hover()<cr>", { desc = "View breakpoints" })

-- ============================================================================
-- REFACTORING
-- ============================================================================

keymap.set("n", "<S-F6>", "<cmd>lua vim.lsp.buf.rename()<cr>", { desc = "Rename" })
keymap.set("n", "<F6>", "<cmd>lua vim.lsp.buf.code_action()<cr>", { desc = "Move" })
keymap.set("n", "<F5>", "yyp", { desc = "Copy" })
keymap.set("n", "<C-F6>", "<cmd>lua vim.lsp.buf.code_action()<cr>", { desc = "Change signature" })
keymap.set("v", "<C-A-m>", "<cmd>lua vim.lsp.buf.code_action()<cr>", { desc = "Extract method" })
keymap.set("v", "<C-A-v>", "<cmd>lua vim.lsp.buf.code_action()<cr>", { desc = "Extract variable" })
keymap.set("v", "<C-A-c>", "<cmd>lua vim.lsp.buf.code_action()<cr>", { desc = "Extract constant" })
keymap.set("v", "<C-A-p>", "<cmd>lua vim.lsp.buf.code_action()<cr>", { desc = "Extract parameter" })
keymap.set("n", "<A-Delete>", "<cmd>lua vim.lsp.buf.code_action()<cr>", { desc = "Safe delete" })

-- ============================================================================
-- VCS/LOCAL HISTORY
-- ============================================================================

keymap.set("n", "<leader>gc", "<cmd>Git commit<cr>", { desc = "Git commit" })
keymap.set("n", "<leader>gu", "<cmd>Git pull<cr>", { desc = "Git pull/update" })
keymap.set("n", "<C-A-z>", "<cmd>Git checkout -- %<cr>", { desc = "Rollback changes" })
keymap.set("n", "<leader>gp", "<cmd>Git push<cr>", { desc = "Git push" })
keymap.set("n", "<A-`>", "<cmd>Git<cr>", { desc = "VCS operations popup" })

-- ============================================================================
-- LIVE TEMPLATES
-- ============================================================================

keymap.set("i", "<C-l>", "<cmd>lua require('luasnip').expand_or_jump()<cr>", { desc = "Insert live template" })
keymap.set("v", "<C-A-j>", "<cmd>lua require('luasnip').expand_or_jump()<cr>", { desc = "Surround with live template" })

-- ============================================================================
-- GENERAL
-- ============================================================================

-- File operations
keymap.set("n", "<C-s>", "<cmd>w<cr>", { desc = "Save" })
keymap.set("n", "<C-S-s>", "<cmd>wa<cr>", { desc = "Save all" })
keymap.set("n", "<C-w>", "<cmd>bd<cr>", { desc = "Close" })
keymap.set("n", "<C-S-w>", "<cmd>%bd|e#<cr>", { desc = "Close all" })
keymap.set("n", "<C-n>", "<cmd>Telescope find_files<cr>", { desc = "Go to class" })
keymap.set("n", "<C-S-n>", "<cmd>Telescope find_files<cr>", { desc = "Go to file" })
keymap.set("n", "<C-e>", "<cmd>Telescope oldfiles<cr>", { desc = "Recent files" })
keymap.set("n", "<C-S-e>", "<cmd>Telescope oldfiles<cr>", { desc = "Recently edited files" })
keymap.set("n", "<C-A-s>", "<cmd>e ~/.config/nvim/init.lua<cr>", { desc = "Settings" })

-- Tab operations
keymap.set("n", "<C-Tab>", "<cmd>bnext<cr>", { desc = "Next tab" })
keymap.set("n", "<C-S-Tab>", "<cmd>bprevious<cr>", { desc = "Previous tab" })
keymap.set("n", "<A-Right>", "<cmd>bnext<cr>", { desc = "Select next tab" })
keymap.set("n", "<A-Left>", "<cmd>bprevious<cr>", { desc = "Select previous tab" })

-- Tool windows (simulated with telescope and splits)
keymap.set("n", "<A-1>", "<cmd>NvimTreeToggle<cr>", { desc = "Project" })
keymap.set("n", "<A-2>", "<cmd>Telescope file_browser<cr>", { desc = "Bookmarks" })
keymap.set("n", "<A-3>", "<cmd>Telescope find_files<cr>", { desc = "Find" })
keymap.set("n", "<A-4>", "<cmd>terminal<cr>", { desc = "Run" })
keymap.set("n", "<A-5>", "<cmd>lua require('dap.ui.widgets').hover()<cr>", { desc = "Debug" })
keymap.set("n", "<A-6>", "<cmd>Telescope live_grep<cr>", { desc = "Problems" })
keymap.set("n", "<A-7>", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "Structure" })
keymap.set("n", "<A-9>", "<cmd>Git<cr>", { desc = "Version Control" })
keymap.set("n", "<A-0>", "<cmd>Git<cr>", { desc = "Commit" })
keymap.set("n", "<A-F12>", "<cmd>terminal<cr>", { desc = "Terminal" })

-- Navigation
keymap.set("n", "<C-g>", ":<C-u>call inputsave()<Bar>let line = input('Go to line: ')<Bar>call inputrestore()<Bar>exec 'normal! ' . line . 'G'<CR>", { desc = "Go to line" })
keymap.set("n", "<C-F12>", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "File structure popup" })
keymap.set("n", "<C-A-Left>", "<C-o>", { desc = "Navigate back" })
keymap.set("n", "<C-A-Right>", "<C-i>", { desc = "Navigate forward" })
keymap.set("n", "<C-S-Backspace>", "<C-o>", { desc = "Last edit location" })

-- Code completion and documentation
keymap.set("n", "<C-q>", "<cmd>lua vim.lsp.buf.hover()<cr>", { desc = "Quick documentation" })
keymap.set("n", "<C-p>", "<cmd>lua vim.lsp.buf.signature_help()<cr>", { desc = "Parameter info" })
keymap.set("n", "<C-S-i>", "<cmd>lua vim.lsp.buf.hover()<cr>", { desc = "Quick definition" })
keymap.set("i", "<C-Space>", "<cmd>lua vim.lsp.buf.completion()<cr>", { desc = "Basic completion" })

-- ============================================================================
-- MULTI-CURSOR SUPPORT (Handled by nvim-visual-multi plugin)
-- ============================================================================
-- Note: Multi-cursor mappings are configured in the plugin file to avoid conflicts

-- ============================================================================
-- CODE FOLDING
-- ============================================================================

keymap.set("n", "<C-NumPad+>", "zo", { desc = "Expand" })
keymap.set("n", "<C-NumPad->", "zc", { desc = "Collapse" })
keymap.set("n", "<C-S-NumPad+>", "zR", { desc = "Expand all" })
keymap.set("n", "<C-S-NumPad->", "zM", { desc = "Collapse all" })
keymap.set("n", "<C-.>", "za", { desc = "Fold selection" })

-- Alternative for keyboards without numpad
keymap.set("n", "<C-=>", "zo", { desc = "Expand" })
keymap.set("n", "<C-->", "zc", { desc = "Collapse" })
keymap.set("n", "<C-S-=>", "zR", { desc = "Expand all" })
keymap.set("n", "<C-S-->", "zM", { desc = "Collapse all" })

-- ============================================================================
-- BOOKMARKS
-- ============================================================================

keymap.set("n", "<F11>", "ma", { desc = "Toggle bookmark" })
keymap.set("n", "<S-F11>", ":marks<cr>", { desc = "Show bookmarks" })
keymap.set("n", "<C-F11>", "m", { desc = "Toggle bookmark with mnemonic" })
keymap.set("n", "<C-1>", "'1", { desc = "Go to bookmark 1" })
keymap.set("n", "<C-2>", "'2", { desc = "Go to bookmark 2" })
keymap.set("n", "<C-3>", "'3", { desc = "Go to bookmark 3" })
keymap.set("n", "<C-4>", "'4", { desc = "Go to bookmark 4" })
keymap.set("n", "<C-5>", "'5", { desc = "Go to bookmark 5" })

-- ============================================================================
-- ADDITIONAL NEOVIM-SPECIFIC IMPROVEMENTS
-- ============================================================================

-- Better escape
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode" })
keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Clear search highlights
keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })

-- Better window navigation
keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Window resizing
keymap.set("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
keymap.set("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
keymap.set("n", "<C-S-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
keymap.set("n", "<C-S-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- Move lines up and down
keymap.set("n", "<A-Up>", ":m .-2<CR>==", { desc = "Move line up" })
keymap.set("n", "<A-Down>", ":m .+1<CR>==", { desc = "Move line down" })
keymap.set("v", "<A-Up>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
keymap.set("v", "<A-Down>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })

-- Better indenting
keymap.set("v", "<", "<gv", { desc = "Unindent and keep selection" })
keymap.set("v", ">", ">gv", { desc = "Indent and keep selection" })

-- Keep cursor in place when joining lines
keymap.set("n", "J", "mzJ`z", { desc = "Join lines" })

-- Better scrolling - commented out to avoid conflict with duplicate line
-- keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
-- keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })

-- Quickfix navigation
keymap.set("n", "[q", vim.cmd.cprev, { desc = "Previous quickfix" })
keymap.set("n", "]q", vim.cmd.cnext, { desc = "Next quickfix" })

-- Diagnostic navigation
keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })

-- ============================================================================
-- LEADER KEY MAPPINGS (Space)
-- ============================================================================

-- File operations
keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Recent files" })
keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Search in files" })
keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor" })
keymap.set("n", "<leader>fb", "<cmd>Telescope file_browser<cr>", { desc = "File browser" })

-- Buffer operations
keymap.set("n", "<leader>bb", "<cmd>Telescope buffers<cr>", { desc = "Switch buffers" })
keymap.set("n", "<leader>bd", "<cmd>bd<cr>", { desc = "Delete buffer" })
keymap.set("n", "<leader>bn", "<cmd>bnext<cr>", { desc = "Next buffer" })
keymap.set("n", "<leader>bp", "<cmd>bprevious<cr>", { desc = "Previous buffer" })

-- LSP operations
keymap.set("n", "<leader>ld", "<cmd>lua vim.lsp.buf.definition()<cr>", { desc = "Go to definition" })
keymap.set("n", "<leader>lr", "<cmd>Telescope lsp_references<cr>", { desc = "References" })
keymap.set("n", "<leader>lh", "<cmd>lua vim.lsp.buf.hover()<cr>", { desc = "Hover documentation" })
keymap.set("n", "<leader>li", "<cmd>lua vim.lsp.buf.implementation()<cr>", { desc = "Implementation" })
keymap.set("n", "<leader>ls", "<cmd>lua vim.lsp.buf.signature_help()<cr>", { desc = "Signature help" })
keymap.set("n", "<leader>lt", "<cmd>lua vim.lsp.buf.type_definition()<cr>", { desc = "Type definition" })
keymap.set("n", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", { desc = "Code action" })
keymap.set("n", "<leader>lf", "<cmd>lua vim.lsp.buf.format()<cr>", { desc = "Format" })
keymap.set("n", "<leader>lR", "<cmd>LspRestart<cr>", { desc = "Restart LSP" })

-- Git operations
keymap.set("n", "<leader>gs", "<cmd>Git<cr>", { desc = "Git status" })
keymap.set("n", "<leader>gb", "<cmd>Git blame<cr>", { desc = "Git blame" })
keymap.set("n", "<leader>gd", "<cmd>Gdiffsplit<cr>", { desc = "Git diff" })
keymap.set("n", "<leader>gl", "<cmd>Git log<cr>", { desc = "Git log" })

-- Window management
keymap.set("n", "<leader>sv", "<cmd>vsplit<cr>", { desc = "Split vertically" })
keymap.set("n", "<leader>sh", "<cmd>split<cr>", { desc = "Split horizontally" })
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Equal splits" })
keymap.set("n", "<leader>sx", "<cmd>close<cr>", { desc = "Close split" })

-- Tab management
keymap.set("n", "<leader>to", "<cmd>tabnew<cr>", { desc = "New tab" })
keymap.set("n", "<leader>tx", "<cmd>tabclose<cr>", { desc = "Close tab" })
keymap.set("n", "<leader>tn", "<cmd>tabnext<cr>", { desc = "Next tab" })
keymap.set("n", "<leader>tp", "<cmd>tabprevious<cr>", { desc = "Previous tab" })

-- Utility
keymap.set("n", "<leader>nh", "<cmd>nohlsearch<cr>", { desc = "Clear highlights" })
keymap.set("n", "<leader>ur", "<cmd>nohlsearch<bar>diffupdate<bar>normal! <C-L><cr>", { desc = "Redraw screen" })

-- ============================================================================
-- NOTES
-- ============================================================================
-- Some mappings require additional plugins:
-- - Multi-cursor: nvim-visual-multi
-- - Debugging: nvim-dap
-- - Advanced refactoring: varies by language
-- - Some advanced IntelliJ features may need custom implementation