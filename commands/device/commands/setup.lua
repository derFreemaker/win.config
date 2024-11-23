local tools = require("tools.tools")

if config.args.name then
    if not tools.setup_tool(config.args.name) then
        terminal_body:print("failed to setup '" .. config.args.name .. "'")
    end
    return
end

tools.setup()
