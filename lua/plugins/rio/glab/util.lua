local M = {}
local H = {}

local builtin = require("rio.callbacks.builtin")
local rio = require("rio")
local git_util = require("plugins.rio.git.util")

---@param label string
---@return Rio.Action
M.notify_start = function(label)
  return function()
    Snacks.notify.info("glab " .. label .. "…", { id = "glab-" .. label, title = "[rio]", timeout = false })
  end
end

---@param label string
---@return Rio.Action
M.notify_finish = function(label)
  return function(handle)
    local result = handle.result
    if result.code ~= 0 then
      local msg = (result.stderr ~= "" and result.stderr or result.stdout):gsub("%s+$", "")
      Snacks.notify.error(msg ~= "" and msg or ("glab " .. label .. " failed"), { id = "glab-" .. label, title = "[rio]" })
      return false
    end
    Snacks.notify.info("glab " .. label .. " done", { id = "glab-" .. label, title = "[rio]" })
  end
end

---Like notify_finish but shows command stdout/stderr in the success notification.
---@param label string
---@return Rio.Action
M.notify_finish_output = function(label)
  return function(handle)
    local result = handle.result
    local msg = (result.stdout ~= "" and result.stdout or result.stderr):gsub("%s+$", "")
    local opts = { id = "glab-" .. label, title = "[rio]" }
    if result.code ~= 0 then
      Snacks.notify.error(msg ~= "" and msg or ("glab " .. label .. " failed"), opts)
      return false
    end
    Snacks.notify.info(msg ~= "" and msg or ("glab " .. label .. " done"), opts)
  end
end

---Resolver spec that wraps a view command in start/finish notifications.
---@param label string
---@param render? Rio.Action callback inserted before create_buf (e.g. to set state.lines)
M.notify_callbacks = function(label, render)
  return {
    on_start = function(callbacks)
      table.insert(callbacks, M.notify_start(label))
      return callbacks
    end,
    on_finish = function(callbacks)
      callbacks[1] = M.notify_finish(label)
      if render then
        table.insert(callbacks, 2, render)
      end
      return callbacks
    end,
  }
end

---@param handle Rio.Handle
H.refresh_parent = function(handle)
  builtin.refresh().action(handle.parent)
end

---@param cmd string
---@param label string
M.mutation = function(cmd, label)
  return function(parent)
    M.notify_start(label)()
    rio.run(cmd, {
      parent = parent,
      resolver = {
        callbacks = {
          on_finish = function()
            return { M.notify_finish_output(label), H.refresh_parent }
          end,
        },
      },
    })
  end
end

---@param cmd string
---@param label string
---@param confirm_msg string
M.confirmed_mutation = function(cmd, label, confirm_msg)
  local action = M.mutation(cmd, label)
  return function(parent)
    if not git_util.confirm(confirm_msg) then
      return
    end
    action(parent)
  end
end

return M
