local M = {}

M.filename = "justfile"

---@diagnostic disable-next-line: unused-local
local function set_filename(item, ctx)
  item.filename = M.filename
end

M.node = {
  "extract",
  { postprocess = set_filename },
  "^(error): (.+) on line (%d+) with exit code (%d+)$",
  "type",
  "text",
  "lnum",
  "code",
}

return M
