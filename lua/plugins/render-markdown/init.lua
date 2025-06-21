local H = {}

H.opts = {
  heading = {
    sign = true,
    signs = { "# " },
    left_pad = 1,
    right_pad = 2,
    border = true,
  },
  code = {
    sign = false,
    width = "block",
    left_pad = 1,
    right_pad = 1,
    position = "right",
    language_pad = 1,
    inline_pad = 1,
  },
  checkbox = {
    enabled = false,
  },
  completions = {
    blink = { enabled = true },
    lsp = { enabled = true },
  },
}

return {
  "MeanderingProgrammer/render-markdown.nvim",
  opts = H.opts,
  ft = { "markdown", "vimwiki", "codecompanion" },
}
