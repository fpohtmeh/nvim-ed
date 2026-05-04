local H = {}

H.notify_only = function(msg)
  local builtin = require("rio.callbacks.builtin")
  return {
    on_finish = function()
      return {
        builtin.notify_error,
        function()
          vim.notify(msg, vim.log.levels.INFO)
        end,
      }
    end,
  }
end

H.add_file = function()
  vim.cmd("update")
  local file = vim.fn.expand("%:.")
  require("rio").run("git add -- {file}", {
    params = { file = file },
    resolver = { callbacks = H.notify_only("Added " .. file) },
  })
end

H.add_all = function()
  vim.cmd("wall")
  require("rio").run("git add .", {
    resolver = { callbacks = H.notify_only("Added all") },
  })
end

H.log = function()
  require("plugins.rio.git.views.log")()
end

H.log_full = function()
  require("plugins.rio.git.views.log")({ oneline = false })
end

H.file_log = function()
  require("plugins.rio.git.views.log")({ file = true })
end

H.file_log_full = function()
  require("plugins.rio.git.views.log")({ oneline = false, file = true })
end

H.diff = function()
  require("plugins.rio.git.views.diff").working()
end

H.diff_staged = function()
  require("plugins.rio.git.views.diff").working({ staged = true })
end

H.branch = function()
  require("plugins.rio.git.views.branch")()
end

H.branch_all = function()
  require("plugins.rio.git.views.branch")({ all = true })
end

H.status = function()
  require("plugins.rio.git.views.status")()
end

H.summary = function()
  require("plugins.rio.git.views.summary")()
end

H.stash = function()
  require("plugins.rio.git.views.stash")()
end

H.top = function()
  local win_builtin = require("rio.resolver.win.builtin")
  local builtin = require("rio.callbacks.builtin")
  require("rio").run("top -b -n 1", {
    resolver = {
      win = { win_builtin.reuse, win_builtin.current },
    },
    callbacks = {
      on_finish = { builtin.auto_refresh({ interval = 1000 }) },
    },
  })
end

return {
  "fpohtmeh/rio.nvim",
  dev = true,
  opts = {},
  keys = {
    { "<leader>ga", H.add_file, desc = "Rio: git add (file)" },
    { "<leader>gA", H.add_all, desc = "Rio: git add (all)" },
    { "<leader>gl", H.log, desc = "Rio: git log" },
    { "<leader>gL", H.log_full, desc = "Rio: git log (full)" },
    { "<leader>gf", H.file_log, desc = "Rio: git file log" },
    { "<leader>gF", H.file_log_full, desc = "Rio: git file log (full)" },
    { "<leader>gd", H.diff, desc = "Rio: git diff" },
    { "<leader>gD", H.diff_staged, desc = "Rio: git diff (staged)" },
    { "<leader>gb", H.branch, desc = "Rio: git branch" },
    { "<leader>gB", H.branch_all, desc = "Rio: git branch (all)" },
    { "<leader>gg", H.summary, desc = "Rio: git summary" },
    { "<leader>gs", H.status, desc = "Rio: git status" },
    { "<leader>gz", H.stash, desc = "Rio: git stash" },
    { "<leader>T", H.top, desc = "Rio: top" },
  },
}
