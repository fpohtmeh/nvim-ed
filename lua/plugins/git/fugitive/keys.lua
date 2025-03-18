local actions = require("plugins.git.actions")

local H = {}

H.prefix = "Git "
H.key_prefix = "<leader>g"
H.limit = 100
H.limit_str = tostring(H.limit)

H.log = "log --decorate"
H.arg = {}
H.arg.limit = " -n " .. H.limit_str
H.arg.limit1 = " -n 1"
H.arg.detail = " -p"
H.arg.file = " %"

H.map = function(key, action, desc)
  local cmd = type(action) == "function" and action or actions.create(action)
  return { H.key_prefix .. key, cmd, desc = H.prefix .. desc }
end

return {
  -- status
  H.map("g", actions.status, "Status"),
  -- add
  H.map("a", actions.add_file, "Add (file)"),
  H.map("A", actions.add_all_files, "Add (all files)"),
  -- commit
  H.map("c", "commit", "Commit"),
  H.map("C", "commit --amend", "Commit (ammend)"),
  H.map("<a-c>", "commit --amend --no-edit", "Commit (ammend no-edit)"),
  -- reset
  H.map("r", "reset .", "Reset Staged"),
  H.map("R", "reset HEAD~1", "Reset Last Commit"),
  -- log
  H.map("l", H.log .. H.arg.limit, "Log (" .. H.limit_str .. ")"),
  H.map("L", H.log .. H.arg.limit1 .. H.arg.detail, "Log (detailed 1)"),
  H.map("<c-l>", H.log .. H.arg.limit .. H.arg.detail, "Log (detailed " .. H.limit_str .. ")"),
  H.map("<a-l>", H.log, "Log (full)"),
  -- log: file
  H.map("f", H.log .. H.arg.limit .. H.arg.file, "File Log (" .. H.limit_str .. ")"),
  H.map("F", H.log .. H.arg.limit1 .. H.arg.detail .. H.arg.file, "File Log (detailed 1)"),
  H.map("<c-f>", H.log .. H.arg.limit .. H.arg.detail .. H.arg.file, "File Log (detailed " .. H.limit_str .. ")"),
  H.map("<a-f>", H.log .. H.arg.file, "File Log (full)"),
  -- diff
  H.map("d", "diff", "Diff"),
  H.map("D", "diff --staged", "Diff (staged)"),
  -- branch
  H.map("b", "branch", "Branch"),
  H.map("B", "branch -a", "Branch (all)"),
  -- pull/push
  H.map("p", "pull", "Pull"),
  H.map("P", "push", "Push"),
}
