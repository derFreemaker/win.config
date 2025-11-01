---@class config.winget : config.tool_handler
local winget = {}

---@param action string
---@param name string
---@param args string[]
---@return boolean success
---@return integer exitcode
---@return string output
local function execute(action, name, args)
    print(("%s '%s' with winget..."):format(action, name))
    local result = config.env.execute("winget", args)
    return result.success, result.exitcode, result.stdout .. result.stderr
end

---@param tool_config config.tool_config
---@return boolean success
---@return integer exitcode
---@return string output
function winget.install(tool_config)
    return execute(
        "installing",
        tool_config.name,
        {
            "install",
            "--disable-interactivity",
            "--accept-source-agreements",
            "--accept-package-agreements",
            "--id", tool_config.id,
            "-e",
        }
    )
end

---@param tool_config config.tool_config
---@return boolean success
---@return integer exitcode
---@return string output
function winget.uninstall(tool_config)
    return execute(
        "uninstalling",
        tool_config.name,
        {
            "uninstall",
            "--disable-interactivity",
            "--id", tool_config.id,
            "-e"
        }
    )
end

---@param tool_config config.tool_config
---@return boolean success
---@return integer exitcode
---@return string output
function winget.upgrade(tool_config)
    return execute(
        "upgrading",
        tool_config.name,
        {
            "upgrade",
            "--disable-interactivity",
            "--accept-source-agreements",
            "--accept-package-agreements",
            "--id", tool_config.id,
            "-e"
        }
    )
end

return winget
