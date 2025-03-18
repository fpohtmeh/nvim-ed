return {
  "michaelrommel/nvim-silicon",
  cmd = "Silicon",
  opts = {
    font = "Consolas=36",
    pad_horiz = 20,
    pad_vert = 20,
    line_pad = 3,
    to_clipboard = true,
    line_offset = function(args)
      return args.line1
    end,
    theme = "tokyonight_night",
    window_title = function()
      return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()), ":t")
    end,
  },
}
