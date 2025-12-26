-- Ultra-stable telescope configuration with no preview functionality
-- This configuration eliminates all buffer preview errors by disabling preview entirely
return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    telescope.setup({
      defaults = {
        -- Minimal, stable configuration
        path_display = { "truncate" },
        preview = false, -- Completely disable preview

        -- Essential mappings only
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            ["<ESC>"] = actions.close,
          },
          n = {
            ["q"] = actions.close,
            ["<ESC>"] = actions.close,
          },
        },

        -- Stable layout settings
        layout_strategy = "horizontal",
        layout_config = {
          horizontal = {
            prompt_position = "top",
            width = 0.8,
            height = 0.6,
          },
        },

        -- Performance settings
        cache_picker = { num_pickers = 5 },
        selection_strategy = "reset",
        sorting_strategy = "ascending",
        scroll_strategy = "cycle",

        -- File filtering
        file_ignore_patterns = {
          ".git/",
          "node_modules/",
          "%.o",
          "%.a",
          "%.class",
          "%.pdf",
          "%.zip"
        },

        -- Visual settings
        prompt_prefix = " ",
        selection_caret = " ",
        entry_prefix = "  ",
        initial_mode = "insert",
        border = {},
        borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
        winblend = 0,
        color_devicons = true,
      },

      pickers = {
        -- All pickers explicitly disable preview
        find_files = {
          theme = "dropdown",
          previewer = false,
          hidden = true,
        },
        live_grep = {
          theme = "dropdown",
          previewer = false,
        },
        grep_string = {
          theme = "dropdown",
          previewer = false,
        },
        buffers = {
          theme = "dropdown",
          previewer = false,
          initial_mode = "normal",
          mappings = {
            i = { ["<C-d>"] = actions.delete_buffer },
            n = { ["dd"] = actions.delete_buffer },
          },
        },
        oldfiles = {
          theme = "dropdown",
          previewer = false,
        },
        help_tags = {
          theme = "dropdown",
          previewer = false,
        },
        keymaps = {
          theme = "dropdown",
          previewer = false,
        },
        commands = {
          theme = "dropdown",
          previewer = false,
          layout_config = {
            width = 0.6,
            height = 0.7,
          },
        },
        command_history = {
          theme = "dropdown",
          previewer = false,
        },
        -- LSP pickers
        lsp_references = {
          theme = "dropdown",
          previewer = false,
          initial_mode = "normal",
        },
        lsp_definitions = {
          theme = "dropdown",
          previewer = false,
          initial_mode = "normal",
        },
        lsp_implementations = {
          theme = "dropdown",
          previewer = false,
          initial_mode = "normal",
        },
        lsp_document_symbols = {
          theme = "dropdown",
          previewer = false,
        },
        lsp_workspace_symbols = {
          theme = "dropdown",
          previewer = false,
        },
      },
    })

    -- Load essential extensions only
    local success, _ = pcall(telescope.load_extension, "fzf")
    if not success then
      vim.notify("fzf extension failed to load", vim.log.levels.DEBUG)
    end

    -- Set up keymaps with error handling
    local keymap = vim.keymap.set
    local opts = { silent = true, noremap = true }

    keymap("n", "<leader>ff", function()
      require("telescope.builtin").find_files()
    end, vim.tbl_extend("force", opts, { desc = "Find files" }))

    keymap("n", "<leader>fr", function()
      require("telescope.builtin").oldfiles()
    end, vim.tbl_extend("force", opts, { desc = "Recent files" }))

    keymap("n", "<leader>fs", function()
      require("telescope.builtin").live_grep()
    end, vim.tbl_extend("force", opts, { desc = "Live grep" }))

    keymap("n", "<leader>fc", function()
      require("telescope.builtin").grep_string()
    end, vim.tbl_extend("force", opts, { desc = "Grep string" }))

    keymap("n", "<leader>fb", function()
      require("telescope.builtin").buffers()
    end, vim.tbl_extend("force", opts, { desc = "Buffers" }))

    -- IntelliJ-style Find Action (Ctrl+Shift+A) - Enhanced Command Palette
    keymap("n", "<C-S-a>", function()
      require("config.command-palette").find_action()
    end, vim.tbl_extend("force", opts, { desc = "Find Action (IntelliJ Command Palette)" }))

    keymap("n", "<leader>sa", function()
      require("config.command-palette").find_action()
    end, vim.tbl_extend("force", opts, { desc = "Find Action (Enhanced)" }))

    -- Simple command search as fallback
    keymap("n", "<leader>sc", function()
      require("telescope.builtin").commands()
    end, vim.tbl_extend("force", opts, { desc = "Simple Commands" }))

    -- Additional command-related shortcuts
    keymap("n", "<leader>sh", function()
      require("telescope.builtin").command_history()
    end, vim.tbl_extend("force", opts, { desc = "Command History" }))
  end,
}