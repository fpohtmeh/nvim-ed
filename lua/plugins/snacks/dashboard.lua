local H = {}

H.rust_logo = [[
      $$                      $$      
    $$$  $                  $  $$$    
   $$$   $$                $$   $$$   
   $$$$$$$$                $$$$$$$$   
    $$$$$$                  $$$$$$    
     $$$$    $$$$$$$$$$$$    $$$$     
       $$  $$$  $$$$$$  $$$  $$       
   $$   $$$$$$$$$$$$$$$$$$$$$$   $$   
 $$  $$  $$$$$$$$$$$$$$$$$$$$  $$  $$ 
$      $$$$$$$$$$$$$$$$$$$$$$$$      $
$  $$$    $$$$$$$$$$$$$$$$$$    $$$  $
  $   $$$$ $$$$$$$$$$$$$$$$ $$$$   $  
 $         $ $$$$$$$$$$$$ $         $ 
 $      $$$                $$$      $ 
       $                      $       
      $                        $      
      $                        $      
]]

H.next_color = function()
  local color = require("core.palette").random_color("dashboard")
  vim.api.nvim_set_hl(0, "SnacksDashboardHeader", { fg = color })
end

H.keys = {
  { action = ':lua require("core.fs").create_new_file()', desc = "New file", icon = "", key = "n" },
  { action = ':lua require("persistence").load()', desc = "Restore Session", icon = "", key = "s" },
  { action = H.next_color, desc = "Change color", icon = "󰸌", key = "c" },
  { action = ":qa", desc = "Quit", icon = "", key = "q" },
}

H.lazy_stats = nil

H.startup_time = function()
  H.lazy_stats = H.lazy_stats and H.lazy_stats.startuptime > 0 and H.lazy_stats or require("lazy.stats").stats()
  local ms = (math.floor(H.lazy_stats.startuptime * 100 + 0.5) / 100)
  return "Startup time: " .. ms .. "ms"
end

return {
  width = 26,
  preset = {
    header = H.rust_logo,
    keys = H.keys,
  },
  sections = {
    { section = "header" },
    { section = "keys", padding = 3 },
    function()
      return { title = H.startup_time(), align = "center" }
    end,
  },
}
