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

H.expand = function(cmd)
  return cmd:gsub("%%", vim.fn.expand("%:p"))
end

H.subpicker_confirm = function(spec)
  return function(picker, item)
    picker:close()
    local cmd = H.expand(item.command)
    if spec.terminal then
      local terminal = require("core.terminal")
      Snacks.terminal(cmd, {
        interactive = false,
        cwd = Snacks.git.get_root(),
        win = { style = "terminal", position = "bottom", keys = terminal.keys },
        env = { terminal_style = "normal" },
      })
    else
      H.run(item)
    end
  end
end

H.subpicker_format = function(item)
  local parts = { { item.text, "SnacksPickerFile" } }
  if type(item.command) == "string" then
    parts[#parts + 1] = { " " }
    parts[#parts + 1] = { item.command, "SnacksPickerComment" }
  end
  return parts
end

H.subpicker = function(title, spec)
  local items = {}
  for i, entry in ipairs(spec.commands) do
    items[i] = { idx = i, text = entry.text, command = entry.command }
  end
  vim.schedule(function()
    require("snacks").picker({
      items = items,
      title = title,
      format = H.subpicker_format,
      layout = { preset = "select" },
      actions = { confirm = H.subpicker_confirm(spec) },
    })
  end)
end

H.ctx = {}

H.fill = function(items)
  local add = function(text, category, command) H.add(items, text, category, command) end
  require("plugins.toolbox.clipboard").fill(add, H.ctx)
  local category
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
