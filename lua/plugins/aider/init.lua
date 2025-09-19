local H = {}

local fn = require("plugins.aider.fn")

H.make_key = function(letter, command, description)
  local cmd = function()
    local opts = require("core.terminal").aider_opts
    local func = type(command) == "function" and command or require("nvim_aider.api")[command]
    func(opts)
  end
  local mode = command == "send_to_terminal" and "v" or { "n", "v" }
  return { "<leader>a" .. letter, cmd, desc = "Aider: " .. description, mode = mode }
end

H.make_send_command = function(command)
  return function(opts)
    fn.send_command(command, opts)
  end
end

H.session_prefix = ".aider.session-"
H.session_suffix = ".md"

H.make_save_command = function(opts)
  local suffix = vim.fn.input({
    prompt = "Session name (letters, digits, spaces only): ",
    default = "main",
  })

  if suffix == "" then
    Snacks.notify.warn("Session name cannot be empty")
    return nil
  end

  if not suffix:match("^[%w%s]*$") then
    Snacks.notify.warn("Invalid characters in session name")
    return nil
  end

  local session_name = H.session_prefix .. suffix .. H.session_suffix
  fn.send_command("/save " .. session_name, opts)
end

H.make_load_command = function(opts)
  local git_root = Snacks.git.get_root()
  if not git_root then
    Snacks.notify.warn("Not in a git repository")
    return nil
  end

  local pattern = H.session_prefix .. "*" .. H.session_suffix
  local files = vim.fn.glob(git_root .. "/" .. pattern, false, true)

  if #files == 0 then
    Snacks.notify.warn("No session files found")
    return nil
  end

  local items = {}
  for _, file in ipairs(files) do
    local basename = vim.fn.fnamemodify(file, ":t")
    local suffix = basename:sub(#H.session_prefix + 1, -#H.session_suffix - 1)
    table.insert(items, suffix)
  end

  local load = function(session_name)
    if session_name ~= nil then
      local full_name = H.session_prefix .. session_name .. H.session_suffix
      fn.send_command("/load " .. full_name, opts)
    end
  end

  vim.ui.select(items, { prompt = "Select Aider session:" }, load)
end

return {
  "GeorgesAlkhouri/nvim-aider",
  cmd = "Aider",
  keys = {
    H.make_key("t", "toggle_terminal", "Toggle"),
    -- Add
    H.make_key("a", "add_current_file", "Add current file"),
    H.make_key("A", "add_read_only_file", "Add readonly file"),
    -- Drop/reset
    H.make_key("d", "drop_current_file", "Drop current file"),
    H.make_key("D", H.make_send_command("/drop"), "Drop all"),
    H.make_key("X", "reset_session", "Reset session"),
    -- Session
    H.make_key("s", H.make_save_command, "Save session"),
    H.make_key("l", H.make_load_command, "Load session"),
    -- Send
    H.make_key("v", "send_to_terminal", "Send selection"),
    H.make_key("b", "send_buffer_with_prompt", "Send buffer"),
    H.make_key("q", "send_diagnostics_with_prompt", "Send buffer diagnostics"),
    -- Commands
    H.make_key("<CR>", H.make_send_command("/voice"), "Voice"),
    H.make_key("c", H.make_send_command("/commit"), "Commit"),
  },
  opts = {
    aider_cmd = "aider",
    auto_reload = true,
    picker_cfg = { preset = "ivy" },
  },
  dependencies = { "folke/snacks.nvim" },
}
