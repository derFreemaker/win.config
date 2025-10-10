print("setting up...")

if not config.env.set("USERCONFIG_FREEMAKER_PORTABLE", config.root_path, config.env.scope.user) then
    fatal("unable to set userconfig env variable")
end

local tools_dir
do
    local pos = config.root_path:reverse():find("/", 2, true)
    local drive = config.root_path:sub(0, config.root_path:len() - pos + 1)
    if not config.env.set("DRIVE_FREEMAKER_PORTABLE", drive, config.env.scope.user) then
        fatal("unable to set drive env variable")
    end

    tools_dir = drive .. "tools"
    if not config.env.set("TOOLS_FREEMAKER_PORTABLE", tools_dir:gsub("/", "\\"), config.env.scope.user) then
        fatal("unable to set tools env variable")
    end
end

if not lfs.exists(tools_dir)
    or lfs.attributes(tools_dir).mode ~= "directory" then
    fatal("no tools directory found: " .. tools_dir)
end

---@class config.portable.tool
---@field name string
---@field path string

---@class config.portable
---@field package file_infos { path: string, args: string[]?, proxy: boolean? }[]
---@field package run_after_funcs { tool: config.portable.tool, func: function }[]
---
---@field package current_tool config.portable.tool
portable = {
    file_infos = {},
    run_after_funcs = {},
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

---@class config.portable.file_path_options
---@field name string
---@field path string
---@field proxy boolean? will invoke with 'start' on none admin right setup when false
---@field args string[]?

---@param opt config.portable.file_path_options
function portable.add_file_to_path(opt)
    if opt.proxy and opt.args then
        error("a proxy file cannot have args")
    end

    portable.file_infos[opt.name] = {
        path = portable.current_tool.path .. "/" .. opt.path,
        args = opt.args,
        proxy = opt
            .proxy or not opt.args
    }
end

---@param func function
function portable.run_after(func)
    table.insert(portable.run_after_funcs, {
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

for tool in lfs.dir(tools_dir) do
    local attr = lfs.attributes(tools_dir .. "/" .. tool)
    if not attr
        or attr.mode ~= "directory"
        or tool == "."
        or tool == ".." then
        goto continue
    end

    setup_tool({
        name = tool,
        path = tools_dir .. "/" .. tool,
    })

    ::continue::
end

-- get back to config dir
if not lfs.chdir(config.root_path) then
    error("unable to change directory to '" .. config.root_path .. "'")
end

local bin_dir = tools_dir .. "/bin"
if not lfs.exists(bin_dir) then
    lfs.mkdir(bin_dir)
end

verbose("creating links...")

for file_name, file_info in pairs(portable.file_infos) do
    local function open_batch_file()
        local batch_file_path = bin_dir .. "/" .. file_name .. ".bat"
        local batch_file = io.open(batch_file_path, "w")
        if not batch_file then
            print(("unable to open file '%s'"):format(batch_file_path))
            return nil
        end

        return batch_file
    end

    local windows_conform_path = file_info.path:gsub("/", "\\")

    if file_info.proxy then
        verbose("creating proxy for '" .. file_info.path .. "'")
        if config.env.is_root then
            config.path.create_symlink(file_name .. ".exe", windows_conform_path)
        else
            local batch_file = open_batch_file()
            if not batch_file then
                goto continue
            end

            batch_file:write(("\"%s\""):format(windows_conform_path))
            batch_file:write(" %*")
            batch_file:close()
        end
    else
        verbose("creating batch file for '" .. file_info.path .. "'")
        local batch_file = open_batch_file()
        if not batch_file then
            goto continue
        end

        batch_file:write(("start \"\" \"%s\" %s")
            :format(windows_conform_path, table.concat(file_info.args, " ")))
        batch_file:write(" %*")
        batch_file:close()
    end

    ::continue::
end

verbose("done creating links")

local bin_path = tools_dir:gsub("/", "\\") .. "\\bin"
verbose("bin path: " .. bin_path)

if not config.env.add("PATH", bin_path, config.env.scope.user, true, ";") then
    fatal("unable to add bin path to PATH")
end

if not config.env.set("PATH_FREEMAKER_PORTABLE", bin_path, config.env.scope.user) then
    fatal("unable to set PATH_FREEMAKER_PORTABLE")
end

for _, func in pairs(portable.run_after_funcs) do
    portable.set_current_tool(func.tool)
    pcall(func.func)
end

print("done setting up!")
