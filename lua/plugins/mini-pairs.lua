local H = {}

H.quote_pattern = "[%s=%(%[%{]."
H.skip_pattern = [=[[%w%%%'%[%"%.%`%$]]=]
H.mappings = {
  ['"'] = { neigh_pattern = H.quote_pattern },
  ["'"] = { neigh_pattern = H.quote_pattern },
}

return {
  "echasnovski/mini.pairs",
  event = "InsertEnter",
  opts = {
    modes = { insert = true, command = true, terminal = false },
    skip_next = H.skip_pattern,
    skip_ts = { "string" },
    skip_unbalanced = true,
    markdown = true,
    mappings = H.mappings,
  },
}
