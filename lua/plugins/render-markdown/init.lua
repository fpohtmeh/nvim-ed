local H = {}

H.opts = {
  enabled = false,
  heading = {
    sign = false,
    icons = {},
    width = "block",
    left_pad = 1,
    right_pad = 1,
  },
  code = {
    sign = false,
    width = "block",
    right_pad = 1,
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
  ft = { "markdown", "vimwiki" },
}
