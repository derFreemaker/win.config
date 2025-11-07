local constants = require("commands.portable.commands.constants")

if not lfs.exists(constants.tools_dir)
    or lfs.attributes(constants.tools_dir).mode ~= "directory" then
    fatal("no tools directory found: " .. constants.tools_dir)
end


if not lfs.exists(constants.bin_dir) then
    if not lfs.mkdir(constants.bin_dir) then
        fatal("unable to create: " .. constants.bin_dir)
    end
end

---@class config.portable.tool
---@field name string
---@field path string

---@class config.portable.queued_action
---@field tool config.portable.tool
---@field func function

---@class config.portable
---@field package path_files table<string, boolean?>
---@field package queued_actions config.portable.queued_action[]
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

function portable.execute_queued_actions()
    verbose("executing queued actions...")
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
end
