local M = {}
local H = {}

M.setup_highlights = function(hl, colors)
  hl.GrugFarResultsMatchAdded = { bg = "#273849", fg = "#B8DB87" }
  hl.GrugFarResultsMatchRemoved = { bg = "#3A273A", fg = "#E26A75" }
  hl.GrugFarResultsHeader = { fg = colors.blue }
  hl.GrugFarResultsNumberLabel = { fg = colors.yellow, bold = true }
  hl.GrugFarInputLabel = { fg = colors.blue }
  hl.GrugFarResultsStats = { fg = colors.blue }
end

-- ACTIONS

local fn = require("core.fn")
local fs = require("core.fs")

H.make_action = function(args)
  return function()
    local prefills = {}

    if fn.is_visual_mode() then
      prefills.flags = "--fixed-strings"
    end
    args = args or {}
    if args.word then
      prefills.search = vim.fn.expand("<cword>")
    end

    if args.file then
      prefills.paths = fs.to_native(vim.fn.expand("%"))
    elseif args.dir then
      prefills.paths = fs.to_native(vim.fn.expand("%:p:h"))
    end

    require("grug-far").open({
      transient = true,
      prefills = prefills,
    })
  end
end

M.open = H.make_action()
M.open_with_word = H.make_action({ word = true })
M.open_with_file = H.make_action({ file = true })
M.open_with_directory = H.make_action({ dir = true })

-- TOGGLES

H.make_toggle = function(flags)
  return function()
    require("grug-far").get_instance(0):toggle_flags(flags)
  end
end

M.toggle = {}
M.toggle.fixed_strings = H.make_toggle({ "--fixed-strings" })
M.toggle.ignore = H.make_toggle({ "--no-ignore" })
M.toggle.hidden = H.make_toggle({ "--hidden" })
M.toggle.smart_case = H.make_toggle({ "--smart-case" })

return M
