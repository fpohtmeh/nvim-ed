vim.filetype.add({
  extension = {
    qrc = "xml",
  },
})

local icons = {
  qt_project = {
    icon = "",
    color = "#2b8937",
    cterm_color = "28",
    name = "Qt",
  },
  qrc = {
    icon = "󰗀",
    color = "#89e051",
    cterm_color = "130",
    name = "Qrc",
  },
  qml = {
    icon = "",
    color = "#cbcb41",
    cterm_color = "130",
    name = "Qml",
  },
}

local devicons = {
  "nvim-tree/nvim-web-devicons",
  opts = {
    override_by_extension = {
      qrc = icons.qrc,
      qml = icons.qml,
      pro = icons.qt_project,
      pri = icons.qt_project,
    },
  },
}

return {
  devicons,
  {
    "peterhoeg/vim-qml",
    ft = { "qml" },
  },
  {
    "artoj/qmake-syntax-vim",
    ft = { "qmake" },
  },
}
