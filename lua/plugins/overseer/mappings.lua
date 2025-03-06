local actions = require("plugins.overseer.actions")

local M = {}

local prefix = "<leader>j"

local function create_by_task_name(key, task_name)
  local action = actions.run_by_name(task_name)
  return {
    prefix .. key,
    action,
    desc = "Run task '" .. task_name .. "'",
  }
end

M.keys = {
  {
    prefix .. "j",
    actions.open_tasks_picker,
    desc = "Select task",
  },
  {
    prefix .. ".",
    actions.restart_recent_task,
    desc = "Restart last task",
  },
  {
    prefix .. "l",
    actions.toggle_tasks_list,
    desc = "Toggle tasks list",
  },
  {
    prefix .. "/",
    actions.toggle_recent_task_output,
    desc = "Toggle last task output",
  },
  create_by_task_name("r", "run"),
  create_by_task_name("b", "build"),
  create_by_task_name("t", "test"),
  create_by_task_name("x", "clean"),
}

M.add_by_task_name = function(key, task_name)
  M.keys[#M.keys + 1] = create_by_task_name(key, task_name)
end

M.remove_by_key = function(key)
  M.keys[#M.keys + 1] = { prefix .. key, false }
end

return M
