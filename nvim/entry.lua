local configPath = os.getenv("USERCONFIG")
if not configPath then
    return
end
if not os.execute("cd \"" .. configPath .. "\"") then
    return
end
configPath = configPath .. "\\nvim\\"

MyR = function(module)
    module = module:gsub("%.", "\\") .. ".lua"

    dofile(configPath .. module)
end

local func = loadfile(configPath .. "init.lua")
configPath = configPath .. "lua\\"
if func then
    func()
end
