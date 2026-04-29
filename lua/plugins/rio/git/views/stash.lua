local H = {}

local parse = require("plugins.rio.git.parse")
local process = require("rio.process")
local util = require("plugins.rio.git.util")

---@type Rio.KeyDef
H.apply = {
  fn = function(handle)
    local ref = parse.stash_ref_under_cursor()
    if not ref then
      return
    end
    util.run_then_refresh({ "git", "stash", "apply", ref }, handle)
  end,
  desc = "apply",
}

---@type Rio.KeyDef
H.pop = {
  fn = function(handle)
    local ref = parse.stash_ref_under_cursor()
    if not ref then
      return
    end
    if not util.confirm("Pop " .. ref .. "?") then
      return
    end
    util.run_then_refresh({ "git", "stash", "pop", ref }, handle)
  end,
  desc = "pop",
}

---@type Rio.KeyDef
H.rename = {
  fn = function(handle)
    local ref = parse.stash_ref_under_cursor()
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
      cwd = vim.fn.getcwd(),
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
}

---@type Rio.KeyDef
H.drop = {
  fn = function(handle)
    local ref = parse.stash_ref_under_cursor()
    if not ref then
      return
    end
    if not util.confirm("Drop " .. ref .. "?") then
      return
    end
    util.run_then_refresh({ "git", "stash", "drop", ref }, handle)
  end,
  desc = "drop",
}

return function()
  require("rio").run("git stash list", {
    keys = {
      a = H.apply,
      R = H.rename,
      P = H.pop,
      X = H.drop,
    },
  })
end
