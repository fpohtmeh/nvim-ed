local function toolbox()
  local opts = {
    prompt = "Select command",
    format_item = function(command)
      return string.format("%-50s", command.name) .. " │ " .. command.category
    end,
  }
  require("toolbox").show_picker(nil, opts)
end

local commands = {
  -- Clipboard
  { name = "Copy full path", category = "Clipboard", execute = ":let @+ = expand('%:p')" },
  { name = "Copy directory path", category = "Clipboard", execute = ":let @+ = expand('%:p:h')" },
  { name = "Copy filename", category = "Clipboard", execute = ":let @+ = expand('%:t')" },
  { name = "Copy relative path", category = "Clipboard", execute = ":let @+ = expand('%:.')" },
  -- Editor
  { name = "Remove empty lines", category = "Editor", execute = ":g/^$/d" },
  { name = "Remove trailing spaces", category = "Editor", execute = ":%s/\\s\\+$//e" },
  { name = "Sort selected lines", category = "Editor", execute = "sort" },
  { name = "Sort selected lines reverse", category = "Editor", execute = "sort!" },
  -- Utils
  { name = "Copy code image (Silicon)", category = "Utils", execute = "Silicon" },
}

return {
  "DanWlker/toolbox.nvim",
  keys = {
    { mode = { "n", "v" }, "<leader>;", toolbox, desc = "Toolbox" },
  },
  opts = {
    commands = commands,
  },
}
