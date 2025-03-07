local H = {}

H.ensure_installed = {
  "c",
  "cpp",
  "diff",
  "json",
  "json5",
  "jsonc",
  "lua",
  "luadoc",
  "markdown",
  "markdown_inline",
  "python",
  "query",
  "toml",
  "vim",
  "vimdoc",
  "xml",
  "yaml",
}

H.is_disabled = function(lang, buf)
  local max_filesize = 100 * 1024 -- 100 KB
  local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
  if ok and stats and stats.size > max_filesize then
    return true
  end
end

H.opts = {
  ensure_installed = H.ensure_installed,
  auto_install = true,
  highlight = {
    enable = true,
    disable = H.is_disabled,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enabled = true,
  },
}

return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup(H.opts)
  end,
}
