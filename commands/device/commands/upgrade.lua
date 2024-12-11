config.env.check_admin()

local tools = require("tools.tools")


if not config.args.tools or #config.args.tools == 0 then
    tools.upgrade()
    return
end

for _, tool in ipairs(config.args.tools) do
    tools.upgrade_tool(tool, terminal_body)
end
