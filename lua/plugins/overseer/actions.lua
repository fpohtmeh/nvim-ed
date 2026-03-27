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
  for _, template in ipairs(templates) do
    if string.find(template.name, task_name) then
      require("overseer").run_template({ name = template.name })
      return
    end
  end
  vim.notify("No tasks found: " .. task_name, vim.log.levels.WARN)
end

H.find_output_win = function()
  return require("core.fn").find_window_by_filetype("OverseerOutput")
end

H.pin_augroup = vim.api.nvim_create_augroup("OverseerPin", { clear = true })
H.pinned = true
H.pinned_task_id = nil

H.setup_pin_autocmd = function(bufnr)
  vim.api.nvim_clear_autocmds({ group = H.pin_augroup })
  vim.api.nvim_create_autocmd("CursorMoved", {
    group = H.pin_augroup,
    buffer = bufnr,
    callback = function()
      if not H.pinned then
        return
      end
      local t = H.get_sidebar_task()
      if not t or t.id == H.pinned_task_id then
        return
      end
      H.pinned_task_id = t.id
      H.show_task_output(t)
    end,
  })
end

vim.api.nvim_create_autocmd("FileType", {
  group = H.pin_augroup,
  pattern = "OverseerList",
  callback = function(ev)
    H.setup_pin_autocmd(ev.buf)
  end,
})

H.open_task_output = function(task)
  task:open_output("horizontal")
  vim.cmd("wincmd J")
  vim.cmd("resize 15")
  require("overseer.util").scroll_to_end(0)
end

H.show_task_output = function(task)
  if not task then
    return
  end
  local bufnr = task:get_bufnr()
  if not bufnr then
    return
  end
  local win = H.find_output_win()
  if not win then
    return H.open_task_output(task)
  end
  vim.api.nvim_win_set_buf(win, bufnr)
  require("overseer.util").scroll_to_end(win)
end

H.current_task_index = function(tasks)
  local win = H.find_output_win()
  if not win then
    return
  end
  local bufnr = vim.api.nvim_win_get_buf(win)
  for i, task in ipairs(tasks) do
    if task:get_bufnr() == bufnr then
      return i
    end
  end
end

H.focus_sidebar_task = function(task)
  local sidebar = require("overseer.task_list.sidebar").get()
  if not sidebar then
    return
  end
  sidebar:focus_task_id(task.id)
end

-- Run / pick tasks

M.open_tasks_picker = function()
  vim.cmd("OverseerRun")
end

M.run_by_name = function(task_name)
  return function()
    require("overseer.template").list(H.template_search_params(), function(templates)
      H.find_and_run_template(templates, task_name)
    end)
  end
end

-- Restart / stop

M.restart_recent_task = function()
  local task = H.find_recent_task()
  if not task then
    return
  end
  require("overseer").run_action(task, "restart")
end

M.restart_task = function()
  local task = H.get_sidebar_task()
  if not task then
    return
  end
  require("overseer").run_action(task, "restart")
end

M.stop_recent_task = function()
  local task = H.find_recent_task()
  if not task then
    return
  end
  task:stop()
end

M.stop_all_tasks = function()
  local tasks = require("overseer").list_tasks({ status = "RUNNING" })
  for _, task in ipairs(tasks) do
    task:stop()
  end
end

-- Output / UI

M.toggle_tasks_list = function()
  vim.cmd("OverseerToggle right")
end

M.open_task_output = function()
  H.show_task_output(H.get_sidebar_task())
end

M.show_adjacent_task_output = function(direction)
  return function()
    local tasks = require("overseer").list_tasks({ recent_first = true })
    if vim.tbl_isempty(tasks) then
      return
    end
    local idx = H.current_task_index(tasks)
    if not idx then
      H.show_task_output(tasks[1])
      H.focus_sidebar_task(tasks[1])
      return
    end
    local next_idx = ((idx - 1 + direction) % #tasks) + 1
    H.show_task_output(tasks[next_idx])
    H.focus_sidebar_task(tasks[next_idx])
  end
end

M.toggle_pin = function()
  H.pinned = not H.pinned
  H.pinned_task_id = nil
end

M.toggle_recent_task_output = function()
  local win = H.find_output_win()
  if win == nil then
    local task = H.find_recent_task()
    if task then
      H.open_task_output(task)
    end
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

return M
