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

H.hooks = (function()
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

H.hooks_ref = vim.fn.has("win32") == 1 and "$env:CLAUDE_HOOKS" or '"$CLAUDE_HOOKS"'

H.float_height = function()
  return vim.o.lines - 1
end

H.geometry = function(style)
  if style == "float" then
    return { position = "float", row = 0, col = 0, width = 0, height = H.float_height, border = "none", zindex = 50 }
  end
  return { position = "bottom", height = 0.4, border = "none" }
end

H.keys = vim.tbl_extend("force", {}, terminal.keys, {
  toggle_style = {
    "<A-t>",
    function()
      M.toggle_style()
    end,
    mode = { "n", "t" },
    desc = "Toggle Claude window",
  },
})

H.win = function(style)
  return vim.tbl_extend("force", {
    keys = H.keys,
    relative = "editor",
    backdrop = false,
  }, H.geometry(style))
end

H.cmd = function(action)
  local base = "claude --settings " .. H.hooks_ref
  local flag = action == "resume" and "--resume" or "--continue"
  return base .. " " .. flag .. " || " .. base
end

H.run = function(style, action)
  H.style = style
  H.cwd = fs.tab_cwd()
  H.term = Snacks.terminal(H.cmd(action), {
    cwd = H.cwd,
    win = H.win(style),
    env = { terminal_style = "claude", CLAUDE_HOOKS = H.hooks },
  })
end

H.close = function()
  if H.term and H.term:buf_valid() then
    vim.api.nvim_buf_delete(H.term.buf, { force = true })
  end
  H.term = nil
end

H.apply_style = function(style)
  local o, g = H.term.opts, H.geometry(style)
  o.relative = "editor"
  o.backdrop = false
  o.row, o.col = g.row, g.col
  o.position = g.position
  o.width = g.width
  o.height = g.height
  o.border = g.border
  o.zindex = g.zindex
  H.style = style
end

H.show = function(style)
  if not (H.term and H.term:buf_valid()) then
    return H.run(style)
  end
  if H.style ~= style then
    H.term:hide()
    H.apply_style(style)
  end
  if not H.term:win_valid() then
    H.term:show()
  end
  H.term:focus()
end

function M.bottom()
  H.show("bottom")
end

function M.toggle_style()
  H.show(H.style == "float" and "bottom" or "float")
end

function M.resume()
  H.close()
  H.run(H.style or "float", "resume")
end

function M.send(text, submit)
  local buf = H.term and H.term.buf
  if buf and vim.api.nvim_buf_is_valid(buf) then
    return vim.fn.chansend(vim.b[buf].terminal_job_id, submit and text .. H.enter or text)
  end
  H.show(H.style or "float")
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
