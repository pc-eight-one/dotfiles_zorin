-- Enhanced JVM Languages Development Support with nvim-jdtls
return {
  "mfussenegger/nvim-jdtls",
  dependencies = {
    "mfussenegger/nvim-dap",
    "rcarriga/nvim-dap-ui",
  },
  ft = { "java", "kotlin" }, -- Support both Java and Kotlin
  config = function()
    local jdtls = require("jdtls")
    local jdtls_dap = require("jdtls.dap")
    local jdtls_setup = require("jdtls.setup")

    -- Function to get the jdtls installation path
    local function get_jdtls_install_path()
      -- Try common installation paths
      local possible_paths = {
        vim.fn.stdpath("data") .. "/mason/packages/jdtls",
        vim.fn.expand("~/.local/share/nvim/mason/packages/jdtls"),
        "/usr/local/share/java/jdtls",
        "/opt/jdtls",
      }

      for _, path in ipairs(possible_paths) do
        if vim.fn.isdirectory(path) == 1 then
          return path
        end
      end

      -- Fallback: assume mason installation
      return vim.fn.stdpath("data") .. "/mason/packages/jdtls"
    end

    -- Function to get Java executable path
    local function get_java_executable()
      -- Check JAVA_HOME first
      local java_home = vim.fn.getenv("JAVA_HOME")
      if java_home and java_home ~= vim.NIL then
        return java_home .. "/bin/java"
      end

      -- Check if java is in PATH
      local java_path = vim.fn.exepath("java")
      if java_path and java_path ~= "" then
        return java_path
      end

      -- Fallback
      return "java"
    end

    -- Enhanced on_attach function for Java
    local function on_attach(client, bufnr)
      -- Enable completion triggered by <c-x><c-o>
      vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

      local opts = { noremap = true, silent = true, buffer = bufnr }

      -- Standard LSP mappings
      vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
      vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
      vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
      vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
      vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
      vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format({ async = true }) end, opts)

      -- Java-specific JDTLS commands
      vim.keymap.set("n", "<leader>jo", jdtls.organize_imports,
        vim.tbl_extend("force", opts, { desc = "Organize Imports" }))
      vim.keymap.set("n", "<leader>jv", jdtls.extract_variable,
        vim.tbl_extend("force", opts, { desc = "Extract Variable" }))
      vim.keymap.set("n", "<leader>jc", jdtls.extract_constant,
        vim.tbl_extend("force", opts, { desc = "Extract Constant" }))
      vim.keymap.set("v", "<leader>jm", [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]],
        vim.tbl_extend("force", opts, { desc = "Extract Method" }))
      vim.keymap.set("n", "<leader>jt", jdtls.test_class,
        vim.tbl_extend("force", opts, { desc = "Test Class" }))
      vim.keymap.set("n", "<leader>jn", jdtls.test_nearest_method,
        vim.tbl_extend("force", opts, { desc = "Test Nearest Method" }))

      -- DAP (Debug Adapter Protocol) mappings
      vim.keymap.set("n", "<leader>df", jdtls_dap.test_class,
        vim.tbl_extend("force", opts, { desc = "Debug Test Class" }))
      vim.keymap.set("n", "<leader>dn", jdtls_dap.test_nearest_method,
        vim.tbl_extend("force", opts, { desc = "Debug Test Method" }))

      -- IntelliJ-style shortcuts
      vim.keymap.set("n", "<A-S-o>", jdtls.organize_imports,
        vim.tbl_extend("force", opts, { desc = "Optimize Imports (Alt+Shift+O)" }))
      vim.keymap.set("n", "<C-A-l>", function() vim.lsp.buf.format({ async = true }) end,
        vim.tbl_extend("force", opts, { desc = "Format Code (Ctrl+Alt+L)" }))

      -- Enable DAP if available
      if client.server_capabilities.executeCommandProvider then
        jdtls_dap.setup_dap_main_class_configs()
      end

      -- Set up DAP configurations
      jdtls_dap.setup_dap()
    end

    -- Configuration function to be called on JVM language file open
    local function setup_jdtls()
      -- Enhanced root directory detection for JVM languages
      local root_dir = jdtls_setup.find_root({
        -- Git repository
        ".git",
        -- Maven
        "mvnw", "pom.xml",
        -- Gradle
        "gradlew", "build.gradle", "build.gradle.kts",
        -- SBT (Scala)
        "build.sbt",
        -- General JVM project indicators
        "settings.gradle", "settings.gradle.kts",
        ".project", -- Eclipse project
      })

      local home = vim.fn.expand("~")
      local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
      local eclipse_workspace = home .. "/.local/share/eclipse/" .. project_name
      local jdtls_install_path = get_jdtls_install_path()

      -- Get platform-specific configuration
      local system = "linux"
      if vim.fn.has("mac") == 1 then
        system = "mac"
      elseif vim.fn.has("win32") == 1 then
        system = "win"
      end

      local config = {
        cmd = {
          get_java_executable(),
          "-Declipse.application=org.eclipse.jdt.ls.core.id1",
          "-Dosgi.bundles.defaultStartLevel=4",
          "-Declipse.product=org.eclipse.jdt.ls.core.product",
          "-Dlog.protocol=true",
          "-Dlog.level=WARNING",
          "-Xms1g",
          "-Xmx2G",
          "--add-modules=ALL-SYSTEM",
          "--add-opens", "java.base/java.util=ALL-UNNAMED",
          "--add-opens", "java.base/java.lang=ALL-UNNAMED",
          "--add-opens", "java.base/java.nio.file=ALL-UNNAMED",
          "--add-opens", "java.base/java.net=ALL-UNNAMED",
          "-XX:+IgnoreUnrecognizedVMOptions",
          "--illegal-access=permit",
          "-jar", vim.fn.glob(jdtls_install_path .. "/plugins/org.eclipse.equinox.launcher_*.jar"),
          "-configuration", jdtls_install_path .. "/config_" .. system,
          "-data", eclipse_workspace,
        },

        root_dir = root_dir,

        settings = {
          java = {
            home = vim.fn.getenv("JAVA_HOME") or "/usr/lib/jvm/default-java",
            eclipse = {
              downloadSources = true,
            },
            -- Enhanced decompiler configuration
            decompiler = {
              fernflower = {
                enabled = true,
              },
            },
            -- Enhanced source attachment
            sources = {
              organizeImports = {
                starThreshold = 9999,
                staticStarThreshold = 9999,
              },
            },
            configuration = {
              updateBuildConfiguration = "interactive",
              -- Enhanced JVM runtime support
              runtimes = {
                {
                  name = "JavaSE-21",
                  path = vim.fn.getenv("JAVA_HOME") or "/usr/lib/jvm/java-21-openjdk",
                },
                {
                  name = "JavaSE-17",
                  path = vim.fn.getenv("JAVA_HOME") or "/usr/lib/jvm/java-17-openjdk",
                },
                {
                  name = "JavaSE-11",
                  path = vim.fn.getenv("JAVA_HOME") or "/usr/lib/jvm/java-11-openjdk",
                },
                {
                  name = "JavaSE-1.8",
                  path = "/usr/lib/jvm/java-8-openjdk",
                },
              }
            },
            -- Enhanced build tool support
            compile = {
              nullAnalysis = {
                mode = "automatic",
              },
            },
            import = {
              maven = {
                enabled = true,
              },
              gradle = {
                enabled = true,
                wrapper = {
                  enabled = true,
                },
              },
            },
            maven = {
              downloadSources = true,
              downloadJavadoc = true,
            },
            implementationsCodeLens = {
              enabled = true,
            },
            referencesCodeLens = {
              enabled = true,
            },
            references = {
              includeDecompiledSources = true,
            },
            -- Enhanced source handling
            saveActions = {
              organizeImports = true,
            },
            maxConcurrentBuilds = 2,
            format = {
              enabled = true,
              settings = {
                url = vim.fn.stdpath("config") .. "/lang-servers/intellij-java-google-style.xml",
                profile = "GoogleStyle",
              },
            },
          },
          signatureHelp = { enabled = true },
          completion = {
            favoriteStaticMembers = {
              "org.hamcrest.MatcherAssert.assertThat",
              "org.hamcrest.Matchers.*",
              "org.hamcrest.CoreMatchers.*",
              "org.junit.jupiter.api.Assertions.*",
              "java.util.Objects.requireNonNull",
              "java.util.Objects.requireNonNullElse",
              "org.mockito.Mockito.*",
            },
            importOrder = {
              "java",
              "javax",
              "com",
              "org"
            },
          },
          contentProvider = {
            preferred = "fernflower",
            -- Re-enable decompilation for proper source navigation
            includeDecompiledSources = true,
          },
          sources = {
            organizeImports = {
              starThreshold = 9999,
              staticStarThreshold = 9999,
            },
          },
          extendedClientCapabilities = jdtls.extendedClientCapabilities,
          codeGeneration = {
            toString = {
              template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
            },
            useBlocks = true,
          },
        },

        flags = {
          allow_incremental_sync = true,
        },

        on_attach = on_attach,

        capabilities = require("cmp_nvim_lsp").default_capabilities(),

        -- Language server `initializationOptions`
        init_options = {
          bundles = {}
        },
      }

      -- This starts a new client & server,
      -- or attaches to an existing client & server depending on the `root_dir`.
      jdtls.start_or_attach(config)
    end

    -- Optimized Java file detection
    vim.api.nvim_create_autocmd("BufEnter", {
      pattern = "*.java",
      callback = function()
        -- Only start if not already attached
        local clients = vim.lsp.get_active_clients({name = "jdtls"})
        if #clients == 0 then
          vim.defer_fn(function()
            setup_jdtls()
          end, 500) -- Reduced delay
        end
      end,
    })

    -- Set up autocommands to configure JDTLS when opening JVM language files
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "java", "kotlin" },
      callback = function()
        local filetype = vim.bo.filetype
        -- Only start if not already running
        local clients = vim.lsp.get_active_clients({name = "jdtls"})
        if #clients > 0 then
          return -- Already running
        end

        if filetype == "java" then
          setup_jdtls()
        elseif filetype == "kotlin" then
          -- For Kotlin files, we'll use JDTLS if in a mixed project,
          -- otherwise fall back to kotlin_language_server
          local root_dir = jdtls_setup.find_root({
            "build.gradle", "build.gradle.kts", "pom.xml", ".git"
          })
          if root_dir then
            -- Check if this is a mixed Java/Kotlin project or pure Kotlin
            local has_java = vim.fn.glob(root_dir .. "/**/*.java") ~= ""
            if has_java or vim.fn.filereadable(root_dir .. "/build.gradle") == 1 or
               vim.fn.filereadable(root_dir .. "/build.gradle.kts") == 1 then
              -- Mixed or Gradle project - use JDTLS for better integration
              setup_jdtls()
            end
          end
        end
      end,
    })

    -- Additional autocmd for Android projects
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "java", "kotlin" },
      callback = function()
        local root_dir = jdtls_setup.find_root({
          "AndroidManifest.xml", "build.gradle", "settings.gradle"
        })
        if root_dir and vim.fn.filereadable(root_dir .. "/AndroidManifest.xml") == 1 then
          -- Android project detected - silent operation
          -- Enhanced JDTLS configuration is already active
        end
      end,
    })

    -- Add manual command to start JDTLS
    vim.api.nvim_create_user_command("JdtlsStart", function()
      setup_jdtls()
      vim.notify("JDTLS startup initiated", vim.log.levels.INFO)
    end, { desc = "Manually start JDTLS" })

    -- Add command to restart JDTLS
    vim.api.nvim_create_user_command("JdtlsRestart", function()
      vim.cmd("LspRestart jdtls")
      vim.notify("JDTLS restarted", vim.log.levels.INFO)
    end, { desc = "Restart JDTLS" })

    -- Enhanced .class file handling with decompilation support
    vim.api.nvim_create_autocmd("BufReadCmd", {
      pattern = "*.class",
      callback = function()
        local bufnr = vim.api.nvim_get_current_buf()
        local filename = vim.api.nvim_buf_get_name(bufnr)

        -- Show loading message first
        vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {
          "Loading decompiled source for: " .. vim.fn.fnamemodify(filename, ":t"),
          "",
          "Please wait while JDTLS decompiles the bytecode...",
          "",
          "If this takes too long, the source may not be available.",
        })

        -- Set filetype to java for syntax highlighting
        vim.bo[bufnr].filetype = 'java'
        vim.bo[bufnr].readonly = true

        -- Try to trigger JDTLS decompilation
        vim.schedule(function()
          -- Let JDTLS handle the decompilation
          local clients = vim.lsp.get_active_clients({name = "jdtls"})
          if #clients > 0 then
            -- JDTLS should automatically handle .class file decompilation
            -- Wait a moment then try to reload the buffer to trigger decompilation
            vim.defer_fn(function()
              vim.cmd("edit!")
            end, 1000)
          else
            -- Fallback if no JDTLS client
            vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {
              "// Could not decompile " .. vim.fn.fnamemodify(filename, ":t"),
              "//",
              "// JDTLS language server is not running.",
              "// Start JDTLS first, then try opening this file again.",
              "//",
              "// Run :JdtlsStart to manually start the language server",
              "//",
              "// File: " .. filename,
            })
          end
        end)
      end,
      desc = "Handle .class files with decompilation"
    })

    -- Enhanced error handling for LSP operations
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client.name == "jdtls" then
          -- Override handlers to suppress common errors
          local original_show_message = client.handlers["window/showMessage"] or function() end
          local original_log_message = client.handlers["window/logMessage"] or function() end

          client.handlers["window/showMessage"] = function(err, result, ctx, config)
            -- Suppress specific errors
            if result and result.message then
              if result.message:find("resolveMainClass") or
                 result.message:find("reloadBundles") or
                 result.message:find("not supported on client") then
                return -- Suppress these messages
              end
            end
            return original_show_message(err, result, ctx, config)
          end

          client.handlers["window/logMessage"] = function(err, result, ctx, config)
            -- Suppress verbose log messages
            if result and result.message then
              if result.message:find("reloadBundles") or
                 result.message:find("not supported on client") or
                 result.message:find("incubator modules") then
                return -- Suppress these log messages
              end
            end
            return original_log_message(err, result, ctx, config)
          end

          -- Add custom command handler to prevent unsupported command errors
          if not client.server_capabilities.executeCommandProvider then
            client.server_capabilities.executeCommandProvider = {
              commands = {}
            }
          end
        end
      end,
    })
  end,
}