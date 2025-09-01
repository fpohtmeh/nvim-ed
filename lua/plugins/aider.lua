local H = {}

H.toggle = function()
  require("core.terminal").toggle_aider()
end

return {
  "GeorgesAlkhouri/nvim-aider",
  cmd = "Aider",
  keys = {
    { "<leader>aa", "<cmd>Aider<cr>", desc = "Aider", mode = { "n", "v" } },
    { "<leader>at", H.toggle, desc = "Toggle Aider", mode = { "n", "v" } },
  },
  opts = {
    aider_cmd = "uvx aider",
    auto_reload = true,
    picker_cfg = { preset = "ivy" },
  },
  dependencies = { "folke/snacks.nvim" },
}
