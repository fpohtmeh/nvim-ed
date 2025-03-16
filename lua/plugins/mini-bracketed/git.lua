local H = {}
local engine = require("plugins.mini-bracketed.engine")

H.git_opts = {}

H.get_git_data = function()
  local file_basenames = {}
  local fs = require("core.fs")

  local list = vim.fn.systemlist({ "git", "status", "-u", "--porcelain=v1" })
  for _, v in ipairs(list) do
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

Ed.bracketed.git = function(direction, opts)
  if engine.is_disabled() then
    return
  end

  engine.validate_direction(direction, { "first", "backward", "forward", "last" }, "git")
  opts = vim.tbl_deep_extend("force", { n_times = vim.v.count1, wrap = true }, H.git_opts, opts or {})

  local git_data = H.get_git_data()
  if git_data == nil then
    return
  end
  local file_basenames, directory = git_data.file_basenames, git_data.directory

  local iterator = engine.make_iterator(#file_basenames)

  local fs = require("core.fs")
  local cur_filename = fs.buf_full_path()
  if cur_filename ~= "" then
    for index, file_basename in ipairs(file_basenames) do
      if cur_filename == fs.join(directory, file_basename) then
        iterator.state = index
        break
      end
    end
  end

  local res_index = MiniBracketed.advance(iterator, direction, opts)
  if res_index == iterator.state then
    return
  end

  local target_path = fs.join(directory, file_basenames[res_index])
  engine.edit(target_path)
end
