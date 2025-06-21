local icons = require("core.icons")

local overriden_keys = {
  ["<a-m>"] = false,
  ["<a-t>"] = { "toggle_maximize", mode = { "i", "n" } },
  ["<c-j>"] = false,
  ["<c-k>"] = false,
}

return {
  layout = { preset = "ivy" },
  formatters = {
    file = { truncate = 80 },
  },
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
