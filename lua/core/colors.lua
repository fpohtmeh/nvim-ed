local M = {}
local H = {}

-- stylua: ignore
H.colors = {
    -- Red
    { name = "IndianRed",             hex = "#CD5C5C", rgb = "205, 92, 92",   group = "Red" },
    { name = "LightCoral",            hex = "#F08080", rgb = "240, 128, 128",  group = "Red" },
    { name = "Salmon",                hex = "#FA8072", rgb = "250, 128, 114",  group = "Red" },
    { name = "DarkSalmon",            hex = "#E9967A", rgb = "233, 150, 122",  group = "Red" },
    { name = "LightSalmon",           hex = "#FFA07A", rgb = "255, 160, 122",  group = "Red" },
    { name = "Crimson",               hex = "#DC143C", rgb = "220, 20, 60",    group = "Red" },
    { name = "Red",                   hex = "#FF0000", rgb = "255, 0, 0",      group = "Red" },
    { name = "FireBrick",             hex = "#B22222", rgb = "178, 34, 34",    group = "Red" },
    { name = "DarkRed",               hex = "#8B0000", rgb = "139, 0, 0",      group = "Red" },

    -- Pink
    { name = "Pink",                  hex = "#FFC0CB", rgb = "255, 192, 203",  group = "Pink" },
    { name = "LightPink",             hex = "#FFB6C1", rgb = "255, 182, 193",  group = "Pink" },
    { name = "HotPink",               hex = "#FF69B4", rgb = "255, 105, 180",  group = "Pink" },
    { name = "DeepPink",              hex = "#FF1493", rgb = "255, 20, 147",   group = "Pink" },
    { name = "MediumVioletRed",       hex = "#C71585", rgb = "199, 21, 133",   group = "Pink" },
    { name = "PaleVioletRed",         hex = "#DB7093", rgb = "219, 112, 147",  group = "Pink" },

    -- Orange
    { name = "Coral",                 hex = "#FF7F50", rgb = "255, 127, 80",   group = "Orange" },
    { name = "Tomato",                hex = "#FF6347", rgb = "255, 99, 71",    group = "Orange" },
    { name = "OrangeRed",             hex = "#FF4500", rgb = "255, 69, 0",     group = "Orange" },
    { name = "DarkOrange",            hex = "#FF8C00", rgb = "255, 140, 0",    group = "Orange" },
    { name = "Orange",                hex = "#FFA500", rgb = "255, 165, 0",    group = "Orange" },

    -- Yellow
    { name = "Gold",                  hex = "#FFD700", rgb = "255, 215, 0",    group = "Yellow" },
    { name = "Yellow",                hex = "#FFFF00", rgb = "255, 255, 0",    group = "Yellow" },
    { name = "LightYellow",           hex = "#FFFFE0", rgb = "255, 255, 224",  group = "Yellow" },
    { name = "LemonChiffon",          hex = "#FFFACD", rgb = "255, 250, 205",  group = "Yellow" },
    { name = "LightGoldenrodYellow",  hex = "#FAFAD2", rgb = "250, 250, 210",  group = "Yellow" },
    { name = "PapayaWhip",            hex = "#FFEFD5", rgb = "255, 239, 213",  group = "Yellow" },
    { name = "Moccasin",              hex = "#FFE4B5", rgb = "255, 228, 181",  group = "Yellow" },
    { name = "PeachPuff",             hex = "#FFDAB9", rgb = "255, 218, 185",  group = "Yellow" },
    { name = "PaleGoldenrod",         hex = "#EEE8AA", rgb = "238, 232, 170",  group = "Yellow" },
    { name = "Khaki",                 hex = "#F0E68C", rgb = "240, 230, 140",  group = "Yellow" },
    { name = "DarkKhaki",             hex = "#BDB76B", rgb = "189, 183, 107",  group = "Yellow" },

    -- Purple
    { name = "Lavender",              hex = "#E6E6FA", rgb = "230, 230, 250",  group = "Purple" },
    { name = "Thistle",               hex = "#D8BFD8", rgb = "216, 191, 216",  group = "Purple" },
    { name = "Plum",                  hex = "#DDA0DD", rgb = "221, 160, 221",  group = "Purple" },
    { name = "Violet",                hex = "#EE82EE", rgb = "238, 130, 238",  group = "Purple" },
    { name = "Orchid",                hex = "#DA70D6", rgb = "218, 112, 214",  group = "Purple" },
    { name = "Fuchsia",               hex = "#FF00FF", rgb = "255, 0, 255",    group = "Purple" },
    { name = "Magenta",               hex = "#FF00FF", rgb = "255, 0, 255",    group = "Purple" },
    { name = "MediumOrchid",          hex = "#BA55D3", rgb = "186, 85, 211",   group = "Purple" },
    { name = "MediumPurple",          hex = "#9370DB", rgb = "147, 112, 219",  group = "Purple" },
    { name = "RebeccaPurple",         hex = "#663399", rgb = "102, 51, 153",   group = "Purple" },
    { name = "BlueViolet",            hex = "#8A2BE2", rgb = "138, 43, 226",   group = "Purple" },
    { name = "DarkViolet",            hex = "#9400D3", rgb = "148, 0, 211",    group = "Purple" },
    { name = "DarkOrchid",            hex = "#9932CC", rgb = "153, 50, 204",   group = "Purple" },
    { name = "DarkMagenta",           hex = "#8B008B", rgb = "139, 0, 139",    group = "Purple" },
    { name = "Purple",                hex = "#800080", rgb = "128, 0, 128",    group = "Purple" },
    { name = "Indigo",                hex = "#4B0082", rgb = "75, 0, 130",     group = "Purple" },
    { name = "SlateBlue",             hex = "#6A5ACD", rgb = "106, 90, 205",   group = "Purple" },
    { name = "DarkSlateBlue",         hex = "#483D8B", rgb = "72, 61, 139",    group = "Purple" },
    { name = "MediumSlateBlue",       hex = "#7B68EE", rgb = "123, 104, 238",  group = "Purple" },

    -- Green
    { name = "GreenYellow",           hex = "#ADFF2F", rgb = "173, 255, 47",   group = "Green" },
    { name = "Chartreuse",            hex = "#7FFF00", rgb = "127, 255, 0",    group = "Green" },
    { name = "LawnGreen",             hex = "#7CFC00", rgb = "124, 252, 0",    group = "Green" },
    { name = "Lime",                  hex = "#00FF00", rgb = "0, 255, 0",      group = "Green" },
    { name = "LimeGreen",             hex = "#32CD32", rgb = "50, 205, 50",    group = "Green" },
    { name = "PaleGreen",             hex = "#98FB98", rgb = "152, 251, 152",  group = "Green" },
    { name = "LightGreen",            hex = "#90EE90", rgb = "144, 238, 144",  group = "Green" },
    { name = "MediumSpringGreen",     hex = "#00FA9A", rgb = "0, 250, 154",    group = "Green" },
    { name = "SpringGreen",           hex = "#00FF7F", rgb = "0, 255, 127",    group = "Green" },
    { name = "MediumSeaGreen",        hex = "#3CB371", rgb = "60, 179, 113",   group = "Green" },
    { name = "SeaGreen",              hex = "#2E8B57", rgb = "46, 139, 87",    group = "Green" },
    { name = "ForestGreen",           hex = "#228B22", rgb = "34, 139, 34",    group = "Green" },
    { name = "Green",                 hex = "#008000", rgb = "0, 128, 0",      group = "Green" },
    { name = "DarkGreen",             hex = "#006400", rgb = "0, 100, 0",      group = "Green" },
    { name = "YellowGreen",           hex = "#9ACD32", rgb = "154, 205, 50",   group = "Green" },
    { name = "OliveDrab",             hex = "#6B8E23", rgb = "107, 142, 35",   group = "Green" },
    { name = "Olive",                 hex = "#808000", rgb = "128, 128, 0",    group = "Green" },
    { name = "DarkOliveGreen",        hex = "#556B2F", rgb = "85, 107, 47",    group = "Green" },
    { name = "MediumAquamarine",      hex = "#66CDAA", rgb = "102, 205, 170",  group = "Green" },
    { name = "DarkSeaGreen",          hex = "#8FBC8B", rgb = "143, 188, 139",  group = "Green" },
    { name = "LightSeaGreen",         hex = "#20B2AA", rgb = "32, 178, 170",   group = "Green" },
    { name = "DarkCyan",              hex = "#008B8B", rgb = "0, 139, 139",    group = "Green" },
    { name = "Teal",                  hex = "#008080", rgb = "0, 128, 128",    group = "Green" },

    -- Blue
    { name = "Aqua",                  hex = "#00FFFF", rgb = "0, 255, 255",    group = "Blue" },
    { name = "Cyan",                  hex = "#00FFFF", rgb = "0, 255, 255",    group = "Blue" },
    { name = "LightCyan",             hex = "#E0FFFF", rgb = "224, 255, 255",  group = "Blue" },
    { name = "PaleTurquoise",         hex = "#AFEEEE", rgb = "175, 238, 238",  group = "Blue" },
    { name = "Aquamarine",            hex = "#7FFFD4", rgb = "127, 255, 212",  group = "Blue" },
    { name = "Turquoise",             hex = "#40E0D0", rgb = "64, 224, 208",   group = "Blue" },
    { name = "MediumTurquoise",       hex = "#48D1CC", rgb = "72, 209, 204",   group = "Blue" },
    { name = "DarkTurquoise",         hex = "#00CED1", rgb = "0, 206, 209",    group = "Blue" },
    { name = "CadetBlue",             hex = "#5F9EA0", rgb = "95, 158, 160",   group = "Blue" },
    { name = "SteelBlue",             hex = "#4682B4", rgb = "70, 130, 180",   group = "Blue" },
    { name = "LightSteelBlue",        hex = "#B0C4DE", rgb = "176, 196, 222",  group = "Blue" },
    { name = "PowderBlue",            hex = "#B0E0E6", rgb = "176, 224, 230",  group = "Blue" },
    { name = "LightBlue",             hex = "#ADD8E6", rgb = "173, 216, 230",  group = "Blue" },
    { name = "SkyBlue",               hex = "#87CEEB", rgb = "135, 206, 235",  group = "Blue" },
    { name = "LightSkyBlue",          hex = "#87CEFA", rgb = "135, 206, 250",  group = "Blue" },
    { name = "DeepSkyBlue",           hex = "#00BFFF", rgb = "0, 191, 255",    group = "Blue" },
    { name = "DodgerBlue",            hex = "#1E90FF", rgb = "30, 144, 255",   group = "Blue" },
    { name = "CornflowerBlue",        hex = "#6495ED", rgb = "100, 149, 237",  group = "Blue" },
    { name = "RoyalBlue",             hex = "#4169E1", rgb = "65, 105, 225",   group = "Blue" },
    { name = "Blue",                  hex = "#0000FF", rgb = "0, 0, 255",      group = "Blue" },
    { name = "MediumBlue",            hex = "#0000CD", rgb = "0, 0, 205",      group = "Blue" },
    { name = "DarkBlue",              hex = "#00008B", rgb = "0, 0, 139",      group = "Blue" },
    { name = "Navy",                  hex = "#000080", rgb = "0, 0, 128",      group = "Blue" },
    { name = "MidnightBlue",          hex = "#191970", rgb = "25, 25, 112",    group = "Blue" },

    -- Brown
    { name = "Cornsilk",              hex = "#FFF8DC", rgb = "255, 248, 220",  group = "Brown" },
    { name = "BlanchedAlmond",        hex = "#FFEBCD", rgb = "255, 235, 205",  group = "Brown" },
    { name = "Bisque",                hex = "#FFE4C4", rgb = "255, 228, 196",  group = "Brown" },
    { name = "NavajoWhite",           hex = "#FFDEAD", rgb = "255, 222, 173",  group = "Brown" },
    { name = "Wheat",                 hex = "#F5DEB3", rgb = "245, 222, 179",  group = "Brown" },
    { name = "BurlyWood",             hex = "#DEB887", rgb = "222, 184, 135",  group = "Brown" },
    { name = "Tan",                   hex = "#D2B48C", rgb = "210, 180, 140",  group = "Brown" },
    { name = "RosyBrown",             hex = "#BC8F8F", rgb = "188, 143, 143",  group = "Brown" },
    { name = "SandyBrown",            hex = "#F4A460", rgb = "244, 164, 96",   group = "Brown" },
    { name = "Goldenrod",             hex = "#DAA520", rgb = "218, 165, 32",   group = "Brown" },
    { name = "DarkGoldenrod",         hex = "#B8860B", rgb = "184, 134, 11",   group = "Brown" },
    { name = "Peru",                  hex = "#CD853F", rgb = "205, 133, 63",   group = "Brown" },
    { name = "Chocolate",             hex = "#D2691E", rgb = "210, 105, 30",   group = "Brown" },
    { name = "SaddleBrown",           hex = "#8B4513", rgb = "139, 69, 19",    group = "Brown" },
    { name = "Sienna",                hex = "#A0522D", rgb = "160, 82, 45",    group = "Brown" },
    { name = "Brown",                 hex = "#A52A2A", rgb = "165, 42, 42",    group = "Brown" },
    { name = "Maroon",                hex = "#800000", rgb = "128, 0, 0",      group = "Brown" },

    -- White
    { name = "White",                 hex = "#FFFFFF", rgb = "255, 255, 255",  group = "White" },
    { name = "Snow",                  hex = "#FFFAFA", rgb = "255, 250, 250",  group = "White" },
    { name = "HoneyDew",              hex = "#F0FFF0", rgb = "240, 255, 240",  group = "White" },
    { name = "MintCream",             hex = "#F5FFFA", rgb = "245, 255, 250",  group = "White" },
    { name = "Azure",                 hex = "#F0FFFF", rgb = "240, 255, 255",  group = "White" },
    { name = "AliceBlue",             hex = "#F0F8FF", rgb = "240, 248, 255",  group = "White" },
    { name = "GhostWhite",            hex = "#F8F8FF", rgb = "248, 248, 255",  group = "White" },
    { name = "WhiteSmoke",            hex = "#F5F5F5", rgb = "245, 245, 245",  group = "White" },
    { name = "SeaShell",              hex = "#FFF5EE", rgb = "255, 245, 238",  group = "White" },
    { name = "Beige",                 hex = "#F5F5DC", rgb = "245, 245, 220",  group = "White" },
    { name = "OldLace",               hex = "#FDF5E6", rgb = "253, 245, 230",  group = "White" },
    { name = "FloralWhite",           hex = "#FFFAF0", rgb = "255, 250, 240",  group = "White" },
    { name = "Ivory",                 hex = "#FFFFF0", rgb = "255, 255, 240",  group = "White" },
    { name = "AntiqueWhite",          hex = "#FAEBD7", rgb = "250, 235, 215",  group = "White" },
    { name = "Linen",                 hex = "#FAF0E6", rgb = "250, 240, 230",  group = "White" },
    { name = "LavenderBlush",         hex = "#FFF0F5", rgb = "255, 240, 245",  group = "White" },
    { name = "MistyRose",             hex = "#FFE4E1", rgb = "255, 228, 225",  group = "White" },

    -- Gray
    { name = "Gainsboro",             hex = "#DCDCDC", rgb = "220, 220, 220",  group = "Gray" },
    { name = "LightGray",             hex = "#D3D3D3", rgb = "211, 211, 211",  group = "Gray" },
    { name = "Silver",                hex = "#C0C0C0", rgb = "192, 192, 192",  group = "Gray" },
    { name = "DarkGray",              hex = "#A9A9A9", rgb = "169, 169, 169",  group = "Gray" },
    { name = "Gray",                  hex = "#808080", rgb = "128, 128, 128",  group = "Gray" },
    { name = "DimGray",               hex = "#696969", rgb = "105, 105, 105",  group = "Gray" },
    { name = "LightSlateGray",        hex = "#778899", rgb = "119, 136, 153",  group = "Gray" },
    { name = "SlateGray",             hex = "#708090", rgb = "112, 128, 144",  group = "Gray" },
    { name = "DarkSlateGray",         hex = "#2F4F4F", rgb = "47, 79, 79",    group = "Gray" },
    { name = "Black",                 hex = "#000000", rgb = "0, 0, 0",        group = "Gray" },
}

H.hl_cache = {}

H.ensure_hl = function(hex)
  if H.hl_cache[hex] then
    return H.hl_cache[hex]
  end
  local hl_name = "HtmlColor_" .. hex:sub(2)
  vim.api.nvim_set_hl(0, hl_name, { fg = hex })
  H.hl_cache[hex] = hl_name
  return hl_name
end

H.insert_color = function(hex)
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  vim.api.nvim_buf_set_text(0, row - 1, col, row - 1, col, { hex })
end

M.picker = {
  title = "HTML Colors",
  finder = function()
    local items = {}
    for _, c in ipairs(H.colors) do
      items[#items + 1] = {
        text = ("%s %s %s %s"):format(c.name, c.group, c.hex, c.rgb),
        color = c,
      }
    end
    return items
  end,
  format = function(item)
    local c = item.color
    local hl = H.ensure_hl(c.hex)
    local name = c.name .. string.rep(" ", 25 - #c.name)
    local rgb = c.rgb:gsub("(%d+)", function(n)
      return string.format("%3s", n)
    end)
    return {
      { "██ ", hl },
      { name },
      { c.hex, "SnacksPickerDimmed" },
      { "  " },
      { rgb, "SnacksPickerDimmed" },
      { "  " },
      { c.group, "SnacksPickerBold" },
    }
  end,
  confirm = function(picker, item)
    picker:close()
    if not item then
      return
    end
    vim.fn.setreg("+", item.color.hex)
    Snacks.notify("Copied " .. item.color.hex, { level = "info" })
  end,
  win = {
    input = {
      keys = {
        ["<S-CR>"] = { "insert_color", mode = { "i", "n" } },
      },
    },
  },
  actions = {
    insert_color = function(picker, item)
      picker:close()
      if not item then
        return
      end
      local ok = pcall(H.insert_color, item.color.hex)
      if not ok then
        Snacks.notify("Cannot insert color", { level = "warn" })
      end
    end,
  },
}

return M
