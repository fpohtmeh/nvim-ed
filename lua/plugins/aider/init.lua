local function api_call(action)
  return function()
    local api = require("nvim_aider.api")
    api[action]()
  end
end

local function send_command(command)
  return function()
    local api = require("nvim_aider.api")
    api.send_command(command)
  end
end

return {
  "GeorgesAlkhouri/nvim-aider",
  cmd = "Aider",
  keys = {
    { "<leader>at", "<cmd>Aider toggle<cr>", desc = "Toggle Aider" },
    -- Add
    { "<leader>aa", "<cmd>Aider add<cr>", desc = "Add File" },
    { "<leader>aA", "<cmd>Aider add readonly<cr>", desc = "Add Read-Only" },
    -- Drop/reset
    { "<leader>ad", "<cmd>Aider drop<cr>", desc = "Drop File" },
    { "<leader>aD", "<cmd>Aider drop<cr>", desc = "Drop All" },
    { "<leader>aX", "<cmd>Aider reset<cr>", desc = "Reset Session" },
    -- -- Send
    { "<leader>av", api_call("send_to_terminal"), desc = "Send selection" },
    { "<leader>ab", api_call("send_buffer_with_prompt"), desc = "Send buffer" },
    { "<leader>aq", api_call("send_diagnostics_with_prompt"), desc = "Send buffer diagnostics" },
    -- Commands
    { "<leader>a<CR>", send_command("/voice"), desc = "Voice" },
    { "<leader>ac", send_command("/commit"), desc = "Commit" },
  },
  opts = {
    aider_cmd = "aider",
    auto_reload = true,
    notifications = false,
    picker_cfg = { preset = "ivy" },
  },
  dependencies = { "folke/snacks.nvim" },
}
