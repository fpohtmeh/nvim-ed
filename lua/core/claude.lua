local M = {}

M.state = "inactive"

local highlight_map = {
    idle = "LualineClaudeIdle",
    busy = "LualineClaudeBusy",
}

function M.set_state(state)
    M.state = state
    vim.cmd.redrawstatus()
    return ""
end

function M.component()
    return M.state ~= "inactive" and "claude" or ""
end

function M.color()
    return highlight_map[M.state] or highlight_map.inactive
end

return M
