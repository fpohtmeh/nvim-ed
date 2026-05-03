local H = {}

local actions = require("plugins.rio.git.actions")
local builtin = require("rio.callbacks.builtin")

H.format_output = function(handle)
  local stdout = handle.result.stdout
  local staged = {}
  local unstaged = {}
  local untracked = {}

  for _, line in ipairs(vim.split(stdout, "\n", { trimempty = true })) do
    local x = line:sub(1, 1)
    local y = line:sub(2, 2)
    local file = line:sub(4)
    file = file:match("->%s*(.+)$") or file

    if x == "?" then
      table.insert(untracked, "  " .. file)
    else
      if x ~= " " then
        table.insert(staged, "  " .. x .. " " .. file)
      end
      if y ~= " " then
        table.insert(unstaged, "  " .. y .. " " .. file)
      end
    end
  end

  local lines = {}
  local sections = {
    { "Staged", staged },
    { "Unstaged", unstaged },
    { "Untracked", untracked },
  }
  for _, section in ipairs(sections) do
    if #section[2] > 0 then
      if #lines > 0 then
        table.insert(lines, "")
      end
      table.insert(lines, section[1] .. " (" .. #section[2] .. ")")
      vim.list_extend(lines, section[2])
    end
  end

  handle.state.lines = lines
end

H.is_file_line = function(line)
  return line:match("^  ") ~= nil
end

H.is_section_line = function(line)
  return line:match("^%S") ~= nil
end

H.parse_path = function(line)
  local path = line:match("^  %S (.+)$") or line:match("^  (.+)$")
  if not path then
    return nil
  end
  return path:match("^(%S+)%s+%(") or path
end

H.parser = {
  parse = function(param, handle)
    if param ~= "path" then
      return nil
    end
    local buf = handle.state.buf
    local win = handle.state.win
    local cursor = vim.api.nvim_win_get_cursor(win)
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    local row = cursor[1]
    -- current line first, then search down, then up
    if H.is_file_line(lines[row]) then
      return H.parse_path(lines[row])
    end
    for offset = 1, #lines do
      if row + offset <= #lines and H.is_file_line(lines[row + offset]) then
        return H.parse_path(lines[row + offset])
      end
      if row - offset >= 1 and H.is_file_line(lines[row - offset]) then
        return H.parse_path(lines[row - offset])
      end
    end
  end,
}

H.next_file = {
  action = function(handle)
    local buf = handle.state.buf
    local win = handle.state.win
    local cursor = vim.api.nvim_win_get_cursor(win)
    local lines = vim.api.nvim_buf_get_lines(buf, cursor[1], -1, false)
    for i, line in ipairs(lines) do
      if H.is_file_line(line) then
        vim.api.nvim_win_set_cursor(win, { cursor[1] + i, 2 })
        return
      end
    end
  end,
  desc = "next file",
  group = "Navigate",
}

H.prev_file = {
  action = function(handle)
    local buf = handle.state.buf
    local win = handle.state.win
    local cursor = vim.api.nvim_win_get_cursor(win)
    local lines = vim.api.nvim_buf_get_lines(buf, 0, cursor[1] - 1, false)
    for i = #lines, 1, -1 do
      if H.is_file_line(lines[i]) then
        vim.api.nvim_win_set_cursor(win, { i, 2 })
        return
      end
    end
  end,
  desc = "prev file",
  group = "Navigate",
}

H.current_section = function(handle)
  local buf = handle.state.buf
  local win = handle.state.win
  local cursor = vim.api.nvim_win_get_cursor(win)
  local lines = vim.api.nvim_buf_get_lines(buf, 0, cursor[1], false)
  for i = #lines, 1, -1 do
    if H.is_section_line(lines[i]) then
      return lines[i]:match("^(%S+)")
    end
  end
end

H.diff_cmds = {
  Staged = "git diff --staged -- {path}",
  Unstaged = "git diff -- {path}",
  Untracked = "git diff --no-index -- /dev/null {path}",
}

H.diff_file = {
  action = function(handle)
    local section = H.current_section(handle)
    local cmd = H.diff_cmds[section]
    if not cmd then
      return
    end
    local opts = {
      parent = handle,
      link = { key = "diff" },
      callbacks = { on_finish = { builtin.set_filetype("diff") } },
    }
    if section == "Untracked" then
      opts.resolver = {
        callbacks = {
          on_finish = function(cbs)
            cbs[1] = function() end
          end,
        },
      }
    end
    require("rio").run(cmd, opts)
  end,
  desc = "diff file",
  group = "Diff",
}

H.go_to_section = function(prefix)
  return {
    action = function(handle)
      local buf = handle.state.buf
      local win = handle.state.win
      local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
      for i, line in ipairs(lines) do
        if line:match("^" .. prefix) then
          vim.api.nvim_win_set_cursor(win, { i, 0 })
          return
        end
      end
    end,
    desc = prefix:lower() .. " section",
    group = "Navigate",
  }
end

return function()
  require("rio").run("git status --porcelain -uall", {
    parsers = { H.parser },
    resolver = {
      callbacks = {
        on_finish = function(finish_actions)
          table.insert(finish_actions, 2, H.format_output)
        end,
      },
    },
    keys = {
      ["<CR>"] = actions.open_path,
      ["-"] = actions.toggle,
      s = actions.stage,
      a = actions.stage_all,
      u = actions.unstage,
      X = actions.discard,
      cc = actions.commit,
      ce = actions.amend,
      st = actions.stash_all,
      su = actions.stash_unstaged,
      ss = actions.stash_staged,
      R = actions.reset_staged,
      dd = H.diff_file,
      [";;"] = H.next_file,
      [",,"] = H.prev_file,
      gs = H.go_to_section("Staged"),
      gu = H.go_to_section("Unstaged"),
      gt = H.go_to_section("Untracked"),
    },
  })
end
