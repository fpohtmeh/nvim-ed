local H = {}

H.get_notification_id = function(task)
  return "overseer_task_progress_" .. table.concat(task.cmd, "_")
end

H.get_display_task = function(task)
  return table.concat(task.cmd, " ")
end

H.title = "Task"

---@diagnostic disable-next-line: unused-local
H.on_start = function(self, task)
  local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
  local message = "[RUNNING:] " .. H.get_display_task(task)
  vim.notify(message, vim.log.levels.INFO, {
    id = H.get_notification_id(task),
    title = H.title,
    timeout = 0,
    opts = function(notif)
      notif.icon = spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1] .. " "
    end,
  })
end

---@diagnostic disable-next-line: unused-local
H.on_complete = function(self, task, status, result)
  local levels = {
    ["SUCCESS"] = vim.log.levels.INFO,
    ["FAILURE"] = vim.log.levels.ERROR,
    ["CANCELED"] = vim.log.levels.WARN,
  }
  local message = "[" .. status:upper() .. ":] " .. H.get_display_task(task)
  vim.notify(message, levels[status], {
    id = H.get_notification_id(task),
    title = H.title,
  })
end

---@diagnostic disable-next-line: unused-local
H.render = function(self, task, lines, highlights, detail)
  table.insert(lines, require("plugins.overseer.parsers").info)
end

return {
  "Report task progress",
  params = {},
  constructor = function()
    return {
      on_start = H.on_start,
      on_complete = H.on_complete,
      render = H.render,
    }
  end,
}
