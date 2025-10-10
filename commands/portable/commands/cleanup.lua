print("cleaning up...")

local pos = config.root_path:reverse():find("/", 2, true)
local drive = config.root_path:sub(0, config.root_path:len() - pos + 1)
local tools_dir = drive .. "tools/"
if not lfs.exists(tools_dir) then
    --//TODO: maybe check if it's a directory
    -- or config.fs.attributes(tools_dir).mode ~= "directory"
    fatal("no tools directory found: " .. tools_dir)
end

local function cleanup_tool(tool)
    local tool_path = tools_dir .. tool

    local attr = lfs.attributes(tool_path)
    if not attr or attr.mode ~= "directory" then
        return
    end

    local tool_config_path = tool_path .. "/.config/"
    if not lfs.exists(tool_config_path) then
        return
    end


    local disable_path = tool_config_path .. ".disable"
    if lfs.exists(disable_path) then
        print(("tool '%s' is disabled"):format(tool))
        return
    end


    local tool_cleanup_path = tool_config_path .. "cleanup.lua"
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

for tool in lfs.dir(tools_dir) do
    cleanup_tool(tool)
end

config.env.remove("PATH", tools_dir .. "bin;", config.env.scope.user)

config.env.unset("TOOLS_FREEMAKER_PORTABLE", config.env.scope.user)
config.env.unset("USERCONFIG_FREEMAKER_PORTABLE", config.env.scope.user)
config.env.unset("DRIVE_FREEMAKER_PORTABLE", config.env.scope.user)

print("done cleaning up!")
