local H = {}

local icons = require("core.icons")

H.overriden_keys = {
  ["<A-m>"] = false,
  ["<A-t>"] = { "toggle_maximize", mode = { "i", "n" } },
  ["<C-j>"] = false,
  ["<C-k>"] = false,
  ["<C-t>"] = false,
  ["<C-e>T"] = { "tab", mode = { "i", "n" } },
  ["<C-e>r"] = { "search_and_replace", mode = { "i", "n" } },
}

---@class snacks.picker.Action
H.search_and_replace = {
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
    input = { keys = H.overriden_keys },
    list = { keys = H.overriden_keys },
  },
  actions = {
    search_and_replace = H.search_and_replace,
  },
  sources = {
    html_colors = require("core.colors").picker,
  },
}
