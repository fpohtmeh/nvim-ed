local H = {}

H.opts = {
  mappings = {
    add = "Sa",
    delete = "Sd",
    replace = "Sr",
    find = "",
    find_left = "",
    highlight = "",
    update_n_lines = "",
  },
}

return {
  "echasnovski/mini.surround",
  version = "*",
  event = "LazyFile",
  config = function()
    require("mini.surround").setup(H.opts)
  end,
}
