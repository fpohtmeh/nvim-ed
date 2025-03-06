return {
  config = {
    notification = { focusable = false },
    lazygit = {
      row = 0,
      col = 0,
      width = 0,
      height = function()
        return vim.o.lines - 1
      end,
      backdrop = false,
    },
    zoom_indicator = { text = " 󰊓 zoom " },
  },
  notification = function(buf, notif, ctx)
    ctx.opts.border = "single"
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(notif.msg, "\n"))
    vim.api.nvim_buf_set_extmark(buf, ctx.ns, 0, 0, {
      virt_text = { { notif.icon, ctx.hl.icon } },
      virt_text_pos = "inline",
    })
  end,
}
