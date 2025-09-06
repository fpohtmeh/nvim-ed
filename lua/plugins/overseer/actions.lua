local M = {}
local H = {}

M.open_tasks_picker = function()
  vim.cmd("OverseerRun")
end

H.template_search_params = function()
  local dir = vim.fn.getcwd()
  if vim.bo.buftype == "" then
    local bufname = vim.api.nvim_buf_get_name(0)
    if bufname ~= "" then
      dir = vim.fn.fnamemodify(bufname, ":p:h")
    end
  end
  return { dir = dir, filetype = vim.bo.filetype }
end

H.find_and_run_template = function(templates, task_name)
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

H.find_recent_task = function()
  local tasks = require("overseer").list_tasks({ recent_first = true })
  if vim.tbl_isempty(tasks) then
    vim.notify("No recent task found", vim.log.levels.WARN)
  else
    return tasks[1]
  end
end

H.open_recent_task_output = function()
  local task = H.find_recent_task()
  if task == nil then
    return
  end

  task:open_output("horizontal")
  vim.cmd("wincmd J")
  vim.cmd("resize 15")
  require("overseer.util").scroll_to_end(0)
end

M.run_by_name = function(task_name)
  return function()
    local function callback(templates)
      H.find_and_run_template(templates, task_name)
    end
    require("overseer.template").list(H.template_search_params(), callback)
  end
end

M.restart_recent_task = function()
  local task = H.find_recent_task()
  if task ~= nil then
    require("overseer").run_action(task, "restart")
  end
end

M.toggle_tasks_list = function()
  vim.cmd("OverseerToggle right")
end

M.toggle_recent_task_output = function()
  local win = require("core.fn").find_window_by_filetype("OverseerOutput")
  if win == nil then
    H.open_recent_task_output()
    return
  end

  local win_tab = vim.api.nvim_win_get_tabpage(win)
  local current_tab = vim.api.nvim_get_current_tabpage()
  if win_tab ~= current_tab then
    vim.api.nvim_set_current_tabpage(win_tab)
    vim.api.nvim_set_current_win(win)
    return
  end

  local windows = vim.api.nvim_tabpage_list_wins(current_tab)
  if vim.fn.tabpagenr("$") > 1 or #windows > 1 then
    vim.api.nvim_win_close(win, false)
  else
    Snacks.notify.error("Cannot close last window")
  end
end

M.stop_recent_task = function()
  local task = H.find_recent_task()
  if task ~= nil then
    task:stop()
  end
end

return M
