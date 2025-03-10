local M = {}
local H = {}

H.icons = require("core.icons")

---@param str string -- input string
---@param hl string -- highlight
---@param map table<string, string> -- map for replace
H.replace_icons = function(str, hl, map)
  if str == "" or str == "-" then
    return ""
  end

  local function replace(char)
    if char == " " then
      return "%#" .. hl .. "#"
    end
    for key, value in pairs(map) do
      if key == char then
        return value
      end
    end
    return char
  end

  str = str .. " "
  local res = ""
  for i = 1, #str do
    res = res .. replace(str:sub(i, i))
  end
  return res
end

M.section_filename = function()
  local args = { trunc_width = 140 }
  if vim.bo.buftype == "terminal" then
    return "%t"
  end

  local modified = vim.bo.modified and " " .. H.icons.modified or ""
  if MiniStatusline.is_truncated(args.trunc_width) then
    return "%f%r" .. modified
  else
    return "%F%r" .. modified
  end
end

H.get_filesize = function()
  local size = math.max(vim.fn.line2byte(vim.fn.line("$") + 1) - 1, 0)
  if size < 1024 then
    return string.format("%dB", size)
  elseif size < 1048576 then
    return string.format("%.2fKB", size / 1024)
  else
    return string.format("%.2fMB", size / 1048576)
  end
end

H.get_icon = function()
  local devicons = require("nvim-web-devicons")
  return devicons.get_icon(vim.fn.expand("%:t"), nil, { default = true })
end

M.section_fileinfo = function()
  local args = { trunc_width = 120 }

  local filetype = vim.bo.filetype
  if filetype ~= "" then
    filetype = H.get_icon() .. " " .. filetype
  end

  if MiniStatusline.is_truncated(args.trunc_width) or vim.bo.buftype ~= "" then
    return filetype
  end

  local encoding = vim.bo.fileencoding or vim.bo.encoding
  local size = H.get_filesize()

  return string.format("%s%s%s %s", filetype, filetype == "" and "" or " ", encoding, size)
end

M.section_diff = function(hl)
  local args = { trunc_width = 75, icon = "" }
  local diff = require("mini.statusline").section_diff(args):sub(2)
  return H.replace_icons(diff, hl, {
    ["+"] = "%#MiniStatuslineGitAdded# " .. H.icons.git.added,
    ["~"] = "%#MiniStatuslineGitModified# " .. H.icons.git.modified,
    ["-"] = "%#MiniStatuslineGitRemoved# " .. H.icons.git.removed,
  })
end

M.section_diagnostics = function(hl)
  local args = { trunc_width = 75, icon = "" }
  local section = require("mini.statusline").section_diagnostics(args):sub(2)
  return H.replace_icons(section, hl, {
    ["E"] = "%#MiniStatuslineDiagnosticError# " .. H.icons.diagnostics.error,
    ["W"] = "%#MiniStatuslineDiagnosticWarn# " .. H.icons.diagnostics.warn,
    ["I"] = "%#MiniStatuslineDiagnosticInfo# " .. H.icons.diagnostics.info,
    ["H"] = "%#MiniStatuslineDiagnosticHint# " .. H.icons.diagnostics.hint,
  })
end

return M
