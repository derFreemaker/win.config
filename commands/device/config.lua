---@param command argparse.Command
return function(command)
    command:command_target("device_command")

    local device_commands_path = "./commands/device/commands/"
    for file in lfs.dir(device_commands_path) do
        local attr = lfs.attributes(device_commands_path .. file)
        if attr.mode == "file" then
            file = file:match("(.+)%..+$") or file
            command:command(file, "run " .. file .. " scripts")
        end
    end
end, function()
    print("running in device mode")
    require("commands.device.commands." .. config.args.device_command)
end
