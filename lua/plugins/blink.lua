local H = {}

H.is_enabled = function()
  local ignored_filetypes = { "snacks_picker_input" }
  return not vim.tbl_contains(ignored_filetypes, vim.bo.filetype)
end

H.completion = {
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
}

H.sources = {
  default = {
    "snippets",
    "buffer",
    "lsp",
    "ripgrep",
    "lazydev",
    "path",
  },
  providers = {
    lazydev = {
      name = "LazyDev",
      module = "lazydev.integrations.blink",
      score_offset = 100, -- show at a higher priority than lsp
    },
    ripgrep = {
      name = "Ripgrep",
      module = "blink-ripgrep",
      opts = {
        backend = {
          ripgrep = { max_filesize = "100K" },
        },
      },
    },
  },
}

return {
  "saghen/blink.cmp",
  version = "*",
  event = "InsertEnter",
  dependencies = {
    "mikavilpas/blink-ripgrep.nvim",
    version = "*",
  },
  opts = {
    appearance = {
      use_nvim_cmp_as_default = false,
      nerd_font_variant = "mono",
    },
    completion = H.completion,
    enabled = H.is_enabled,
    sources = H.sources,
    cmdline = {
      enabled = false,
      sources = {},
    },
    keymap = {
      preset = "enter",
      ["<C-y>"] = { "select_and_accept" },
      ["<CR>"] = {},
    },
  },
}
