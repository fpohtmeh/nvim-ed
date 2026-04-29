local togglers = require("rio.togglers")

---@param opts? { all?: boolean }
return function(opts)
  opts = opts or {}
  local all = opts.all or false
  local cmd = "git branch {all}"
  require("rio").run(cmd, {
    params = {
      all = togglers.param("all", "-a", all),
    },
    keys = {
      tt = togglers.key("all"),
    },
  })
end
