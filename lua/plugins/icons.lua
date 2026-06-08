return {
  "nvim-tree/nvim-web-devicons",
  event = "LazyFile",
  opts = {
    override_by_extension = {
      dll = { icon = "", color = "#FF0500", cterm_color = "52", name = "Dll" },
      exe = { icon = "", color = "#FF0500", cterm_color = "124", name = "Exe" },
      plist = { icon = "󰗀", color = "#E37933", cterm_color = "166", name = "Plist" },
      manifest = { icon = "󰗀", color = "#E37933", cterm_color = "166", name = "Manifest" },
      yml = { icon = "󰗀", color = "#D70000", cterm_color = "160", name = "Yaml" },
    },
    override_by_filename = {
      ["CMakeLists.txt"] = { icon = "", color = "#DCE3EB", cterm_color = "254", name = "CMake" },
    },
  },
}
