if not config.env.is_windows then
    print("my config is windows only")
    os.exit(1)
end

config.args_parser:command_target("command")
config.args_parser:flag("-v --verbose")

---@type table<string, fun()>
local commands = {}
for dir in config.fs.dir("./commands") do
    --//TODO: maybe check if it's a directory
    -- local attr = config.fs.attributes("./commands/" .. dir)
    -- if not attr or attr.mode ~= "directory" then
    --     goto continue
    -- end

    if not config.fs.exists("./commands/" .. dir .. "/config.lua") then
        print("missing config file for command: " .. dir)
        goto continue
    end

    local command_config = require("commands." .. dir .. ".config")
    local command = config.args_parser:command(dir)
    command_config.config(command)
    commands[dir] = command_config.execute

    ::continue::
end

config.parse_args()

local _verbose = config.args.verbose
---@param ... any
function verbose(...)
    if not _verbose then
        return
    end
    print(...)
end

---@param ... any
function fatal(...)
    print(...)
    os.exit(1)
end

-- execute chosen command init
commands[config.args.command]()
