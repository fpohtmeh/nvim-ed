local mason = {
  "williamboman/mason.nvim",
  opts = {
    ensure_installed = {
      "black",
      "pyright",
    },
  },
}

local format = {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      python = { "black" },
    },
  },
}

return { mason, format }
