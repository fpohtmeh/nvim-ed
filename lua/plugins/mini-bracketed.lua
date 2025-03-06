local function make_keymap(letter, action, direction)
  local capitalize = require("core.utils").capitalize
  letter = (direction == "first" or direction == "last") and capitalize(letter) or letter
  local keys = require("core").keys
  local key_dir = (direction == "first" or direction == "backward") and keys.prev or keys.next

  return {
    key_dir .. letter,
    string.format("<cmd>lua MiniBracketed.%s('%s')<cr>", action, direction),
    desc = capitalize(action) .. " " .. direction,
  }
end

return {
  "echasnovski/mini.bracketed",
  lazy = false,
  opts = {
    buffer = { suffix = "" },
    comment = { suffix = "" },
    conflict = { suffix = "" },
    diagnostic = { suffix = "" },
    file = { suffix = "" },
    indent = { suffix = "" },
    jump = { suffix = "" },
    location = { suffix = "" },
    oldfile = { suffix = "" },
    quickfix = { suffix = "" },
    treesitter = { suffix = "" },
    undo = { suffix = "" },
    window = { suffix = "" },
    yank = { suffix = "" },
  },
  keys = {
    make_keymap("b", "buffer", "first"),
    make_keymap("b", "buffer", "last"),
    make_keymap("b", "buffer", "backward"),
    make_keymap("b", "buffer", "forward"),

    make_keymap("f", "file", "first"),
    make_keymap("f", "file", "last"),
    make_keymap("f", "file", "backward"),
    make_keymap("f", "file", "forward"),

    make_keymap("i", "indent", "first"),
    make_keymap("i", "indent", "last"),
    make_keymap("i", "indent", "backward"),
    make_keymap("i", "indent", "forward"),

    make_keymap("q", "quickfix", "first"),
    make_keymap("q", "quickfix", "last"),
    make_keymap("q", "quickfix", "backward"),
    make_keymap("q", "quickfix", "forward"),

    make_keymap("u", "undo", "first"),
    make_keymap("u", "undo", "last"),
    make_keymap("u", "undo", "backward"),
    make_keymap("u", "undo", "forward"),
  },
}
