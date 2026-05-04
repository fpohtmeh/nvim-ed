local H = {}

local util = require("plugins.rio.git.util")
local win_builtin = require("rio.resolver.win.builtin")

---@type Rio.Parser
H.parser = {
  parse = function(param, handle)
    if param ~= "ref" then
      return nil
    end
    local cursor = vim.api.nvim_win_get_cursor(handle.state.win)
    local line = vim.api.nvim_buf_get_lines(handle.state.buf, cursor[1] - 1, cursor[1], false)[1]
    return line:match("^(stash@{%d+})")
  end,
}

---@type Rio.KeyDef
H.apply = {
  action = function(handle)
    util.run_then_refresh("git stash apply {ref}", handle)
  end,
  desc = "apply",
  group = "Stash",
}

---@type Rio.KeyDef
H.pop = {
  action = function(handle)
    util.run_then_refresh("git stash pop {ref}", handle, {
      util.confirm_action("Pop stash?"),
    })
  end,
  desc = "pop",
  group = "Stash",
}

---@type Rio.KeyDef
H.drop = {
  action = function(handle)
    util.run_then_refresh("git stash drop {ref}", handle, {
      util.confirm_action("Drop stash?"),
    })
  end,
  desc = "drop",
  group = "Stash",
}

return function()
  require("rio").run("git stash list", {
    resolver = {
      win = { win_builtin.reuse, win_builtin.current },
    },
    parsers = { H.parser },
    keys = {
      a = H.apply,
      P = H.pop,
      X = H.drop,
    },
  })
end
