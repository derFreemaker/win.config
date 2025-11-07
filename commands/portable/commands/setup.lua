local constants = require("commands.portable.commands.constants")

print("setting up...")

if not config.env.set("USERCONFIG_FREEMAKER_PORTABLE", config.root_path, config.env.scope.user) then
    fatal("unable to set userconfig env variable")
end

if not config.env.set("DRIVE_FREEMAKER_PORTABLE", constants.drive .. "\\", config.env.scope.user) then
    fatal("unable to set drive env variable")
end


if not config.env.set("TOOLS_FREEMAKER_PORTABLE", constants.tools_dir:gsub("/", "\\"), config.env.scope.user) then
    fatal("unable to set tools env variable")
end

if not lfs.exists(constants.tools_dir)
    or lfs.attributes(constants.tools_dir).mode ~= "directory" then
    fatal("no tools directory found: " .. constants.tools_dir)
end

if not lfs.exists(constants.bin_dir) then
    if not lfs.mkdir(constants.bin_dir) then
        fatal("unable to create: " .. constants.bin_dir)
    end
end

verbose("adding '" .. constants.bin_dir .. "' to PATH")

if not config.env.add("PATH", (constants.bin_dir .. "/"):gsub("/", "\\"), config.env.scope.user, true, ";") then
    fatal("unable to add bin path to PATH")
end

---@class config.portable.tool
---@field name string
---@field path string

---@class config.portable
---@field package path_files table<string, boolean?>
---@field package queued_actions { tool: config.portable.tool, func: function }[]
---
---@field package current_tool config.portable.tool
portable = {
    path_files = {},
    queued_actions = {},
}

---@return config.portable.tool
function portable.get_current_tool()
    return portable.current_tool
end

---@package
---@param tool config.portable.tool
function portable.set_current_tool(tool)
    local windows_conform_path = tool.path:gsub("/", "\\")
    if not lfs.chdir(windows_conform_path) then
        error("unable to change directory to '" .. windows_conform_path .. "'")
    end

    portable.current_tool = tool
end

---@class config.portable.path_file_options
---@field name string
---@field path string
---@field args string[]?
---@field prefix string?

---@param opt config.portable.path_file_options
function portable.add_file_to_path(opt)
    if portable.path_files[opt.name] then
        error("file already exists: " .. opt.name)
    end
    portable.path_files[opt.name] = true

    ---@return file*
    local function open_cmd_file()
        local batch_file_path = constants.bin_dir .. "/" .. opt.name .. ".cmd"
        local batch_file = io.open(batch_file_path, "w+")
        if not batch_file then
            error(("unable to open file '%s'"):format(batch_file_path))
        end

        return batch_file
    end

    local reverse = opt.path:reverse()
    local pos = reverse:find(".", 0, true)
    local ext = reverse:sub(0, pos or 0)

    local path = (portable.current_tool.path .. opt.path):gsub("/", "\\")
    if not opt.args and not opt.prefix then
        if config.env.is_root then
            verbose("creating symlink for '" .. opt.name .. "'")
            config.path.create_symlink(constants.bin_dir .. "/" .. opt.name .. ext, path)
        else
            verbose("creating indirect '.cmd' file as symlink fallback for '" .. opt.name .. "'")
            local file = open_cmd_file()

            file:write(("\"%s\""):format(path))
            file:write(" %*")
            file:close()
        end
    else
        verbose("creating '.cmd' file for '" .. opt.name .. "'")
        local file = open_cmd_file()

        file:write(("%s\"%s\" %s")
            :format(opt.prefix or "", path, table.concat(opt.args or {}, " ")))
        file:write(" %*")
        file:close()
    end
end

---@class config.portable.custom_path_file_options
---@field filename string
---@field content string

---@param opt config.portable.custom_path_file_options
function portable.add_custom_file_to_path(opt)
    local pos = opt.filename:find(".", 0, true)
    local name
    if pos then
        name = opt.filename:sub(0, pos - 1)
    else
        name = opt.filename
    end

    if portable.path_files[name] then
        error("file already exists: " .. name)
    end
    portable.path_files[name] = true

    local path = (constants.bin_dir .. "/" .. opt.filename):gsub("/", "\\")
    local file = io.open(path, "w+")
    if not file then
        error("unable to open file: ")
    end

    file:write(opt.content)
    file:close()
end

---@param func function
function portable.queue_action(func)
    table.insert(portable.queued_actions, {
        tool = portable.get_current_tool(),
        func = func,
    })
end

---@param tool config.portable.tool
local function setup_tool(tool)
    local tool_config_path = tool.path .. "/.config"
    if not lfs.exists(tool_config_path) then
        verbose("tool '" .. tool.name .. "' has no '.config' directory")
        return
    end

    local disable_path = tool_config_path .. "/.disable"
    if lfs.exists(disable_path) then
        print("tool '" .. tool.name .. "' is disabled")
        return
    end

    local tool_setup_path = tool_config_path .. "/setup.lua"
    if not lfs.exists(tool_setup_path) then
        verbose("tool '" .. tool.name .. "' has no 'setup.lua' script in '.config' directory")
        return
    end

    local setup_func, load_err_msg = loadfile(tool_setup_path)
    if not setup_func then
        print("unable to load setup file for tool '" .. tool.name .. "'\n" .. load_err_msg)
        return
    end

    print(("tool '%s'..."):format(tool.name))
    portable.set_current_tool(tool)

    local tool_thread = coroutine.create(setup_func)
    local success, setup_err_msg = coroutine.resume(tool_thread)

    if not success then
        print("tool '" .. tool.name .. "' setup failed with:\n"
            .. debug.traceback(tool_thread, setup_err_msg))

        coroutine.close(tool_thread)
        return
    end

    coroutine.close(tool_thread)
end

for tool in lfs.dir(constants.tools_dir) do
    local attr = lfs.attributes(constants.tools_dir .. "/" .. tool)
    if not attr
        or attr.mode ~= "directory"
        or tool == "."
        or tool == ".." then
        goto continue
    end

    setup_tool({
        name = tool,
        path = (constants.tools_dir .. "/" .. tool .. "/"):gsub("/", "\\"),
    })

    ::continue::
end

-- get back to config dir
if not lfs.chdir(config.root_path) then
    error("unable to change directory to '" .. config.root_path .. "'")
end

if not config.env.broadcast_change_message() then
    fatal("unable to broadcast environment change")
end

verbose("running queued actions...")

for _, action in pairs(portable.queued_actions) do
    portable.set_current_tool(action.tool)

    local thread = coroutine.create(action.func)
    local success, action_err_msg = coroutine.resume(thread)

    if not success then
        warn("tool '" .. action.tool.name .. "' queued action failed with:\n"
            .. debug.traceback(thread, action_err_msg))
    end

    coroutine.close(thread)
end

print("done setting up!")
