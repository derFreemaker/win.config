config.env.check_admin()

local tools = require("scripts.tools")

if config.args.name then
    if not tools.upgrade_tool(config.args.name) then
        print("failed to upgrade '" .. config.args.name .. "'")
    end
    return
end

tools.upgrade()
