local pos = config.root_path:reverse():find("/", 2, true)
local drive = config.root_path:sub(0, config.root_path:len() - pos + 1)
local tools_dir = drive .. "tools/"
if not lfs.exists(tools_dir) or lfs.attributes(tools_dir).mode ~= "directory" then
    fatal("no tools directory found: " .. tools_dir)
end

for tool in lfs.dir(tools_dir) do
    local tool_path = tools_dir .. tool
    local attr = lfs.attributes(tool_path)
    if not attr or attr.mode ~= "directory" or tool == "." or tool == ".." then
        goto continue
    end

    local tool_config_path = tool_path .. "/.config/"
    if not lfs.exists(tool_config_path) then
        goto continue
    end

    local disable_path = tool_config_path .. ".disable"
    if lfs.exists(disable_path) then
        print("tool '" .. tool .. "' is disabled")
        goto continue
    end

    local tool_cleanup_path = tool_config_path .. "cleanup.lua"
    if not lfs.exists(tool_cleanup_path) then
        goto continue
    end

    local cleanup_func, err_msg = loadfile(tool_cleanup_path)
    if not cleanup_func then
        print("unable to load cleanup file for tool '" .. tool .. "'\n" .. err_msg)
        goto continue
    end

    print("cleaning up tool '" .. tool .. "'")
    cleanup_func()

    ::continue::
end

config.env.remove("PATH", tools_dir .. "bin;", "user")

config.env.unset("TOOLS_FREEMAKER_PORTABLE", "user")
config.env.unset("USERCONFIG_FREEMAKER_PORTABLE", "user")

print("done cleaning up!")
