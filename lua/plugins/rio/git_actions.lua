local M = {}
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
M.stage = {
  fn = function(handle)
    local path = parse.status_path_under_cursor(handle)
    if not path then
      return
    end
    H.run_then_refresh({ "git", "add", "--", path }, handle)
  end,
  desc = "stage",
}

---@type Rio.KeyDef
M.unstage = {
  fn = function(handle)
    local path = parse.status_path_under_cursor(handle)
    if not path then
      return
    end
    H.run_then_refresh({ "git", "restore", "--staged", "--", path }, handle)
  end,
  desc = "unstage",
}

---@type Rio.KeyDef
M.toggle = {
  fn = function(handle)
    local path = parse.status_path_under_cursor(handle)
    if not path then
      return
    end
    if parse.is_staged(path) then
      M.unstage.fn(handle)
    else
      M.stage.fn(handle)
    end
  end,
  desc = "toggle staged",
}

---@type Rio.KeyDef
M.commit = {
  fn = function(handle)
    local msg = vim.fn.input("Commit message: ")
    if msg == "" then
      return
    end
    H.run_then_refresh({ "git", "commit", "-m", msg }, handle)
  end,
  desc = "commit",
}

---@type Rio.KeyDef
M.amend = {
  fn = function(handle)
    local confirmed = vim.fn.confirm("Amend last commit?", "&Yes\n&No") == 1
    if not confirmed then
      return
    end
    H.run_then_refresh({ "git", "commit", "--amend", "--no-edit" }, handle)
  end,
  desc = "amend",
}

---@type Rio.KeyDef
M.stash_all = {
  fn = function(handle)
    local msg = vim.fn.input("Stash message: ")
    local args = { "git", "stash", "push" }
    if msg ~= "" then
      table.insert(args, "-m")
      table.insert(args, msg)
    end
    H.run_then_refresh(args, handle)
  end,
  desc = "stash all",
}

---@type Rio.KeyDef
M.stash_unstaged = {
  fn = function(handle)
    local msg = vim.fn.input("Stash message: ")
    local args = { "git", "stash", "push", "--keep-index" }
    if msg ~= "" then
      table.insert(args, "-m")
      table.insert(args, msg)
    end
    H.run_then_refresh(args, handle)
  end,
  desc = "stash unstaged",
}

---@type Rio.KeyDef
M.stash_staged = {
  fn = function(handle)
    local msg = vim.fn.input("Stash message: ")
    local args = { "git", "stash", "push", "--staged" }
    if msg ~= "" then
      table.insert(args, "-m")
      table.insert(args, msg)
    end
    H.run_then_refresh(args, handle)
  end,
  desc = "stash staged",
}

---@type Rio.KeyDef
M.discard = {
  fn = function(handle)
    local path = parse.status_path_under_cursor(handle)
    if not path then
      return
    end
    local confirmed = vim.fn.confirm("Discard changes to " .. path .. "?", "&Yes\n&No") == 1
    if not confirmed then
      return
    end
    H.run_then_refresh({ "git", "checkout", "--", path }, handle)
  end,
  desc = "discard",
}

return M
