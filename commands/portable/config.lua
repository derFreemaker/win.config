local t = {}

-- we are expecting that the portable medium has following file structure
--  <drive>
--      .config -- config root
--      tools
--          <tool>
--              .config -- if not present ignores tool
--                  .disable -- if present ignores tool scripts
--                  [setup.lua] -- gets executed if present
--                  [cleanup.lua] -- gets executed if present

---@param command argparse.Command
function t.config(command)
    command:command_target("portable_command")

    local device_commands_path = "./commands/portable/commands/"
    for file in config.fs.dir(device_commands_path) do
        --//TODO: maybe check if it's a file
        -- local attr = config.fs.attributes(device_commands_path .. file)
        -- if not attr or attr.mode ~= "file" then
        --     goto continue
        -- end

        file = file:match("(.+)%..+$") or file
        command:command(file, "run " .. file .. " scripts")

        ::continue::
    end
end

function t.execute()
    print("running in portable mode")

    -- call command
    require("commands.portable.commands." .. config.args.portable_command)
end

return t
