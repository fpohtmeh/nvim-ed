local M = {}
local H = {}

local parse = require("plugins.rio.git.parse")
local util = require("plugins.rio.git.util")

H.append_stash_message = function(args)
  local msg = vim.fn.input("Stash message: ")
  if msg ~= "" then
    table.insert(args, "-m")
    table.insert(args, msg)
  end
end

---@type Rio.KeyDef
M.stage = {
  action = function(handle)
    local path = parse.status_path_under_cursor(handle)
    if not path then
      return
    end
    util.run_then_refresh({ "git", "add", "--", path }, handle)
  end,
  desc = "stage",
  group = "Stage",
}

---@type Rio.KeyDef
M.unstage = {
  action = function(handle)
    local path = parse.status_path_under_cursor(handle)
    if not path then
      return
    end
    util.run_then_refresh({ "git", "restore", "--staged", "--", path }, handle)
  end,
  desc = "unstage",
  group = "Stage",
}

---@type Rio.KeyDef
M.toggle = {
  action = function(handle)
    local path = parse.status_path_under_cursor(handle)
    if not path then
      return
    end
    if parse.is_staged(path) then
      M.unstage.action(handle)
    else
      M.stage.action(handle)
    end
  end,
  desc = "toggle staged",
  group = "Stage",
}

---@type Rio.KeyDef
M.commit = {
  action = function(handle)
    local msg = vim.fn.input("Commit message: ")
    if msg == "" then
      return
    end
    util.run_then_refresh({ "git", "commit", "-m", msg }, handle)
  end,
  desc = "commit",
  group = "Commit",
}

---@type Rio.KeyDef
M.amend = {
  action = function(handle)
    if not util.confirm("Amend last commit?") then
      return
    end
    util.run_then_refresh({ "git", "commit", "--amend", "--no-edit" }, handle)
  end,
  desc = "amend",
  group = "Commit",
}

---@type Rio.KeyDef
M.stash_all = {
  action = function(handle)
    local args = { "git", "stash", "push" }
    H.append_stash_message(args)
    util.run_then_refresh(args, handle)
  end,
  desc = "stash all",
  group = "Stash",
}

---@type Rio.KeyDef
M.stash_unstaged = {
  action = function(handle)
    local args = { "git", "stash", "push", "--keep-index" }
    H.append_stash_message(args)
    util.run_then_refresh(args, handle)
  end,
  desc = "stash unstaged",
  group = "Stash",
}

---@type Rio.KeyDef
M.stash_staged = {
  action = function(handle)
    local args = { "git", "stash", "push", "--staged" }
    H.append_stash_message(args)
    util.run_then_refresh(args, handle)
  end,
  desc = "stash staged",
  group = "Stash",
}

---@type Rio.KeyDef
M.discard = {
  action = function(handle)
    local path = parse.status_path_under_cursor(handle)
    if not path then
      return
    end
    if not util.confirm("Discard changes to " .. path .. "?") then
      return
    end
    util.run_then_refresh({ "git", "checkout", "--", path }, handle)
  end,
  desc = "discard",
  group = "Stage",
}

---@type Rio.KeyDef
M.stage_all = {
  action = function(handle)
    util.run_then_refresh({ "git", "add", "." }, handle)
  end,
  desc = "stage all",
  group = "Stage",
}

---@type Rio.KeyDef
M.reset_staged = {
  action = function(handle)
    util.run_then_refresh({ "git", "reset", "." }, handle)
  end,
  desc = "reset staged",
  group = "Stage",
}

return M
