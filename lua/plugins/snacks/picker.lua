local icons = require("core.icons")

local overriden_keys = {
  ["<a-m>"] = false,
  ["<a-t>"] = { "toggle_maximize", mode = { "i", "n" } },
}

return {
  layout = { preset = "ivy" },
  icons = {
    ui = {
      selected = icons.mark .. " ",
    },
  },
  win = {
    input = { keys = overriden_keys },
    list = { keys = overriden_keys },
  },
}
