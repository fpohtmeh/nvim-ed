_G.Ed = {
  colorscheme = vim.env.NVIM_COLORSCHEME or "tokyonight",
  is_nested = vim.env.NVIM ~= nil,
}

_G.dd = function(...)
  Snacks.debug.inspect(...)
end
