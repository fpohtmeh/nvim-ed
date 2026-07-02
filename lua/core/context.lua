local M = {}
local H = {}

local fs = require("core.fs")

H.parts = function(path)
  return {
    full_path = function()
      return path
    end,
    dir_path = function()
      return vim.fn.fnamemodify(path, ":h") .. "/"
    end,
    filename = function()
      return vim.fn.fnamemodify(path, ":t")
    end,
    relative_path = function()
      return vim.fn.fnamemodify(path, ":.")
    end,
  }
end

H.buffer = {}
H.buffer.current = function()
  return vim.fn.expand("%:p")
end
H.buffer.selection = function()
  return { H.buffer.current() }
end

H.oil = {}
H.oil.matches = function()
  return vim.bo.filetype == "oil"
end
H.oil.path = function(dir, entry)
  return fs.to_unix(dir) .. (entry and entry.name or "")
end
H.oil.current = function()
  local oil = require("oil")
  return H.oil.path(oil.get_current_dir(), oil.get_cursor_entry())
end
H.oil.selection = function()
  local oil = require("oil")
  local dir = oil.get_current_dir()
  local range = require("oil.util").get_visual_range()
  if not range then
    return { H.oil.path(dir, oil.get_cursor_entry()) }
  end
  local paths = {}
  for line = range.start_lnum, range.end_lnum do
    local entry = oil.get_entry_on_line(0, line)
    if entry then
      table.insert(paths, H.oil.path(dir, entry))
    end
  end
  return paths
end

H.snacks = {}
H.snacks.picker = function()
  for _, picker in ipairs(Snacks.picker.get()) do
    if picker:is_focused() then
      return picker
    end
  end
end
H.snacks.matches = function()
  return H.snacks.picker() ~= nil
end
H.snacks.path = function(item)
  return item and require("snacks.picker.util").path(item) or ""
end
H.snacks.current = function()
  return H.snacks.path(H.snacks.picker():current())
end
H.snacks.selection = function()
  local paths = {}
  for _, item in ipairs(H.snacks.picker():selected({ fallback = true })) do
    local path = H.snacks.path(item)
    if path ~= "" then
      table.insert(paths, path)
    end
  end
  return paths
end

H.types = { H.snacks, H.oil }

H.active = function()
  for _, context in ipairs(H.types) do
    if context.matches() then
      return context
    end
  end
  return H.buffer
end

M.current = setmetatable({}, {
  __index = function(_, name)
    return H.parts(H.active().current())[name]()
  end,
})

M.selection = setmetatable({}, {
  __index = function(_, name)
    return vim.tbl_map(function(path)
      return H.parts(path)[name]()
    end, H.active().selection())
  end,
})

return M
