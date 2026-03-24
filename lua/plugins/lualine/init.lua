local components = require("plugins.lualine.components")
local icons = require("core.icons")

local sections = {
  lualine_a = {
    {
      "mode",
      fmt = function(str)
        return str:sub(1, 1) .. str:sub(2):lower()
      end,
    },
  },
  lualine_b = { components.buffers, { "branch", icon = icons.branch } },
  lualine_c = { components.directory, components.filename, components.filename_short },
  lualine_x = {
    {
      "diff",
      symbols = {
        added = icons.git.added,
        modified = icons.git.modified,
        removed = icons.git.removed,
      },
    },
    {
      "diagnostics",
      symbols = {
        error = icons.diagnostics.error,
        warn = icons.diagnostics.warn,
        info = icons.diagnostics.info,
        hint = icons.diagnostics.hint,
      },
      cond = function()
        return vim.diagnostic.is_enabled({ bufnr = 0 })
      end,
    },
  },
  lualine_y = {
    { "filetype", colored = true },
    {
      "encoding",
      cond = function()
        return vim.bo.buftype == "" and vim.api.nvim_win_get_width(0) > 120
      end,
    },
    components.filesize,
  },
  lualine_z = { components.searchcount, components.location },
}

return {
  "nvim-lualine/lualine.nvim",
  lazy = false,
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    options = {
      theme = "tokyonight",
      globalstatus = true,
      component_separators = "",
      section_separators = "",
      disabled_filetypes = {
        statusline = { "snacks_dashboard" },
      },
    },
    sections = sections,
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { "filename" },
      lualine_x = {},
      lualine_y = {},
      lualine_z = {},
    },
  },
}
