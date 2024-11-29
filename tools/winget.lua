---@type lua-term
local term = require("tools.term")
local utils = require("tools.utils")

---@class config.winget : config.tool_handler
local winget = {}

---@param action string
---@param command string
---@return boolean success
---@return integer exitcode
---@return string output
local function execute(action, name, command)
    local group = term.components.group.new(action .. "-winget", terminal_body)
    group:print(("%s '%s' with winget..."):format(action, name))
    return utils.display_execute(command, group)
end

local install =
"winget install --disable-interactivity --accept-source-agreements --accept-package-agreements --id \"%s\" -e"
---@param tool_config config.tool_config
---@return boolean success
---@return integer exitcode
---@return string output
function winget.install(tool_config)
    return execute(
        "installing",
        tool_config.name,
        install:format(tool_config.id)
    )
end

local uninstall = "winget uninstall --disable-interactivity --id \"%s\" -e"
---@param tool_config config.tool_config
---@return boolean success
---@return integer exitcode
---@return string output
function winget.uninstall(tool_config)
    return execute(
        "uninstalling",
        tool_config.name,
        uninstall:format(tool_config.id)
    )
end

local upgrade =
"winget upgrade --disable-interactivity --accept-source-agreements --accept-package-agreements --id \"%s\" -e"
---@param tool_config config.tool_config
---@return boolean success
---@return integer exitcode
---@return string output
function winget.upgrade(tool_config)
    return execute(
        "upgrading",
        tool_config.name,
        upgrade:format(tool_config.id)
    )
end

return winget
