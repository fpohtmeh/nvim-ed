local H = {}

H.opts = {
  highlight_duration = 750,
  mappings = {
    add = "ys",
    delete = "ds",
    replace = "cs",
    find = "",
    find_left = "",
    highlight = "yh",
    update_n_lines = "",
  },
}

return {
  "echasnovski/mini.surround",
  version = "*",
  event = "LazyFile",
  opts = H.opts,
}
