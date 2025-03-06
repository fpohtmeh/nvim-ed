local map = vim.keymap.set
local opts = { noremap = true, silent = true }
local keys = require("core").keys

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

-- Buffer navigation
map("n", keys.prev .. "b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", keys.next .. "b", "<cmd>bnext<cr>", { desc = "Next Buffer" })

-- Delete buffer
map("n", "<leader>x", function()
  Snacks.bufdelete()
end, { desc = "Delete Buffer" })
map("n", "<leader><A-x>", function()
  Snacks.bufdelete.other()
end, { desc = "Delete Other Buffers" })
map("n", "<leader>X", "<cmd>:bd<cr>", { desc = "Delete Buffer and Window" })

-- Move Lines
map("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
map("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })

-- Quickfix
-- stylua: ignore start
map("n", keys.prev .. "<A-q>", function() pcall(vim.cmd.colder) end, { desc = "Prev Quickfix list" })
map("n", keys.next .. "<A-q>", function() pcall(vim.cmd.cnewer) end, { desc = "Next Quickfix list" })
-- stylua: ignore end

-- Diagnostic
local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity, float = false })
  end
end
map("n", keys.prev .. "d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
map("n", keys.next .. "d", diagnostic_goto(true), { desc = "Next Diagnostic" })
map("n", keys.prev .. "e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
map("n", keys.next .. "e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
map("n", keys.prev .. "w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })
map("n", keys.next .. "w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })

-- Terminal
-- stylua: ignore start
map("n", "<c-/>", function() Snacks.terminal() end, { desc = "Terminal" })
map("n", "<c-_>", function() Snacks.terminal() end, { desc = "which_key_ignore" })
map("t", "<c-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })
map("t", "<c-_>", "<cmd>close<cr>", { desc = "which_key_ignore" })
-- stylua: ignore end

-- Lazygit
if vim.fn.executable("lazygit") == 1 then
  map("n", "<leader>G", function()
    Snacks.lazygit({ cwd = Snacks.git.get_root() })
  end, { desc = "Lazygit" })
end

-- LSP
-- stylua: ignore start
map("n", "gd", function() Snacks.picker.lsp_definitions() end, { desc = "Goto Definition" })
map("n", "gD", function() Snacks.picker.lsp_declarations() end, { desc = "Goto Declaration" })
map("n", "gr", function() Snacks.picker.lsp_references() end, { nowait = true, desc = "References" })
map("n", "gI", function() Snacks.picker.lsp_implementations() end, { desc = "Goto Implementation" })
map("n", "gy", function() Snacks.picker.lsp_type_definitions() end, { desc = "Goto Type Definition" })
-- stylua: ignore end
