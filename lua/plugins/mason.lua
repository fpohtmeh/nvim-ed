local border = require("core").border
local icons = require("core.icons").package

return {
  "williamboman/mason.nvim",
  cmd = "Mason",
  build = ":MasonUpdate",
  keys = {
    { "<leader>M", "<cmd>Mason<cr>", desc = "Mason" },
  },
  opts = {
    ensure_installed = {
      "stylua",
      "shfmt",
    },
    ui = {
      width = 0.7,
      height = 0.85,
      border = border,
      icons = {
        package_pending = icons.pending,
        package_installed = icons.installed,
        package_uninstalled = icons.uninstalled,
      },
    },
  },
  config = function(_, opts)
    require("mason").setup(opts)
    local registry = require("mason-registry")
    registry.refresh(function()
      for _, tool in ipairs(opts.ensure_installed) do
        local p = registry.get_package(tool)
        if not p:is_installed() then
          p:install()
        end
      end
    end)
  end,
}
