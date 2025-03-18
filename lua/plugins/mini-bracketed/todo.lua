local H = {}
local engine = require("plugins.mini-bracketed.engine")

H.get_todo_rows = function()
  local rows = {}
  local last_line = vim.fn.line("$")

  for line_num = 1, last_line do
    local line_content = vim.fn.getline(line_num)
    if line_content:match("TODO:") then
      table.insert(rows, line_num)
    end
  end

  return #rows > 0 and rows or nil
end

Ed.bracketed.todo = function(direction, opts)
  if engine.is_disabled() then
    return
  end

  engine.validate_direction(direction, { "first", "backward", "forward", "last" }, "todo")
  opts = vim.tbl_deep_extend("force", { n_times = vim.v.count1, wrap = true }, opts or {})

  local rows = H.get_todo_rows()
  if rows == nil then
    return
  end

  local iterator = engine.make_iterator(#rows)

  local current_row = vim.api.nvim_win_get_cursor(0)[1]
  for index, row in ipairs(rows) do
    if current_row >= row then
      iterator.state = index
    end
  end

  local res_index = MiniBracketed.advance(iterator, direction, opts)
  if res_index == iterator.state then
    return
  end

  vim.api.nvim_win_set_cursor(0, { rows[res_index], 0 })
end
