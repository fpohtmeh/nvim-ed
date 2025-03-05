local M = {}

M.rust_logo = [[
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

M.keys = {
  { action = ":ene | startinsert", desc = "New file", icon = "", key = "n" },
  { action = ':lua require("persistence").load()', desc = "Restore Session", icon = "", key = "s" },
  { action = ":Git status", desc = "Git status", icon = "", key = "g" },
  { action = ":Lazy", desc = "Lazy", icon = "", key = "l" },
  {
    action = ":lua Snacks.dashboard.pick('files', { cwd = vim.fn.stdpath('config') })",
    desc = "Config",
    icon = "",
    key = "c",
  },
  { action = ":qa", desc = "Quit", icon = "", key = "q" },
}

M.lazy_stats = nil

M.startup_time = function()
  M.lazy_stats = M.lazy_stats and M.lazy_stats.startuptime > 0 and M.lazy_stats or require("lazy.stats").stats()
  local ms = (math.floor(M.lazy_stats.startuptime * 100 + 0.5) / 100)
  return "Startup time: " .. ms .. "ms"
end

return {
  width = 26,
  preset = {
    header = M.rust_logo,
    keys = M.keys,
  },
  sections = {
    { section = "header" },
    { section = "keys", padding = 3 },
    function()
      return { title = M.startup_time(), align = "center" }
    end,
  },
}
