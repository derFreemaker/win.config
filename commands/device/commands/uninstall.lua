config.env.check_admin()

local tools = require("scripts.tools")

if config.args.name then
    if not tools.uninstall_tool(config.args.name) then
        print("failed to uninstall '" .. config.args.name .. "'")
    end
    return
end

tools.uninstall()
require("chocolatey.uninstall")
