local M = {}
local H = {}

local icons = require("core.icons")
local titles = require("plugins.lualine.titles")

H.filename = function()
  local rio_cmd = vim.b.rio_cmd
  if rio_cmd then
    return icons.git.icon .. " " .. rio_cmd
  end
  local bufname = vim.api.nvim_buf_get_name(0)
  local title = titles.by_bufname(bufname)
  if title then
    local is_term = bufname:match("^term://")
    if not is_term then
      return title
    end
    local is_claude = bufname:match("claude%f[%A]")
    return is_claude and title or icons.terminal .. " " .. title
  end
  title = titles.by_filetype(vim.bo.filetype)
  if title then
    if vim.bo.filetype == "OverseerOutput" then
      local task_id = vim.b.overseer_task
      if task_id then
        local task = require("overseer.task_list").get(task_id)
        if task then
          return title .. ": " .. task.name
        end
      end
    end
    return title
  end

  bufname = vim.fn.expand("%:t")
  icon = require("nvim-web-devicons").get_icon(bufname, nil, { default = true })
  name = vim.fn.expand("%:.")
  if name == "" then
    name = "[No Name]"
  end

  local modified = vim.bo.modified and (" " .. core.modified) or ""
  local readonly = vim.bo.readonly and " " .. icons.readonly or ""
  return icon .. " " .. name .. modified .. readonly
end

H.key = function()
  if Ed.is_nested then
    return "[term]"
  end
  local keys = require("core").keys.window
  local k = keys[vim.api.nvim_win_get_number(0)] or ""
  return k ~= "" and "#" .. k or ""
end

M.filename = { H.filename, color = "WinBar" }
M.filename_inactive = { H.filename, color = "WinBarNC" }
M.key = { H.key, color = "WinBar" }
M.key_inactive = { H.key, color = "WinBarNC" }

return M
