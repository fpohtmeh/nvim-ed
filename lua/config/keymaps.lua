local map = vim.keymap.set

local opts = { noremap = true, silent = true }

-- Move cursor to non-blank character
map({ "n", "o", "x" }, "<s-h>", "^", opts)
map({ "n", "o", "x" }, "<s-l>", "g_", opts)

-- Escape
map({ "i", "n", "s" }, "<esc>", function()
  vim.cmd("noh")
  return "<esc>"
end, { expr = true, desc = "Escape" })

-- Better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Save
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

-- Quit
map("n", "<leader>q", "<cmd>qa<cr>", { desc = "Quit All" })

-- Lazy
map("n", "<leader>L", "<cmd>Lazy<cr>", opts)

-- Delete buffer
map("n", "<leader>x", function()
  Snacks.bufdelete()
end, { desc = "Delete Buffer" })
map("n", "<leader><A-x>", function()
  Snacks.bufdelete.other()
end, { desc = "Delete Other Buffers" })
map("n", "<leader>X", "<cmd>:bd<cr>", { desc = "Delete Buffer and Window" })

-- Lazygit
if vim.fn.executable("lazygit") == 1 then
  map("n", "<leader>G", function()
    Snacks.lazygit({ cwd = Snacks.git.get_root() })
  end, { desc = "Lazygit" })
end
