local winget = {}

local install = "winget install --disable-interactivity --id \"%s\""
---@param id string
---@return boolean success
---@return integer exitcode
---@return string output
function winget.install(id)
    local seg = terminal_body:print("installing '" .. id .. "' with winget...")
    local success, exitcode, output = config.env.execute(install:format(id))
    seg:remove()

    return success, exitcode, output
end

local uninstall = "winget uninstall --disable-interactivity --id \"%s\""
---@param id string
---@return boolean success
---@return integer exitcode
---@return string output
function winget.uninstall(id)
    local seg = terminal_body:print("uninstalling '" .. id .. "' with winget...")
    local success, exitcode, output = config.env.execute(uninstall:format(id))
    seg:remove()

    return success, exitcode, output
end

local upgrade = "winget upgrade --disable-interactivity --id \"%s\""
---@param id string
---@return boolean success
---@return integer exitcode
---@return string output
function winget.upgrade(id)
    local seg = terminal_body:print("upgrading '" .. id .. "' with winget...")
    local success, exitcode, output = config.env.execute(upgrade:format(id))
    seg:remove()

    return success, exitcode, output
end

return winget
