local M = {}
local H = {}

M.toggle = function()
  return Snacks.toggle({
    name = "Render Markdown",
    get = function()
      return require("render-markdown.state").enabled
    end,
    set = function(enabled)
      local fn = enabled and "enable" or "disable"
      require("render-markdown")[fn]()
    end,
  })
end

H.setup_headers = function(hl)
  local bg_colors = { "#2d3f76", "#2a3866", "#2f3457", "#283045", "#2a2c3f", "#252841" }
  local fg_colors = { "#86e1fc", "#82aaff", "#c099ff", "#c3e88d", "#ffc777", "#ff9e64" }

  for i = 1, 6 do
    local level = tostring(i)
    local bg = bg_colors[i]
    local fg = fg_colors[i]
    hl["RenderMarkdownH" .. level .. "Bg"] = { bg = bg, fg = fg }
    hl["RenderMarkdownH" .. level] = { bold = true, fg = fg }
    hl["@markup.heading." .. level .. ".markdown"] = { bold = true, fg = fg }
  end
end

M.setup_highlights = function(hl, colors)
  H.setup_headers(hl)

  hl.RenderMarkdownTableHead = { fg = colors.blue }
  hl.RenderMarkdownTableRow = { fg = colors.blue }
  hl.RenderMarkdownDash = { fg = colors.fg }
  hl.RenderMarkdownBullet = { fg = colors.blue1 }

  local code_bg = "#303550"
  hl.RenderMarkdownCodeInline = { bg = code_bg }
  hl.RenderMarkdownCode = { bg = code_bg }
end

return M
