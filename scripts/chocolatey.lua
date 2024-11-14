local choco = {}

local install = "choco install \"%s\" -y"
---@param name string
---@return boolean success
---@return integer exitcode
---@return string output
function choco.install(name)
    print("installing " .. name .. " with chocolatey...")
    return config.env.execute(install:format(name))
end

local uninstall = "choco uninstall \"%s\" -y"
---@param name string
---@return boolean success
---@return integer exitcode
---@return string output
function choco.uninstall(name)
    print("uninstalling " .. name .. " with chocolatey...")
    return config.env.execute(uninstall:format(name))
end

local upgrade = "choco upgrade \"%s\" -y"
---@param name string
---@return boolean success
---@return integer exitcode
---@return string output
function choco.upgrade(name)
    print("upgrading " .. name .. " with chocolatey...")
    return config.env.execute(upgrade:format(name))
end

return choco
