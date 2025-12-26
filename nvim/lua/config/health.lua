-- Health check for configuration
local M = {}

M.check = function()
  -- Check if required plugins are available
  local plugins = {
    "telescope",
    "which-key",
    "nvim-lspconfig",
    "nvim-cmp",
    "Comment",
    "nvim-treesitter",
    "gitsigns",
  }

  for _, plugin in ipairs(plugins) do
    local ok, _ = pcall(require, plugin)
    if ok then
      vim.health.report_ok(plugin .. " is available")
    else
      vim.health.report_error(plugin .. " is not available")
    end
  end

  -- Check LSP servers
  local mason_ok, mason_registry = pcall(require, "mason-registry")
  if mason_ok then
    local servers = { "lua_ls", "tsserver", "pyright" }
    for _, server in ipairs(servers) do
      if mason_registry.is_installed(server) then
        vim.health.report_ok(server .. " LSP is installed")
      else
        vim.health.report_warn(server .. " LSP is not installed - run :Mason to install")
      end
    end
  end
end

return M