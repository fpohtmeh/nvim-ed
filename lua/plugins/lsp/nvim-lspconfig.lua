local diagnostic = require("plugins.lsp.diagnostic")
local clangd = require("plugins.lsp.clangd")

local H = {}
H.configure_servers = function()
  vim.lsp.config("clangd", clangd.opts)
  vim.lsp.enable({ "lua_ls", "pyright", "clangd", "marksman", "yamlls" })
end

return {
  "neovim/nvim-lspconfig",
  event = "VeryLazy",
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
