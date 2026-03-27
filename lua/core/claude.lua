local M = {}
local H = {}

local fs = require("core.fs")
local terminal = require("core.terminal")

H.state = "inactive"
H.term = nil

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

H.settings = vim.fn.stdpath("config") .. "/scripts/claude-hooks.json"

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

function M.send(text)
  local buf = H.term and H.term.buf
  if not buf or not vim.api.nvim_buf_is_valid(buf) then
    vim.notify("No Claude terminal running", vim.log.levels.WARN)
    return
  end
  vim.fn.chansend(vim.b[buf].terminal_job_id, text .. "\n")
end

function M.input()
  vim.ui.input({ prompt = "Claude: " }, function(input)
    if input then
      M.send(input)
    end
  end)
end

return M
