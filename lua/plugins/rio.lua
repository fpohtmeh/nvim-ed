local H = {}

H.commit_hash_under_cursor = function()
  local line = vim.api.nvim_get_current_line()
  return line:match("^(%x+)")
end

H.git_log = function()
  require("rio").run("git log -{limit} --oneline --no-merges", {
    callbacks = {
      on_start = {},
      on_finish = function(callbacks)
        table.insert(callbacks, function(handle)
          vim.bo[handle.buf].filetype = "git"
        end)
      end,
    },
    params = { limit = 100 },
    keys = {
      ["<CR>"] = function()
        local hash = H.commit_hash_under_cursor()
        if hash then
          vim.cmd("0Git show " .. hash)
        end
      end,
    },
  })
end

return {
  "fpohtmeh/rio.nvim",
  dev = true,
  opts = {},
  keys = {
    { "<leader>R", H.git_log, desc = "Rio: git log" },
  },
}
