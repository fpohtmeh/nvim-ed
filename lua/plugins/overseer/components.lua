local fs = require("core.fs")

local M = {}

local function find_file(files)
  for _, file in ipairs(files) do
    if fs.path_exists(file) then
      return file
    end
  end
  return ""
end

local function load_parser(name)
  return require("plugins.overseer.parsers." .. name)
end

local function append_node(nodes, name, parser)
  table.insert(nodes, parser.node)
  require("plugins.overseer.parsers").add_name(name)
end

local function load_nodes()
  local nodes = {}
  -- cpp
  if find_file({ ".clang-format", "vcpkg.json", "CMakeLists.txt" }) then
    local parser = load_parser("cpp")
    append_node(nodes, "cpp", parser)
  end
  -- just
  local justfile = find_file({ ".justfile", "justfile" })
  if justfile then
    local parser = load_parser("just")
    parser.filename = justfile
    append_node(nodes, "just", parser)
  end
  return nodes
end

M.aliases = {
  default = {
    "on_output_summarize",
    "on_exit_set_status",
    { "on_output_parse", parser = { diagnostics = load_nodes() } },
    { "on_result_diagnostics_quickfix", open = true },
    "on_notify_status",
  },
}

return M
