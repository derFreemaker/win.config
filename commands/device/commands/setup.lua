local tools = require("tools.tools")

if not config.args.tools or #config.args.tools == 0 then
    tools.setup()
    return
end

for _, tool in ipairs(config.args.tools) do
    tools.setup_tool(tool)
end
