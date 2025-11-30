local sql_ft = { "sql", "mysql", "plsql" }

local main = {
  "tpope/vim-dadbod",
  cmd = "DB",
}

local ui = {
  "kristijanhusak/vim-dadbod-ui",
  cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection" },
  ft = sql_ft,
  dependencies = "vim-dadbod",
  init = function()
    local data_path = vim.fn.stdpath("data")

    vim.g.db_ui_auto_execute_table_helpers = 1
    vim.g.db_ui_save_location = data_path .. "/dadbod_ui"
    vim.g.db_ui_show_database_icon = true
    vim.g.db_ui_tmp_query_location = data_path .. "/dadbod_ui/tmp"
    vim.g.db_ui_use_nerd_fonts = true
    vim.g.db_ui_use_nvim_notify = true
  end,
}

return { main, ui }
