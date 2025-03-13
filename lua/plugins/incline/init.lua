local H = {}
local keys = require("core").keys.window

H.ignored_filetypes = { "snacks_dashboard" }

H.render_contents = function(props)
  local key = keys[vim.api.nvim_win_get_number(props.win)]
  if not key then
    return {}
  end
  local colors = require("tokyonight.colors").setup()
  local is_current = props.win == vim.api.nvim_get_current_win()
  return {
    { " " .. key .. " ", guibg = is_current and colors.green or colors.comment, guifg = colors.black },
  }
end

H.opts = {
  window = {
    margin = { vertical = 0, horizontal = 0 },
    padding = 0,
  },
  ignore = {
    buftypes = {},
    unlisted_buffers = false,
    wintypes = {},
    filetypes = H.ignored_filetypes,
  },
  render = H.render_contents,
}

return {
  "b0o/incline.nvim",
  event = { "VeryLazy", "LazyFile" },
  opts = H.opts,
  dependencies = { "nvim-tree/nvim-web-devicons" },
}
