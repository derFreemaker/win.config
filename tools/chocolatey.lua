---@type lua-term
local term = require("tools.term")

---@class config.chocolatey : config.tool_handler
local choco = {}

---@param action string
---@param command string
---@return boolean success
---@return integer exitcode
---@return string output
local function execute(action, name, command)
    local handle = config.env.start_execute(command)

    local group = term.components.group.new(action .. "-chocolatey", terminal_body)
    group:print(("%s '%s' with cocolatey...\n> %s"):format(action, name, command))
    local stream = term.components.stream.new("execute", group, handle, {
        before = term.colors.foreground_24bit(100, 100, 100) .. "> ",
        after = tostring(term.colors.reset)
    })
    stream:read_all()
    group:remove()

    return config.env.end_execute(handle)
end

local install = "choco install \"%s\" -y"
---@param tool_config config.tool_config
---@return boolean success
---@return integer exitcode
---@return string output
function choco.install(tool_config)
    return execute(
        "installing",
        tool_config.name,
        install:format(tool_config.id)
    )
end

local uninstall = "choco uninstall \"%s\" -y"
---@param tool_config config.tool_config
---@return boolean success
---@return integer exitcode
---@return string output
function choco.uninstall(tool_config)
    return execute(
        "uninstalling",
        tool_config.name,
        uninstall:format(tool_config.id)
    )
end

local upgrade = "choco upgrade \"%s\" -y"
---@param tool_config config.tool_config
---@return boolean success
---@return integer exitcode
---@return string output
function choco.upgrade(tool_config)
    return execute(
        "upgrading",
        tool_config.name,
        upgrade:format(tool_config.id)
    )
end

return choco
