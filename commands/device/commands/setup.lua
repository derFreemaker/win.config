local tools = require("scripts.tools")

if config.args.name then
    if not tools.setup_tool(config.args.name) then
        print("failed to setup '" .. config.args.name .. "'")
    end
    return
end

tools.setup()
