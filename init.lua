config.args_parser:command_target("command")

---@type table<string, fun()>
local commands = {}
for dir in lfs.dir("./commands") do
    local attr = lfs.attributes("./commands/" .. dir)
    if not attr or attr.mode ~= "directory" or dir == "." or dir == ".." then
        goto continue
    end
    if not lfs.exists("./commands/" .. dir .. "/config.lua") then
        print("missing config file for command: " .. dir)
        goto continue
    end

    local command_config, command_init = require("commands." .. dir .. ".config")
    local command = config.args_parser
        :command(dir)
    command_config(command)

    commands[dir] = command_init
    ::continue::
end

config.parse_args()

-- execute chosen command init
commands[config.args.command]()
