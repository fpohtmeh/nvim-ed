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

H.fill = function(items)
  local category
  category = "Clipboard"
  H.add(items, "Copy full path", category, ":let @+ = expand('%:p')")
  H.add(items, "Copy directory path", category, ":let @+ = expand('%:p:h')")
  H.add(items, "Copy filename", category, ":let @+ = expand('%:t')")
  H.add(items, "Copy relative path", category, ":let @+ = expand('%:.')")
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
