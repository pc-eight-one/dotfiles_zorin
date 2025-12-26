-- Manual JDTLS startup script
-- Run with :luafile manual_jdtls.lua

print("Starting JDTLS manually...")

-- Check if we're in a Java file
if vim.bo.filetype ~= "java" then
  print("❌ Not in a Java file! Open a .java file first.")
  return
end

-- Check if jdtls plugin is available
local jdtls_ok, jdtls = pcall(require, "jdtls")
if not jdtls_ok then
  print("❌ nvim-jdtls plugin not loaded!")
  print("Check :Lazy to see if nvim-jdtls is installed")
  return
end

-- Check JDTLS installation
local mason_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls"
if vim.fn.isdirectory(mason_path) == 0 then
  print("❌ JDTLS not installed via Mason!")
  print("Run :Mason and install jdtls")
  return
end

-- Find workspace
local current_dir = vim.fn.expand("%:p:h")
local workspace_name = vim.fn.fnamemodify(current_dir, ":t")
local workspace_dir = vim.fn.expand("~/.local/share/eclipse/" .. workspace_name)

-- Create workspace directory if it doesn't exist
vim.fn.mkdir(workspace_dir, "p")

-- Get Java executable
local java_cmd = "java"
local java_home = vim.fn.getenv("JAVA_HOME")
if java_home and java_home ~= vim.NIL then
  java_cmd = java_home .. "/bin/java"
end

-- Simple JDTLS config
local config = {
  cmd = {
    java_cmd,
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.level=ALL",
    "-Xms256m",
    "-Xmx1G",
    "--add-modules=ALL-SYSTEM",
    "--add-opens", "java.base/java.util=ALL-UNNAMED",
    "--add-opens", "java.base/java.lang=ALL-UNNAMED",
    "-jar", vim.fn.glob(mason_path .. "/plugins/org.eclipse.jdt.ls.core_*.jar"),
    "-configuration", mason_path .. "/config_linux",
    "-data", workspace_dir,
  },
  root_dir = current_dir,
  settings = {
    java = {
      signatureHelp = { enabled = true },
    },
  },
  on_attach = function(client, bufnr)
    print("✅ JDTLS attached successfully!")

    -- Basic keymaps
    local opts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  end,
  capabilities = vim.lsp.protocol.make_client_capabilities(),
}

print("🚀 Starting JDTLS with config:")
print("  Java: " .. java_cmd)
print("  Workspace: " .. workspace_dir)
print("  Root: " .. current_dir)

jdtls.start_or_attach(config)

print("✅ JDTLS start command sent!")
print("Wait 10-30 seconds for initialization...")
print("Then check :LspInfo")