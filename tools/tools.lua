---@type lua-term
local term = require("tools.term")

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
---@field setup (fun(tool_config: config.tool_config) : boolean) | nil

---@class config.tool_config
---@field name string
---@field id string
---@field handler config.tool_handler | nil
---@field after config.tool_handler.after | nil
---@field setup (fun(tool_config: config.tool_config) : boolean) | nil

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
        return false
    end

    terminal_body:print("installing '" .. name .. "'...")

    local success, exitcode, output
    if config.handler.install then
        success, exitcode, output = config.handler.install(config)
    else
        success = false
        exitcode = 1
        print("no install handler")
    end

    if not success then
        print("exitcode: " .. tostring(exitcode))
        print(output)
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
    local install_loading = term.components.loading.new("install_loading", terminal_footer)

    local one_item_percent = 100 / #tools.m_configs
    for name in pairs(tools.m_configs) do
        if not tools.install_tool(name) then
            print("failed to install '" .. name .. "'")
        end

        install_loading:changed_relativ(one_item_percent)
    end

    install_loading:remove()
end

---@param name string
---@return boolean
function tools.uninstall_tool(name)
    local config = tools.m_configs[name]
    if not config then
        return false
    end

    terminal_body:print("uninstalling '" .. name .. "'...")

    local success, exitcode, output
    if config.handler.uninstall then
        success, exitcode, output = config.handler.uninstall(config)
    else
        success = false
        exitcode = 1
        print("no uninstall handler")
    end

    if not success then
        print("exitcode: " .. tostring(exitcode))
        print(output)
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
    local uninstall_loading = term.components.loading.new("uninstall_loading", terminal_footer)

    local one_item_percent = 100 / #tools.m_configs
    for name in pairs(tools.m_configs) do
        if not tools.uninstall_tool(name) then
            print("failed to uninstall '" .. name .. "'")
        end

        uninstall_loading:changed_relativ(one_item_percent)
    end

    uninstall_loading:remove()
end

---@param name string
---@return boolean
function tools.upgrade_tool(name)
    local config = tools.m_configs[name]
    if not config then
        return false
    end

    terminal_body:print("upgrading '" .. name .. "'...")

    local success, exitcode, output
    if config.handler.upgrade then
        success, exitcode, output = config.handler.upgrade(config)
    else
        success = false
        exitcode = 1
        print("no upgrade handler")
    end

    if not success then
        print("exitcode: " .. tostring(exitcode))
        print(output)
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
    local upgrade_loading = term.components.loading.new("upgrade_loading", terminal_footer)

    local one_item_percent = 100 / #tools.m_configs
    for name in pairs(tools.m_configs) do
        if not tools.upgrade_tool(name) then
            print("failed to upgrade '" .. name .. "'")
        end

        upgrade_loading:changed_relativ(one_item_percent)
    end

    upgrade_loading:remove()
end

---@param name string
---@return boolean
function tools.setup_tool(name)
    local config = tools.m_configs[name]
    if not config then
        return false
    end

    terminal_body:print("setting up '" .. name .. "' ")

    local success = true
    if config.setup then
        success = config.setup(config)
    end

    return success
end

function tools.setup()
    local setup_loading = term.components.loading.new("setup_loading", terminal_footer)

    local one_item_percent = 100 / #tools.m_configs
    for name in pairs(tools.m_configs) do
        if not tools.setup_tool(name) then
            print("failed to setup '" .. name .. "'")
        end

        setup_loading:changed_relativ(one_item_percent)
    end

    setup_loading:remove()
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
