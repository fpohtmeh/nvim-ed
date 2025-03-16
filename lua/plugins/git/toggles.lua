local M = {}

M.current_line_blame = function()
  return Snacks.toggle({
    name = "Git Blame Line",
    get = function()
      return require("gitsigns.config").config.current_line_blame
    end,
    set = function(state)
      require("gitsigns").toggle_current_line_blame(state)
    end,
  })
end

return M
