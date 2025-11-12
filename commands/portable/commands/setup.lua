local constants = require("commands.portable.commands.constants")

print("setting up...")

require("commands.portable.commands.helper")

verbose("adding environment variables...")

if not config.env.set("USERCONFIG_FREEMAKER_PORTABLE", config.root_path, config.env.scope.user) then
    fatal("unable to set userconfig env variable")
end

if not config.env.set("DRIVE_FREEMAKER_PORTABLE", constants.drive .. "\\", config.env.scope.user) then
    fatal("unable to set drive env variable")
end

if not config.env.set("TOOLS_FREEMAKER_PORTABLE", constants.tools_dir:gsub("/", "\\"), config.env.scope.user) then
    fatal("unable to set tools env variable")
end

if not config.env.add("PATH", (constants.bin_dir .. "/"):gsub("/", "\\"), config.env.scope.user, true) then
    fatal("unable to add bin path to PATH")
end

---@param tool config.portable.tool
local function setup_tool(tool)
    local tool_config_path = tool.path .. "/.config"
    if not lfs.exists(tool_config_path) then
        verbose("has no '.config' directory")
        return
    end

    local disable_path = tool_config_path .. "/.disable"
    if lfs.exists(disable_path) then
        print("is disabled")
        return
    end

    local tool_setup_path = tool_config_path .. "/setup.lua"
    if not lfs.exists(tool_setup_path) then
        verbose("has no 'setup.lua' script in '.config' directory")
        return
    end

    local setup_func, load_err_msg = loadfile(tool_setup_path)
    if not setup_func then
        print("unable to load setup file:\n" .. load_err_msg)
        return
    end

    local tool_thread = coroutine.create(setup_func)
    local success, setup_err_msg = coroutine.resume(tool_thread)

    if not success then
        print("setup failed with:\n"
            .. debug.traceback(tool_thread, setup_err_msg))

        coroutine.close(tool_thread)
        return
    end

    coroutine.close(tool_thread)
end

for tool_name in lfs.dir(constants.tools_dir) do
    local attr = lfs.attributes(constants.tools_dir .. "/" .. tool_name)
    if not attr
        or attr.mode ~= "directory"
        or tool_name == "."
        or tool_name == ".." then
        goto continue
    end

    local tool = {
        name = tool_name,
        path = (constants.tools_dir .. "/" .. tool_name .. "/"):gsub("/", "\\"),
    }

    print(("tool '%s'..."):format(tool.name))
    portable.set_current_tool(tool)

    setup_tool(tool)

    ::continue::
end

-- get back to config dir
if not lfs.chdir(config.root_path) then
    error("unable to change directory to '" .. config.root_path .. "'")
end

verbose("broadcast environment change...")
if not config.env.broadcast_change_message() then
    fatal("unable to broadcast environment change")
end

portable.execute_queued_actions()

print("done setting up!")
