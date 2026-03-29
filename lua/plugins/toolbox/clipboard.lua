local H = {}

H.copy = {
    file = {
        full_path = function(p) return p end,
        dir_path = function(p) return vim.fn.fnamemodify(p, ":h") .. "/" end,
        filename = function(p) return vim.fn.fnamemodify(p, ":t") end,
        relative_path = function(p) return vim.fn.fnamemodify(p, ":.") end,
    },
    oil = {
        full_path = function(dir, entry) return dir .. (entry and entry.name or "") end,
        dir_path = function(dir, _) return dir end,
        filename = function(_, entry) return entry and entry.name or "" end,
        relative_path = function(dir, entry) return vim.fn.fnamemodify(dir .. (entry and entry.name or ""), ":.") end,
    },
}

H.command = function(name, ctx)
    return function()
        local value
        if ctx.oil then
            value = H.copy.oil[name](ctx.oil.dir, ctx.oil.entry)
        else
            value = H.copy.file[name](ctx.path)
        end
        if value then
            vim.fn.setreg("+", value)
        end
    end
end

H.fill = function(add, ctx)
    local category = "Clipboard"
    add("Copy full path", category, H.command("full_path", ctx))
    add("Copy directory path", category, H.command("dir_path", ctx))
    add("Copy filename", category, H.command("filename", ctx))
    add("Copy relative path", category, H.command("relative_path", ctx))
end

return H
