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
  -- commit
  H.map("c", "commit", "Commit"),
  H.map("C", "commit --amend", "Commit (ammend)"),
  H.map("<a-c>", "commit --amend --no-edit", "Commit (ammend no-edit)"),
  -- diff
  H.map("d", "diff", "Diff"),
  H.map("D", "diff --staged", "Diff (staged)"),
  -- branch
  H.map("b", "branch", "Branch"),
  H.map("B", "branch -a", "Branch (all)"),
}
