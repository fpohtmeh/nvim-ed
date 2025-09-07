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
  ["<C-e>a"] = { "add_to_aider", mode = { "i", "n" } },
  ["<C-e>A"] = { "add_readonly_to_aider", mode = { "i", "n" } },
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

---@param picker snacks.Picker
---@param read_only boolean
H.add_files_to_aider = function(picker, read_only)
  local selected = picker:selected({ fallback = true })
  local args = { read_only and "/read-only" or "/add" }
  for _, item in ipairs(selected) do
    if item.file then
      local escaped_file = item.file:gsub(" ", "\\ "):gsub("'", "'\"'\"'")
      table.insert(args, escaped_file)
    end
  end

  local fn = require("plugins.aider.fn")
  local command = table.concat(args, " ")
  fn.send_command(command)
end

---@class snacks.picker.Action
H.add_to_aider = {
  name = "Add to Aider",
  action = function(picker, _, _)
    H.add_files_to_aider(picker, false)
  end,
}

---@class snacks.picker.Action
H.add_readonly_to_aider = {
  name = "Add readonly to Aider",
  action = function(picker, _, _)
    H.add_files_to_aider(picker, true)
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
    add_to_aider = H.add_to_aider,
    add_readonly_to_aider = H.add_readonly_to_aider,
  },
}
