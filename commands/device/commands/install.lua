config.env.check_admin()

local tools = require("scripts.tools")

if config.args.name then
    if not tools.install_tool(config.args.name) then
        print("failed to install '" .. config.args.name .. "'")
    end
    return
end

tools.install()
