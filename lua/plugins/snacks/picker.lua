local icons = require("core.icons")

local overriden_keys = {
  ["<A-m>"] = false,
  ["<A-t>"] = { "toggle_maximize", mode = { "i", "n" } },
  ["<C-j>"] = false,
  ["<C-k>"] = false,
  ["<C-t>"] = false,
  ["<C-e>T"] = { "tab", mode = { "i", "n" } },
  ["<C-e>r"] = { "search_and_replace", mode = { "i", "n" } },
}

---@class snacks.picker.Action
local search_and_replace = {
  name = "Search and Replace",
  ---@diagnostic disable-next-line: unused-local
  action = function(picker, item, action)
    local source = picker.opts.source
    local fn = require("plugins.grug-far.fn")
    if source == "zoxide" then
      fn.open_with_args({ path = item.file })
    else
      fn.open_with_args({ search = picker.finder.filter.search })
    end
  end,
}

return {
  layout = {
    preset = "ivy",
    preview = false,
  },
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
  actions = {
    search_and_replace = search_and_replace,
  },
}
