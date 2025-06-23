local M = {}
local H = {}

local fs = require("core.fs")

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

H.lcd = function()
  local actions = require("oil.actions")
  actions.cd.callback({ scope = "win" })
end

M.open_oil = function(path)
  local cmd = "Oil" .. (path and " " .. fs.to_escaped(path) or "")
  vim.cmd(cmd)
end

M.open_oil_cwd = function()
  vim.cmd("Oil " .. fs.to_escaped(vim.fn.getcwd()))
end

M.setup = function()
  local actions = require("oil.actions")
  actions.toggle_columns = {
    desc = "Toggle columns",
    callback = H.toggle_columns,
  }
  actions.lcd = {
    desc = "lcd to the current Oil directory",
    callback = H.lcd,
  }
end

M.keymaps = {
  ["g?"] = "actions.show_help",
  ["<CR>"] = "actions.select",
  ["<C-s>"] = false, -- "actions.select_vsplit",
  ["<C-w>v"] = "actions.select_vsplit",
  ["<C-h>"] = false, -- "actions.select_split",
  ["<C-w>s"] = "actions.select_split",
  ["<C-t>"] = false, -- "actions.select_tab",
  ["<C-w>t"] = "actions.select_tab",
  ["<C-p>"] = "actions.preview",
  ["<C-c>"] = "actions.close",
  ["q"] = "actions.close",
  ["<C-l>"] = false, -- "actions.refresh",
  ["<C-e>r"] = "actions.refresh",
  ["-"] = "actions.parent",
  ["_"] = false, -- "actions.open_cwd",
  ["<C-e>e"] = "actions.open_cwd",
  ["`"] = false, -- "actions.cd",
  ["<C-e>d"] = "actions.cd",
  ["~"] = false, -- "actions.tcd",
  ["<C-e>t"] = "actions.tcd",
  ["<C-e>l"] = "actions.lcd",
  ["gs"] = false, -- "actions.change_sort",
  ["<C-e>s"] = "actions.change_sort",
  ["gx"] = "actions.open_external",
  ["g."] = false, -- "actions.toggle_hidden",
  ["<C-e>."] = "actions.toggle_hidden",
  ["<C-e>,"] = "actions.toggle_columns",
}

return M
