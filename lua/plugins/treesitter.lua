local H = {}

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
  "sql",
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
    enable = true,
  },
}

local plugin = {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  commit = vim.fn.has("nvim-0.12") == 0 and "7caec274fd19c12b55902a5b795100d21531391f" or nil,
  version = false,
  cmd = { "TSUpdate", "TSInstall", "TSLog", "TSUninstall" },
  build = ":TSUpdate",
  event = { "LazyFile", "VeryLazy" },
  opts = H.opts,
}

local text_objects = {
  "nvim-treesitter/nvim-treesitter-textobjects",
  branch = "main",
  event = "LazyFile",
}

return {
  plugin,
  text_objects,
}
