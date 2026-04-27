local H = {}

H.commit_hash_under_cursor = function()
  local line = vim.api.nvim_get_current_line()
  return line:match("^(%x+)")
end

H.toggles = {}

H.make_toggle_param = function(key, value, enabled)
  if enabled == nil then
    enabled = true
  end
  H.toggles[key] = { enabled = enabled, value = value }
  return function()
    return H.toggles[key].enabled and value or ""
  end
end

H.make_filetype = function(ft)
  return function(callbacks)
    table.insert(callbacks, function(handle)
      vim.bo[handle.buf].filetype = ft
    end)
  end
end

H.make_toggle_key = function(key)
  return function(handle)
    local toggle = H.toggles[key]
    toggle.enabled = not toggle.enabled
    vim.notify("[rio] Toggled parameter: " .. key .. " " .. (toggle.enabled and "ON" or "OFF"))
    require("rio.callbacks.builtin").refresh(handle)
  end
end

H.git_diff = function(hash)
  require("rio").run("git diff {name_only} {whitespace} {word_diff} {stat} {commit}~1 {commit}", {
    params = {
      commit = hash,
      name_only = H.make_toggle_param("name_only", "--name-only", false),
      whitespace = H.make_toggle_param("whitespace", "-w", false),
      word_diff = H.make_toggle_param("word_diff", "--word-diff", false),
      stat = H.make_toggle_param("stat", "--stat", false),
    },
    callbacks = {
      on_start = {},
      on_finish = H.make_filetype("diff"),
    },
    keys = {
      tt = H.make_toggle_key("name_only"),
      tw = H.make_toggle_key("whitespace"),
      ts = H.make_toggle_key("stat"),
    },
  })
end

H.git_log = function()
  require("rio").run("git log {limit} {oneline} {merges}", {
    callbacks = {
      on_finish = H.make_filetype("git"),
    },
    params = {
      limit = H.make_toggle_param("limit", "-100"),
      oneline = H.make_toggle_param("oneline", "--oneline"),
      merges = H.make_toggle_param("merges", "--no-merges"),
    },
    keys = {
      ["<CR>"] = function()
        local hash = H.commit_hash_under_cursor()
        if hash then
          H.git_diff(hash)
        end
      end,
      tl = H.make_toggle_key("limit"),
      tt = H.make_toggle_key("oneline"),
      tm = H.make_toggle_key("merges"),
    },
  })
end

return {
  "fpohtmeh/rio.nvim",
  dev = true,
  opts = {},
  keys = {
    { "<leader>R", H.git_log, desc = "Rio: git log" },
  },
}
