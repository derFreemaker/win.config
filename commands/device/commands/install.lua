config.env.check_root()

local tools = require("tools.tools")

if not config.args.tools or #config.args.tools == 0 then
    tools.install()
    return
end

for _, tool in ipairs(config.args.tools) do
    tools.install_tool(tool)
end
