local actions = require("plugins.git.actions")

return {
  -- Status
  { "<leader>gs", actions.status, desc = "Git: Status" },
  -- Log
  { "<leader>gl", actions.create("log -n 100"), desc = "Git: Log (100)" },
  { "<leader>gL", actions.create("log"), desc = "Git: Log (full)" },
  { "<leader>gf", actions.create("log"), desc = "Git: File Log" },
  -- Add
  { "<leader>ga", actions.add_file, desc = "Git: Add" },
  { "<leader>gA", actions.add_all_files, desc = "Git: Add All" },
  -- Pull & Push
  { "<leader>gp", actions.create("pull"), desc = "Git: Pull" },
  { "<leader>gP", actions.create("pull"), desc = "Git: Push" },
  -- Reset
  { "<leader>gr", actions.create("reset ."), desc = "Git: Reset Staged" },
  { "<leader>gR", actions.create("reset HEAD~1"), desc = "Git: Reset Last Commit" },
}
