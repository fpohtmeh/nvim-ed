local diagnostic = require("plugins.lsp.diagnostic")
local clangd = require("plugins.lsp.clangd")

local H = {}
H.configure_servers = function()
  local config = require("lspconfig")
  config.lua_ls.setup({})
  config.pyright.setup({})
  config.clangd.setup(clangd.opts)
end

return {
  "neovim/nvim-lspconfig",
  event = "LazyFile",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    require("plugins.lsp.lazydev"),
  },
  config = function()
    H.configure_servers()
    diagnostic.configure()
  end,
  keys = clangd.keys,
}
