local H = {}

H.add = function(items, text, category, command)
  local id = #items + 1
  items[id] = {
    idx = id,
    text = text,
    category = category,
    command = command,
  }
end

H.copy = {
  file = {
    full_path = function(p) return p end,
    dir_path = function(p) return vim.fn.fnamemodify(p, ":h") .. "/" end,
    filename = function(p) return vim.fn.fnamemodify(p, ":t") end,
    relative_path = function(p) return vim.fn.fnamemodify(p, ":.") end,
  },
  oil = {
    full_path = function(dir, entry) return dir .. (entry and entry.name or "") end,
    dir_path = function(dir, _) return dir end,
    filename = function(_, entry) return entry and entry.name or "" end,
    relative_path = function(dir, entry) return vim.fn.fnamemodify(dir .. (entry and entry.name or ""), ":.") end,
  },
}

H.subpicker = function(title, spec)
  local items = {}
  for i, entry in ipairs(spec.commands) do
    items[i] = { idx = i, text = entry.text, command = entry.command }
  end
  require("snacks").picker({
    items = items,
    title = title,
    format = function(item)
      return { { item.text, "SnacksPickerFile" } }
    end,
    layout = { preset = "select" },
    actions = {
      confirm = function(picker, item)
        picker:close()
        H.run(item)
      end,
    },
  })
end

H.ctx = {}

H.clipboard = function(name)
  return function()
    local value
    if H.ctx.oil then
      value = H.copy.oil[name](H.ctx.oil.dir, H.ctx.oil.entry)
    else
      value = H.copy.file[name](H.ctx.path)
    end
    if value then
      vim.fn.setreg("+", value)
    end
  end
end

H.fill = function(items)
  local category
  category = "Clipboard"
  H.add(items, "Copy full path", category, H.clipboard("full_path"))
  H.add(items, "Copy directory path", category, H.clipboard("dir_path"))
  H.add(items, "Copy filename", category, H.clipboard("filename"))
  H.add(items, "Copy relative path", category, H.clipboard("relative_path"))
  category = "Editor"
  H.add(items, "Remove empty lines", category, ":g/^$/d")
  H.add(items, "Remove trailing spaces", category, ":%s/\\s\\+$//e")
  H.add(items, "Sort selected lines", category, "sort")
  H.add(items, "Sort selected lines reverse", category, "sort!")
  category = "Utils"
  H.add(items, "Copy code image (Silicon)", category, "Silicon")
  category = "Diff"
  H.add(items, "Turn on diff mode", category, "windo diffthis")
  H.add(items, "Turn off diff mode", category, "windo diffoff")
  category = "CSV"
  H.add(items, "Toggle CSV mode ;", category, ":CsvViewToggle delimiter=; display_mode=border header_lnum=1")
  H.add(items, "Toggle CSV mode ,", category, ":CsvViewToggle delimiter=, display_mode=border header_lnum=1")
  category = "Database"
  H.add(items, "Toggle database UI", category, ":DBUIToggle")
  H.add(items, "Add database connection", category, ":DBUIAddConnection")
  category = "Tools"
  H.add(items, "Chezmoi", category, require("plugins.toolbox.chezmoi"))
end

H.items = function()
  local items = {}
  H.fill(items)
  return items
end

H.format = function(item)
  return {
    { string.format("%-50s", item.text), "SnacksPickerFile" },
    { " " },
    { item.category, "SnacksPickerComment" },
  }
end

H.is_visual_mode = false

H.run = function(item)
  local command = item.command
  if command == nil then
    return
  end

  if type(command) == "table" and command.commands then
    H.subpicker(item.text, command)
    return
  end

  if type(command) == "function" then
    local ok, res = pcall(command)
    if not ok then
      error(res, 0)
    end
  elseif type(command) == "string" then
    local prefix = ":"
    if H.is_visual_mode then
      prefix = prefix .. "'<,'>"
    end
    local cmd = vim.cmd --[[@as function]]
    local ok, res = pcall(cmd, prefix .. command)
    if not ok then
      error(res, 0)
    end
  else
    error("Unknown command: " .. tostring(command), 0)
  end
end

H.confirm = function(picker, item)
  picker:close()
  H.run(item)
end

H.toolbox = function()
  H.is_visual_mode = require("core.fn").is_visual_mode()
  if vim.bo.filetype == "oil" then
    local oil = require("oil")
    local fs = require("core.fs")
    local dir = oil.get_current_dir()
    local entry = oil.get_cursor_entry()
    H.ctx = { oil = { dir = fs.to_unix(dir), entry = entry } }
  else
    H.ctx = { path = vim.fn.expand("%:p") }
  end

  require("snacks").picker({
    items = H.items(),
    title = "Toolbox",
    format = H.format,
    layout = { preset = "select" },
    actions = {
      confirm = H.confirm,
    },
  })
end

return {
  "folke/snacks.nvim",
  keys = {
    { mode = { "n", "v" }, "<leader>;", H.toolbox, desc = "Toolbox" },
  },
}
