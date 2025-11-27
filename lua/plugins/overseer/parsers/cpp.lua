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
  line_col_colon = ":(%d+):(%d+)",
  type = "(%a*%s?error)",
  code = "(%w%d+)",
  any_text = "(.+)",
  eol = "$",
}

-- Examples:
-- * D:\Projects\foo\bar.cpp(2,5): error C1234: '=': left operand must be l-value [D:\Projects\foo\build\bar.vcxproj]
-- * ..\foo\main.cpp(31): error C4430: missing type specifier - int assumed. Note: C++ does not support default-int
-- * /Users/user/Projects/MyApp/MyRenderer.cpp:29:16: error: no member named 'property' in 'MyClass'
M.node = {
  "loop",
  {
    "extract",
    { postprocess = fix_filename },
    r.begin .. r.filename .. r.line_col .. ": " .. r.type .. " " .. r.code .. ": " .. r.any_text .. r.eol,
    "filename",
    "lnum",
    "col",
    "type",
    "code",
    "text",
  },
  {
    "extract",
    { postprocess = fix_filename },
    r.begin .. r.filename .. r.line_col_colon .. ": " .. r.type .. ": " .. r.any_text .. r.eol,
    "filename",
    "lnum",
    "col",
    "type",
    "text",
  },
}

return M
