return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  config = function()
    local wk = require("which-key")

    wk.setup({
      plugins = {
        marks = true,
        registers = true,
        spelling = {
          enabled = true,
          suggestions = 20,
        },
        presets = {
          operators = false,
          motions = true,
          text_objects = true,
          windows = true,
          nav = true,
          z = true,
          g = true,
        },
      },
      -- operators = { gc = "Comments" },
      icons = {
        breadcrumb = "»",
        separator = "➜",
        group = "+",
      },
      popup_mappings = {
        scroll_down = "<c-d>",
        scroll_up = "<c-u>",
      },
      window = {
        border = "rounded",
        position = "bottom",
        margin = { 1, 0, 1, 0 },
        padding = { 2, 2, 2, 2 },
        winblend = 0,
      },
      layout = {
        height = { min = 4, max = 25 },
        width = { min = 20, max = 50 },
        spacing = 3,
        align = "left",
      },
      ignore_missing = true,
      hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " },
      show_help = true,
      triggers = "auto",
      triggers_blacklist = {
        i = { "j", "k" },
        v = { "j", "k" },
      },
    })

    -- Register comprehensive IntelliJ-like key mappings
    wk.register({
      -- File operations (IntelliJ File menu)
      f = {
        name = "📁 File",
        f = { "<cmd>Telescope find_files<cr>", "Find Files (Ctrl+N)" },
        r = { "<cmd>Telescope oldfiles<cr>", "Recent Files (Ctrl+E)" },
        s = { "<cmd>Telescope live_grep<cr>", "Search in Files (Ctrl+Shift+F)" },
        c = { "<cmd>Telescope grep_string<cr>", "Find String Under Cursor" },
        b = { "<cmd>Telescope file_browser<cr>", "File Browser" },
        n = { "<cmd>enew<cr>", "New File" },
        w = { "<cmd>Telescope grep_string<cr>", "Find Word Under Cursor" },
        h = { "<cmd>Telescope help_tags<cr>", "Help Tags" },
        k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
        j = { "<cmd>Telescope jumplist<cr>", "Jumplist" },
        m = { "<cmd>Telescope marks<cr>", "Marks" },
        q = { "<cmd>Telescope quickfix<cr>", "Quickfix" },
        l = { "<cmd>Telescope loclist<cr>", "Location List" },
      },

      -- Buffer operations (IntelliJ Tab management)
      b = {
        name = "📄 Buffer",
        b = { "<cmd>Telescope buffers<cr>", "Switch Buffers" },
        d = { "<cmd>bd<cr>", "Delete Buffer (Ctrl+W)" },
        n = { "<cmd>bnext<cr>", "Next Buffer (Ctrl+Tab)" },
        p = { "<cmd>bprevious<cr>", "Previous Buffer (Ctrl+Shift+Tab)" },
        a = { "<cmd>%bd|e#<cr>", "Close All But Current" },
        f = { "<cmd>bfirst<cr>", "First Buffer" },
        l = { "<cmd>blast<cr>", "Last Buffer" },
      },

      -- LSP operations (IntelliJ Code intelligence)
      l = {
        name = "🧠 LSP",
        d = { "<cmd>lua vim.lsp.buf.definition()<cr>", "Go to Definition (Ctrl+B)" },
        D = { "<cmd>lua vim.lsp.buf.declaration()<cr>", "Go to Declaration" },
        r = { "<cmd>Telescope lsp_references<cr>", "References (Alt+F7)" },
        R = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename (Shift+F6)" },
        h = { "<cmd>lua vim.lsp.buf.hover()<cr>", "Hover Documentation (Ctrl+Q)" },
        i = { "<cmd>lua vim.lsp.buf.implementation()<cr>", "Implementation (Ctrl+Alt+B)" },
        s = { "<cmd>lua vim.lsp.buf.signature_help()<cr>", "Signature Help (Ctrl+P)" },
        t = { "<cmd>lua vim.lsp.buf.type_definition()<cr>", "Type Definition" },
        a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action (Alt+Enter)" },
        f = { "<cmd>lua vim.lsp.buf.format()<cr>", "Format Code (Ctrl+Alt+L)" },
        w = { "<cmd>lua vim.lsp.buf.workspace_symbol()<cr>", "Workspace Symbols" },
        e = { "<cmd>lua vim.diagnostic.open_float()<cr>", "Show Line Diagnostics" },
        n = { "<cmd>lua vim.diagnostic.goto_next()<cr>", "Next Diagnostic (F2)" },
        p = { "<cmd>lua vim.diagnostic.goto_prev()<cr>", "Previous Diagnostic (Shift+F2)" },
        q = { "<cmd>lua vim.diagnostic.setloclist()<cr>", "Diagnostics to Location List" },
      },

      -- Git operations (IntelliJ VCS)
      g = {
        name = "🔀 Git",
        s = { "<cmd>Git<cr>", "Git Status (Ctrl+K for commit)" },
        b = { "<cmd>Git blame<cr>", "Git Blame" },
        d = { "<cmd>Gdiffsplit<cr>", "Git Diff" },
        l = { "<cmd>Git log<cr>", "Git Log" },
        p = { "<cmd>Git push<cr>", "Git Push (Ctrl+Shift+K)" },
        P = { "<cmd>Git pull<cr>", "Git Pull (Ctrl+T)" },
        c = { "<cmd>Git commit<cr>", "Git Commit" },
        a = { "<cmd>Git add .<cr>", "Git Add All" },
        r = { "<cmd>Git reset<cr>", "Git Reset" },
        R = { "<cmd>Git checkout -- %<cr>", "Rollback Changes (Ctrl+Alt+Z)" },
        h = {
          name = "🔍 Hunks",
          s = { "<cmd>Gitsigns stage_hunk<cr>", "Stage Hunk" },
          r = { "<cmd>Gitsigns reset_hunk<cr>", "Reset Hunk" },
          u = { "<cmd>Gitsigns undo_stage_hunk<cr>", "Undo Stage Hunk" },
          p = { "<cmd>Gitsigns preview_hunk<cr>", "Preview Hunk" },
          b = { "<cmd>Gitsigns blame_line<cr>", "Blame Line" },
          d = { "<cmd>Gitsigns diffthis<cr>", "Diff This" },
          D = { "<cmd>Gitsigns diffthis ~<cr>", "Diff This ~" },
        },
      },

      -- Code operations (IntelliJ Code menu)
      c = {
        name = "💻 Code",
        c = { "<cmd>lua require('Comment.api').toggle.linewise.current()<cr>", "Comment Line (Ctrl+/)" },
        b = { "<cmd>lua require('Comment.api').toggle.blockwise.current()<cr>", "Comment Block (Ctrl+Shift+/)" },
        f = { "<cmd>lua vim.lsp.buf.format()<cr>", "Format Code (Ctrl+Alt+L)" },
        r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename Symbol (Shift+F6)" },
        a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Actions (Alt+Enter)" },
        i = { "gg=G``", "Auto Indent File (Ctrl+Alt+I)" },
        u = { "<cmd>lua vim.lsp.buf.references()<cr>", "Find Usages (Alt+F7)" },
        h = { "<cmd>lua vim.lsp.buf.hover()<cr>", "Quick Documentation (Ctrl+Q)" },
        d = { "<cmd>lua vim.lsp.buf.definition()<cr>", "Go to Definition (Ctrl+B)" },
      },

      -- Window management (IntelliJ Window menu)
      w = {
        name = "🪟 Window",
        v = { "<cmd>vsplit<cr>", "Vertical Split" },
        s = { "<cmd>split<cr>", "Horizontal Split" },
        h = { "<C-w>h", "Go to Left Window" },
        j = { "<C-w>j", "Go to Lower Window" },
        k = { "<C-w>k", "Go to Upper Window" },
        l = { "<C-w>l", "Go to Right Window" },
        q = { "<cmd>close<cr>", "Close Window" },
        o = { "<cmd>only<cr>", "Only This Window" },
        e = { "<C-w>=", "Equal Windows" },
      },

      -- Tab management (IntelliJ Tabs)
      t = {
        name = "📑 Tabs",
        o = { "<cmd>tabnew<cr>", "New Tab" },
        x = { "<cmd>tabclose<cr>", "Close Tab" },
        n = { "<cmd>tabnext<cr>", "Next Tab (Ctrl+Tab)" },
        p = { "<cmd>tabprevious<cr>", "Previous Tab (Ctrl+Shift+Tab)" },
        f = { "<cmd>tabnew %<cr>", "Open Current Buffer in New Tab" },
        ["1"] = { "1gt", "Go to Tab 1" },
        ["2"] = { "2gt", "Go to Tab 2" },
        ["3"] = { "3gt", "Go to Tab 3" },
        ["4"] = { "4gt", "Go to Tab 4" },
        ["5"] = { "5gt", "Go to Tab 5" },
      },

      -- Search operations (IntelliJ Search menu)
      s = {
        name = "🔍 Search",
        f = { "<cmd>Telescope live_grep<cr>", "Find in Files (Ctrl+Shift+F)" },
        w = { "<cmd>Telescope grep_string<cr>", "Find Word Under Cursor" },
        r = { "<cmd>Telescope resume<cr>", "Resume Last Search" },
        h = { "<cmd>Telescope help_tags<cr>", "Help Tags" },
        k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
        a = { "<cmd>Telescope commands<cr>", "Find Action/Commands (Ctrl+Shift+A)" },
        c = { "<cmd>Telescope commands<cr>", "Commands" },
        b = { "<cmd>Telescope buffers<cr>", "Buffers" },
        ["<C-h>"] = { "<cmd>Telescope command_history<cr>", "Command History" },
      },

      -- Trouble/Problems window
      x = {
        name = "❗ Trouble",
        x = { "<cmd>TroubleToggle<cr>", "Toggle Trouble" },
        w = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "Workspace Diagnostics (Alt+6)" },
        d = { "<cmd>TroubleToggle document_diagnostics<cr>", "Document Diagnostics" },
        l = { "<cmd>TroubleToggle loclist<cr>", "Location List" },
        q = { "<cmd>TroubleToggle quickfix<cr>", "Quickfix List" },
      },

      -- Multi-cursor operations (IntelliJ-like)
      m = {
        name = "🎯 Multi-Cursor",
        j = { "<Plug>(VM-Find-Under)", "Add Next Occurrence (Alt+J)" },
        k = { "<Plug>(VM-Find-Subword-Under)", "Add Next Word (Alt+Shift+J)" },
        a = { "<Plug>(VM-Select-All)", "Select All Occurrences (Ctrl+Alt+Shift+J)" },
        s = { "<Plug>(VM-Skip-Region)", "Skip Current (Alt+Shift+K)" },
        x = { "<Plug>(VM-Remove-Region)", "Remove Current Selection" },
        n = { "<Plug>(VM-Goto-Next)", "Next Cursor" },
        p = { "<Plug>(VM-Goto-Prev)", "Previous Cursor" },
        c = { "<Plug>(VM-Add-Cursor-Down)", "Add Cursor Below" },
        u = { "<Plug>(VM-Add-Cursor-Up)", "Add Cursor Above" },
        v = { "<Plug>(VM-Toggle-Block)", "Toggle Column Mode" },
        r = { "<Plug>(VM-Visual-Regex)", "Visual Regex Selection" },
        e = { "<Plug>(VM-Exit)", "Exit Multi-Cursor Mode" },
      },

      -- Utility operations
      u = {
        name = "🔧 Utility",
        r = { "<cmd>nohlsearch<bar>diffupdate<bar>normal! <C-L><cr>", "Redraw Screen" },
        h = { "<cmd>nohlsearch<cr>", "Clear Highlights" },
      },

      -- Quit operations
      q = {
        name = "🚪 Quit",
        q = { "<cmd>q<cr>", "Quit" },
        Q = { "<cmd>q!<cr>", "Quit Without Saving" },
        w = { "<cmd>wq<cr>", "Save and Quit" },
        a = { "<cmd>qa<cr>", "Quit All" },
      },

      -- JVM Development (Java/Kotlin/Scala - IntelliJ-style)
      j = {
        name = "☕ JVM Languages",
        -- Java operations
        o = { "<cmd>lua require('jdtls').organize_imports()<cr>", "Organize Imports (Alt+Shift+O)" },
        v = { "<cmd>lua require('jdtls').extract_variable()<cr>", "Extract Variable" },
        c = { "<cmd>lua require('jdtls').extract_constant()<cr>", "Extract Constant" },
        m = { "<cmd>lua require('jdtls').extract_method(true)<cr>", "Extract Method" },
        t = { "<cmd>lua require('jdtls').test_class()<cr>", "Test Class" },
        n = { "<cmd>lua require('jdtls').test_nearest_method()<cr>", "Test Nearest Method" },
        r = { "<cmd>JdtRefresh<cr>", "Refresh Workspace" },
        s = { "<cmd>JdtSetRuntime<cr>", "Set Java Runtime" },

        -- Build operations (Gradle/Maven/SBT)
        b = {
          name = "🔨 Build",
          c = { "<cmd>!./gradlew build<cr>", "Gradle Build" },
          t = { "<cmd>!./gradlew test<cr>", "Gradle Test" },
          r = { "<cmd>!./gradlew run<cr>", "Gradle Run" },
          m = { "<cmd>!mvn compile<cr>", "Maven Compile" },
          p = { "<cmd>!mvn package<cr>", "Maven Package" },
          s = { "<cmd>!sbt compile<cr>", "SBT Compile" },
        },

        -- Scala specific (when using Metals)
        S = {
          name = "🎯 Scala",
          c = { "<cmd>MetalsCompile<cr>", "Metals Compile" },
          i = { "<cmd>MetalsImportBuild<cr>", "Import Build" },
          w = { "<cmd>MetalsNewWorksheet<cr>", "New Worksheet" },
        },
      },

      -- Explorer
      e = {
        name = "🗂️ Explorer",
        e = { "<cmd>NvimTreeToggle<cr>", "Toggle File Explorer (Alt+1)" },
        f = { "<cmd>NvimTreeFindFileToggle<cr>", "Find File in Explorer" },
        c = { "<cmd>NvimTreeCollapse<cr>", "Collapse Explorer" },
        r = { "<cmd>NvimTreeRefresh<cr>", "Refresh Explorer" },
      },
    }, { prefix = "<leader>" })

    -- Register ALT key tool windows (IntelliJ Alt+Number shortcuts)
    wk.register({
      ["<A-1>"] = { "<cmd>NvimTreeToggle<cr>", "Project Tool Window" },
      ["<A-3>"] = { "<cmd>Telescope current_buffer_fuzzy_find<cr>", "Find Tool Window" },
      ["<A-4>"] = { "<cmd>terminal<cr>", "Run Tool Window" },
      ["<A-6>"] = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "Problems Tool Window" },
      ["<A-7>"] = { "<cmd>Telescope lsp_document_symbols<cr>", "Structure Tool Window" },
      ["<A-9>"] = { "<cmd>Git<cr>", "Version Control Tool Window" },
      ["<A-F12>"] = { "<cmd>terminal<cr>", "Terminal Tool Window" },
    })

    -- Register Function keys (IntelliJ F-key shortcuts)
    wk.register({
      ["<F2>"] = { "<cmd>lua vim.diagnostic.goto_next()<cr>", "Next Error" },
      ["<S-F2>"] = { "<cmd>lua vim.diagnostic.goto_prev()<cr>", "Previous Error" },
      ["<F3>"] = { "n", "Find Next" },
      ["<S-F3>"] = { "N", "Find Previous" },
      ["<C-F3>"] = { "*", "Find Word at Cursor" },
      ["<S-F6>"] = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename Symbol" },
      ["<F11>"] = { "ma", "Toggle Bookmark" },
      ["<S-F11>"] = { ":marks<cr>", "Show Bookmarks" },
      ["<C-F12>"] = { "<cmd>Telescope lsp_document_symbols<cr>", "File Structure" },
    })

    -- Register Ctrl key shortcuts (IntelliJ Ctrl shortcuts)
    wk.register({
      ["<C-n>"] = { "<cmd>Telescope find_files<cr>", "Go to Class/File" },
      ["<C-e>"] = { "<cmd>Telescope oldfiles<cr>", "Recent Files" },
      ["<C-f>"] = { "/", "Find in Current File" },
      ["<C-g>"] = { ":<C-u>call inputsave()<Bar>let line = input('Go to line: ')<Bar>call inputrestore()<Bar>exec 'normal! ' . line . 'G'<CR>", "Go to Line" },
      ["<C-b>"] = { "<cmd>lua vim.lsp.buf.definition()<cr>", "Go to Declaration/Definition" },
      ["<C-q>"] = { "<cmd>lua vim.lsp.buf.hover()<cr>", "Quick Documentation" },
      ["<C-p>"] = { "<cmd>lua vim.lsp.buf.signature_help()<cr>", "Parameter Info" },
      ["<C-s>"] = { "<cmd>w<cr>", "Save File" },
      ["<C-y>"] = { "dd", "Delete Line" },
      ["<C-d>"] = { "yyp", "Duplicate Line" },
      ["<C-w>"] = { "<cmd>bd<cr>", "Close Buffer/Tab" },
      ["<C-z>"] = { "u", "Undo" },
      ["<C-a>"] = { "ggVG", "Select All" },
      ["<C-S-a>"] = { "<cmd>Telescope commands<cr>", "Find Action (IntelliJ Command Palette)" },
    })

    -- Register Alt key shortcuts for Java (IntelliJ-style)
    wk.register({
      ["<A-S-o>"] = { "<cmd>lua require('jdtls').organize_imports()<cr>", "Organize Imports (Java)" },
    })
  end,
}