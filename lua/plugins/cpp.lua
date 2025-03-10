local mason = {
  "williamboman/mason.nvim",
  opts = {
    ensure_installed = {
      "clang-format",
    },
  },
}

local format = {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      cpp = { "clang-format" },
    },
  },
}

return { mason, format }
