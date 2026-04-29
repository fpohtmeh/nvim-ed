local actions = require("plugins.git.actions")

local H = {}

H.prefix = "Git "
H.key_prefix = "<leader>g"

H.map = function(key, action, desc)
  local cmd = type(action) == "function" and action or actions.create(action)
  return { H.key_prefix .. key, cmd, desc = H.prefix .. desc }
end

return {
  -- commit
  H.map("c", "commit", "Commit"),
  H.map("C", "commit --amend", "Commit (ammend)"),
  H.map("<a-c>", "commit --amend --no-edit", "Commit (ammend no-edit)"),
}
