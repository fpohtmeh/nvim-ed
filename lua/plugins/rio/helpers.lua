local H = {}

H.toggles = {}

---@param key string
---@param value string
---@param enabled? boolean
---@return fun(): string
H.make_toggle_param = function(key, value, enabled)
  if enabled == nil then
    enabled = true
  end
  H.toggles[key] = { enabled = enabled, value = value }
  return function()
    return H.toggles[key].enabled and value or ""
  end
end

---@param ft string
---@return fun(handle: Rio.Handle)
H.make_filetype = function(ft)
  return function(handle)
    vim.bo[handle.state.buf].filetype = ft
  end
end

---@param key string
---@return fun(handle: Rio.Handle)
H.make_toggle_key = function(key)
  return function(handle)
    local toggle = H.toggles[key]
    toggle.enabled = not toggle.enabled
    local message = "[rio] Toggled parameter: " .. key .. " " .. (toggle.enabled and "ON" or "OFF")
    require("rio.callbacks.builtin").refresh(message)(handle)
  end
end

return H
