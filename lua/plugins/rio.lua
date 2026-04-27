local function commit_hash_under_cursor()
  local line = vim.api.nvim_get_current_line()
  return line:match("^(%x+)")
end

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
    keys = {
      ["<CR>"] = function()
        local hash = commit_hash_under_cursor()
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
    { "<leader>R", git_log, desc = "Rio: git log" },
  },
}
