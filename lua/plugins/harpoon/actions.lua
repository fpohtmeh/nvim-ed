local M = {}
local H = {}

function M.add()
  require("harpoon"):list():add()
end

function M.show_quick_menu()
  local harpoon = require("harpoon")
  local list = harpoon:list()
  local opts = {
    height_in_lines = math.max(15, vim.api.nvim_win_get_height(0) - 10),
    title = " Harpoon [" .. #list.items .. "] ",
  }
  harpoon.ui:toggle_quick_menu(list, opts)
end

H.make_picker_finder = function()
  local file_paths = {}
  local list = require("harpoon"):list()
  for _, item in ipairs(list.items) do
    table.insert(file_paths, {
      text = item.value,
      file = item.value,
    })
  end
  return file_paths
end

H.picker_keys = {
  ["<c-x>"] = { "harpoon_delete", mode = { "n", "x", "i" } },
}

H.picker_delete_action = function(picker, item)
  local list = require("harpoon"):list()
  local to_remove = item or picker:selected()
  table.remove(list.items, to_remove.idx)
  picker:find({ refresh = true })
end

function M.show_picker()
  Snacks.picker({
    title = "Harpoon",
    finder = H.make_picker_finder,
    win = {
      input = { keys = H.picker_keys },
      list = { keys = H.picker_keys },
    },
    actions = {
      harpoon_delete = H.picker_delete_action,
    },
  })
end

return M
