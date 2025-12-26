return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
          }
        }
      })
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "tsserver",
          "html",
          "cssls",
          "tailwindcss",
          "jdtls",           -- Java Development Tools Language Server
          "kotlin_language_server", -- Kotlin Language Server
          "metals",          -- Scala Language Server (optional)
          "pyright",
          "rust_analyzer",
        },
        automatic_installation = true,
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      { "antosha417/nvim-lsp-file-operations", config = true },
    },
    config = function()
      local lspconfig = require("lspconfig")
      local cmp_nvim_lsp = require("cmp_nvim_lsp")

      local keymap = vim.keymap

      local opts = { noremap = true, silent = true }
      local on_attach = function(client, bufnr)
        opts.buffer = bufnr

        -- set keybinds
        opts.desc = "Show LSP references"
        keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

        opts.desc = "Go to declaration"
        keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

        opts.desc = "Show LSP definitions"
        keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

        opts.desc = "Show LSP implementations"
        keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

        opts.desc = "Show LSP type definitions"
        keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

        opts.desc = "See available code actions"
        keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

        opts.desc = "Smart rename"
        keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

        opts.desc = "Show buffer diagnostics"
        keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

        opts.desc = "Show line diagnostics"
        keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

        opts.desc = "Go to previous diagnostic"
        keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)

        opts.desc = "Go to next diagnostic"
        keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

        opts.desc = "Show documentation for what is under cursor"
        keymap.set("n", "K", vim.lsp.buf.hover, opts)

        opts.desc = "Restart LSP"
        keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)
      end

      -- used to enable autocompletion (assign to every lsp server config)
      local capabilities = cmp_nvim_lsp.default_capabilities()

      -- Change the Diagnostic symbols in the sign column (gutter)
      local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
      end

      -- configure html server
      lspconfig["html"].setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })

      -- configure typescript server with plugin
      lspconfig["tsserver"].setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })

      -- configure css server
      lspconfig["cssls"].setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })

      -- configure tailwindcss server
      lspconfig["tailwindcss"].setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })

      -- configure python server
      lspconfig["pyright"].setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })

      -- configure lua server (with special settings)
      lspconfig["lua_ls"].setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              library = {
                [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                [vim.fn.stdpath("config") .. "/lua"] = true,
              },
            },
          },
        },
      })

      -- configure rust analyzer
      lspconfig["rust_analyzer"].setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          ["rust-analyzer"] = {
            imports = {
              granularity = {
                group = "module",
              },
              prefix = "self",
            },
            cargo = {
              buildScripts = {
                enable = true,
              },
            },
            procMacro = {
              enable = true
            },
          },
        },
      })

      -- Java server is configured separately in java.lua using nvim-jdtls
      -- This provides better Java support with advanced refactoring capabilities

      -- Enhanced Kotlin language server configuration
      lspconfig["kotlin_language_server"].setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          kotlin = {
            compiler = {
              jvm = {
                target = "17", -- or "11", "1.8" depending on your project
              },
            },
            linting = {
              debounceTime = 250,
            },
            completion = {
              snippets = {
                enabled = true,
              },
            },
            -- Enable indexing for better performance with large codebases
            indexing = {
              enabled = true,
            },
          },
        },
        root_dir = function(fname)
          local util = require("lspconfig/util")
          return util.root_pattern(
            "settings.gradle", -- Gradle (Kotlin)
            "settings.gradle.kts",
            "build.gradle",
            "build.gradle.kts",
            "pom.xml", -- Maven
            ".git"
          )(fname)
        end,
      })

      -- Scala language server (Metals) configuration
      lspconfig["metals"].setup({
        capabilities = capabilities,
        on_attach = function(client, bufnr)
          on_attach(client, bufnr)
          -- Metals specific configuration
          vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>mc", "<cmd>MetalsCompile<cr>",
            { noremap = true, silent = true, desc = "Metals Compile" })
          vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>mi", "<cmd>MetalsImportBuild<cr>",
            { noremap = true, silent = true, desc = "Metals Import Build" })
        end,
        settings = {
          metals = {
            serverVersion = "latest.snapshot",
            showImplicitArguments = true,
            showImplicitConversionsAndClasses = true,
            showInferredType = true,
            superMethodLensesEnabled = true,
            enableSemanticHighlighting = true,
          },
        },
        root_dir = function(fname)
          local util = require("lspconfig/util")
          return util.root_pattern("build.sbt", ".bloop", ".metals")(fname)
        end,
      })
    end,
  },
}