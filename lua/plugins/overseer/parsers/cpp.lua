local M = {}

---@diagnostic disable-next-line: unused-local
local function fix_filename(item, ctx)
  if item.filename:sub(1, 3) == "..\\" then
    item.filename = item.filename:sub(4)
  end
end

local r = {
  begin = "^",
  filename = "(.-)",
  line_col = "%((%d+),?(%d*)%)",
  type = "(%a*%s?error)",
  code = "(%w%d+)",
  any_text = "(.+)",
  eol = "$",
}

-- Examples:
-- * D:\Projects\foo\bar.cpp(2,5): error C1234: '=': left operand must be l-value [D:\Projects\foo\build\bar.vcxproj]
-- * ..\foo\main.cpp(31): error C4430: missing type specifier - int assumed. Note: C++ does not support default-int
M.node = {
  "extract",
  { postprocess = fix_filename },
  r.begin .. r.filename .. r.line_col .. ": " .. r.type .. " " .. r.code .. ": " .. r.any_text .. r.eol,
  "filename",
  "lnum",
  "col",
  "type",
  "code",
  "text",
}

return M
