return {
  "aaronik/treewalker.nvim",
  opts = { highlight = false },
  keys = {
    { "<a-j>", "<cmd>Treewalker Down<cr>", desc = "Move To Prev Node" },
    { "<a-k>", "<cmd>Treewalker Up<cr>", desc = "Move To Next Node" },
    { "<a-h>", "<cmd>Treewalker Left<cr>", desc = "Move To Parent Node" },
    { "<a-l>", "<cmd>Treewalker Right<cr>", desc = "Move To Child Node" },
    { "<c-a-j>", "<cmd>Treewalker SwapDown<cr>", desc = "Swap With Next Node" },
    { "<c-a-k>", "<cmd>Treewalker SwapUp<cr>", desc = "Swap With Prev Node" },
    { "<c-a-h>", "<cmd>Treewalker SwapLeft<cr>", desc = "Swap With Left Node" },
    { "<c-a-l>", "<cmd>Treewalker SwapRight<cr>", desc = "Swap With Right Node" },
  },
}
