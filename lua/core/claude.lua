local M = {}
local H = {}

local fs = require("core.fs")
local terminal = require("core.terminal")

H.state = "inactive"
H.term = nil
H.enter = vim.fn.has("win32") == 1 and "\r\n" or "\r"

H.event_states = {
  UserPromptSubmit = "busy",
  Stop = "idle",
  SessionStart = "idle",
  SessionEnd = "inactive",
}

function M.process_event(event)
  local state = H.event_states[event]
  if state then
    M.set_state(state)
  end
  return ""
end

function M.set_state(state)
  H.state = state
  vim.cmd.redrawstatus()
  return ""
end

function M.component()
  return H.state ~= "inactive" and "claude" or ""
end

function M.color()
  local highlight_map = {
    idle = "LualineClaudeIdle",
    busy = "LualineClaudeBusy",
  }
  return highlight_map[H.state] or highlight_map.inactive
end

H.settings = (function()
  local base = vim.fn.stdpath("config"):gsub("\\", "/") .. "/scripts"
  if vim.fn.has("win32") == 1 then
    local hook = base .. "/claude-hook.ps1"
    local path = base .. "/claude-hooks-win.json"
    local entry = {
      type = "command",
      command = "pwsh -NoProfile -NonInteractive -ExecutionPolicy Bypass -File " .. hook,
      async = true,
    }
    local config = { hooks = {} }
    for _, event in ipairs({ "UserPromptSubmit", "Stop", "SessionStart", "SessionEnd" }) do
      config.hooks[event] = { { matcher = "", hooks = { entry } } }
    end
    local f = assert(io.open(path, "w"))
    f:write(vim.json.encode(config))
    f:close()
    return path
  end
  return base .. "/claude-hooks.json"
end)()

H.run = function(args)
  local cmd = "claude --settings " .. H.settings .. (args and " " .. args or "")
  H.term = Snacks.terminal(cmd, {
    cwd = fs.tab_cwd(),
    win = { position = "right", width = 80, keys = terminal.keys },
    env = { terminal_style = "claude" },
  })
end

function M.resume()
  H.run("--continue")
end

function M.new()
  H.run()
end

function M.send(text, submit)
  local buf = H.term and H.term.buf
  if not buf or not vim.api.nvim_buf_is_valid(buf) then
    vim.notify("No Claude terminal running", vim.log.levels.WARN)
    return
  end
  vim.fn.chansend(vim.b[buf].terminal_job_id, submit and text .. H.enter or text)
end

function M.input(submit)
  vim.ui.input({ prompt = "Claude: " }, function(input)
    if input then
      M.send(input, submit)
    end
  end)
end

function M.commit()
  M.send("commit", true)
end

function M.clear()
  M.send("/clear", true)
end

function M.send_qf(submit)
  local items = vim.fn.getqflist()
  if #items == 0 then
    vim.notify("Quickfix list is empty", vim.log.levels.WARN)
    return
  end
  local lines = vim.tbl_map(function(item)
    local fname = item.bufnr > 0 and vim.api.nvim_buf_get_name(item.bufnr) or ""
    return fname .. ":" .. item.lnum .. ": " .. item.text
  end, items)
  vim.ui.input({ prompt = "Claude: " }, function(input)
    if input then
      M.send(input .. H.enter .. table.concat(lines, H.enter), submit)
    end
  end)
end

return M
