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
---@field install (fun(tool_config: config.tool_config) : boolean, integer, string) | nil
---@field uninstall (fun(tool_config: config.tool_config) : boolean, integer, string) | nil
---@field upgrade (fun(tool_config: config.tool_config) : boolean, integer, string) | nil

---@class config.tool_handler.after
---@field install (fun(tool_config: config.tool_config)  : boolean) | nil
---@field uninstall (fun(tool_config: config.tool_config)  : boolean) | nil
---@field upgrade (fun(tool_config: config.tool_config)  : boolean) | nil

---@class config.tool_config
---@field name string
---@field handler config.tool_handler.type
---@field after config.tool_handler.after | nil
---@field setup (fun(tool_config: config.tool_config) : boolean) | nil

---@class config.tools
---@field package configs table<string, config.tool_config>
local tools = {
    configs = {}
}

---@param name string
---@return boolean
function tools.install_tool(name)
    local config = tools.configs[name]
    if not config then
        return false
    end

    print("installing '" .. name .. "'...")

    local success, exitcode, output
    if config.handler == "winget" then
        success, exitcode, output = winget.install(config.name)
    elseif config.handler == "chocolatey" then
        success, exitcode, output = choco.install(config.name)
    elseif type(config.handler) == "table" then
        local handler = config.handler
        ---@cast handler -string
        if handler.install then
            success, exitcode, output = handler.install(config)
        else
            success = false
            exitcode = 1
            output = "no install handler"
        end
    end

    if not success then
        print(string.format("exitcode: %s\n%s", tostring(exitcode), tostring(output)))
        return false
    end

    if config.after then
        if config.after.install then
            success = config.after.install(config)
        end
    end

    return success
end

function tools.install()
    for name in pairs(tools.configs) do
        if not tools.install_tool(name) then
            print("failed to install '" .. name .. "'")
        end
    end
end

---@param name string
---@return boolean
function tools.uninstall_tool(name)
    local config = tools.configs[name]
    if not config then
        return false
    end

    print("uninstalling '" .. name .. "'...")

    local success, exitcode, output
    if config.handler == "winget" then
        success, exitcode, output = winget.uninstall(config.name)
    elseif config.handler == "chocolatey" then
        success, exitcode, output = choco.uninstall(config.name)
    elseif type(config.handler) == "table" then
        local handler = config.handler
        ---@cast handler -string
        if handler.uninstall then
            success, exitcode, output = handler.uninstall(config)
        else
            success = false
            exitcode = 1
            output = "no uninstall handler"
        end
    end

    if not success then
        print(string.format("exitcode: %s\n%s", tostring(exitcode), tostring(output)))
        return false
    end

    if config.after then
        if config.after.uninstall then
            success = config.after.uninstall(config)
        end
    end

    return success
end

function tools.uninstall()
    for name in pairs(tools.configs) do
        if not tools.uninstall_tool(name) then
            print("failed to uninstall '" .. name .. "'")
        end
    end
end

---@param name string
---@return boolean
function tools.upgrade_tool(name)
    local config = tools.configs[name]
    if not config then
        return false
    end

    print("upgrading '" .. name .. "'...")

    local success, exitcode, output
    if config.handler == "winget" then
        success, exitcode, output = winget.upgrade(config.name)
    elseif config.handler == "chocolatey" then
        success, exitcode, output = choco.upgrade(config.name)
    elseif type(config.handler) == "table" then
        local handler = config.handler
        ---@cast handler -string
        if handler.upgrade then
            success, exitcode, output = handler.upgrade(config)
        else
            success = false
            exitcode = 1
            output = "no upgrade handler"
        end
    end

    if not success then
        print(string.format("exitcode: %s\n%s", tostring(exitcode), tostring(output)))
        return false
    end

    if config.after then
        if config.after.upgrade then
            success = config.after.upgrade(config)
        end
    end

    return success
end

function tools.upgrade()
    for name in pairs(tools.configs) do
        if not tools.upgrade_tool(name) then
            print("failed to upgrade '" .. name .. "'")
        end
    end
end

---@param name string
---@return boolean
function tools.setup_tool(name)
    local config = tools.configs[name]
    if not config then
        return false
    end

    print("setting up '" .. name .. "' ")

    local success = true
    if config.setup then
        success = config.setup(config)
    end

    return success
end

function tools.setup()
    for name in pairs(tools.configs) do
        if not tools.setup_tool(name) then
            print("failed to setup '" .. name .. "'")
        end
    end
end

---@param tool_config config.tool_config
function tools.add_tool(tool_config)
    tools.configs[tool_config.name] = tool_config
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

return tools
