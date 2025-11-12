local constants = require("commands.portable.commands.constants")

print("cleaning up...")

require("commands.portable.commands.helper")

---@param tool config.portable.tool
local function cleanup_tool(tool)
    local attr = lfs.attributes(tool.path)
    if not attr or attr.mode ~= "directory" then
        return
    end

    local tool_config_path = tool.path .. "/.config"
    if not lfs.exists(tool_config_path) then
        return
    end


    local disable_path = tool_config_path .. "/.disable"
    if lfs.exists(disable_path) then
        print("is disabled")
        return
    end


    local tool_cleanup_path = tool_config_path .. "/cleanup.lua"
    if not lfs.exists(tool_cleanup_path) then
        verbose("has no 'cleanup.lua' script in '.config' directory")
        return
    end

    local cleanup_func, err_msg = loadfile(tool_cleanup_path)
    if not cleanup_func then
        print(("unable to load cleanup file\n%s"):format(tool, err_msg))
        return
    end

    local tool_thread = coroutine.create(cleanup_func)
    local success, setup_err_msg = coroutine.resume(tool_thread)

    if not success then
        print("cleanup failed with:\n"
            .. debug.traceback(tool_thread, setup_err_msg))
    end
end

for tool_name in lfs.dir(constants.tools_dir) do
    local attr = lfs.attributes(constants.tools_dir .. "/" .. tool_name)
    if not attr
        or attr.mode ~= "directory"
        or tool_name == "."
        or tool_name == ".." then
        goto continue
    end

    ---@type config.portable.tool
    local tool = {
        name = tool_name,
        path = (constants.tools_dir .. "/" .. tool_name .. "/"):gsub("/", "\\"),
    }

    print(("tool '%s'..."):format(tool.name))
    portable.set_current_tool(tool)

    cleanup_tool(tool)

    ::continue::
end

portable.execute_queued_actions()

verbose("removing '" .. constants.bin_dir .. "'")

local win_bin_dir = (constants.bin_dir .. "/"):gsub("/", "\\")
config.env.remove("PATH", win_bin_dir, config.env.scope.user)
if lfs.exists(constants.bin_dir) then
    local result = config.env.execute("rm", { "-r", win_bin_dir }, true)
    if not result.success then
        print("unable to remove '" .. constants.bin_dir .. "'")
        print(result.exitcode)
        print(result.stdout)
        print(result.stderr)
    end
end

config.env.unset("TOOLS_FREEMAKER_PORTABLE", config.env.scope.user)
config.env.unset("USERCONFIG_FREEMAKER_PORTABLE", config.env.scope.user)
config.env.unset("DRIVE_FREEMAKER_PORTABLE", config.env.scope.user)

verbose("broadcast environment change...")
if not config.env.broadcast_change_message() then
    fatal("unable to broadcast environment change")
end

print("done cleaning up!")
