local M = {}
local H = {}

local rio = require("rio")
local util = require("plugins.rio.glab.util")

---@param user table?
---@return string
H.format_user = function(user)
  user = user or {}
  return (user.name or "?") .. " (" .. (user.username or "?") .. ")"
end

---@param iid string
---@return table?
H.fetch_approvals = function(iid)
  local out = vim.fn.system({ "glab", "api", "projects/:id/merge_requests/" .. iid .. "/approvals" })
  if vim.v.shell_error ~= 0 then
    return nil
  end
  local ok, data = pcall(vim.json.decode, out)
  if not ok then
    return nil
  end
  return data
end

---@param handle Rio.Handle
H.render = function(handle)
  local result = handle.result
  if not result or result.code ~= 0 then
    return
  end

  local ok, mr = pcall(vim.json.decode, result.stdout)
  if not ok or type(mr) ~= "table" then
    handle.state.lines = vim.split(result.stdout, "\n", { trimempty = true })
    return
  end

  local lines = { "Author:    " .. H.format_user(mr.author) }

  local approvals = H.fetch_approvals(tostring(mr.iid))
  local approved_by = approvals and approvals.approved_by or {}
  if #approved_by == 0 then
    table.insert(lines, "Approved:  (none)")
  else
    for i, entry in ipairs(approved_by) do
      local label = i == 1 and "Approved:  " or "           "
      table.insert(lines, label .. H.format_user(entry.user))
    end
  end

  table.insert(lines, "Squash:    " .. (mr.squash and "yes" or "no"))
  table.insert(lines, "Delete:    " .. (mr.force_remove_source_branch and "yes" or "no"))

  handle.state.lines = lines
end

---@param parent Rio.Handle
function M.show(parent)
  rio.run("glab api projects/:id/merge_requests/{iid}", {
    parent = parent,
    link = { key = "info" },
    resolver = { callbacks = util.notify_callbacks("loading MR info", H.render) },
  })
end

return M
