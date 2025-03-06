local default_info = "Parsers: -"

local M = {
  info = default_info,
}

M.add_name = function(name)
  if M.info == default_info then
    M.info = M.info:sub(1, -2) .. name
  else
    M.info = M.info .. ", " .. name
  end
end

return M
