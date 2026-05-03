local H = {}

local process = require("rio.process")
local util = require("plugins.rio.git.util")

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
    local ref = H.parser.parse("ref", handle)
    if not ref then
      return
    end
    util.run_then_refresh({ "git", "stash", "apply", ref }, handle)
  end,
  desc = "apply",
  group = "Stash",
}

---@type Rio.KeyDef
H.pop = {
  action = function(handle)
    local ref = H.parser.parse("ref", handle)
    if not ref then
      return
    end
    if not util.confirm("Pop " .. ref .. "?") then
      return
    end
    util.run_then_refresh({ "git", "stash", "pop", ref }, handle)
  end,
  desc = "pop",
  group = "Stash",
}

---@type Rio.KeyDef
H.rename = {
  action = function(handle)
    local ref = H.parser.parse("ref", handle)
    if not ref then
      return
    end
    local msg = vim.fn.input("New stash message: ")
    if msg == "" then
      return
    end
    local hash = vim.fn.systemlist({ "git", "rev-parse", ref })[1]
    if not hash then
      return
    end
    process.spawn({
      cmd = { "git", "stash", "drop", ref },
      cwd = handle.state.cwd,
      on_exit = function(code, _, stderr)
        if code ~= 0 then
          Snacks.notify.error(stderr)
          return
        end
        util.run_then_refresh({ "git", "stash", "store", "-m", msg, hash }, handle)
      end,
    })
  end,
  desc = "rename",
  group = "Stash",
}

---@type Rio.KeyDef
H.drop = {
  action = function(handle)
    local ref = H.parser.parse("ref", handle)
    if not ref then
      return
    end
    if not util.confirm("Drop " .. ref .. "?") then
      return
    end
    util.run_then_refresh({ "git", "stash", "drop", ref }, handle)
  end,
  desc = "drop",
  group = "Stash",
}

return function()
  require("rio").run("git stash list", {
    parsers = { H.parser },
    keys = {
      a = H.apply,
      R = H.rename,
      P = H.pop,
      X = H.drop,
    },
  })
end
