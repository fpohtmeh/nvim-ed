local M = {}
local H = {}

function M.setup(shell)
  vim.o.shell = shell or vim.o.shell

  if shell == "pwsh" or shell == "powershell" then
    if vim.fn.executable("pwsh") == 1 then
      vim.o.shell = "pwsh"
    elseif vim.fn.executable("powershell") == 1 then
      vim.o.shell = "powershell"
    end

    vim.o.shellcmdflag =
      "-NoLogo -NonInteractive -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();$PSDefaultParameterValues['Out-File:Encoding']='utf8';$PSStyle.OutputRendering='plaintext';Remove-Alias -Force -ErrorAction SilentlyContinue tee;"
    vim.o.shellredir = '2>&1 | %%{ "$_" } | Out-File %s; exit $LastExitCode'
    vim.o.shellpipe = '2>&1 | %%{ "$_" } | tee %s; exit $LastExitCode'
    vim.o.shellquote = ""
    vim.o.shellxquote = ""
  end
end

H.keys = {
  term_normal = {
    "<S-esc>",
    function(self)
      return "<C-\\><C-n>"
    end,
    mode = "t",
    expr = true,
    desc = "Shift escape to normal mode",
  },
}

function M.open()
  local opts = {
    cwd = Snacks.git.get_root(),
    win = { keys = H.keys },
    env = { terminal_style = "normal" }, -- for different terminal id
  }
  Snacks.terminal(nil, opts)
end

function M.open_float()
  local opts = {
    cwd = Snacks.git.get_root(),
    win = { style = "max_float", title = "Terminal", keys = H.keys },
    env = { terminal_style = "float" },
  }
  Snacks.terminal(nil, opts)
end

function M.open_vsplit()
  local opts = {
    cwd = Snacks.git.get_root(),
    win = { position = "right", width = 80, keys = H.keys },
    env = { terminal_style = "vsplit" },
  }
  Snacks.terminal(nil, opts)
end

function M.close()
  vim.cmd.close()
end

function M.lazy_git()
  --@type snacks.lazygit.Config
  local lazygit_opts = { cwd = Snacks.git.get_root() }
  Snacks.lazygit(lazygit_opts)
end

return M
