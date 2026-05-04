local M = {}
local H = {}

local builtin = require("rio.callbacks.builtin")
local togglers = require("rio.togglers")
local win_builtin = require("rio.resolver.win.builtin")

---@type Rio.Parser
H.parser = {
  parse = function(param, handle)
    local cursor = vim.api.nvim_win_get_cursor(handle.state.win)
    local line = vim.api.nvim_buf_get_lines(handle.state.buf, cursor[1] - 1, cursor[1], false)[1]

    if param == "path" then
      return line:match("%S+")
    end

    if param == "patch" then
      local lines = vim.api.nvim_buf_get_lines(handle.state.buf, 0, -1, false)
      local row = cursor[1]

      local hunk_start
      for i = row, 1, -1 do
        if lines[i]:match("^@@") then
          hunk_start = i
          break
        end
      end
      if not hunk_start then
        return nil
      end

      local header_start
      for i = hunk_start - 1, 1, -1 do
        if lines[i]:match("^diff %-%-git") then
          header_start = i
          break
        end
      end
      if not header_start then
        return nil
      end

      local patch = {}
      for i = header_start, hunk_start - 1 do
        table.insert(patch, lines[i])
      end
      for i = hunk_start, #lines do
        local l = lines[i]
        if i > hunk_start and (l:match("^@@") or l:match("^diff %-%-git")) then
          break
        end
        table.insert(patch, l)
      end
      return table.concat(patch, "\n") .. "\n"
    end
  end,
}

---@param lines string[]
---@param row number
---@return number, number
H.find_block = function(lines, row)
  local prefix = lines[row]:sub(1, 1)
  if prefix ~= "-" and prefix ~= "+" then
    return 0, 0
  end
  local first = row
  while first > 1 and lines[first - 1]:sub(1, 1) == prefix do
    first = first - 1
  end
  local last = row
  while last < #lines and lines[last + 1]:sub(1, 1) == prefix do
    last = last + 1
  end
  return first, last
end

---@param handle Rio.Handle
---@param reverse boolean
---@return string?
H.build_block_patch = function(handle, reverse)
  local cursor = vim.api.nvim_win_get_cursor(handle.state.win)
  local lines = vim.api.nvim_buf_get_lines(handle.state.buf, 0, -1, false)
  local row = cursor[1]

  local hunk_start
  for i = row, 1, -1 do
    if lines[i]:match("^@@") then
      hunk_start = i
      break
    end
  end
  if not hunk_start then
    return nil
  end

  local header_start
  for i = hunk_start - 1, 1, -1 do
    if lines[i]:match("^diff %-%-git") then
      header_start = i
      break
    end
  end
  if not header_start then
    return nil
  end

  local hunk_lines = {}
  for i = hunk_start + 1, #lines do
    local l = lines[i]
    if l:match("^@@") or l:match("^diff %-%-git") then
      break
    end
    table.insert(hunk_lines, { line = l, idx = i })
  end

  local block_first, block_last = H.find_block(lines, row)
  if block_first == 0 then
    return nil
  end

  local patch = {}
  for i = header_start, hunk_start - 1 do
    table.insert(patch, lines[i])
  end

  local old_count, new_count = 0, 0
  local body = {}
  for _, entry in ipairs(hunk_lines) do
    local c = entry.line:sub(1, 1)
    local in_block = entry.idx >= block_first and entry.idx <= block_last
    if c == " " then
      table.insert(body, entry.line)
      old_count = old_count + 1
      new_count = new_count + 1
    elseif c == "-" then
      if in_block then
        table.insert(body, entry.line)
        old_count = old_count + 1
      elseif reverse then
        -- skip: line doesn't exist in index
      else
        table.insert(body, " " .. entry.line:sub(2))
        old_count = old_count + 1
        new_count = new_count + 1
      end
    elseif c == "+" then
      if in_block then
        table.insert(body, entry.line)
        new_count = new_count + 1
      elseif reverse then
        table.insert(body, " " .. entry.line:sub(2))
        old_count = old_count + 1
        new_count = new_count + 1
      end
    end
  end

  local old_start = lines[hunk_start]:match("^@@ %-(%d+)")
  table.insert(patch, string.format("@@ -%s,%d +%s,%d @@", old_start, old_count, old_start, new_count))
  vim.list_extend(patch, body)
  return table.concat(patch, "\n") .. "\n"
end

---@type Rio.KeyDef
H.next_hunk = {
  action = function()
    vim.fn.search("^@@", "W")
  end,
  desc = "next hunk",
  group = "Navigate",
}

---@type Rio.KeyDef
H.prev_hunk = {
  action = function()
    vim.fn.search("^@@", "bW")
  end,
  desc = "prev hunk",
  group = "Navigate",
}

---@param patch string
---@param args string[]
---@param error_msg string
---@param handle Rio.Handle
H.apply_patch = function(patch, args, error_msg, handle)
  vim.fn.system(args, patch)
  if vim.v.shell_error ~= 0 then
    Snacks.notify.error(error_msg)
    return
  end
  builtin.refresh().action(handle)
end

---@type Rio.KeyDef
H.stage_block = {
  action = function(handle)
    local patch = H.build_block_patch(handle, false)
    if not patch then
      return
    end
    H.apply_patch(patch, { "git", "apply", "--cached" }, "Failed to stage block", handle)
  end,
  desc = "stage block",
  group = "Stage",
}

---@type Rio.KeyDef
H.unstage_block = {
  action = function(handle)
    local patch = H.build_block_patch(handle, true)
    if not patch then
      return
    end
    H.apply_patch(patch, { "git", "apply", "--cached", "--reverse" }, "Failed to unstage block", handle)
  end,
  desc = "unstage block",
  group = "Stage",
}

---@type Rio.KeyDef
H.stage_hunk = {
  action = function(handle)
    local patch = H.parser.parse("patch", handle)
    if not patch then
      return
    end
    H.apply_patch(patch, { "git", "apply", "--cached" }, "Failed to stage hunk", handle)
  end,
  desc = "stage hunk",
  group = "Stage",
}

---@type Rio.KeyDef
H.unstage_hunk = {
  action = function(handle)
    local patch = H.parser.parse("patch", handle)
    if not patch then
      return
    end
    H.apply_patch(patch, { "git", "apply", "--cached", "--reverse" }, "Failed to unstage hunk", handle)
  end,
  desc = "unstage hunk",
  group = "Stage",
}

---@type Rio.KeyDef
H.open_file_diff = {
  action = function(handle)
    if not handle.state.toggles.name_only.enabled then
      return
    end
    require("rio").run("git diff {commit}~1 {commit} -- {path}", {
      parent = handle,
      link = { key = "diff" },
      callbacks = { on_finish = { builtin.set_filetype("diff") } },
    })
  end,
  desc = "open file diff",
  group = "Navigate",
}

M.keys = {
  [";h"] = H.next_hunk,
  [",h"] = H.prev_hunk,
  s = H.stage_block,
  u = H.unstage_block,
  S = H.stage_hunk,
  U = H.unstage_hunk,
}

M.parsers = { H.parser }

---@param parent Rio.Handle
function M.for_commit(parent)
  local cmd = "git diff {name_only} {whitespace} {word_diff} {stat} {commit}~1 {commit}"
  require("rio").run(cmd, {
    parent = parent,
    link = { key = "diff" },
    parsers = { H.parser },
    params = {
      name_only = togglers.param("name_only", "--name-only", false),
      whitespace = togglers.param("whitespace", "-w", false),
      word_diff = togglers.param("word_diff", "--word-diff", false),
      stat = togglers.param("stat", "--stat", false),
    },
    callbacks = {
      on_finish = { builtin.set_filetype("diff") },
    },
    keys = {
      ["<CR>"] = H.open_file_diff,
      [";h"] = H.next_hunk,
      [",h"] = H.prev_hunk,
      tt = togglers.key("name_only"),
      tw = togglers.key("whitespace"),
      td = togglers.key("word_diff"),
      ts = togglers.key("stat"),
    },
  })
end

---@param opts? { staged?: boolean }
function M.working(opts)
  opts = opts or {}
  local staged = opts.staged or false
  local cmd = "git diff {staged} {whitespace} {word_diff} {stat}"
  require("rio").run(cmd, {
    resolver = {
      win = { win_builtin.reuse, win_builtin.current },
    },
    parsers = { H.parser },
    params = {
      staged = togglers.param("staged", "--staged", staged),
      whitespace = togglers.param("whitespace", "-w", false),
      word_diff = togglers.param("word_diff", "--word-diff", false),
      stat = togglers.param("stat", "--stat", false),
    },
    callbacks = {
      on_finish = { builtin.set_filetype("diff") },
    },
    keys = {
      [";h"] = H.next_hunk,
      [",h"] = H.prev_hunk,
      s = H.stage_block,
      u = H.unstage_block,
      S = H.stage_hunk,
      U = H.unstage_hunk,
      tt = togglers.key("staged"),
      tw = togglers.key("whitespace"),
      td = togglers.key("word_diff"),
      ts = togglers.key("stat"),
    },
  })
end

return M
