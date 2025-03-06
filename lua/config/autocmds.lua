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

-- Yank
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({ higroup = "FlashLabel", timeout = 250 })
  end,
})

-- Grug-far
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "grug-far" },
  callback = function(event)
    require("plugins.grug-far.keymaps").attach_to_buffer(event.buf)
  end,
})
