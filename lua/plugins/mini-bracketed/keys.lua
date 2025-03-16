local H = {}

H.get_module = function(action)
  if action == "git" then
    require("plugins.mini-bracketed.git")
    return "Bracketed"
  end
  return "MiniBracketed"
end

H.make_keymap = function(letter, action, direction)
  local capitalize = require("core.fn").capitalize
  letter = (direction == "first" or direction == "last") and capitalize(letter) or letter
  local keys = require("core").keys
  local key_dir = (direction == "first" or direction == "backward") and keys.prev or keys.next
  local module = H.get_module(action)

  return {
    key_dir .. letter,
    string.format("<cmd>lua %s.%s('%s')<cr>", module, action, direction),
    desc = capitalize(action) .. " " .. direction,
  }
end

return {
  H.make_keymap("b", "buffer", "backward"),
  H.make_keymap("b", "buffer", "forward"),

  H.make_keymap("f", "file", "backward"),
  H.make_keymap("f", "file", "forward"),

  H.make_keymap("i", "indent", "first"),
  H.make_keymap("i", "indent", "last"),
  H.make_keymap("i", "indent", "backward"),
  H.make_keymap("i", "indent", "forward"),

  H.make_keymap("q", "quickfix", "first"),
  H.make_keymap("q", "quickfix", "last"),
  H.make_keymap("q", "quickfix", "backward"),
  H.make_keymap("q", "quickfix", "forward"),

  H.make_keymap("g", "git", "backward"),
  H.make_keymap("g", "git", "forward"),
}
