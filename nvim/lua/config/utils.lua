-- Utility functions for safer telescope operations
local M = {}

-- Enhanced safe telescope command wrapper with buffer validation
M.safe_telescope = function(command, opts)
  opts = opts or {}

  local success, telescope = pcall(require, "telescope.builtin")
  if not success then
    vim.notify("Telescope not available", vim.log.levels.ERROR)
    return
  end

  -- Pre-cleanup any invalid buffers before running telescope
  vim.schedule(function()
    local buffers = vim.api.nvim_list_bufs()
    for _, buf in ipairs(buffers) do
      if not M.is_valid_buffer(buf) then
        pcall(vim.api.nvim_buf_delete, buf, { force = true })
      end
    end
  end)

  -- Execute telescope command with enhanced error handling
  local cmd_success, result = pcall(function()
    return telescope[command](opts)
  end)

  if not cmd_success then
    vim.notify("Telescope command failed: " .. command, vim.log.levels.DEBUG)
    -- Enhanced fallbacks
    if command == "find_files" then
      vim.cmd("edit")
    elseif command == "live_grep" then
      vim.cmd("vimgrep //j **")
    elseif command == "buffers" then
      vim.cmd("ls")
    elseif command == "oldfiles" then
      vim.cmd("browse oldfiles")
    end
  end
  return result
end

-- Buffer validation helper
M.is_valid_buffer = function(bufnr)
  return bufnr and vim.api.nvim_buf_is_valid(bufnr) and vim.api.nvim_buf_is_loaded(bufnr)
end

-- Safe buffer operation wrapper
M.safe_buf_operation = function(bufnr, operation, ...)
  if not M.is_valid_buffer(bufnr) then
    return false
  end

  local success, result = pcall(operation, bufnr, ...)
  if not success then
    vim.notify("Buffer operation failed for buffer " .. bufnr, vim.log.levels.DEBUG)
    return false
  end
  return result
end

return M