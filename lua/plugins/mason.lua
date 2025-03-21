local border = require("core").border
local icons = require("core.icons").package

local H = {}

H.auto_install = function(ensure_installed)
  local registry = require("mason-registry")
  registry.refresh(function()
    for _, tool in ipairs(ensure_installed) do
      local p = registry.get_package(tool)
      if not p:is_installed() then
        p:install()
      end
    end
  end)
end

H.ensure_installed = {
  "black", -- python formatter
  "clang-format", -- cpp formatter
  "clangd", -- cpp server
  "lua-language-server", -- lua server
  "pyright", -- python server
  "shfmt", -- shell formatter
  "stylua", -- lua formatter
  "marksman", -- markdown server
}

H.ui_opts = {
  width = 0.7,
  height = 0.85,
  border = border,
  icons = {
    package_pending = icons.pending,
    package_installed = icons.installed,
    package_uninstalled = icons.uninstalled,
  },
}

return {
  "williamboman/mason.nvim",
  cmd = { "Mason", "MasonUpdate" },
  build = ":MasonUpdate",
  keys = {
    { "<leader>M", "<cmd>Mason<cr>", desc = "Mason" },
  },
  opts = {
    ensure_installed = H.ensure_installed,
    ui = H.ui_opts,
  },
  config = function(_, opts)
    require("mason").setup(opts)
    H.auto_install(opts.ensure_installed)
  end,
}
