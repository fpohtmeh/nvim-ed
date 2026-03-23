local M = {}

M.ignored_filetypes = {
  "help",
  "snacks_dashboard",
  "snacks_terminal",
  "OverseerList",
  "OverseerOutput",
}

local aliases = {
  fugitive = "Git",
  qf = "quickfix",
}

function M.render()
  local ft = vim.bo.filetype
  if vim.tbl_contains(M.ignored_filetypes, ft) then
    return ""
  end
  local alias = aliases[ft]
  if alias then
    return "  " .. alias
  end
  local icon = require("nvim-web-devicons").get_icon(vim.fn.expand("%:t"), nil, { default = true })
  local filename = vim.fn.expand("%:.")
  if filename == "" then
    filename = "[No Name]"
  end
  local modified = vim.bo.modified and " [+]" or ""
  local readonly = vim.bo.readonly and " " .. require("core.icons").readonly or ""
  return "  " .. icon .. " " .. filename .. modified .. readonly
end

return M
