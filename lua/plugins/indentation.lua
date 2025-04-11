local excluded_filetypes = require("core").indentation.excluded_filetypes
local keys = require("core").keys

local mini = {
  "echasnovski/mini.indentscope",
  version = false,
  event = "LazyFile",
  opts = {
    symbol = "│",
    options = { try_as_border = true },
    draw = {
      animation = function()
        return 0
      end,
    },
    mappings = {
      goto_top = keys.prev .. "i",
      goto_bottom = keys.next .. "i",
    },
  },
}

local blankline = {
  "lukas-reineke/indent-blankline.nvim",
  event = "LazyFile",
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

local detect = {
  "Darazaki/indent-o-matic",
  event = "LazyFile",
}

return {
  mini,
  blankline,
  detect,
}
