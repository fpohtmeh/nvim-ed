local function git_log()
  require("rio").run("git log -100 --oneline --no-merges", {
    callbacks = {
      on_start = {},
      on_finish = function(callbacks)
        table.insert(callbacks, function(handle)
          vim.bo[handle.buf].filetype = "git"
        end)
      end,
    },
  })
end

return {
  "fpohtmeh/rio.nvim",
  dev = true,
  opts = {},
  keys = {
    { "<leader>R", git_log, desc = "Rio: git log" },
  },
}
