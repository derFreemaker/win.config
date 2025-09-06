---@class config.tool_handler
---@field install (fun(tool_config: config.tool_config) : boolean, integer, string) | nil
---@field uninstall (fun(tool_config: config.tool_config) : boolean, integer, string) | nil
---@field upgrade (fun(tool_config: config.tool_config) : boolean, integer, string) | nil

---@class config.tool_handler.after
---@field install (fun(tool_config: config.tool_config)  : boolean) | nil
---@field uninstall (fun(tool_config: config.tool_config)  : boolean) | nil
---@field upgrade (fun(tool_config: config.tool_config)  : boolean) | nil

---@class config.tool_config.create
---@field name string
---@field id string | nil
---@field handler config.tool_handler | nil
---@field after config.tool_handler.after | nil
---@field setup (fun(tool_config: config.tool_config) : boolean, string | nil) | nil

---@class config.tool_config
---@field name string
---@field id string
---@field handler config.tool_handler | nil
---@field after config.tool_handler.after | nil
---@field setup (fun(tool_config: config.tool_config) : boolean, string | nil) | nil

---@class config.tools
---@field winget config.winget
---@field chocolatey config.chocolatey
---
---@field private m_configs table<string, config.tool_config>
local tools = {
    winget = require("tools.winget"),
    chocolatey = require("tools.chocolatey"),

    m_configs = {},
}

---@param name string
---@return boolean
function tools.install_tool(name)
    local config = tools.m_configs[name]
    if not config then
        print("no config for '" .. name .. "'")
        return false
    end

    if not config.handler or not config.handler.install then
        print(("'%s' has no install handler"):format(name))
        return true
    end

    print(("installing '%s'..."):format(name))
    local success, exitcode, output = config.handler.install(config)

    if not success then
        print("failed to install")
        print("exitcode: " .. tostring(exitcode))
        print(output)
        return false
    end

    if config.after then
        if config.after.install then
            print("running after install handler...")
            success = config.after.install(config)
        end
    end

    return success
end

function tools.install()
    for name in pairs(tools.m_configs) do
        tools.install_tool(name)
    end
end

---@param name string
---@return boolean
function tools.uninstall_tool(name)
    local config = tools.m_configs[name]
    if not config then
        print("no config for '" .. name .. "'")
        return false
    end

    if not config.handler or not config.handler.uninstall then
        print(("'%s' has no uninstall handler"):format(name))
        return true
    end

    print(("uninstalling '%s'..."):format(name))
    local success, exitcode, output = config.handler.uninstall(config)

    if not success then
        print("failed to uninstall")
        print("exitcode: " .. tostring(exitcode))
        print(output)
        return false
    end

    if config.after then
        if config.after.uninstall then
            print("running after unsintall handler...")
            success = config.after.uninstall(config)
        end
    end

    return success
end

function tools.uninstall()
    for name in pairs(tools.m_configs) do
        tools.uninstall_tool(name)
    end
end

---@param name string
---@return boolean
function tools.upgrade_tool(name)
    local config = tools.m_configs[name]
    if not config then
        print("no config for '" .. name .. "'")
        return false
    end

    if not config.handler or config.handler.upgrade then
        print(("'%s' has no upgrade handler"):format(name))
        return true
    end

    local success, exitcode, output = config.handler.upgrade(config)

    if not success then
        print("failed to upgrade")
        print("exitcode: " .. tostring(exitcode))
        print(output)
        return false
    end

    if config.after then
        if config.after.upgrade then
            print("running after upgrade handler...")
            success = config.after.upgrade(config)
        end
    end

    return success
end

function tools.upgrade()
    for name in pairs(tools.m_configs) do
        tools.upgrade_tool(name)
    end
end

---@param name string
---@return boolean
function tools.setup_tool(name)
    local config = tools.m_configs[name]
    if not config then
        print("no config for '" .. name .. "'")
        return false
    end

    if not config.setup then
        print(("'%s' has no setup handler"):format(name))
        return true;
    end

    print(("setting up '%s'..."):format(name))
    ---@type boolean, string | boolean, string?
    local success, err_msg_or_result, message = pcall(config.setup, config)
    if success and err_msg_or_result == false then
        success = false
    end

    if not success then
        print("failed:\n" .. tostring(message))
    end

    return success
end

function tools.setup()
    for name in pairs(tools.m_configs) do
        tools.setup_tool(name)
    end
end

---@param tool_config config.tool_config.create
function tools.add_tool(tool_config)
    tool_config.id = tool_config.id or tool_config.name

    ---@diagnostic disable-next-line: assign-type-mismatch
    tools.m_configs[tool_config.name] = tool_config
end

---@param name string
---@param id string | nil
function tools.use_winget(name, id)
    tools.add_tool({
        name = name,
        id = id or name,
        handler = tools.winget
    })
end

---@param name string
---@param id string | nil
function tools.use_choco(name, id)
    tools.add_tool({
        name = name,
        id = id or name,
        handler = tools.chocolatey
    })
end

return tools
