local M = {}
local H = {}

local builtin = require("rio.callbacks.builtin")
local togglers = require("rio.togglers")

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

---@type Rio.KeyDef
H.stage_hunk = {
  action = function(handle)
    local patch = H.parser.parse("patch", handle)
    if not patch then
      return
    end
    vim.fn.system({ "git", "apply", "--cached" }, patch)
    if vim.v.shell_error ~= 0 then
      Snacks.notify.error("Failed to stage hunk")
      return
    end
    builtin.refresh().action(handle)
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
    vim.fn.system({ "git", "apply", "--cached", "--reverse" }, patch)
    if vim.v.shell_error ~= 0 then
      Snacks.notify.error("Failed to unstage hunk")
      return
    end
    builtin.refresh().action(handle)
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
      tt = togglers.key("name_only"),
      tw = togglers.key("whitespace"),
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
      s = H.stage_hunk,
      u = H.unstage_hunk,
      tt = togglers.key("staged"),
      tw = togglers.key("whitespace"),
      td = togglers.key("word_diff"),
      ts = togglers.key("stat"),
    },
  })
end

return M
