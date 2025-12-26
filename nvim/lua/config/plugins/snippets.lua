return {
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets",
      "honza/vim-snippets",
    },
    build = "make install_jsregexp",
    event = "InsertEnter",
    config = function()
      local luasnip = require("luasnip")
      local types = require("luasnip.util.types")

      luasnip.setup({
        history = true,
        delete_check_events = "TextChanged",
        update_events = "TextChanged,TextChangedI",
        enable_autosnippets = true,
        store_selection_keys = "<Tab>",
        ext_opts = {
          [types.choiceNode] = {
            active = {
              virt_text = { { "choiceNode", "Comment" } },
            },
          },
        },
      })

      -- Load VSCode-style snippets
      require("luasnip.loaders.from_vscode").lazy_load()
      -- Load Snipmate-style snippets
      require("luasnip.loaders.from_snipmate").lazy_load()

      -- Custom IntelliJ-like snippets
      local s = luasnip.snippet
      local t = luasnip.text_node
      local i = luasnip.insert_node
      local f = luasnip.function_node
      local c = luasnip.choice_node
      local d = luasnip.dynamic_node
      local sn = luasnip.snippet_node

      -- Helper function to get current date
      local function get_date()
        return os.date("%Y-%m-%d")
      end

      -- Helper function to get current time
      local function get_time()
        return os.date("%H:%M:%S")
      end

      -- Helper function to get filename
      local function get_filename()
        local name = vim.fn.expand("%:t:r")
        if name == "" then
          return "ClassName"
        end
        return name
      end

      -- Java snippets (IntelliJ-like)
      luasnip.add_snippets("java", {
        s("class", {
          t("public class "), f(get_filename, {}), t({" {", "    "}),
          i(1, "// TODO: Implement"),
          t({"", "}"})
        }),
        s("main", {
          t({"public static void main(String[] args) {", "    "}),
          i(1, "// TODO: Implement"),
          t({"", "}"})
        }),
        s("sout", {
          t("System.out.println("), i(1, ""), t(");")
        }),
        s("psvm", {
          t({"public static void main(String[] args) {", "    "}),
          i(1, ""),
          t({"", "}"})
        }),
        s("fori", {
          t("for (int "), i(1, "i"), t(" = "), i(2, "0"), t("; "),
          f(function(args) return args[1][1] end, {1}), t(" < "), i(3, "length"),
          t("; "), f(function(args) return args[1][1] end, {1}), t({"++) {", "    "}),
          i(4, "// TODO: Implement"),
          t({"", "}"})
        }),
        s("iter", {
          t("for ("), i(1, "Object"), t(" "), i(2, "item"), t(" : "), i(3, "collection"), t({") {", "    "}),
          i(4, "// TODO: Implement"),
          t({"", "}"})
        }),
        s("itar", {
          t("for (int "), i(1, "i"), t(" = 0; "),
          f(function(args) return args[1][1] end, {1}), t(" < "), i(2, "array"), t(".length; "),
          f(function(args) return args[1][1] end, {1}), t({"++) {", "    "}),
          i(3, "// TODO: Implement"),
          t({"", "}"})
        }),
        s("ify", {
          t("if ("), i(1, "condition"), t({") {", "    "}),
          i(2, "// TODO: Implement"),
          t({"", "}"})
        }),
        s("ifn", {
          t("if ("), i(1, "object"), t({" != null) {", "    "}),
          i(2, "// TODO: Implement"),
          t({"", "}"})
        }),
        s("inst", {
          t("if ("), i(1, "object"), t(" instanceof "), i(2, "Class"), t({") {", "    "}),
          i(3, "// TODO: Implement"),
          t({"", "}"})
        }),
        s("try", {
          t({"try {", "    "}), i(1, "// TODO: Implement"),
          t({"", "} catch ("}), i(2, "Exception"), t(" "), i(3, "e"), t({") {", "    "}),
          i(4, "// TODO: Handle exception"),
          t({"", "}"})
        }),
      })

      -- JavaScript/TypeScript snippets
      luasnip.add_snippets("javascript", {
        s("cl", {
          t("console.log("), i(1, ""), t(");")
        }),
        s("clg", {
          t("console.log("), i(1, ""), t(");")
        }),
        s("fun", {
          t("function "), i(1, "name"), t("("), i(2, "params"), t({") {", "    "}),
          i(3, "// TODO: Implement"),
          t({"", "}"})
        }),
        s("af", {
          t("("), i(1, "params"), t(") => {", "    "),
          i(2, "// TODO: Implement"),
          t({"", "}"})
        }),
        s("iife", {
          t({"(function() {", "    "}),
          i(1, "// TODO: Implement"),
          t({"", "})();"})
        }),
        s("req", {
          t("const "), i(1, "module"), t(" = require('"), i(2, "module"), t("');")
        }),
        s("imp", {
          t("import "), i(1, "module"), t(" from '"), i(2, "module"), t("';")
        }),
        s("exp", {
          t("export "), c(1, {t("default "), t("")}), i(2, "module"), t(";")
        }),
        s("desc", {
          t("describe('"), i(1, "description"), t({"', () => {", "    "}),
          i(2, "// TODO: Implement tests"),
          t({"", "});"})
        }),
        s("it", {
          t("it('"), i(1, "should do something"), t({"', () => {", "    "}),
          i(2, "// TODO: Implement test"),
          t({"", "});"})
        }),
      })

      luasnip.add_snippets("typescript", {
        s("int", {
          t("interface "), i(1, "Name"), t({" {", "    "}),
          i(2, "// TODO: Define interface"),
          t({"", "}"})
        }),
        s("type", {
          t("type "), i(1, "Name"), t(" = "), i(2, "string"), t(";")
        }),
        s("enum", {
          t("enum "), i(1, "Name"), t({" {", "    "}),
          i(2, "// TODO: Define enum values"),
          t({"", "}"})
        }),
        s("class", {
          t("class "), i(1, "Name"), t({" {", "    constructor("}), i(2, ""), t({") {", "        "}),
          i(3, "// TODO: Implement constructor"),
          t({"", "    }", ""});
          i(4, "// TODO: Add methods"),
          t({"", "}"})
        }),
      })

      -- Python snippets
      luasnip.add_snippets("python", {
        s("def", {
          t("def "), i(1, "function_name"), t("("), i(2, ""), t({"):", "    "}),
          i(3, "pass")
        }),
        s("class", {
          t("class "), i(1, "ClassName"), t({":", "    def __init__(self"}), i(2, ""), t({"):", "        "}),
          i(3, "pass")
        }),
        s("if", {
          t("if "), i(1, "condition"), t({":", "    "}),
          i(2, "pass")
        }),
        s("for", {
          t("for "), i(1, "item"), t(" in "), i(2, "iterable"), t({":", "    "}),
          i(3, "pass")
        }),
        s("try", {
          t({"try:", "    "}), i(1, "pass"),
          t({"", "except "}), i(2, "Exception"), t(" as "), i(3, "e"), t({":", "    "}),
          i(4, "pass")
        }),
        s("main", {
          t({"if __name__ == '__main__':", "    "}),
          i(1, "pass")
        }),
      })

      -- HTML snippets
      luasnip.add_snippets("html", {
        s("html5", {
          t({"<!DOCTYPE html>", "<html lang=\"en\">", "<head>", "    <meta charset=\"UTF-8\">",
            "    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">",
            "    <title>"}), i(1, "Document"), t({"</title>", "</head>", "<body>", "    "}),
          i(2, "<!-- Content -->"),
          t({"", "</body>", "</html>"})
        }),
        s("div", {
          t("<div"), c(1, {t(""), t(" class=\""), t(" id=\"")}),
          c(2, {t(""), i(1, "name"), i(2, "name")}),
          c(3, {t(""), t("\"")}), t(">"),
          i(4, ""), t("</div>")
        }),
        s("link", {
          t("<link rel=\"stylesheet\" href=\""), i(1, "style.css"), t("\">")
        }),
        s("script", {
          t("<script src=\""), i(1, "script.js"), t("\"></script>")
        }),
      })

      -- CSS snippets
      luasnip.add_snippets("css", {
        s("flex", {
          t({"display: flex;", "justify-content: "}), i(1, "center"), t({";", "align-items: "}), i(2, "center"), t(";")
        }),
        s("grid", {
          t({"display: grid;", "grid-template-columns: "}), i(1, "repeat(auto-fit, minmax(200px, 1fr))"), t({";", "gap: "}), i(2, "1rem"), t(";")
        }),
        s("media", {
          t("@media ("), i(1, "max-width: 768px"), t({") {", "    "}),
          i(2, "/* Styles */"),
          t({"", "}"})
        }),
      })

      -- Lua snippets
      luasnip.add_snippets("lua", {
        s("fun", {
          t("function "), i(1, "name"), t("("), i(2, ""), t({")", "    "}),
          i(3, "-- TODO: Implement"),
          t({"", "end"})
        }),
        s("local", {
          t("local "), i(1, "variable"), t(" = "), i(2, "value")
        }),
        s("req", {
          t("local "), i(1, "module"), t(" = require(\""), f(function(args) return args[1][1] end, {1}), t("\")")
        }),
        s("if", {
          t("if "), i(1, "condition"), t({" then", "    "}),
          i(2, "-- TODO: Implement"),
          t({"", "end"})
        }),
        s("for", {
          t("for "), i(1, "i"), t(" = "), i(2, "1"), t(", "), i(3, "10"), t({" do", "    "}),
          i(4, "-- TODO: Implement"),
          t({"", "end"})
        }),
      })

      -- Markdown snippets
      luasnip.add_snippets("markdown", {
        s("h1", {
          t("# "), i(1, "Heading 1")
        }),
        s("h2", {
          t("## "), i(1, "Heading 2")
        }),
        s("h3", {
          t("### "), i(1, "Heading 3")
        }),
        s("link", {
          t("["), i(1, "text"), t("]("), i(2, "url"), t(")")
        }),
        s("img", {
          t("!["), i(1, "alt text"), t("]("), i(2, "image url"), t(")")
        }),
        s("code", {
          t("```"), i(1, "language"), t({"", ""}), i(2, "code"), t({"", "```"})
        }),
        s("table", {
          t({"| "}), i(1, "Header 1"), t(" | "), i(2, "Header 2"), t({" |", "|----------|----------|", "| "}),
          i(3, "Cell 1"), t(" | "), i(4, "Cell 2"), t({" |", "| "}),
          i(5, "Cell 3"), t(" | "), i(6, "Cell 4"), t(" |")
        }),
      })

      -- IntelliJ-like keymaps for snippets
      local keymap = vim.keymap

      -- Ctrl+J to insert live template (IntelliJ shortcut)
      keymap.set("i", "<C-j>", function()
        if luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        end
      end, { desc = "Expand or jump snippet" })

      keymap.set("s", "<C-j>", function()
        if luasnip.jumpable(1) then
          luasnip.jump(1)
        end
      end, { desc = "Jump to next snippet node" })

      -- Ctrl+Shift+J to jump backwards
      keymap.set("i", "<C-S-j>", function()
        if luasnip.jumpable(-1) then
          luasnip.jump(-1)
        end
      end, { desc = "Jump to previous snippet node" })

      keymap.set("s", "<C-S-j>", function()
        if luasnip.jumpable(-1) then
          luasnip.jump(-1)
        end
      end, { desc = "Jump to previous snippet node" })

      -- Tab and Shift-Tab for navigation (alternative to Ctrl+J)
      keymap.set("i", "<Tab>", function()
        if luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        else
          return "<Tab>"
        end
      end, { expr = true, desc = "Expand or jump snippet" })

      keymap.set("s", "<Tab>", function()
        if luasnip.jumpable(1) then
          luasnip.jump(1)
        end
      end, { desc = "Jump to next snippet node" })

      keymap.set("i", "<S-Tab>", function()
        if luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          return "<S-Tab>"
        end
      end, { expr = true, desc = "Jump to previous snippet node" })

      keymap.set("s", "<S-Tab>", function()
        if luasnip.jumpable(-1) then
          luasnip.jump(-1)
        end
      end, { desc = "Jump to previous snippet node" })

      -- Ctrl+L to select choice
      keymap.set("i", "<C-l>", function()
        if luasnip.choice_active() then
          luasnip.change_choice(1)
        end
      end, { desc = "Select next choice" })

      keymap.set("s", "<C-l>", function()
        if luasnip.choice_active() then
          luasnip.change_choice(1)
        end
      end, { desc = "Select next choice" })
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-emoji",
      "f3fora/cmp-spell",
      "hrsh7th/cmp-calc",
    },
    event = { "InsertEnter", "CmdlineEnter" },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          -- IntelliJ-like completion mappings
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = false }),

          -- Navigation (IntelliJ-like)
          ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<Down>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<Up>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),

          -- Scrolling documentation
          ["<C-d>"] = cmp.mapping.scroll_docs(4),
          ["<C-u>"] = cmp.mapping.scroll_docs(-4),

          -- Tab and Shift-Tab for completion and snippets
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),

          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp", priority = 1000 },
          { name = "luasnip", priority = 750 },
          { name = "buffer", priority = 500 },
          { name = "path", priority = 250 },
          { name = "emoji", priority = 100 },
          { name = "calc", priority = 100 },
          { name = "spell", priority = 50 },
        }),
        formatting = {
          format = lspkind.cmp_format({
            mode = "symbol_text",
            maxwidth = 50,
            ellipsis_char = "...",
            before = function(entry, vim_item)
              -- Add source name to the completion item
              vim_item.menu = ({
                nvim_lsp = "[LSP]",
                luasnip = "[Snippet]",
                buffer = "[Buffer]",
                path = "[Path]",
                emoji = "[Emoji]",
                calc = "[Calc]",
                spell = "[Spell]",
              })[entry.source.name]
              return vim_item
            end,
          }),
        },
        experimental = {
          ghost_text = true,
        },
      })

      -- Command line completion
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" }
        }
      })

      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" }
        }, {
          { name = "cmdline" }
        })
      })
    end,
  },
}