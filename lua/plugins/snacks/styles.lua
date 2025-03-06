return {
  notification = { focusable = false },
  lazygit = {
    row = 0,
    col = 0,
    width = 0,
    height = function()
      return vim.o.lines - 2
    end,
    backdrop = false,
  },
}
