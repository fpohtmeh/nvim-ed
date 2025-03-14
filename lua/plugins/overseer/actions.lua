local M = {}

M.open_tasks_picker = function()
  vim.cmd("OverseerRun")
end

local function template_search_params()
  local dir = vim.fn.getcwd()
  if vim.bo.buftype == "" then
    local bufname = vim.api.nvim_buf_get_name(0)
    if bufname ~= "" then
      dir = vim.fn.fnamemodify(bufname, ":p:h")
    end
  end
  return { dir = dir, filetype = vim.bo.filetype }
end

local function find_and_run_template(templates, task_name)
  local found = false
  for _, template in ipairs(templates) do
    if found then
      break
    end
    local start_pos, _ = string.find(template.name, task_name)
    if start_pos then
      found = true
      require("overseer").run_template({ name = template.name })
    end
  end
  if not found then
    vim.notify("No tasks found: " .. task_name, vim.log.levels.WARN)
  end
end

M.run_by_name = function(task_name)
  return function()
    local function callback(templates)
      find_and_run_template(templates, task_name)
    end
    require("overseer.template").list(template_search_params(), callback)
  end
end

local find_recent_task = function()
  local tasks = require("overseer").list_tasks({ recent_first = true })
  if vim.tbl_isempty(tasks) then
    vim.notify("No recent task found", vim.log.levels.WARN)
  else
    return tasks[1]
  end
end

M.restart_recent_task = function()
  local task = find_recent_task()
  if task ~= nil then
    require("overseer").run_action(task, "restart")
  end
end

M.toggle_tasks_list = function()
  vim.cmd("OverseerToggle right")
end

M.toggle_recent_task_output = function()
  local win = require("core.fn").find_window_by_filetype("OverseerOutput")
  if win ~= nil then
    vim.api.nvim_win_close(win, false)
    return
  end

  local task = find_recent_task()
  if task ~= nil then
    task:open_output("horizontal")

    vim.cmd([[
      wincmd J
      resize 15
    ]])
    require("overseer.util").scroll_to_end(0)
  end
end

return M
