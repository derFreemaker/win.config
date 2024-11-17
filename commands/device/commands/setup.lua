config.env.set("USERCONFIG_FREEMAKER", config.root_path:gsub("/", "\\"))

local tools = require("scripts.tools")
tools.setup()
