local M = {}

M.capitalize = function(word)
  if type(word) ~= "string" then
    return nil, "Input must be a string"
  end
  if #word == 0 then
    return ""
  end
  return string.upper(string.sub(word, 1, 1)) .. string.sub(word, 2)
end

M.is_visual_mode = function(mode)
  mode = mode or vim.fn.mode(true)
  return mode == "v" or mode == "V" or mode == "\22"
end

return M
