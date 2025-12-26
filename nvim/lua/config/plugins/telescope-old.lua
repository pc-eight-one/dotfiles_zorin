return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
    "nvim-telescope/telescope-file-browser.nvim",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    telescope.setup({
      defaults = {
        path_display = { "truncate" },
        -- Disable all preview functionality to prevent buffer errors
        preview = false,
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous, -- move to prev result
            ["<C-j>"] = actions.move_selection_next, -- move to next result
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            ["<C-x>"] = actions.select_horizontal,
            ["<C-v>"] = actions.select_vertical,
            ["<C-t>"] = actions.select_tab,
            ["<C-u>"] = actions.preview_scrolling_up,
            ["<C-d>"] = actions.preview_scrolling_down,
          },
          n = {
            ["q"] = actions.close,
          },
        },
        -- Buffer management settings
        cache_picker = {
          num_pickers = 20,
        },
        dynamic_preview_title = true,
        -- Additional buffer safety settings
        wrap_results = true,
        scroll_strategy = "cycle",
        selection_strategy = "reset",
        -- Preview disabled globally for stability
        -- preview = false, -- Already set above
        file_ignore_patterns = {
          ".git/",
          "target/",
          "docs/",
          "%.o",
          "%.a",
          "%.out",
          "%.class",
          "%.pdf",
          "%.mkv",
          "%.mp4",
          "%.zip"
        },
        layout_config = {
          horizontal = {
            prompt_position = "top",
            preview_width = 0.55,
            results_width = 0.8,
          },
          vertical = {
            mirror = false,
          },
          width = 0.87,
          height = 0.80,
          preview_cutoff = 120,
        },
        prompt_prefix = "   ",
        selection_caret = "  ",
        entry_prefix = "  ",
        initial_mode = "insert",
        selection_strategy = "reset",
        sorting_strategy = "ascending",
        layout_strategy = "horizontal",
        file_sorter = require("telescope.sorters").get_fuzzy_file,
        generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
        winblend = 0,
        border = {},
        borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
        color_devicons = true,
        use_less = true,
        set_env = { ["COLORTERM"] = "truecolor" },
      },
      pickers = {
        find_files = {
          theme = "dropdown",
          previewer = false,
          hidden = true,
        },
        git_files = {
          theme = "dropdown",
          previewer = false,
        },
        buffers = {
          theme = "dropdown",
          previewer = false,
          initial_mode = "normal",
          mappings = {
            i = {
              ["<C-d>"] = actions.delete_buffer,
            },
            n = {
              ["dd"] = actions.delete_buffer,
            },
          },
        },
        live_grep = {
          theme = "dropdown",
          previewer = false,
        },
        grep_string = {
          theme = "dropdown",
          previewer = false,
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
        colorscheme = {
          enable_preview = false,
        },
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
        lsp_declarations = {
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
      extensions = {
        file_browser = {
          theme = "dropdown",
          hijack_netrw = true,
          mappings = {
            ["i"] = {},
            ["n"] = {},
          },
        },
      },
    })

    telescope.load_extension("fzf")
    telescope.load_extension("file_browser")

    -- set keymaps
    local keymap = vim.keymap

    keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
    keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
    keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
    keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
    keymap.set("n", "<leader>fb", "<cmd>Telescope file_browser<cr>", { desc = "File browser" })
  end,
}