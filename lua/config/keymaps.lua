local map = vim.keymap.set
local opts = { noremap = true, silent = true }
local keys = require("core").keys
local fs = require("core.fs")

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
map("n", "gQ", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })
map("n", "<leader><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })

-- File
map({ "i", "x", "n", "s" }, "<C-s>", fs.save_current_file, { desc = "Save File" })
map("n", "<leader>fn", fs.create_new_file, { desc = "New File" })
map("n", "<leader>fr", fs.rename_current_file, { desc = "Rename File" })
map("n", "<leader>fx", fs.delete_current_file, { desc = "Delete File" })

-- Quit, Close
map("n", "<leader>Q", "<cmd>qa<cr>", { desc = "Quit All" })
map("n", "<leader>w", "<cmd>close<cr>", { desc = "Close Window" })
map("n", "<leader>W", "<cmd>only<cr>", { desc = "Close Other Windows" })

-- Lazy
map("n", "<leader>L", "<cmd>Lazy<cr>", opts)

-- Buffer navigation
map("n", keys.prev .. "b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", keys.next .. "b", "<cmd>bnext<cr>", { desc = "Next Buffer" })

-- Delete buffer
local function delete_buffers()
  Snacks.bufdelete.all()
  vim.cmd.only()
end
-- stylua: ignore start
map("n", "<leader>x", function() Snacks.bufdelete() end, { desc = "Delete Buffer" })
map("n", "<leader>X", function() Snacks.bufdelete.other() end, { desc = "Delete Other Buffers" })
-- stylua: ignore end
map("n", "<leader><c-x>", delete_buffers, { desc = "Delete All Buffers" })

-- Move Lines
map("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
map("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })

-- Quickfix
local function toggle_quickfix()
  pcall(vim.fn.getqflist({ winid = 0 }).winid ~= 0 and vim.cmd.cclose or vim.cmd("botright copen"))
end
map("n", "<leader>q", toggle_quickfix, { desc = "Toggle Quickfix list" })
-- stylua: ignore start
map("n", keys.prev .. "<c-q>", function() pcall(vim.cmd.colder) end, { desc = "Prev Quickfix list" })
map("n", keys.next .. "<c-q>", function() pcall(vim.cmd.cnewer) end, { desc = "Next Quickfix list" })
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

-- Windows keys
for i = 1, #keys.window do
  local lhs = "<c-" .. keys.window[i] .. ">"
  local rhs = function()
    vim.cmd(tostring(i) .. " wincmd w")
  end
  local description = "Go to window " .. i
  vim.keymap.set({ "n", "t" }, lhs, rhs, { desc = description, remap = true })
end
