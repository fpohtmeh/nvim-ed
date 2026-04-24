local M = {}

local icons = require("core.icons")
local fs = require("core.fs")

M.buffers = {
  function()
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

    local count_str = tostring(math.max(count, 1))
    if index == 0 then
      return icons.buffers .. " " .. count_str
    end
    return icons.buffers .. " " .. tostring(index) .. "/" .. count_str
  end,
  color = function()
    local current_buf_id = vim.api.nvim_get_current_buf()
    local buf_list = vim.api.nvim_list_bufs()
    local modified_count = 0
    local current_modified = false
    for buf_id = 1, buf_list[#buf_list] do
      if vim.api.nvim_buf_is_valid(buf_id) and vim.bo[buf_id].buflisted and vim.bo[buf_id].modified then
        modified_count = modified_count + 1
        if buf_id == current_buf_id then
          current_modified = true
        end
      end
    end
    if modified_count == 0 then
      return "LualineBuffers"
    end
    local is_unsaved = modified_count > 1 or (modified_count == 1 and not current_modified)
    return is_unsaved and "LualineUnsaved" or "LualineModified"
  end,
}

M.directory = {
  function()
    if vim.bo.buftype == "terminal" then
      return ""
    end
    local directory = vim.fn.getcwd()
    local filename = fs.buf_full_path()
    if filename:sub(1, #directory) ~= directory then
      return ""
    end
    local home = vim.env.HOME
    if home and directory:sub(1, #home) == home then
      directory = "~" .. directory:sub(#home + 1)
    end
    return directory
  end,
  padding = { left = 1, right = 0 },
  cond = function()
    return vim.o.columns > 140
  end,
  color = "LualineDirectory",
}

M.filename = {
  function()
    if vim.fn.bufname() == "" then
      return ""
    end
    if vim.bo.buftype == "terminal" then
      return vim.fn.bufname() --"%t"
    end
    local directory = vim.fn.getcwd()
    local filename = fs.buf_full_path()
    if filename:sub(1, #directory) == directory then
      filename = filename:sub(#directory + 2)
    end
    local prefix = vim.bo.readonly and icons.readonly .. " " or ""
    return prefix .. filename
  end,
  cond = function()
    return vim.o.columns > 140
  end,
  color = "LualineFilename",
}

M.filename_short = {
  "filename",
  path = 0,
  symbols = { readonly = icons.readonly },
  cond = function()
    return vim.o.columns <= 140
  end,
  color = "LualineFilename",
}

M.filesize = {
  function()
    local size = math.max(vim.fn.line2byte(vim.fn.line("$") + 1) - 1, 0)
    if size < 1024 then
      return string.format("%dB", size)
    elseif size < 1048576 then
      return string.format("%.2fKB", size / 1024)
    else
      return string.format("%.2fMB", size / 1048576)
    end
  end,
  color = function()
    local size = math.max(vim.fn.line2byte(vim.fn.line("$") + 1) - 1, 0)
    return size >= 1048576 and "LualineBigFileinfo" or nil
  end,
  cond = function()
    return vim.bo.buftype == "" and vim.o.columns > 120
  end,
}

M.location = {
  function()
    local lines_str = tostring(vim.api.nvim_buf_line_count(0))
    if vim.o.columns <= 75 then
      return lines_str
    end
    local line = vim.fn.line(".")
    local col = vim.fn.charcol(".")
    return string.format("%3d|%" .. #lines_str .. "d:%s", col, line, lines_str)
  end,
}

M.claude = {
  require("core.claude").component,
  color = require("core.claude").color,
}

M.searchcount = {
  "searchcount",
  fmt = function(str)
    return str ~= "" and icons.search .. " " .. str or ""
  end,
}

return M
