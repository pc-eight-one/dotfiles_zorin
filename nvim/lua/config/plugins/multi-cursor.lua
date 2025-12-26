return {
  "mg979/vim-visual-multi",
  branch = "master",
  event = { "BufReadPre", "BufNewFile" },
  init = function()
    -- Configure vim-visual-multi settings
    vim.g.VM_theme = 'iceblue'
    vim.g.VM_highlight_matches = 'underline'

    -- Enhanced IntelliJ-like multi-cursor mappings
    vim.g.VM_maps = {
      -- Core IntelliJ multi-cursor shortcuts
      ['Find Under'] = '<A-j>',           -- IntelliJ: Alt+J (Add selection for next occurrence)
      ['Find Subword Under'] = '<A-S-j>', -- IntelliJ: Alt+Shift+J (Add selection for next occurrence of current word)
      ['Select All'] = '<C-A-S-j>',      -- IntelliJ: Ctrl+Alt+Shift+J (Select all occurrences)
      ['Skip Region'] = '<A-S-k>',       -- IntelliJ: Alt+Shift+K (Unselect occurrence)

      -- Additional multi-cursor operations
      ['Add Cursor Down'] = '<A-S-Down>', -- Add cursor below
      ['Add Cursor Up'] = '<A-S-Up>',     -- Add cursor above
      ['Select Cursor Down'] = '<C-S-Down>',
      ['Select Cursor Up'] = '<C-S-Up>',

      -- Column selection (IntelliJ: Alt+Shift+Insert or middle mouse drag)
      ['Select l'] = '<S-Right>',
      ['Select h'] = '<S-Left>',
      ['Select j'] = '<S-Down>',
      ['Select k'] = '<S-Up>',

      -- Advanced operations
      ['Remove Region'] = '<A-S-x>',      -- Remove current selection
      ['Increase'] = '<A-=>',             -- Expand selection
      ['Decrease'] = '<A-->',             -- Shrink selection
      ['Toggle Mappings'] = '<C-S-\\>',

      -- Navigation between cursors
      ['Goto Next'] = '<A-n>',            -- Next cursor
      ['Goto Prev'] = '<A-p>',            -- Previous cursor
      ['Seek Next'] = '<C-f>',
      ['Seek Prev'] = '<C-b>',

      -- Visual mode operations
      ['Visual Regex'] = '\\/',           -- Regex selection
      ['Visual All'] = '\\A',             -- Select all in visual mode
      ['Visual Add'] = '\\a',             -- Add visual selection
      ['Visual Find'] = '\\f',            -- Find in visual mode
      ['Visual Cursors'] = '\\c',         -- Create cursors from visual

      -- Mouse support (IntelliJ-like)
      ['Mouse Cursor'] = '<A-LeftMouse>',    -- Alt+Click to add cursor
      ['Mouse Word'] = '<A-RightMouse>',     -- Alt+Right-click for word selection
      ['Mouse Column'] = '<A-MiddleMouse>',  -- Alt+Middle-click for column selection

      -- Case operations
      ['Switch Mode'] = '<Tab>',          -- Switch between extend/cursor mode
      ['Toggle Block'] = '<C-v>',         -- Toggle block mode
      ['Toggle Single Region'] = '<C-S-l>', -- Toggle single region mode

      -- Text editing
      ['Surround'] = 'S',                 -- Surround selection
      ['Replace'] = 'r',                  -- Replace character
      ['Duplicate'] = '<C-d>',            -- Duplicate line/selection

      -- Exit
      ['Exit'] = '<Esc>',                 -- Exit multi-cursor mode
      ['Force Exit'] = '<C-c>',           -- Force exit
    }

    -- Enhanced settings for IntelliJ-like experience
    vim.g.VM_show_warnings = 0                    -- Hide warnings
    vim.g.VM_silent_exit = 1                      -- Silent exit
    vim.g.VM_quit_after_leaving_insert_mode = 0   -- Don't quit after leaving insert
    vim.g.VM_continue_after_leaving_insert_mode = 1 -- Continue multi-cursor mode
    vim.g.VM_leader = '\\'                        -- Leader key for VM commands
    vim.g.VM_mouse_mappings = 1                   -- Enable mouse mappings
    vim.g.VM_extend_defs = 1                      -- Extended definitions
    vim.g.VM_case_setting = 'smart'               -- Smart case handling
    vim.g.VM_highlight_matches = 'underline'      -- Highlight style

    -- Enhanced highlighting for better visibility
    vim.g.VM_Mono_hl = 'DiffText'       -- Monochrome highlight
    vim.g.VM_Extend_hl = 'DiffAdd'       -- Extend mode highlight
    vim.g.VM_Cursor_hl = 'Visual'        -- Cursor highlight
    vim.g.VM_Insert_hl = 'DiffChange'    -- Insert mode highlight
  end,
  config = function()
    -- Additional key mappings and setup for IntelliJ-like multi-cursor experience
    local keymap = vim.keymap.set

    -- Function to check if vim-visual-multi is active
    local function vm_active()
      return vim.fn.exists('b:VM_Selection') == 1
    end

    -- Additional IntelliJ-style shortcuts that complement VM
    -- These work when VM is not active

    -- Quick word selection (IntelliJ: Ctrl+W)
    keymap('n', '<C-w>', 'viw', { desc = "Select word under cursor", silent = true })

    -- Line selection (IntelliJ: Ctrl+L)
    keymap('n', '<C-l>', 'V', { desc = "Select entire line", silent = true })

    -- Autocommands for better multi-cursor experience
    vim.api.nvim_create_autocmd("User", {
      pattern = "visual_multi_start",
      callback = function()
        vim.notify("Multi-cursor mode activated", vim.log.levels.INFO)
      end,
    })

    vim.api.nvim_create_autocmd("User", {
      pattern = "visual_multi_exit",
      callback = function()
        vim.notify("Multi-cursor mode deactivated", vim.log.levels.INFO)
      end,
    })

    -- Set up status line integration
    vim.g.VM_set_statusline = 2 -- Show VM status in statusline
  end,
}