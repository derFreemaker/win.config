local tools = require("tools.tools")

if not config.args.tools or #config.args.tools == 0 then
    tools.setup()
    return
end

for _, tool in ipairs(config.args.tools) do
    if not tools.setup_tool(tool) then
        terminal_body:print("failed to setup '" .. tool .. "'")
    end
end
