local choco = {}

local install = "choco install \"%s\" -y"
---@param name string
---@return boolean success
---@return integer exitcode
---@return string output
function choco.install(name)
    local seg = terminal_body:print("installing '" .. name .. "' with chocolatey...")
    local success, exitcode, output = config.env.execute(install:format(name))
    seg:remove()

    return success, exitcode, output
end

local uninstall = "choco uninstall \"%s\" -y"
---@param name string
---@return boolean success
---@return integer exitcode
---@return string output
function choco.uninstall(name)
    local seg = terminal_body:print("uninstalling '" .. name .. "' with chocolatey...")
    local success, exitcode, output = config.env.execute(uninstall:format(name))
    seg:remove()

    return success, exitcode, output
end

local upgrade = "choco upgrade \"%s\" -y"
---@param name string
---@return boolean success
---@return integer exitcode
---@return string output
function choco.upgrade(name)
    local seg = terminal_body:print("upgrading '" .. name .. "' with chocolatey...")
    local success, exitcode, output = config.env.execute(upgrade:format(name))
    seg:remove()

    return success, exitcode, output
end

return choco
