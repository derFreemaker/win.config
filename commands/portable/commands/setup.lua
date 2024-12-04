---@type lua-term
local term = require("tools.term")

terminal:print("setting up...")
local setup_throbber = term.components.throbber.new("setup_throbber", terminal_footer)
terminal:update()

config.env.set("USERCONFIG_FREEMAKER_PORTABLE", config.root_path, "user")
local tools_dir
do
    local pos = config.root_path:reverse():find("/", 2, true)
    local drive = config.root_path:sub(0, config.root_path:len() - pos + 1)
    config.env.set("DRIVE_FREEMAKER_PORTABLE", drive, "user")

    tools_dir = drive .. "tools/"
    config.env.set("TOOLS_FREEMAKER_PORTABLE", tools_dir:gsub("/", "\\"), "user")
end
if not lfs.exists(tools_dir) or lfs.attributes(tools_dir).mode ~= "directory" then
    fatal("no tools directory found: " .. tools_dir)
end

setup_throbber:rotate()

---@class config.portable
---@field package paths string[]
---
---@field package current_tool_path string
---@field package current_tool string
portable = {
    paths = {}
}

---@return string
function portable.get_current_tool()
    return portable.current_tool
end

function portable.get_current_tool_path()
    return portable.current_tool_path
end

---@package
---@param tool string
function portable.set_current_tool(tool)
    portable.current_tool = tool
    portable.current_tool_path = tools_dir .. tool .. "/"
end

---@param name string
---@param path string
function portable.add_file_to_path(name, path)
    local windows_conform_path = (tools_dir .. portable.current_tool .. "/" .. path):gsub("/", "\\")
    portable.paths[name] = windows_conform_path
end

---@param tool string
local function setup_tool(tool)
    local tool_path = tools_dir .. tool

    local attr = lfs.attributes(tool_path)
    if not attr
        or attr.mode ~= "directory"
        or tool == "."
        or tool == ".." then
        return
    end

    local tool_config_path = tool_path .. "/.config/"
    if not lfs.exists(tool_config_path) then
        verbose("tool '" .. tool .. "' has no '.config' directory")
        return
    end
    setup_throbber:rotate()

    local tool_seg = term.components.text.new("<tool-state>", terminal_body, "tool '" .. tool .. "'...")

    local disable_path = tool_config_path .. ".disable"
    if lfs.exists(disable_path) then
        tool_seg:change("tool '" .. tool .. "' is disabled")
        return
    end

    local tool_setup_path = tool_config_path .. "setup.lua"
    if not lfs.exists(tool_setup_path) then
        tool_seg:remove()
        verbose("tool '" .. tool .. "' has no 'setup.lua' script in '.config' directory")
        return
    end
    setup_throbber:rotate()

    local setup_func, load_err_msg = loadfile(tool_setup_path)
    if not setup_func then
        tool_seg:change("unable to load setup file for tool '" .. tool .. "'\n" .. load_err_msg)
        return
    end
    setup_throbber:rotate()

    portable.set_current_tool(tool)
    -- change into tool dir for easy relativ pathing
    lfs.chdir(portable.current_tool_path)

    local tool_thread = coroutine.create(setup_func)
    local success, setup_err_msg = coroutine.resume(tool_thread)

    tool_seg:remove(false)
    if not success then
        print("tool '" .. tool .. "' setup failed with:\n"
            .. debug.traceback(tool_thread, setup_err_msg))
    end
end

for tool in lfs.dir(tools_dir) do
    setup_tool(tool)
    setup_throbber:rotate()
end

-- get back to config dir
lfs.chdir(config.root_path)

local bin_dir = tools_dir .. "bin/"
if not lfs.exists(bin_dir) then
    lfs.mkdir(bin_dir)
end
setup_throbber:rotate()

for name, path in pairs(portable.paths) do
    if config.env.is_admin then
        local pos = path:reverse():find(".", nil, true)
        local ext = path:sub(path:len() - pos + 1)

        print(bin_dir .. name .. ext, path)
        config.path.create_symlink(bin_dir .. name .. ext, path)
    else
        local batch_file_path = bin_dir .. name .. ".bat"
        local batch_file = io.open(batch_file_path, "w")
        if not batch_file then
            print(("unable to open file '%s'"):format(batch_file_path))
            goto continue
        end

        batch_file:write(("@echo off\n\"" .. path .. "\" %*"))
        batch_file:close()
    end

    ::continue::
    setup_throbber:rotate()
end

local bin_path = tools_dir:gsub("/", "\\") .. "bin"
config.env.add("PATH", bin_path, "user", true, ";")

config.env.set("PATH_FREEMAKER_PORTABLE", bin_path, "user")

setup_throbber:remove()
print("done setting up!")
