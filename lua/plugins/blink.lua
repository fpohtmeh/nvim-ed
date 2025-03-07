return {
  "saghen/blink.cmp",
  version = "*",
  event = "InsertEnter",
  dependencies = {},
  opts = {
    appearance = {
      use_nvim_cmp_as_default = false,
      nerd_font_variant = "mono",
    },
    completion = {
      accept = {
        auto_brackets = { enabled = true },
      },
      menu = {
        max_height = 20,
        border = "single",
        draw = { treesitter = { "lsp" } },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
        window = {
          border = "single",
        },
      },
      ghost_text = { enabled = vim.g.ai_cmp },
    },
    enabled = function()
      local ignored_filetypes = { "snacks_picker_input" }
      return not vim.tbl_contains(ignored_filetypes, vim.bo.filetype)
    end,
    keymap = {
      ["<CR>"] = {},
    },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },
    cmdline = {
      enabled = false,
      sources = {},
    },
    keymap = {
      preset = "enter",
      ["<C-y>"] = { "select_and_accept" },
    },
  },
}
