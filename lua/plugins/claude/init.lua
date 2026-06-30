local claude = require("plugins.claude.terminal")

-- stylua: ignore
return {
  "folke/snacks.nvim",
  keys = {
    { "<leader>aa", claude.show, desc = "Show" },
    { "<leader>ao", claude.open, desc = "Open with options" },
    { "<leader>at", function() claude.input(false) end, desc = "Send Text" },
    { "<leader>as", function() claude.input(true) end, desc = "Submit Text" },
    { "<leader>aq", function() claude.send_qf(true) end, desc = "Send Quickfix" },
    { "<leader>af", claude.send_file, desc = "Send File" },
    { "<leader>ac", claude.commit, desc = "Commit" },
    { "<leader>ax", claude.clear, desc = "Clear" },
  },
}
