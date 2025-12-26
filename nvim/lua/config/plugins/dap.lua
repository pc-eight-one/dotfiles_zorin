return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-neotest/nvim-nio",
      "williamboman/mason.nvim",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- Setup DAP UI
      dapui.setup({
        icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
        mappings = {
          expand = { "<CR>", "<2-LeftMouse>" },
          open = "o",
          remove = "d",
          edit = "e",
          repl = "r",
          toggle = "t",
        },
        expand_lines = vim.fn.has("nvim-0.7") == 1,
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.25 },
              "breakpoints",
              "stacks",
              "watches",
            },
            size = 40,
            position = "left",
          },
          {
            elements = {
              "repl",
              "console",
            },
            size = 0.25,
            position = "bottom",
          },
        },
        controls = {
          enabled = true,
          element = "repl",
          icons = {
            pause = "",
            play = "",
            step_into = "",
            step_over = "",
            step_out = "",
            step_back = "",
            run_last = "▶▶",
            terminate = "⏹",
          },
        },
        floating = {
          max_height = nil,
          max_width = nil,
          border = "single",
          mappings = {
            close = { "q", "<Esc>" },
          },
        },
        windows = { indent = 1 },
        render = {
          max_type_length = nil,
          max_value_lines = 100,
        },
      })

      -- Setup virtual text
      require("nvim-dap-virtual-text").setup({
        enabled = true,
        enabled_commands = true,
        highlight_changed_variables = true,
        highlight_new_as_changed = false,
        show_stop_reason = true,
        commented = false,
        only_first_definition = true,
        all_references = false,
        filter_references_pattern = '<module',
        virt_text_pos = 'eol',
        all_frames = false,
        virt_lines = false,
        virt_text_win_col = nil
      })

      -- Auto open/close DAP UI
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- Configure adapters for different languages

      -- Node.js adapter
      dap.adapters.node2 = {
        type = 'executable',
        command = 'node',
        args = {os.getenv('HOME') .. '/.config/nvim/vscode-node-debug2/out/src/nodeDebug.js'},
      }

      -- JavaScript/TypeScript configurations
      dap.configurations.javascript = {
        {
          name = 'Launch Node.js',
          type = 'node2',
          request = 'launch',
          program = '${file}',
          cwd = vim.fn.getcwd(),
          sourceMaps = true,
          protocol = 'inspector',
          console = 'integratedTerminal',
        },
        {
          name = 'Attach to process',
          type = 'node2',
          request = 'attach',
          processId = require'dap.utils'.pick_process,
        },
      }

      dap.configurations.typescript = dap.configurations.javascript

      -- Python adapter
      dap.adapters.python = {
        type = 'executable',
        command = 'python',
        args = { '-m', 'debugpy.adapter' },
      }

      -- Python configurations
      dap.configurations.python = {
        {
          type = 'python',
          request = 'launch',
          name = "Launch file",
          program = "${file}",
          pythonPath = function()
            return '/usr/bin/python'
          end,
        },
      }

      -- Java adapter (requires nvim-jdtls)
      dap.configurations.java = {
        {
          type = 'java',
          request = 'attach',
          name = "Debug (Attach) - Remote",
          hostName = "127.0.0.1",
          port = 5005,
        },
      }

      -- Signs
      vim.fn.sign_define('DapBreakpoint', {text='🛑', texthl='', linehl='', numhl=''})
      vim.fn.sign_define('DapBreakpointCondition', {text='🔍', texthl='', linehl='', numhl=''})
      vim.fn.sign_define('DapLogPoint', {text='📝', texthl='', linehl='', numhl=''})
      vim.fn.sign_define('DapStopped', {text='▶️', texthl='', linehl='', numhl=''})
      vim.fn.sign_define('DapBreakpointRejected', {text='❌', texthl='', linehl='', numhl=''})

      -- IntelliJ-like debugging keymaps
      local keymap = vim.keymap

      -- Debug session control
      keymap.set("n", "<S-F9>", function() dap.continue() end, { desc = "Start/Continue debugging" })
      keymap.set("n", "<C-F2>", function() dap.terminate() end, { desc = "Stop debugging" })
      keymap.set("n", "<A-S-F9>", function() dap.run_to_cursor() end, { desc = "Run to cursor" })

      -- Step operations
      keymap.set("n", "<F8>", function() dap.step_over() end, { desc = "Step over" })
      keymap.set("n", "<F7>", function() dap.step_into() end, { desc = "Step into" })
      keymap.set("n", "<S-F8>", function() dap.step_out() end, { desc = "Step out" })
      keymap.set("n", "<A-F9>", function() dap.run_to_cursor() end, { desc = "Run to cursor" })
      keymap.set("n", "<F9>", function() dap.continue() end, { desc = "Resume program" })

      -- Breakpoint operations
      keymap.set("n", "<C-F8>", function() dap.toggle_breakpoint() end, { desc = "Toggle breakpoint" })
      keymap.set("n", "<C-S-F8>", function() dapui.toggle() end, { desc = "Toggle debug UI" })
      keymap.set("n", "<A-F8>", function()
        vim.ui.input({ prompt = "Breakpoint condition: " }, function(input)
          dap.set_breakpoint(input)
        end)
      end, { desc = "Conditional breakpoint" })

      -- Debug UI operations
      keymap.set("n", "<leader>du", function() dapui.toggle() end, { desc = "Toggle debug UI" })
      keymap.set("n", "<leader>de", function() dapui.eval() end, { desc = "Evaluate expression" })
      keymap.set("v", "<leader>de", function() dapui.eval() end, { desc = "Evaluate selection" })
      keymap.set("n", "<leader>dr", function() dap.repl.open() end, { desc = "Open debug REPL" })
      keymap.set("n", "<leader>dl", function() dap.run_last() end, { desc = "Run last debug session" })

      -- Frames and scopes
      keymap.set("n", "<C-F10>", function() dap.up() end, { desc = "Go up in stack" })
      keymap.set("n", "<C-S-F10>", function() dap.down() end, { desc = "Go down in stack" })

      -- Watch expressions
      keymap.set("n", "<leader>dw", function()
        vim.ui.input({ prompt = "Watch expression: " }, function(input)
          if input then
            dapui.elements.watches.add(input)
          end
        end)
      end, { desc = "Add watch expression" })
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "mfussenegger/nvim-dap",
    },
    opts = {
      handlers = {},
      ensure_installed = {
        "codelldb",  -- C/C++/Rust
        "node2",     -- Node.js
        "python",    -- Python
      },
    },
  },
}