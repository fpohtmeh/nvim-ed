local H = {}

H.file = function(path)
  vim.cmd("edit " .. vim.fn.fnameescape(path))
end

H.dir = function(path)
  local ok, oil = pcall(require, "oil")
  if ok then
    oil.open(path)
  else
    H.file(path)
  end
end

return function(path)
  if vim.fn.isdirectory(path) == 1 then
    H.dir(path)
  else
    H.file(path)
  end
end
