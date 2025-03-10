return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  dependencies = { "mason.nvim" },
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
    },
    formatters = {
      injected = { options = { ignore_errors = true } },
    },
    notify_on_error = false,
  },
}
