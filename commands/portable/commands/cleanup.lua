local constants = require("commands.portable.commands.constants")

print("cleaning up...")

if not lfs.exists(constants.tools_dir)
    or lfs.attributes(constants.tools_dir).mode ~= "directory" then
    fatal("no tools directory found: " .. constants.tools_dir)
end

local function cleanup_tool(tool)
    local tool_path = constants.tools_dir .. "/" .. tool

    local attr = lfs.attributes(tool_path)
    if not attr or attr.mode ~= "directory" then
        return
    end

    local tool_config_path = tool_path .. "/.config"
    if not lfs.exists(tool_config_path) then
        return
    end


    local disable_path = tool_config_path .. "/.disable"
    if lfs.exists(disable_path) then
        print(("tool '%s' is disabled"):format(tool))
        return
    end


    local tool_cleanup_path = tool_config_path .. "/cleanup.lua"
    if not lfs.exists(tool_cleanup_path) then
        verbose("tool '" .. tool .. "' has no 'cleanup.lua' script in '.config' directory")
        return
    end

    local cleanup_func, err_msg = loadfile(tool_cleanup_path)
    if not cleanup_func then
        print(("unable to load cleanup file for tool '%s'\n%s"):format(tool, err_msg))
        return
    end

    print(("cleaning up tool '%s'..."):format(tool))
    local tool_thread = coroutine.create(cleanup_func)
    local success, setup_err_msg = coroutine.resume(tool_thread)

    if not success then
        print("tool '" .. tool .. "' cleanup failed with:\n"
            .. debug.traceback(tool_thread, setup_err_msg))
    end
end

for tool in lfs.dir(constants.tools_dir) do
    cleanup_tool(tool)
end

local win_bin_dir = constants.bin_dir:gsub("/", "\\")

verbose("removing '" .. constants.bin_dir .. "'")
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

print("done cleaning up!")
