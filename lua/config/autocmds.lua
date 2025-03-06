-- Indentation

local function disable_indentation()
  vim.b.miniindentscope_disable = true
end

vim.api.nvim_create_autocmd("User", {
  pattern = "SnacksDashboardOpened",
  callback = disable_indentation,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = require("core").indentation.excluded_filetypes,
  callback = disable_indentation,
})
