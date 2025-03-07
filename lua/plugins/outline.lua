return {
  "hedyhli/outline.nvim",
  keys = { { "<leader>o", "<cmd>Outline<cr>", desc = "Toggle Outline" } },
  cmd = "Outline",
  opts = {
    symbols = {
      icon_fetcher = function()
        return ""
      end,
    },
  },
}
