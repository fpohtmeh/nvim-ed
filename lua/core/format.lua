local M = {}

function M.toggle(is_buf)
  return Snacks.toggle({
    name = "Auto Format (" .. (is_buf and "Buffer" or "Global") .. ")",
    get = function()
      return M.is_enabled(is_buf)
    end,
    set = function(enabled)
      M.set_enabled(enabled, is_buf)
    end,
  })
end

function M.is_enabled(is_buf)
  if is_buf then
    local is_enabled = vim.b.autoformat
    if is_enabled ~= nil then
      return is_enabled
    end
  end
  return vim.g.autoformat == nil or vim.g.autoformat
end

function M.set_enabled(enabled, is_buf)
  if is_buf then
    vim.b.autoformat = enabled
  else
    vim.g.autoformat = enabled
    vim.b.autoformat = nil
  end
end

function M.format(buf)
  if not M.is_enabled(buf) then
    return
  end

  require("conform").format({
    bufnr = buf,
    timeout_ms = 3000,
    lsp_format = "fallback",
    async = false,
    quiet = false,
  })
end

return M
