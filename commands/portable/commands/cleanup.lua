---@type lua-term
local term = require("tools.term")

terminal_status_bar:print("cleaning up...")
local cleanup_throbber = term.components.throbber("cleanup_throbber", terminal_status_bar)
terminal:update()

local pos = config.root_path:reverse():find("/", 2, true)
local drive = config.root_path:sub(0, config.root_path:len() - pos + 1)
local tools_dir = drive .. "tools/"
if not lfs.exists(tools_dir) or lfs.attributes(tools_dir).mode ~= "directory" then
    fatal("no tools directory found: " .. tools_dir)
end
cleanup_throbber:rotate()

local function cleanup_tool(tool)
    local tool_path = tools_dir .. tool

    local attr = lfs.attributes(tool_path)
    if not attr or attr.mode ~= "directory" or tool == "." or tool == ".." then
        return
    end
    cleanup_throbber:rotate()

    local tool_config_path = tool_path .. "/.config/"
    if not lfs.exists(tool_config_path) then
        return
    end

    local tool_seg = term.components.text("<tool-state>", terminal_body, "cleaning up tool '" .. tool .. "'")

    local disable_path = tool_config_path .. ".disable"
    if lfs.exists(disable_path) then
        tool_seg:change("tool '" .. tool .. "' is disabled")
        return
    end
    cleanup_throbber:rotate()

    local tool_cleanup_path = tool_config_path .. "cleanup.lua"
    if not lfs.exists(tool_cleanup_path) then
        tool_seg:remove()
        verbose("tool '" .. tool .. "' has no 'cleanup.lua' script in '.config' directory")
        return
    end

    local cleanup_func, err_msg = loadfile(tool_cleanup_path)
    if not cleanup_func then
        tool_seg:change("unable to load cleanup file for tool '" .. tool .. "'\n" .. err_msg)
        return
    end
    cleanup_throbber:rotate()

    local tool_thread = coroutine.create(cleanup_func)
    local success, setup_err_msg = coroutine.resume(tool_thread)

    tool_seg:remove(false)
    if not success then
        print("tool '" .. tool .. "' cleanup failed with:\n"
            .. debug.traceback(tool_thread, setup_err_msg))
    end
end

for tool in lfs.dir(tools_dir) do
    cleanup_tool(tool)
    cleanup_throbber:rotate()
end

config.env.remove("PATH", tools_dir .. "bin;", "user")

config.env.unset("TOOLS_FREEMAKER_PORTABLE", "user")
config.env.unset("USERCONFIG_FREEMAKER_PORTABLE", "user")
config.env.unset("DRIVE_FREEMAKER_PORTABLE", "user")

print("done cleaning up!")
