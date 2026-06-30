local M = {}
local H = {}

H.state = "inactive"

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

return M
