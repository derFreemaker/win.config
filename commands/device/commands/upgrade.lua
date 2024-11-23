config.env.check_admin()

local tools = require("tools.tools")

if config.args.name then
    if not tools.upgrade_tool(config.args.name) then
        terminal_body:print("failed to upgrade '" .. config.args.name .. "'")
    end
    return
end

tools.upgrade()
