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

H.pick_color = function()
  local colors = require("core.colors")
  Snacks.picker({
    title = colors.picker.title,
    sort = colors.picker.sort,
    finder = colors.picker.finder,
    format = colors.picker.format,
    layout = { preset = "ivy" },
    confirm = function(picker, item)
      picker:close()
      if not item then
        return
      end
      local hex = item.color.hex
      vim.api.nvim_set_hl(0, "SnacksDashboardHeader", { fg = hex })
      require("core.palette").set_color("dashboard", hex)
    end,
  })
end

H.keys = {
  { action = ':lua require("core.fs").create_new_file()', desc = "New file", icon = "", key = "n" },
  { action = ':lua require("persistence").load()', desc = "Restore Session", icon = "", key = "s" },
  { action = H.pick_color, desc = "Pick color", icon = "󰸌", key = "c" },
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
