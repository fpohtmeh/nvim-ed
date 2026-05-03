local M = {}
local H = {}

local builtin = require("rio.callbacks.builtin")
local rio = require("rio")

H.refresh_parent = function(h)
  builtin.refresh().action(h.parent)
end

H.on_finish_resolver = function()
  return { builtin.notify_error, H.refresh_parent }
end

M.confirm = function(msg)
  return vim.fn.confirm(msg, "&Yes\n&No", 2) == 1
end

M.confirm_action = function(msg)
  return function()
    if not M.confirm(msg) then
      return false
    end
  end
end

M.run_then_refresh = function(cmd, handle, on_start)
  rio.run(cmd, {
    parent = handle,
    resolver = {
      callbacks = {
        on_start = on_start and function()
          return on_start
        end,
        on_finish = H.on_finish_resolver,
      },
    },
  })
end

M.is_staged = function(path)
  local out = vim.fn.systemlist({ "git", "status", "--porcelain", "--", path })
  if #out == 0 then
    return false
  end
  local x = out[1]:sub(1, 1)
  return x ~= " " and x ~= "?"
end

return M
