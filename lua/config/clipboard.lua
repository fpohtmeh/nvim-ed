if not vim.env.SSH_TTY then
  vim.opt.clipboard = "unnamedplus"
else
  local osc52 = require("vim.ui.clipboard.osc52")

  local function copy_reg(reg)
    local orig = osc52.copy(reg)
    return function(lines, regtype)
      -- Write to Vim's internal register
      vim.fn.setreg(reg, table.concat(lines, "\n"), regtype)

      -- Send OSC52 to local clipboard
      ---@diagnostic disable-next-line: redundant-parameter
      orig(lines, regtype)
    end
  end

  vim.g.clipboard = {
    name = "OSC 52 with register sync",
    copy = {
      ["+"] = copy_reg("+"),
      ["*"] = copy_reg("*"),
    },
    -- Do NOT use OSC52 paste, just use internal registers
    paste = {
      ["+"] = function()
        return vim.fn.getreg("+"), "v"
      end,
      ["*"] = function()
        return vim.fn.getreg("*"), "v"
      end,
    },
  }

  vim.opt.clipboard = "unnamedplus"
end
