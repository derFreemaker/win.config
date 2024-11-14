if not config.env.is_windows then
    error("")
end

local winget = require("scripts.winget")
local choco = require("scripts.chocolatey")

---@alias config.tool_handler.type
---|"winget"
---|"chocolatey"
---|config.tool_handler

---@class config.tool_handler
---@field install (fun(tool_config: config.tool_config)) | nil
---@field uninstall (fun(tool_config: config.tool_config)) | nil
---@field upgrade (fun(tool_config: config.tool_config)) | nil

---@class config.tool_config
---@field name string
---@field handler config.tool_handler.type
---@field after config.tool_handler | nil

---@class config.tools
---@field package configs config.tool_config[]
local tools = {
    configs = {}
}

function tools.install()
    for _, config in pairs(tools.configs) do
        print("installing '" .. config.name .. "'...")

        if config.handler == "winget" then
            winget.install(config.name)
        elseif config.handler == "chocolatey" then
            choco.install(config.name)
        elseif type(config.handler) == "table" then
            local handler = config.handler
            ---@cast handler -string
            if handler.install then
                handler.install(config)
            end
        end

        if config.after then
            if config.after.install then
                config.after.install(config)
            end
        end
    end
end

function tools.uninstall()
    for _, config in pairs(tools.configs) do
        print("uninstalling '" .. config.name .. "'...")

        if config.handler == "winget" then
            winget.uninstall(config.name)
        elseif config.handler == "chocolatey" then
            choco.uninstall(config.name)
        elseif type(config.handler) == "table" then
            local handler = config.handler
            ---@cast handler -string
            if handler.uninstall then
                handler.uninstall(config)
            end
        end

        if config.after then
            if config.after.uninstall then
                config.after.uninstall(config)
            end
        end
    end
end

function tools.upgrade()
    for _, config in pairs(tools.configs) do
        print("upgrading '" .. config.name .. "'...")

        if config.handler == "winget" then
            winget.upgrade(config.name)
        elseif config.handler == "chocolatey" then
            choco.upgrade(config.name)
        elseif type(config.handler) == "table" then
            local handler = config.handler
            ---@cast handler -string
            if handler.upgrade then
                handler.upgrade(config)
            end
        end

        if config.after then
            if config.after.upgrade then
                config.after.upgrade(config)
            end
        end
    end
end

---@param tool_config config.tool_config
function tools.add_tool(tool_config)
    table.insert(tools.configs, tool_config)
end

---@param name string
function tools.use_winget(name)
    tools.add_tool({
        name = name,
        handler = "winget"
    })
end

---@param name string
function tools.use_choco(name)
    tools.add_tool({
        name = name,
        handler = "chocolatey"
    })
end

require("register")

return tools
