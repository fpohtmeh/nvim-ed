_G.Ed = {
  colorscheme = vim.env.NVIM_COLORSCHEME or "tokyonight",
}

_G.dd = function(...)
  Snacks.debug.inspect(...)
end
