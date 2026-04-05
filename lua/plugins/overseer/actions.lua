local M = {}
local H = {}

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
      require("overseer").run_task({ name = template.name })
      return
    end
  end
  vim.notify("No tasks found: " .. task_name, vim.log.levels.WARN)
end

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

return M
