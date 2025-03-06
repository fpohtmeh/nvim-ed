local excluded_filetypes = require("core").indentation.excluded_filetypes

local mini = {
  "echasnovski/mini.indentscope",
  version = false,
  opts = {
    symbol = "│",
    options = { try_as_border = true },
    draw = {
      animation = function()
        return 0
      end,
    },
  },
}

local blankline = {
  "lukas-reineke/indent-blankline.nvim",
  opts = {
    indent = {
      char = "│",
      tab_char = "│",
    },
    scope = { enabled = false },
    exclude = {
      filetypes = excluded_filetypes,
    },
  },
  main = "ibl",
}

return { mini, blankline }
