-- Enhanced Command Palette (IntelliJ-style Find Action)
-- This module provides Ctrl+Shift+A functionality similar to IntelliJ IDEA

local M = {}

-- Enhanced command palette that searches across multiple sources
M.find_action = function()
  local telescope = require("telescope")
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  -- Collect all available actions/commands
  local function get_all_actions()
    local commands = {}

    -- Get Neovim commands
    local nvim_commands = vim.api.nvim_get_commands({})
    for name, details in pairs(nvim_commands) do
      table.insert(commands, {
        name = name,
        description = details.definition or "Neovim command",
        type = "command",
        action = function() vim.cmd(name) end
      })
    end

    -- Get common actions with descriptions
    local common_actions = {
      { name = "Find Files", description = "Search and open files (Ctrl+N)", type = "action",
        action = function() require("telescope.builtin").find_files() end },
      { name = "Recent Files", description = "Open recently used files (Ctrl+E)", type = "action",
        action = function() require("telescope.builtin").oldfiles() end },
      { name = "Live Grep", description = "Search in files (Ctrl+Shift+F)", type = "action",
        action = function() require("telescope.builtin").live_grep() end },
      { name = "Go to Definition", description = "Navigate to symbol definition (Ctrl+B)", type = "action",
        action = function() vim.lsp.buf.definition() end },
      { name = "Find References", description = "Find symbol references (Alt+F7)", type = "action",
        action = function() require("telescope.builtin").lsp_references() end },
      { name = "Rename Symbol", description = "Rename symbol across project (Shift+F6)", type = "action",
        action = function() vim.lsp.buf.rename() end },
      { name = "Code Actions", description = "Show available code actions (Alt+Enter)", type = "action",
        action = function() vim.lsp.buf.code_action() end },
      { name = "Format Code", description = "Format current file (Ctrl+Alt+L)", type = "action",
        action = function() vim.lsp.buf.format() end },
      { name = "Toggle File Explorer", description = "Show/hide file tree (Alt+1)", type = "action",
        action = function() vim.cmd("NvimTreeToggle") end },
      { name = "Git Status", description = "View git status", type = "action",
        action = function() vim.cmd("Git") end },
      { name = "Buffer List", description = "Switch between open buffers", type = "action",
        action = function() require("telescope.builtin").buffers() end },
      { name = "Help Tags", description = "Search help documentation", type = "action",
        action = function() require("telescope.builtin").help_tags() end },
      { name = "Keymaps", description = "View all keymaps", type = "action",
        action = function() require("telescope.builtin").keymaps() end },
      { name = "LSP Document Symbols", description = "Navigate file structure (Alt+7)", type = "action",
        action = function() require("telescope.builtin").lsp_document_symbols() end },
      { name = "Problems", description = "View diagnostics/errors (Alt+6)", type = "action",
        action = function() vim.cmd("TroubleToggle") end },
      { name = "Terminal", description = "Open terminal (Alt+F12)", type = "action",
        action = function() vim.cmd("terminal") end },
    }

    -- Add common actions to the list
    for _, action in ipairs(common_actions) do
      table.insert(commands, action)
    end

    return commands
  end

  local function entry_maker(entry)
    local display = entry.name
    if entry.description then
      display = display .. " - " .. entry.description
    end

    return {
      value = entry,
      display = display,
      ordinal = entry.name .. " " .. (entry.description or ""),
    }
  end

  -- Create the picker
  pickers.new({}, {
    prompt_title = "Find Action (Ctrl+Shift+A)",
    finder = finders.new_table({
      results = get_all_actions(),
      entry_maker = entry_maker,
    }),
    sorter = conf.generic_sorter({}),
    previewer = false,
    theme = "dropdown",
    layout_config = {
      width = 0.8,
      height = 0.6,
    },
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)

        if selection and selection.value and selection.value.action then
          selection.value.action()
        end
      end)

      return true
    end,
  }):find()
end

-- Simplified version that just uses telescope commands
M.simple_find_action = function()
  require("telescope.builtin").commands()
end

return M