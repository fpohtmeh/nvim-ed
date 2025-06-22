local H = {}

H.open_oil = function(item, cmd)
  local dir = item.file
  if not dir then
    return
  end

  local escaped_dir = require("core.fs").to_escaped(dir)
  if cmd then
    vim.cmd(cmd == "tab" and "tabnew" or cmd)
  end
  vim.cmd("Oil " .. escaped_dir)
end

H.confirm = function(picker, item, action)
  picker:close()
  H.open_oil(item, action.cmd)
end

H.zoxide_oil = function()
  Snacks.picker.pick("zoxide", {
    format = "file",
    win = {
      preview = { minimal = true },
    },
    actions = {
      confirm = H.confirm,
    },
  })
end

return {
  "folke/snacks.nvim",
  keys = {
    { "<leader>z", H.zoxide_oil, desc = "Zoxide Oil" },
  },
}
