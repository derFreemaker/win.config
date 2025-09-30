print("setting up...")

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

    local windows_conform_path = (tools_dir .. portable.current_tool.path .. "/" .. opt.path):gsub("/", "\\")
    portable.file_infos[opt.name] = { path = windows_conform_path, args = opt.args, proxy = opt.proxy or not opt.args }
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
    local attr = lfs.attributes(tool.path)
    if not attr
        or attr.mode ~= "directory"
        or tool.name == "."
        or tool.name == ".." then
        return
    end

    local tool_config_path = tool.path .. "/.config/"
    if not lfs.exists(tool_config_path) then
        verbose("tool '" .. tool.name .. "' has no '.config' directory")
        return
    end

    local disable_path = tool_config_path .. ".disable"
    if lfs.exists(disable_path) then
        print("tool '" .. tool.name .. "' is disabled")
        return
    end

    local tool_setup_path = tool_config_path .. "setup.lua"
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

    -- change into tool dir for easy relativ pathing
    lfs.chdir(portable.current_tool.path)

    local tool_thread = coroutine.create(setup_func)
    local success, setup_err_msg = coroutine.resume(tool_thread)
	coroutine.close(tool_thread)

    if not success then
        print("tool '" .. tool.name .. "' setup failed with:\n"
            .. debug.traceback(tool_thread, setup_err_msg))
    end
end

for tool in lfs.dir(tools_dir) do
    setup_tool({
        name = tool,
        path = tools_dir .. tool,
    })
end

-- get back to config dir
lfs.chdir(config.root_path)

local bin_dir = tools_dir .. "bin/"
if not lfs.exists(bin_dir) then
    lfs.mkdir(bin_dir)
end

verbose("creating links...")

for file_name, file_info in pairs(portable.file_infos) do
    local function open_batch_file()
        local batch_file_path = bin_dir .. file_name .. ".bat"
        local batch_file = io.open(batch_file_path, "w")
        if not batch_file then
            print(("unable to open file '%s'"):format(batch_file_path))
            return nil
        end

        return batch_file
    end

    if file_info.proxy then
        verbose("creating proxy for '" .. file_info.path .. "'")
        if config.env.is_admin then
            config.path.create_symlink(file_name .. ".exe", file_info.path)
        else
            local batch_file = open_batch_file()
            if not batch_file then
                goto continue
            end

            batch_file:write(("\"%s\""):format(file_info.path))
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
            :format(file_info.path, table.concat(file_info.args, " ")))
        batch_file:write(" %*")
        batch_file:close()
    end

    ::continue::
end

verbose("done creating links")

local bin_path = tools_dir:gsub("/", "\\") .. "bin"
print("bin path: " .. bin_path)
config.env.add("PATH", bin_path, "user", true, ";")

config.env.set("PATH_FREEMAKER_PORTABLE", bin_path, "user")

for _, func in pairs(portable.run_after_funcs) do
	portable.set_current_tool(func.tool)
    pcall(func.func)
end

print("done setting up!")
