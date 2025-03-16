Ed.dial = {}

local H = {
  _groups = {
    default = {},
  },
}

H._config = function()
  require("dial.config").augends:register_group(H._groups)
end

Ed.dial.append = function(func, group)
  local augend = require("dial.augend")
  group = group or "default"
  vim.list_extend(H._groups[group], func(augend))
end

H.call = function(increment, g)
  local fn = require("core.fn")
  local func = (increment and "inc" or "dec") .. (g and "_g" or "_") .. (fn.is_visual_mode() and "visual" or "normal")
  local group = "default"
  return require("dial.map")[func](group)
end

return {
  "monaqa/dial.nvim",
  keys = {
    -- stylua: ignore start
    { "<C-a>", function() return H.call(true) end, expr = true, desc = "Increment", mode = {"n", "v"} },
    { "<C-x>", function() return H.call(false) end, expr = true, desc = "Decrement", mode = {"n", "v"} },
    { "g<C-a>", function() return H.call(true, true) end, expr = true, desc = "Increment", mode = {"n", "v"} },
    { "g<C-x>", function() return H.call(false, true) end, expr = true, desc = "Decrement", mode = {"n", "v"} },
    -- stylua: ignore end
  },
  opts = function()
    Ed.dial.append(function(augend)
      return {
        augend.integer.alias.decimal,
        augend.integer.alias.hex,
        augend.date.alias["%Y-%m-%d"],
        augend.constant.alias.bool,
      }
    end)
  end,
  config = H._config,
}
