-- Write-Output "setting up..."

-- . "$PSScriptRoot/../utils.ps1"

-- $driveLetter = $pwd.drive.name + ":"
-- $Global:DriveLetter = $driveLetter

-- . "$driveLetter\Tools\misc\load.ps1"

-- # adding paths to enviorment variable ("PATH")
-- $paths = Get-Paths -DriveLetter $driveLetter
-- $paths_str = $paths -join ";"

-- Add-ENV -VariableName "PATH" -Value $paths_str
-- Set-ENV -VariableName "PATH_FREEMAKER_PORTABLE" -Value $paths_str

-- Set-ENV -VariableName "USERCONFIG_FREEMAKER_PORTABLE" -Value "$driveLetter/.config"
-- Set-ENV -VariableName "DRIVE_FREEMAKER_PORTABLE" -Value "$driveLetter"

-- # window manger
-- . "$PSScriptRoot/../glazewm/portable/setup.ps1"

print("setting up...")

config.env.set("USERCONFIG_FREEMAKER_PORTABLE", config.root_path)

local pos = config.root_path:reverse():find("/", 2, true)
local drive = config.root_path:sub(0, config.root_path:len() - pos + 1)
local tools_dir = drive .. "tools/"
if not lfs.exists(tools_dir) or lfs.attributes(tools_dir).mode ~= "directory" then
    fatal("no tools directory found: " .. tools_dir)
end

config.env.set("TOOLS_FREEMAKER_PORTABLE", tools_dir)

---@class config.portable
---@field package current_tool string
---@field package paths string[]
portable = {
    paths = {}
}

---@return string
function portable.get_current_tool()
    return portable.current_tool
end

---@package
---@param tool string
function portable.set_current_tool(tool)
    portable.current_tool = tool
end

---@param path string | nil
function portable.add_tool_to_path(path)
    if not path then
        table.insert(portable.paths, tools_dir .. portable.current_tool)
        return
    end

    table.insert(portable.paths, tools_dir .. portable.current_tool .. "/" .. path)
end

for tool in lfs.dir(tools_dir) do
    local tool_path = tools_dir .. tool
    local attr = lfs.attributes(tool_path)
    if not attr or attr.mode ~= "directory" or tool == "." or tool == ".." then
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
    setup_func()

    ::continue::
end

if #portable.paths > 0 then
    local paths_str = table.concat(portable.paths, ";") .. ";"

    -- config.env.set("PATH",paths_str
    --     .. config.env.get("PATH"), "user")

    -- config.env.set("PATHS_FREEMAKER_PORTABLE", paths_str, "user")
end

print("done setting up!")
