local H = {}

H.default_lsp = {
  override = {
    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
    ["vim.lsp.util.stylize_markdown"] = true,
    ["cmp.entry.get_documentation"] = true,
  },
}

H.default_routes = {
  {
    filter = {
      event = "msg_show",
      any = {
        { find = "%d+L, %d+B" },
        { find = "; after #%d+" },
        { find = "; before #%d+" },
      },
    },
    view = "mini",
  },
}

H.confirm = {
  position = {
    row = "50%",
    col = "50%",
  },
  border = {
    style = "single",
  },
}

H.lsp_doc_border = {
  views = {
    hover = {
      border = { style = "single" },
    },
  },
}

return {
  "folke/noice.nvim",
  event = "VeryLazy",
  opts = {
    cmdline = { view = "cmdline" },
    popupmenu = { enabled = false },
    lsp = H.default_lsp,
    routes = H.default_routes,
    views = {
      confirm = H.confirm,
    },
    presets = {
      lsp_doc_border = H.lsp_doc_border,
    },
  },
}
