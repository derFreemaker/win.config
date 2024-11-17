config.env.check_admin()

require("registry.remove")

local tools = require("scripts.tools")
tools.uninstall()

require("chocolatey.uninstall")
