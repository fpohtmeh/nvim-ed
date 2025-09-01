local H = {}

H.current_win = nil

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
  vim.api.nvim_set_current_win(H.current_win)
  H.open_oil(item, action.cmd)
end

H.zoxide_oil = function()
  H.current_win = vim.api.nvim_get_current_win()
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
    { "<leader>d", H.zoxide_oil, desc = "Zoxide Directory" },
  },
}
