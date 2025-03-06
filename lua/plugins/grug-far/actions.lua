local M = {}

local fs = require("core.fs")

M.search_and_replace = function()
  require("grug-far").open({
    transient = true,
  })
end

M.search_and_replace_selection = function()
  require("grug-far").open({
    transient = true,
    prefills = {
      flags = "--fixed-strings",
    },
  })
end

M.search_and_replace_word = function()
  require("grug-far").open({
    transient = true,
    prefills = {
      search = vim.fn.expand("<cword>"),
    },
  })
end

M.search_and_replace_in_file = function()
  require("grug-far").open({
    transient = true,
    prefills = {
      paths = fs.to_native(vim.fn.expand("%")),
    },
  })
end

M.search_and_replace_selection_in_file = function()
  require("grug-far").open({
    transient = true,
    prefills = {
      paths = fs.to_native(vim.fn.expand("%")),
      flags = "--fixed-strings",
    },
  })
end

M.search_and_replace_in_directory = function()
  require("grug-far").open({
    transient = true,
    prefills = {
      paths = fs.to_native(vim.fn.expand("%:p:h")),
    },
  })
end

M.search_and_replace_selection_in_directory = function()
  require("grug-far").open({
    transient = true,
    prefills = {
      paths = fs.to_native(vim.fn.expand("%:p:h")),
      flags = "--fixed-strings",
    },
  })
end

M.toggle = {}

M.toggle.fixed_strings = function()
  require("grug-far").toggle_flags({ "--fixed-strings" })
end

M.toggle.ignore = function()
  require("grug-far").toggle_flags({ "--no-ignore" })
end

M.toggle.hidden = function()
  require("grug-far").toggle_flags({ "--hidden" })
end

M.toggle.smart_case = function()
  require("grug-far").toggle_flags({ "--smart-case" })
end

return M
