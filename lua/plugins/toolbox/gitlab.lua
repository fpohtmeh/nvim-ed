return {
  commands = {
    { text = "CI list", command = "glab ci list" },
    { text = "CI view", command = "glab ci view" },
    { text = "MR checkout", command = "glab mr checkout {input}", input = "MR number: " },
    { text = "MR list", command = "glab mr list" },
    { text = "MR view", command = "glab mr view" },
    { text = "MR create", command = 'glab mr create -t "{input}" --push --yes --no-editor', input = "MR title: " },
  },
  terminal = true,
}
