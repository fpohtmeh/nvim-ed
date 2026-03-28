local M = {}
local H = {}

-- stylua: ignore
H.colors = {
  "#ef4444", "#f97316", "#f59e0b", "#eab308", "#84cc16",
  "#22c55e", "#10b981", "#14b8a6", "#06b6d4", "#0ea5e9",
  "#3b82f6", "#6366f1", "#8b5cf6", "#a855f7", "#d946ef",
  "#ec4899", "#f43f5e",
  "#fca5a5", "#fdba74", "#fcd34d", "#fde047", "#bef264",
  "#86efac", "#6ee7b7", "#5eead4", "#67e8f9", "#7dd3fc",
  "#93c5fd", "#a5b4fc", "#c4b5fd", "#d8b4fe", "#f0abfc",
  "#f9a8d4", "#fda4af",
}

H.dir = vim.fn.stdpath("data") .. "/palette"

H.file = function(key)
  return H.dir .. "/" .. key .. ".lua"
end

H.load = function(key)
  local chunk = loadfile(H.file(key))
  return chunk and chunk() or {}
end

H.save = function(key, data)
  vim.fn.mkdir(H.dir, "p")
  local f = io.open(H.file(key), "w")
  if f then
    f:write("return " .. vim.inspect(data))
    f:close()
  end
end

function M.color(key)
  local data = H.load(key)
  local cwd = vim.fn.getcwd()
  return data[cwd] and data[cwd].color or M.random_color(key)
end

function M.random_color(key)
  math.randomseed(os.time())
  local color = H.colors[math.random(1, #H.colors)]
  if key then
    local cwd = vim.fn.getcwd()
    local data = H.load(key)
    data[cwd] = { color = color }
    H.save(key, data)
  end
  return color
end

return M
