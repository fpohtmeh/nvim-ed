vim.filetype.add({
  extension = {
    plist = "xml",
    manifest = "xml",
    log = "log",
  },
})

return {
  -- GraphQL
  {
    "jparise/vim-graphql",
    ft = { "graphql" },
  },
  -- just (https://github.com/casey/just)
  {
    "NoahTheDuke/vim-just",
    ft = { "just" },
  },
  -- logs
  {
    "fei6409/log-highlight.nvim",
    ft = { "log" },
  },
}
