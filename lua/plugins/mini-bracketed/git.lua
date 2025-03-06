local H = {}

H.git_opts = {}

H.get_git_data = function()
  local file_basenames = {}
  local fs = require("core.fs")

  local list = vim.fn.systemlist({ "git", "status", "--porcelain=v1" })
  for i, v in ipairs(list) do
    local status = string.sub(v, 1, 2)
    local is_staged = string.sub(status, 2) == " "
    if not is_staged then
      local file = fs.to_native(string.sub(v, 4))
      table.insert(file_basenames, file)
    end
  end
  if #file_basenames == 0 then
    return nil
  end
  table.sort(file_basenames)

  return {
    directory = fs.cwd(),
    file_basenames = file_basenames,
  }
end

local engine = require("plugins.mini-bracketed.engine")

Bracketed.git = function(direction, opts)
  if engine.is_disabled() then
    return
  end

  engine.validate_direction(direction, { "first", "backward", "forward", "last" }, "file")
  opts = vim.tbl_deep_extend("force", { n_times = vim.v.count1, wrap = true }, H.git_opts, opts or {})

  local git_data = H.get_git_data()
  if git_data == nil then
    return
  end
  local file_basenames, directory = git_data.file_basenames, git_data.directory

  local iterator = {}
  local n_files = #file_basenames

  iterator.next = function(ind)
    if ind == nil then
      return 1
    end
    if n_files <= ind then
      return
    end
    return ind + 1
  end

  iterator.prev = function(ind)
    if ind == nil then
      return n_files
    end
    if ind <= 1 then
      return
    end
    return ind - 1
  end

  local path_sep = package.config:sub(1, 1)
  local cur_filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":~")
  local cur_basename_ind
  if cur_basename ~= "" then
    for i, f in ipairs(file_basenames) do
      if cur_filename == directory .. path_sep .. f then
        cur_basename_ind = i
        break
      end
    end
  end

  iterator.state = cur_basename_ind
  iterator.start_edge = 0
  iterator.end_edge = n_files + 1

  local res_ind = MiniBracketed.advance(iterator, direction, opts)
  if res_ind == iterator.state then
    return
  end

  local target_path = directory .. path_sep .. file_basenames[res_ind]
  engine.edit(target_path)
end
