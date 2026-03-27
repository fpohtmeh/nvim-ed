local M = {}
local H = {}

local fs = require("core.fs")
local terminal = require("core.terminal")

H.state = "inactive"
H.term = nil
H.enter = vim.fn.has("win32") == 1 and "\r\n" or "\r"

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
