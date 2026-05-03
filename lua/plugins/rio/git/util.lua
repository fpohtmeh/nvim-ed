local M = {}

local builtin = require("rio.callbacks.builtin")
local process = require("rio.process")

M.confirm = function(msg)
  return vim.fn.confirm(msg, "&Yes\n&No", 2) == 1
end

M.run_then_refresh = function(args, handle)
  process.spawn({
    cmd = args,
    cwd = handle.state.cwd,
    on_exit = function(code, _, stderr)
      if code ~= 0 then
        Snacks.notify.error(stderr)
        return
      end
      builtin.refresh().action(handle)
    end,
  })
end

return M
