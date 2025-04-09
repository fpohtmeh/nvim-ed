return {
  "folke/lazydev.nvim",
  ft = "lua",
  opts = {
    library = {
      { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      { path = "${3rd}/love2d/library", words = { "love" } },
      { path = "snacks.nvim", words = { "Snacks" } },
      { path = "lazy.nvim", words = { "LazyVim" } },
      { path = "mini.bracketed", words = { "MiniBracketed" } },
    },
  },
}
