config.env.check_admin()

require("chocolatey.install")

local tools = require("scripts.tools")

tools.install()

require("registry.apply")
