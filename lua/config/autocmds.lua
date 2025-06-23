-- LSP
require("core.lsp").create_autocmds()

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
    vim.hl.on_yank({ higroup = "YankHighlight", timeout = 250 })
  end,
})

-- Grug-far
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "grug-far" },
  callback = function(event)
    require("plugins.grug-far.keymaps").attach_to_buffer(event.buf)
  end,
})

-- Format
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function(args)
    require("core.format").format(args.buf)
  end,
})

-- Block comment support
local block_autocmd
block_autocmd = vim.api.nvim_create_autocmd("FileType", {
  pattern = { "qml" },
  callback = function()
    require("Comment.ft").set("qml", { "//%s", "/*%s*/" })
    pcall(vim.api.nvim_del_autocmd, block_autocmd)
  end,
})

-- Set comment string
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "qmake", "http" },
  callback = function()
    vim.bo.commentstring = "# %s"
  end,
})

-- Cursor word condition
require("plugins.mini-cursorword.core").create_autocmds()

-- Incline
vim.api.nvim_create_autocmd("User", {
  pattern = "PersistenceLoadPost",
  callback = require("plugins.incline.core").defer_refresh,
})

-- Format options
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.bo.formatoptions = "jnl"
  end,
})

-- Git
require("plugins.git.sync").create_autocmds()

vim.api.nvim_create_autocmd("FileType", {
  pattern = "gitcommit",
  callback = function()
    vim.cmd.startinsert()
  end,
})

-- Tabs / indentation width
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "lua" },
  callback = function()
    vim.bo.softtabstop = 2
    vim.bo.tabstop = 2
    vim.bo.shiftwidth = 2
  end,
})
