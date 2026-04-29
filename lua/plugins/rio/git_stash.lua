local H = {}

local builtin = require("rio.callbacks.builtin")
local parse = require("plugins.rio.git_parse")
local process = require("rio.process")

H.run_then_refresh = function(args, handle)
  process.spawn({
    cmd = args,
    cwd = vim.fn.getcwd(),
    on_exit = function(code, _, stderr)
      if code ~= 0 then
        vim.notify(stderr, vim.log.levels.ERROR)
        return
      end
      builtin.refresh().fn(handle)
    end,
  })
end

---@type Rio.KeyDef
H.apply = {
  fn = function(handle)
    local ref = parse.stash_ref_under_cursor()
    if not ref then
      return
    end
    H.run_then_refresh({ "git", "stash", "apply", ref }, handle)
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
    local confirmed = vim.fn.confirm("Pop " .. ref .. "?", "&Yes\n&No") == 1
    if not confirmed then
      return
    end
    H.run_then_refresh({ "git", "stash", "pop", ref }, handle)
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
          vim.notify(stderr, vim.log.levels.ERROR)
          return
        end
        H.run_then_refresh({ "git", "stash", "store", "-m", msg, hash }, handle)
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
    local confirmed = vim.fn.confirm("Drop " .. ref .. "?", "&Yes\n&No") == 1
    if not confirmed then
      return
    end
    H.run_then_refresh({ "git", "stash", "drop", ref }, handle)
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
