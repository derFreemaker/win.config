---@class config.portable.constants
local constants = {}

local pos = config.root_path:reverse():find("/", 2, true)
constants.drive = config.root_path:sub(0, config.root_path:len() - pos)

constants.tools_dir = constants.drive .. "/tools"
constants.bin_dir = constants.tools_dir .. "/bin"

return constants
