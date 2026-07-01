local claude = require("plugins.claude.terminal")

-- stylua: ignore
return {
  "folke/snacks.nvim",
  keys = {
    { "<leader>aa", claude.show, desc = "Show" },
    { "<leader>an", claude.new, desc = "New session" },
    { "<leader>ao", claude.open, desc = "Open with options" },
    { "<leader>at", claude.input, desc = "Send Text" },
    { "<leader>at", claude.send_selection, desc = "Send Selection", mode = "x" },
    { "<leader>aq", claude.send_qf, desc = "Send Quickfix" },
    { "<leader>af", claude.send_filepath, desc = "Send Filepath" },
    { "<leader>ar", claude.send_relative_path, desc = "Send Relative Path" },
    { "<leader>ac", claude.commit, desc = "Commit" },
    { "<leader>ax", claude.clear, desc = "Clear" },
  },
}
