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

M.mode = function()
  local args = { trunc_width = 120 }
  local mode, mode_hl = MiniStatusline.section_mode(args)
  return {
    hl = mode_hl,
    strings = { mode },
  }
end

M.git = function()
  local args = { trunc_width = 40 }
  return MiniStatusline.section_git(args)
end

M.filename = function()
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

M.fileinfo = function()
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

M.diff = function()
  local args = { trunc_width = 75, icon = "" }
  local diff = require("mini.statusline").section_diff(args):sub(2)
  return H.replace_icons(diff, "MiniStatuslineFilename", {
    ["+"] = "%#MiniStatuslineGitAdded# " .. H.icons.git.added,
    ["~"] = "%#MiniStatuslineGitModified# " .. H.icons.git.modified,
    ["-"] = "%#MiniStatuslineGitRemoved# " .. H.icons.git.removed,
  })
end

M.diagnostics = function()
  local args = { trunc_width = 75, icon = "" }
  local section = require("mini.statusline").section_diagnostics(args):sub(2)
  return H.replace_icons(section, "MiniStatuslineFilename", {
    ["E"] = "%#MiniStatuslineDiagnosticError# " .. H.icons.diagnostics.error,
    ["W"] = "%#MiniStatuslineDiagnosticWarn# " .. H.icons.diagnostics.warn,
    ["I"] = "%#MiniStatuslineDiagnosticInfo# " .. H.icons.diagnostics.info,
    ["H"] = "%#MiniStatuslineDiagnosticHint# " .. H.icons.diagnostics.hint,
  })
end

M.location = function()
  local args = { trunc_width = 75 }
  local lines_str = tostring(vim.api.nvim_buf_line_count(0))
  if MiniStatusline.is_truncated(args.trunc_width) then
    return lines_str
  end
  local line = vim.fn.line(".")
  return string.format("%" .. #lines_str .. "d:%s", line, lines_str)
end

M.searchcount = function()
  local args = { trunc_width = 75 }
  local section = require("mini.statusline").section_searchcount(args)
  return section ~= "" and (H.icons.search .. " " .. section) or ""
end

M.buffers = function()
  local current_buf_id = vim.api.nvim_get_current_buf()
  local buf_list = vim.api.nvim_list_bufs()
  local is_listed = function(buf_id)
    return vim.api.nvim_buf_is_valid(buf_id) and vim.bo[buf_id].buflisted
  end

  local index = 0
  local count = 0
  for buf_id = 1, buf_list[#buf_list] do
    if is_listed(buf_id) then
      count = count + 1
      if buf_id == current_buf_id then
        index = count
      end
    end
  end

  local status = H.icons.buffers .. " "
  if index ~= 0 then
    status = status .. tostring(index) .. "/"
  end
  return status .. tostring(math.max(count, 1))
end

return M
