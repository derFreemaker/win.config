local t = {}

---@param command argparse.Command
function t.config(command)
    command:command_target("device_command")

    local device_commands_path = "./commands/device/commands/"
    for file in config.fs.dir(device_commands_path) do
        --//TODO: maybe check if it's a file
        -- local attr = config.fs.attributes(device_commands_path .. file)
        -- if not attr or attr.mode ~= "file" then
        --     goto continue
        -- end

        file = file:match("(.+)%..+$") or file
        command
            :command(file, "run " .. file .. " scripts")
            :argument("tools", "All the tools the command should act on.")
            :args("*")

        ::continue::
    end
end

function t.execute()
    print("running in device mode")

    -- register all tools
    require("register")

    -- call command
    require("commands.device.commands." .. config.args.device_command)
end

return t
