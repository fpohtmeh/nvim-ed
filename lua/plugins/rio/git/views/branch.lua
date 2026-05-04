local H = {}

local builtin = require("rio.callbacks.builtin")
local rio = require("rio")
local togglers = require("rio.togglers")
local win_builtin = require("rio.resolver.win.builtin")

---@type Rio.Parser
H.parser = {
  parse = function(param, handle)
    if param ~= "branch" then
      return nil
    end
    local cursor = vim.api.nvim_win_get_cursor(handle.state.win)
    local line = vim.api.nvim_buf_get_lines(handle.state.buf, cursor[1] - 1, cursor[1], false)[1]
    return line:match("^%s*%*?%s*(%S+)")
  end,
}

---@type Rio.KeyDef
H.show_log = {
  action = function(parent)
    rio.run("git log --oneline -100 --decorate {branch}", {
      parent = parent,
      link = { key = "log" },
      callbacks = {
        on_finish = { builtin.set_filetype("git") },
      },
    })
  end,
  desc = "show log",
  group = "Navigate",
}

---@param opts? { all?: boolean }
return function(opts)
  opts = opts or {}
  local all = opts.all or false
  local cmd = "git branch {all}"
  require("rio").run(cmd, {
    resolver = {
      win = { win_builtin.reuse, win_builtin.current },
    },
    parsers = { H.parser },
    params = {
      all = togglers.param("all", "-a", all),
    },
    keys = {
      ["<CR>"] = H.show_log,
      tt = togglers.key("all"),
    },
  })
end
