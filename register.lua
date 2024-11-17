local winget = require("scripts.winget")
local tools = require("scripts.tools")

-- powershell
tools.add_tool({
    name = "powershell",
    handler = {},
    after = {
        setup = function(tool_config)
            config.env.execute("Copy-Item -Path \"" .. config.root_path .. "/pwsh/entry.ps1\" -Destination $PROFILE -Force")
        end
    }
})
tools.use_choco("oh-my-posh")
tools.add_tool({
    name = "powershell.modules",
    handler = {
        install = function(tool_config)
            config.env.execute("Install-Module -Name Terminal-Icons -Force")
            config.env.execute("Install-Module -Name PSReadLine -Force")
        end
    }
})

-- Git & co
tools.use_winget("Git.Git")
tools.use_winget("GitHub.GitHubDesktop")
-- tools.use_winget("Axosoft.GitKraken")
tools.use_winget("GitHub.cli")

tools.use_choco("mingw")
tools.use_choco("make")
tools.use_choco("gsudo")

-- cmake
tools.add_tool({
    name = "cmake.install",
    handler = "chocolatey",
    after = {
        install = function(tool_config)
            config.env.add("PATH", "C:/Program Files/CMake/bin", "machine", true)
        end
    }
})

-- neovim
tools.use_choco("neovim")

-- powertoys & co
tools.use_winget("microsoft.powertoys")
tools.use_choco("everythingpowertoys")
tools.add_tool({
    name = "chatgptpowertoys",
    handler = {
        install = function(tool_config)
            print("installing powertoys plugin for " .. tool_config.name)
            config.env.execute("\"" .. config.root_path .. "/powertoys/plugins/chatgpt/install.ps1\"")
        end
    }
})

-- glazewm
tools.add_tool({
    name = "glzr-io.glazewm",
    handler = "winget",
    after = {
        install = function(tool_config)
            winget.uninstall("glzr-io.zebar")

            local path = config.env.get("USERPROFILE") .. "/.glzr"
            if lfs.exists(path) then
                config.env.execute("Remove-Item -Path \"" .. path .. "\" -Recurse -Force")
            end
        end,
        setup = function(tool_config)
            local userprofile = config.env.get("USERPROFILE")
            lfs.mkdir(userprofile .. "/.glzr")
            local glazewm_dir = config.path.add_hostname_if_found(config.root_path .. "/glazewm")
            config.path.create_junction(userprofile .. "/.glzr/glazewm", glazewm_dir)
            config.path.create_shortcut()
        end
    }
})

-- explorer blur
tools.add_tool({
    name = "explorer_blur",
    handler = {
        install = function()
            config.env.execute("./explorer_blur/register.cmd")
        end,
        uninstall = function()
            config.env.execute("./explorer_blur/uninstall.cmd")
        end
    }
})

-- some other Programs
tools.use_winget("7zip.7zip")
tools.use_winget("Brave.Brave")
tools.use_winget("Notepad++.Notepad++")
tools.use_winget("Postman.Postman")
tools.use_winget("Balena.Etcher")
tools.use_winget("AnyDeskSoftwareGmbH.Anydesk")
-- tools.use_winget("Docker.DockerDesktop")
-- tools.use_winget("LocalSend.LocalSend")
