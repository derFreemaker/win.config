-- import lualine plugin safely
local setup, lualine, lualine_nightfly = protectedRequire("lualine", "lualine.themes.nightfly")
if not setup then
    return
end

-- new colors for theme
local new_colors = {
    blue = "#65D1FF",
    green = "#28d461",
    violet = "#FF61EF",
    yellow = "#FFDA7B",
    black = "#000000",
}

-- change nightlfy theme colors
lualine_nightfly.normal.a.bg = new_colors.blue
lualine_nightfly.insert.a.bg = new_colors.green
lualine_nightfly.visual.a.bg = new_colors.violet
lualine_nightfly.command = {
    a = {
        gui = "bold",
        bg = new_colors.yellow,
        fg = new_colors.black, -- black
    },
}

-- configure lualine with modified theme
lualine.setup({
    options = {
        theme = lualine_nightfly,
    },
})
