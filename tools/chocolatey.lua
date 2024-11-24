---@class config.chocolatey : config.tool_handler
local choco = {}

local install = "choco install \"%s\" -y"
---@param tool_config config.tool_config
---@return boolean success
---@return integer exitcode
---@return string output
function choco.install(tool_config)
    local seg = terminal_body:print("installing '" .. tool_config.name .. "' with chocolatey...")
    local success, exitcode, output = config.env.execute(install:format(tool_config.id))
    seg:remove()

    return success, exitcode, output
end

local uninstall = "choco uninstall \"%s\" -y"
---@param tool_config config.tool_config
---@return boolean success
---@return integer exitcode
---@return string output
function choco.uninstall(tool_config)
    local seg = terminal_body:print("uninstalling '" .. tool_config.name .. "' with chocolatey...")
    local success, exitcode, output = config.env.execute(uninstall:format(tool_config.id))
    seg:remove()

    return success, exitcode, output
end

local upgrade = "choco upgrade \"%s\" -y"
---@param tool_config config.tool_config
---@return boolean success
---@return integer exitcode
---@return string output
function choco.upgrade(tool_config)
    local seg = terminal_body:print("upgrading '" .. tool_config.name .. "' with chocolatey...")
    local success, exitcode, output = config.env.execute(upgrade:format(tool_config.id))
    seg:remove()

    return success, exitcode, output
end

return choco
