return {
  commands = {
    { text = "Add", command = "chezmoi add %" },
    { text = "Re-add", command = "chezmoi re-add %" },
    { text = "Edit", command = "chezmoi edit %" },
    { text = "Forget", command = "chezmoi forget %" },
    { text = "Apply", command = "chezmoi apply" },
    { text = "Apply (re-fetch)", command = "chezmoi apply -R" },
    { text = "Update", command = "chezmoi update" },
    { text = "Status", command = "chezmoi status" },
  },
  terminal = true,
}
