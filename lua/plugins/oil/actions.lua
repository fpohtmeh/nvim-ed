local M = {}
local H = {}

H.show_all_columns = false

H.toggle_columns = function()
  H.show_all_columns = not H.show_all_columns
  local columns = H.show_all_columns and { "icon", "permissions", "mtime", "size" } or { "icon" }
  local oil = require("oil")
  local current_dir = oil.get_current_dir()
  oil.set_columns(columns)
  oil.close()
  M.open_oil(current_dir)
end

M.open_oil = function(path)
  local fs = require("core.fs")
  local cmd = "Oil" .. (path and " " .. fs.to_escaped(path) or "")
  vim.cmd(cmd)
end

M.setup = function()
  local actions = require("oil.actions")
  actions.toggle_columns = {
    desc = "Toggle columns",
    callback = H.toggle_columns,
  }
end

M.keymaps = {
  ["g?"] = "actions.show_help",
  ["<CR>"] = "actions.select",
  ["<C-s>"] = false, -- "actions.select_vsplit",
  ["<C-h>"] = false, -- "actions.select_split",
  ["<C-t>"] = false, -- "actions.select_tab",
  ["<C-p>"] = "actions.preview",
  ["<C-c>"] = false, -- "actions.close",
  ["q"] = "actions.close",
  ["<C-l>"] = false, -- "actions.refresh",
  ["-"] = "actions.parent",
  ["_"] = false, -- "actions.open_cwd",
  ["`"] = false, -- "actions.cd",
  ["~"] = false, -- "actions.tcd",
  ["gs"] = "actions.change_sort",
  ["gx"] = "actions.open_external",
  ["g."] = "actions.toggle_hidden",
  ["g,"] = "actions.toggle_columns",
}

return M
