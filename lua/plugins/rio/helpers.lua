local H = {}

H.toggles = {}

H.make_toggle_param = function(key, value, enabled)
  if enabled == nil then
    enabled = true
  end
  H.toggles[key] = { enabled = enabled, value = value }
  return function()
    return H.toggles[key].enabled and value or ""
  end
end

H.make_filetype = function(ft)
  return function(callbacks)
    table.insert(callbacks, function(handle)
      vim.bo[handle.state.buf].filetype = ft
    end)
  end
end

H.make_toggle_key = function(key)
  return function(handle)
    local toggle = H.toggles[key]
    toggle.enabled = not toggle.enabled
    vim.notify("[rio] Toggled parameter: " .. key .. " " .. (toggle.enabled and "ON" or "OFF"))
    require("rio.callbacks.builtin").refresh(handle)
  end
end

return H
