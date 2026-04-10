local H = {}

local components = require("plugins.lualine.components")
local winbar = require("plugins.lualine.winbar")
local icons = require("core.icons")

function H.theme()
  local theme = require("lualine.themes.tokyonight")
  local colors = require("tokyonight.colors").setup()
  theme.terminal = {
    a = { bg = colors.magenta, fg = theme.normal.a.fg },
    b = { bg = theme.normal.b.bg, fg = colors.magenta },
  }
  theme.visual = {
    a = { bg = colors.yellow, fg = theme.normal.a.fg },
    b = { bg = theme.normal.b.bg, fg = colors.yellow },
  }
  theme.command = {
    a = { bg = colors.orange, fg = theme.normal.a.fg },
    b = { bg = theme.normal.b.bg, fg = colors.orange },
  }
  return theme
end

H.sections = {
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
    components.claude,
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
      theme = H.theme(),
      globalstatus = true,
      component_separators = "",
      section_separators = "",
      disabled_filetypes = {
        statusline = { "snacks_dashboard" },
        winbar = { "snacks_dashboard" },
      },
    },
    sections = H.sections,
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { "filename" },
      lualine_x = {},
      lualine_y = {},
      lualine_z = {},
    },
    winbar = {
      lualine_c = { winbar.filename },
      lualine_z = { winbar.key },
    },
    inactive_winbar = {
      lualine_c = { winbar.filename_inactive },
      lualine_z = { winbar.key_inactive },
    },
    tabline = nil,
  },
}
