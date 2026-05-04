local H = {}

local actions = require("plugins.rio.git.actions")
local builtin = require("rio.callbacks.builtin")
local diff = require("plugins.rio.git.views.diff")
local togglers = require("rio.togglers")
local win_builtin = require("rio.resolver.win.builtin")

H.has_path = function(line, handle)
  if handle.state.toggles.porcelain.enabled then
    return line:match("^...(.+)$") ~= nil
  end
  return line:match("^\t") ~= nil
end

H.next_file = {
  action = function(handle)
    local buf = handle.state.buf
    local win = handle.state.win
    local cursor = vim.api.nvim_win_get_cursor(win)
    local lines = vim.api.nvim_buf_get_lines(buf, cursor[1], -1, false)
    for i, line in ipairs(lines) do
      if H.has_path(line, handle) then
        vim.api.nvim_win_set_cursor(win, { cursor[1] + i, 0 })
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
      if H.has_path(lines[i], handle) then
        vim.api.nvim_win_set_cursor(win, { i, 0 })
        return
      end
    end
  end,
  desc = "prev file",
  group = "Navigate",
}

H.unstaged_on_finish = function(handle)
  return function(callbacks)
    callbacks[1] = function(h)
      local _, x, _ = H.parse_line(handle)
      if x == "?" and h.result.code == 1 then
        return
      end
      return builtin.notify_error(h)
    end
    table.insert(callbacks, builtin.set_filetype("diff"))
  end
end

H.diff_file = {
  action = function(handle)
    local sibling_win
    local function resolve_win()
      if sibling_win and vim.api.nvim_win_is_valid(sibling_win) then
        vim.api.nvim_set_current_win(sibling_win)
        vim.cmd("belowright split")
      else
        vim.cmd("vsplit")
      end
      sibling_win = vim.api.nvim_get_current_win()
      return sibling_win
    end

    local diff_params = {
      whitespace = togglers.param("whitespace", "-w", false),
      word_diff = togglers.param("word_diff", "--word-diff", false),
      stat = togglers.param("stat", "--stat", false),
    }
    local diff_keys = {
      [";h"] = diff.keys[";h"],
      [",h"] = diff.keys[",h"],
      s = diff.keys.s,
      u = diff.keys.u,
      S = diff.keys.S,
      U = diff.keys.U,
      tw = togglers.key("whitespace"),
      td = togglers.key("word_diff"),
      ts = togglers.key("stat"),
    }

    local staged_opts = {
      parent = handle,
      link = { key = "diff_staged" },
      resolver = { win = { win_builtin.reuse, resolve_win } },
      callbacks = { on_finish = { builtin.set_filetype("diff") } },
      parsers = diff.parsers,
      params = diff_params,
      keys = diff_keys,
    }
    local unstaged_opts = {
      parent = handle,
      link = { key = "diff_unstaged" },
      resolver = {
        win = { win_builtin.reuse, resolve_win },
        callbacks = { on_finish = H.unstaged_on_finish(handle) },
      },
      parsers = diff.parsers,
      params = diff_params,
      keys = diff_keys,
    }
    require("rio").run("git diff {staged_args} {whitespace} {word_diff} {stat} {path}", staged_opts)
    require("rio").run("git diff {unstaged_args} {whitespace} {word_diff} {stat} {path}", unstaged_opts)
  end,
  desc = "diff file",
  group = "Diff",
}

H.parse_line = function(handle)
  local cursor = vim.api.nvim_win_get_cursor(handle.state.win)
  local line = vim.api.nvim_buf_get_lines(handle.state.buf, cursor[1] - 1, cursor[1], false)[1]
  if not line then
    return nil, nil, nil
  end
  local x, y, path
  if handle.state.toggles.porcelain.enabled then
    x = line:sub(1, 1)
    y = line:sub(2, 2)
    path = line:sub(4)
    if path == "" then
      return nil, nil, nil
    end
  else
    path = line:match("^\t.+:%s+(.+)$") or line:match("^\t(%S.*)$")
  end
  if not path then
    return nil, nil, nil
  end
  path = path:match("->%s*(.+)$") or path
  path = path:match("^(%S+)%s+%(") or path
  return path, x, y
end

H.parser = {
  ---@type fun(param: string, handle: Rio.Handle): string?
  parse = function(param, handle)
    local path, x, _ = H.parse_line(handle)
    if param == "path" then
      return path or "."
    end
    if param == "staged_args" then
      return "--staged --"
    end
    if param == "unstaged_args" then
      if x == "?" then
        return "--no-index -- /dev/null"
      end
      return "--"
    end
  end,
}

return function()
  local cmd = "git status {porcelain} {expand_untracked} {untracked} {submodules}"
  require("rio").run(cmd, {
    resolver = {
      win = { win_builtin.reuse, win_builtin.current },
    },
    parsers = { H.parser },
    params = {
      porcelain = togglers.param("porcelain", "--porcelain"),
      expand_untracked = togglers.param("expand_untracked", "-uall"),
      untracked = togglers.param("untracked", "-uno", false),
      submodules = togglers.param("submodules", "--ignore-submodules", false),
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
      tt = togglers.key("porcelain"),
      te = togglers.key("expand_untracked"),
      tu = togglers.key("untracked"),
      ts = togglers.key("submodules"),
    },
  })
end
