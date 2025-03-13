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

-- Tabs
map("n", "gq", "<cmd>tabclose<cr>", { desc = "Close Tab" })
map("n", "<leader><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })

-- Save
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

-- Quit, Close
map("n", "<leader>q", "<cmd>qa<cr>", { desc = "Quit All" })
map("n", "<leader>w", "<cmd>close<cr>", { desc = "Close Window" })
map("n", "<leader>W", "<cmd>only<cr>", { desc = "Close Other Windows" })

-- Lazy
map("n", "<leader>L", "<cmd>Lazy<cr>", opts)

-- Buffer navigation
map("n", keys.prev .. "b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", keys.next .. "b", "<cmd>bnext<cr>", { desc = "Next Buffer" })

-- Delete buffer
-- stylua: ignore start
map("n", "<leader>x", function() Snacks.bufdelete() end, { desc = "Delete Buffer" })
map("n", "<leader>X", function() Snacks.bufdelete.other() end, { desc = "Delete Other Buffers" })
map("n", "<leader><c-x>", function() Snacks.bufdelete.all() end, { desc = "Delete All Buffers" })
-- stylua: ignore end

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

-- Terminal
local terminal = require("core.terminal")
map("n", "<c-/>", terminal.open, { desc = "Terminal" })
map("n", "<c-_>", terminal.open, { desc = "which_key_ignore" })
map("t", "<c-/>", terminal.close, { desc = "Hide Terminal" })
map("t", "<c-_>", terminal.close, { desc = "which_key_ignore" })

-- Lazygit
if vim.fn.executable("lazygit") == 1 then
  map("n", "<leader>G", terminal.lazy_git, { desc = "Lazygit" })
end

-- LSP
local lsp = require("core.lsp")
map("n", "gr", lsp.rename, { expr = true, desc = "Rename" })
map("n", "gd", lsp.pick.definition, { desc = "Goto Definition" })
map("n", "gD", lsp.pick.declaration, { desc = "Goto Declaration" })
map("n", "gR", lsp.pick.reference, { nowait = true, desc = "References" })
map("n", "gI", lsp.pick.implementation, { desc = "Goto Implementation" })
map("n", "gY", lsp.pick.type_definition, { desc = "Goto Type Definition" })

-- Diagnostic
map("n", keys.prev .. "d", lsp.diagnostic.go_to(false), { desc = "Prev Diagnostic" })
map("n", keys.next .. "d", lsp.diagnostic.go_to(true), { desc = "Next Diagnostic" })
map("n", keys.prev .. "e", lsp.diagnostic.go_to(false, "ERROR"), { desc = "Prev Error" })
map("n", keys.next .. "e", lsp.diagnostic.go_to(true, "ERROR"), { desc = "Next Error" })
map("n", keys.prev .. "w", lsp.diagnostic.go_to(false, "WARN"), { desc = "Prev Warning" })
map("n", keys.next .. "w", lsp.diagnostic.go_to(true, "WARN"), { desc = "Next Warning" })
