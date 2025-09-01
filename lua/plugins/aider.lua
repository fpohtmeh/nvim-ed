return {
  "GeorgesAlkhouri/nvim-aider",
  cmd = "Aider",
  keys = {
    { "<leader>aa", "<cmd>Aider<cr>", desc = "Aider", mode = { "n", "v" } },
    { "<leader>at", "<cmd>Aider toggle<cr>", desc = "Toggle Aider", mode = { "n", "v" } },
  },
  opts = {
    aider_cmd = "uvx aider",
    auto_reload = true,
    picker_cfg = { preset = "ivy" },
  },
  dependencies = { "folke/snacks.nvim" },
}
