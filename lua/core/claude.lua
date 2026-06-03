local M = {}
local H = {}

local fs = require("core.fs")
local terminal = require("core.terminal")

H.state = "inactive"
H.term = nil
H.enter = "\r"

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
    local src = base .. "/claude-hooks-win.json"
    local dst = base .. "/claude-hooks-win.local.json"
    if vim.fn.filereadable(dst) == 0 then
      vim.fn.writefile(vim.fn.readfile(src), dst)
    end
    return dst
  end
  return base .. "/claude-hooks.json"
end)()

H.run = function(args)
  local cmd = "claude --settings " .. H.settings .. (args and " " .. args or "")
  H.cwd = fs.tab_cwd()
  H.term = Snacks.terminal(cmd, {
    cwd = H.cwd,
    win = { position = "right", width = 80, keys = terminal.keys },
    env = { terminal_style = "claude" },
  })
end

function M.resume()
  vim.notify("Resuming Claude session…", vim.log.levels.INFO)
  H.run("--continue")
end

function M.new()
  H.run()
end

function M.send(text, submit)
  local buf = H.term and H.term.buf
  if buf and vim.api.nvim_buf_is_valid(buf) then
    return vim.fn.chansend(vim.b[buf].terminal_job_id, submit and text .. H.enter or text)
  end
  M.resume()
  vim.defer_fn(function()
    M.send(text, submit)
  end, 1000)
end

function M.input(submit)
  vim.ui.input({ prompt = "Claude: " }, function(input)
    if input then
      M.send(input, submit)
    end
  end)
end

function M.send_file()
  local path = fs.buf_full_path()
  if path == "" then
    vim.notify("No file in current buffer", vim.log.levels.WARN)
    return
  end
  path = fs.to_unix(path)
  local cwd = fs.to_unix(H.cwd or fs.tab_cwd())
  if path:sub(1, #cwd + 1) == cwd .. "/" then
    path = path:sub(#cwd + 2)
  end
  M.send("@" .. path .. " ", false)
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
