local H = {}

H.event = { "LazyFile", "VeryLazy" }

H.ensure_installed = {
  "bash",
  "c",
  "cpp",
  "diff",
  "gitignore",
  "json",
  "json5",
  "jsonc",
  "lua",
  "luap",
  "luadoc",
  "markdown",
  "markdown_inline",
  "python",
  "regex",
  "query",
  "toml",
  "vim",
  "vimdoc",
  "xml",
  "yaml",
}

H.is_disabled = function(_, buf)
  local max_filesize = 100 * 1024 -- 100 KB
  local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
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

local plugin = {
  "nvim-treesitter/nvim-treesitter",
  event = H.event,
  version = false,
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup(H.opts)
  end,
}

local text_objects = {
  "nvim-treesitter/nvim-treesitter-textobjects",
  event = H.event,
}

return {
  plugin,
  text_objects,
}
