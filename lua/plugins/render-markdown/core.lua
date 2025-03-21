local M = {}

M.toggle = function()
  return Snacks.toggle({
    name = "Render Markdown",
    get = function()
      return require("render-markdown.state").enabled
    end,
    set = function(enabled)
      local m = require("render-markdown")
      if enabled then
        m.enable()
      else
        m.disable()
      end
    end,
  })
end

M.setup_highlights = function(hl, colors)
  hl.RenderMarkdownH1Bg = { bg = "#334364" }
  hl.RenderMarkdownH2Bg = { bg = "#654f2f" }
  hl.RenderMarkdownH3Bg = { bg = "#303825" }
  hl.RenderMarkdownH4Bg = { bg = "#163c35" }
  hl.RenderMarkdownH5Bg = { bg = "#3c324d" }
  hl.RenderMarkdownH6Bg = { bg = "#4a3446" }
  hl.RenderMarkdownTableHead = { fg = colors.green }
  hl.RenderMarkdownTableRow = { fg = colors.green }
  hl.RenderMarkdownDash = { fg = colors.green }
end

return M
