if not config.env.is_windows then
    print("my config is windows only")
    os.exit(1)
end

---@type lua-term
local term = require("tools.term")
terminal = term.terminal.stdout()
terminal_body = term.components.group.new("body", terminal)
terminal_footer = term.components.group.new("footer", terminal)

function print(...)
    terminal_body:print(...)
end

config.args_parser:command_target("command")
config.args_parser:flag("-v --verbose")

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

    local command_config = require("commands." .. dir .. ".config")
    local command = config.args_parser
        :command(dir)
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

    terminal:update()
    print(...)
end

---@param ... any
function fatal(...)
    terminal:update()
    print(...)

    os.exit(1)
end

-- execute chosen command init
commands[config.args.command]()
