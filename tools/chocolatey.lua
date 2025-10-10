---@class config.chocolatey : config.tool_handler
local choco = {}

---@param action string
---@param args string[]
---@return boolean success
---@return integer exitcode
---@return string output
local function execute(action, name, args)
    print(("%s '%s' with cocolatey..."):format(action, name))
    local result = config.env.execute("choco", args)
    return result.success, result.exitcode, result.stdout .. result.stderr
end

---@param tool_config config.tool_config
---@return boolean success
---@return integer exitcode
---@return string output
function choco.install(tool_config)
    return execute(
        "installing",
        tool_config.name,
        { "install", tool_config.id, "-y" }
    )
end

---@param tool_config config.tool_config
---@return boolean success
---@return integer exitcode
---@return string output
function choco.uninstall(tool_config)
    return execute(
        "uninstalling",
        tool_config.name,
        { "uninstall", tool_config.id, "-y" }
    )
end

---@param tool_config config.tool_config
---@return boolean success
---@return integer exitcode
---@return string output
function choco.upgrade(tool_config)
    return execute(
        "upgrading",
        tool_config.name,
        { "upgrade", tool_config.id, "-y" }
    )
end

return choco
