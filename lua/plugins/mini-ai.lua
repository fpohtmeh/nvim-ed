local H = {}

H.ai_buffer = function(ai_type)
  local start_line, end_line = 1, vim.fn.line("$")
  if ai_type == "i" then
    local first_nonblank, last_nonblank = vim.fn.nextnonblank(start_line), vim.fn.prevnonblank(end_line)
    if first_nonblank == 0 or last_nonblank == 0 then
      return { from = { line = start_line, col = 1 } }
    end
    start_line, end_line = first_nonblank, last_nonblank
  end

  local to_col = math.max(vim.fn.getline(end_line):len(), 1)
  return {
    from = { line = start_line, col = 1 },
    to = { line = end_line, col = to_col },
  }
end

H.opts = function()
  local ai = require("mini.ai")
  return {
    n_lines = 500,
    custom_textobjects = {
      f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
      c = ai.gen_spec.treesitter({ a = "@comment.outer", i = "@comment.inner" }),
      t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, -- tags
      e = { -- Word with case
        { "%u[%l%d]+%f[^%l%d]", "%f[%S][%l%d]+%f[^%l%d]", "%f[%P][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]" },
        "^().*()$",
      },
      g = H.ai_buffer,
    },
  }
end

return {
  "echasnovski/mini.ai",
  event = "LazyFile",
  opts = H.opts,
}
