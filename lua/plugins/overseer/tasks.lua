local M = {}
local H = {}

H.find_recent_task = function()
  local tasks = require("overseer").list_tasks({ recent_first = true })
  if not vim.tbl_isempty(tasks) then
    return tasks[1]
  end
  vim.notify("No recent task found", vim.log.levels.WARN)
end

H.get_sidebar_task = function()
  local sidebar = require("overseer.task_list.sidebar").get()
  if sidebar then
    return sidebar:get_task_from_line()
  end
end

H.get_sidebar_tasks_in_range = function()
  local sidebar = require("overseer.task_list.sidebar").get()
  if not sidebar then
    return {}
  end
  local mode = vim.fn.mode()
  local start_line, end_line
  if mode == "v" or mode == "V" then
    start_line = vim.fn.line("v")
    end_line = vim.fn.line(".")
    if start_line > end_line then
      start_line, end_line = end_line, start_line
    end
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
  else
    start_line = vim.fn.line(".")
    end_line = start_line
  end
  local seen = {}
  local tasks = {}
  for lnum = start_line, end_line do
    local task = sidebar:get_task_from_line(lnum)
    if task and not seen[task.id] then
      seen[task.id] = true
      tasks[#tasks + 1] = task
    end
  end
  return tasks
end

H.for_selected_tasks = function(fn)
  return function()
    local tasks = H.get_sidebar_tasks_in_range()
    for i = #tasks, 1, -1 do
      fn(tasks[i])
    end
  end
end

-- Single task

M.restart_recent = function()
  local task = H.find_recent_task()
  if not task then
    return
  end
  require("overseer").run_action(task, "restart")
end

M.restart = function()
  local task = H.get_sidebar_task()
  if not task then
    return
  end
  require("overseer").run_action(task, "restart")
end

M.stop_recent = function()
  local task = H.find_recent_task()
  if not task then
    return
  end
  task:stop()
end

-- All tasks

M.stop_all = function()
  local tasks = require("overseer").list_tasks({ status = "RUNNING" })
  for _, task in ipairs(tasks) do
    task:stop()
  end
end

M.restart_all = function()
  local tasks = require("overseer").list_tasks({ recent_first = true })
  for i = #tasks, 1, -1 do
    require("overseer").run_action(tasks[i], "restart")
  end
end

M.dispose_all = function()
  local tasks = require("overseer").list_tasks()
  for _, task in ipairs(tasks) do
    task:dispose(true)
  end
end

-- Selected tasks

M.dispose_selected = H.for_selected_tasks(function(task)
  task:dispose(true)
end)
M.stop_selected = H.for_selected_tasks(function(task)
  task:stop()
end)
M.restart_selected = H.for_selected_tasks(function(task)
  require("overseer").run_action(task, "restart")
end)

return M
