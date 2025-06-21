local M = {}
local H = {}

local fs = require("core.fs")

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
  return {
    hl = "MiniStatuslineDevinfo",
    strings = { MiniStatusline.section_git(args) },
  }
end

M.directory = function()
  local args = { trunc_width = 140 }
  if vim.bo.buftype == "terminal" or MiniStatusline.is_truncated(args.trunc_width) then
    return { hl = "MiniStatuslineDirectory", strings = { "" } }
  end

  local directory = vim.fn.getcwd()
  local filename = fs.buf_full_path()
  if filename:sub(1, #directory) ~= directory then
    return { hl = "MiniStatuslineDirectory", strings = { "" } }
  end

  local home = vim.env.HOME
  if home and directory:sub(1, #home) == home then
    directory = "~" .. directory:sub(#home + 1)
  end
  return { hl = "MiniStatuslineDirectory", strings = { directory } }
end

M.filename = function()
  local args = { trunc_width = 140 }
  if vim.fn.bufname() == "" then
    return { hl = "MiniStatuslineFilename", strings = { "" } }
  end
  if vim.bo.buftype == "terminal" or MiniStatusline.is_truncated(args.trunc_width) then
    return { hl = "MiniStatuslineFilename", strings = { "%t" } }
  end

  local directory = vim.fn.getcwd()
  local filename = fs.buf_full_path()
  if filename:sub(1, #directory) == directory then
    filename = filename:sub(#directory + 2)
  end
  local prefix = vim.bo.readonly and H.icons.readonly .. " " or ""
  return { hl = "MiniStatuslineFilename", strings = { prefix .. filename } }
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
  local wrap = function(text)
    return "%#MiniStatuslineFileinfo# " .. text .. " "
  end

  local filetype = vim.bo.filetype
  if filetype ~= "" then
    filetype = H.get_icon() .. " " .. filetype
  end

  if MiniStatusline.is_truncated(args.trunc_width) or vim.bo.buftype ~= "" then
    return wrap(filetype)
  end

  local encoding = vim.bo.fileencoding or vim.bo.encoding
  local info = filetype and (filetype .. " " .. encoding) or encoding
  local filesize = H.get_filesize()
  if filesize:sub(-2) == "MB" then
    return wrap(info .. " %#MiniStatuslineBigFileinfo#" .. filesize)
  end
  return wrap(info .. " " .. filesize)
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
  local col = vim.fn.charcol(".")
  return string.format("%3d|%" .. #lines_str .. "d:%s", col, line, lines_str)
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
  local modified_count = 0
  local is_current_modified = false
  for buf_id = 1, buf_list[#buf_list] do
    if is_listed(buf_id) then
      count = count + 1
      if buf_id == current_buf_id then
        index = count
      end
      if vim.bo[buf_id].modified then
        modified_count = modified_count + 1
        is_current_modified = is_current_modified or index == count
      end
    end
  end

  local is_unsaved = modified_count > 1 or modified_count == 1 and not is_current_modified
  local icon_hl = modified_count == 0 and "MiniStatuslineBuffers"
    or is_unsaved and "MiniStatuslineUnsaved"
    or "MiniStatuslineModified"

  local icon = H.icons.buffers
  local count_str = tostring(math.max(count, 1))
  local str = ""
  if index == 0 then
    str = icon .. " " .. count_str
  else
    str = icon .. " " .. tostring(index) .. "/" .. count_str
  end
  return { hl = icon_hl, strings = { str } }
end

return M
