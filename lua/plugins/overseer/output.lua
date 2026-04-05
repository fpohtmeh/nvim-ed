local M = {}
local H = {}

H.find_output_win = function()
  return require("core.windows").find_by_filetype("OverseerOutput")
end

H.get_sidebar_task = function()
  local sidebar = require("overseer.task_list.sidebar").get()
  if sidebar then
    return sidebar:get_task_from_line()
  end
end

H.find_recent_task = function()
  local tasks = require("overseer").list_tasks({ recent_first = true })
  if not vim.tbl_isempty(tasks) then
    return tasks[1]
  end
  vim.notify("No recent task found", vim.log.levels.WARN)
end

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

-- Pin

H.augroup = vim.api.nvim_create_augroup("OverseerPin", { clear = true })
H.pinned = true
H.pinned_task_id = nil
H.last_task_id = nil

H.setup_pin_autocmd = function(bufnr)
  vim.api.nvim_clear_autocmds({ group = H.augroup })
  vim.api.nvim_create_autocmd("CursorMoved", {
    group = H.augroup,
    buffer = bufnr,
    callback = function()
      if not H.pinned then
        return
      end
      if not H.find_output_win() then
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
  group = H.augroup,
  pattern = "OverseerList",
  callback = function(ev)
    H.setup_pin_autocmd(ev.buf)
  end,
})

vim.api.nvim_create_autocmd("User", {
  group = H.augroup,
  pattern = "OverseerListUpdate",
  callback = function()
    if not H.find_output_win() then
      return
    end
    local tasks = require("overseer").list_tasks({ recent_first = true })
    if vim.tbl_isempty(tasks) then
      return
    end
    local latest = tasks[1]
    if latest.id == H.last_task_id then
      return
    end
    if not latest:get_bufnr() then
      return
    end
    H.last_task_id = latest.id
    H.show_task_output(latest)
  end,
})

-- Public

M.toggle_list = function()
  vim.cmd("OverseerToggle right")
end

M.open = function()
  H.show_task_output(H.get_sidebar_task())
end

M.show_adjacent = function(direction)
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
  vim.notify("Tasks pin " .. (H.pinned and "on" or "off"))
end

M.toggle_recent = function()
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
