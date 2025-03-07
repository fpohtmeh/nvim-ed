Dial = {
  _groups = { default = {} },
}

Dial._config = function()
  require("dial.config").augends:register_group(Dial._groups)
end

Dial.append = function(func, group)
  local augend = require("dial.augend")
  group = group or "default"
  vim.list_extend(Dial._groups[group], func(augend))
end

Dial.call = function(increment, g)
  local mode = vim.fn.mode(true)
  local is_visual = mode == "v" or mode == "V" or mode == "\22"
  local func = (increment and "inc" or "dec") .. (g and "_g" or "_") .. (is_visual and "visual" or "normal")
  local group = "default"
  return require("dial.map")[func](group)
end

return {
  "monaqa/dial.nvim",
  keys = {
    -- stylua: ignore start
    { "<C-a>", function() return Dial.call(true) end, expr = true, desc = "Increment", mode = {"n", "v"} },
    { "<C-x>", function() return Dial.call(false) end, expr = true, desc = "Decrement", mode = {"n", "v"} },
    { "g<C-a>", function() return Dial.call(true, true) end, expr = true, desc = "Increment", mode = {"n", "v"} },
    { "g<C-x>", function() return Dial.call(false, true) end, expr = true, desc = "Decrement", mode = {"n", "v"} },
    -- stylua: ignore end
  },
  opts = function()
    Dial.append(function(augend)
      return {
        augend.integer.alias.decimal,
        augend.integer.alias.hex,
        augend.date.alias["%Y-%m-%d"],
        augend.constant.alias.bool,
      }
    end)
  end,
  config = Dial._config,
}
