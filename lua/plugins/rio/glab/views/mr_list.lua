local H = {}

local diff_view = require("plugins.rio.glab.views.mr_diff")
local info_view = require("plugins.rio.glab.views.mr_info")
local rio = require("rio")
local togglers = require("rio.togglers")
local util = require("plugins.rio.glab.util")
local view_view = require("plugins.rio.glab.views.mr_view")
local win_builtin = require("rio.resolver.win.builtin")

---@type Rio.KeyDef
H.show_info = { action = info_view.show, desc = "show info", group = "Navigate" }

---@type Rio.KeyDef
H.show_view = { action = view_view.show, desc = "show details", group = "Navigate" }

---@type Rio.KeyDef
H.show_diff = { action = diff_view.show, desc = "show diff", group = "Navigate" }

---@type Rio.Parser
H.parser = {
  parse = function(param, handle)
    if param ~= "iid" then
      return nil
    end
    local cursor = vim.api.nvim_win_get_cursor(handle.state.win)
    local line = vim.api.nvim_buf_get_lines(handle.state.buf, cursor[1] - 1, cursor[1], false)[1]
    return line and line:match("^!(%d+)")
  end,
}

---@type Rio.KeyDef
H.checkout = {
  action = util.mutation("glab mr checkout {iid}", "checkout"),
  desc = "checkout",
  group = "MR",
}

---@type Rio.KeyDef
H.approve = {
  action = util.confirmed_mutation("glab mr approve {iid}", "approve", "Approve MR?"),
  desc = "approve",
  group = "MR",
}

---@type Rio.KeyDef
H.revoke = {
  action = util.confirmed_mutation("glab mr revoke {iid}", "revoke", "Revoke approval?"),
  desc = "revoke approval",
  group = "MR",
}

---@type Rio.KeyDef
H.merge = {
  action = util.confirmed_mutation("glab mr merge {iid} -y", "merge", "Merge MR?"),
  desc = "merge",
  group = "MR",
}

---@type Rio.KeyDef
H.web = {
  action = util.mutation("glab mr view {iid} --web", "open in browser"),
  desc = "open in browser",
  group = "MR",
}

return function()
  rio.run("glab mr list --not-draft {mine} {review} {state}", {
    resolver = {
      win = { win_builtin.reuse, win_builtin.current },
      callbacks = util.notify_callbacks("listing MRs"),
    },
    parsers = { H.parser },
    params = {
      mine = togglers.param("mine", "--assignee=@me", false),
      review = togglers.param("review", "--reviewer=@me", false),
      state = togglers.param("state", "--merged", false),
    },
    keys = {
      ["<CR>"] = H.show_info,
      dd = H.show_view,
      D = H.show_diff,
      co = H.checkout,
      a = H.approve,
      A = H.revoke,
      M = H.merge,
      gx = H.web,
      tt = togglers.key("state"),
      tm = togglers.key("mine"),
      tr = togglers.key("review"),
    },
  })
end
