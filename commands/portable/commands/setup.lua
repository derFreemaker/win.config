print("setting up...")

config.env.set("USERCONFIG_FREEMAKER_PORTABLE", config.root_path, "user")

local pos = config.root_path:reverse():find("/", 2, true)
local drive = config.root_path:sub(0, config.root_path:len() - pos + 1)
local tools_dir = drive .. "tools/"
if not lfs.exists(tools_dir) or lfs.attributes(tools_dir).mode ~= "directory" then
    fatal("no tools directory found: " .. tools_dir)
end

config.env.set("TOOLS_FREEMAKER_PORTABLE", tools_dir:gsub("/", "\\"), "user")

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

for tool in lfs.dir(tools_dir) do
    local tool_path = tools_dir .. tool
    local attr = lfs.attributes(tool_path)
    if not attr
        or attr.mode ~= "directory"
        or tool == "."
        or tool == ".."
        or tool == "bin" then
        goto continue
    end

    local tool_config_path = tool_path .. "/.config/"
    if not lfs.exists(tool_config_path) then
        verbose("tool '" .. tool .. "' has no '.config' directory")
        goto continue
    end

    local disable_path = tool_config_path .. ".disable"
    if lfs.exists(disable_path) then
        print("tool '" .. tool .. "' is disabled")
        goto continue
    end

    local tool_setup_path = tool_config_path .. "setup.lua"
    if not lfs.exists(tool_setup_path) then
        verbose("tool '" .. tool .. "' has no 'setup.lua' script in '.config' directory")
        goto continue
    end

    local setup_func, err_msg = loadfile(tool_setup_path)
    if not setup_func then
        print("unable to load setup file for tool '" .. tool .. "'\n" .. err_msg)
        goto continue
    end

    print("tool '" .. tool .. "'...")
    portable.set_current_tool(tool)
    portable.current_tool_path = tool_path .. "/"

    local tool_thread = coroutine.create(setup_func)
    local success, err_msg = coroutine.resume(tool_thread)
    if not success then
        print("tool '" .. tool .. "' setup failed with:\n" .. debug.traceback(tool_thread, err_msg))
    end
    coroutine.close(tool_thread)

    ::continue::
end

local bin_dir = tools_dir .. "bin/"
if not lfs.exists(bin_dir) then
    lfs.mkdir(bin_dir)
end

for name, path in pairs(portable.paths) do
    local batch_file_path = bin_dir .. name .. ".bat"
    local batch_file = io.open(batch_file_path, "w")
    if not batch_file then
        print(("unable to open file '%s'"):format(batch_file_path))
        goto continue
    end

    batch_file:write(("@echo off\nstart \"" .. path .. "\" %*"))
    batch_file:close()

    ::continue::
end

local bin_path = tools_dir:gsub("/", "\\") .. "bin;"
config.env.set("PATH_FREEMAKER_PORTABLE", bin_path, "user")
config.env.set("PATH", bin_path .. (config.env.get("PATH") or ""), "user")

print("done setting up!")
