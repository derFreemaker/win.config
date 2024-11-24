---@class config.winget : config.tool_handler
local winget = {}

local install = "winget install --disable-interactivity --accept-source-agreements --accept-package-agreements --id \"%s\" -e"
---@param tool_config config.tool_config
---@return boolean success
---@return integer exitcode
---@return string output
function winget.install(tool_config)
    local seg = terminal_body:print("installing '" .. tool_config.name .. "' with winget...")
    local success, exitcode, output = config.env.execute(install:format(tool_config.id))
    seg:remove()

    return success, exitcode, output
end

local uninstall = "winget uninstall --disable-interactivity --id \"%s\" -e"
---@param tool_config config.tool_config
---@return boolean success
---@return integer exitcode
---@return string output
function winget.uninstall(tool_config)
    local seg = terminal_body:print("uninstalling '" .. tool_config.name .. "' with winget...")
    local success, exitcode, output = config.env.execute(uninstall:format(tool_config.id))
    seg:remove()

    return success, exitcode, output
end

local upgrade = "winget upgrade --disable-interactivity --accept-source-agreements --accept-package-agreements --id \"%s\" -e"
---@param tool_config config.tool_config
---@return boolean success
---@return integer exitcode
---@return string output
function winget.upgrade(tool_config)
    local seg = terminal_body:print("upgrading '" .. tool_config.name .. "' with winget...")
    local success, exitcode, output = config.env.execute(upgrade:format(tool_config.id))
    seg:remove()

    return success, exitcode, output
end

return winget
