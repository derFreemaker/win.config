local winget = {}

local install = "winget install --id \"%s\""
---@param id string
---@return boolean success
---@return integer exitcode
---@return string output
function winget.install(id)
    print("installing " .. id .. " with winget...")
    return config.env.execute(install:format(id))
end

local uninstall = "winget uninstall --id \"%s\""
---@param id string
---@return boolean success
---@return integer exitcode
---@return string output
function winget.uninstall(id)
    print("uninstalling " .. id .. " with winget...")
    return config.env.execute(uninstall:format(id))
end

local upgrade = "winget upgrade --id \"%s\""
---@param id string
---@return boolean success
---@return integer exitcode
---@return string output
function winget.upgrade(id)
    print("upgrading " .. id .. " with winget...")
    return config.env.execute(upgrade:format(id))
end

return winget
