return {
  commands = {
    { text = "Add", command = "chezmoi add {file}" },
    { text = "Re-add", command = "chezmoi re-add {file}" },
    { text = "Edit", command = "chezmoi edit {file}" },
    { text = "Forget", command = "chezmoi forget {file}" },
    { text = "Apply", command = "chezmoi apply" },
    { text = "Apply (re-fetch)", command = "chezmoi apply -R" },
    { text = "Update", command = "chezmoi update" },
    { text = "Status", command = "chezmoi status" },
  },
  terminal = true,
}
