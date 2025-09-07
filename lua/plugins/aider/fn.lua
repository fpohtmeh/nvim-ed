local M = {}

M.send_command = function(command, opts)
  opts = opts or require("core.terminal").aider_opts
  require("nvim_aider.api").send_command(command, nil, opts)
end

return M
