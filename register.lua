local tools = require("tools.tools")

-- environment variables
tools.add_tool({
    name = "env",
    handler = {
        install = function(tool_config)
            if not config.env.set("USERCONFIG_FREEMAKER", config.root_path, "user") then
                return false, 1, "unable to set environment variable"
            end
            return true, 0, ""
        end,
        uninstall = function(tool_config)
            if not config.env.unset("USERCONFIG_FREEMAKER", "user") then
                return false, 1, "unable to remove environment variable"
            end
            return true, 0, ""
        end
    }
})

-- chocolatey
tools.add_tool({
    name = "chocolatey",
    handler = {
        install = function(tool_config)
            return config.env.execute("Set-ExecutionPolicy Bypass -Scope Process -Force;"
                .. "[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;"
                .. "Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))")
        end,
        uninstall = function(tool_config)
            return config.env.execute("Remove-Item -Force -Recurse \"$env:ChocolateyInstall\" -ErrorAction Ignore")
        end,
        upgrade = function(tool_config)
            return config.env.execute("choco upgrade chocolatey -y")
        end
    }
})

-- wezterm
tools.use_winget("WezTerm", "wez.wezterm")

-- powershell
tools.add_tool({
    name = "powershell",
    handler = {},
    setup = function(tool_config)
        local success = config.env.execute(
            "pwsh -Command \"New-Item -ItemType Directory -Path (Split-Path -Parent $PROFILE) -Force;"
            .. "Copy-Item -Path './pwsh/entry.ps1' -Destination $PROFILE -Force\"", true)
        return success
    end
})
tools.use_choco("oh-my-posh")
tools.add_tool({
    name = "powershell.modules",
    handler = {
        install = function(tool_config)
            return config.env.execute("PowerShell -ExecutionPolicy Bypass;"
                .. "Import-Module PowerShellGet;"
                .. "Install-Module -Name Terminal-Icons -Force;"
                .. "Install-Module -Name PSReadLine -Force;")
        end
    }
})

-- Git & co
tools.use_winget("Git", "Git.Git")
tools.use_winget("Github Desktop", "GitHub.GitHubDesktop")
-- tools.use_winget("Axosoft.GitKraken")
tools.use_winget("Github CLI", "GitHub.cli")

tools.use_choco("mingw")
tools.use_choco("make")
tools.use_choco("gsudo")

-- cmake
tools.add_tool({
    name = "CMake",
    id = "cmake.install",
    handler = tools.chocolatey,
    after = {
        install = function(tool_config)
            config.env.add("PATH", config.env.get("PROGRAMFILES") .. "/CMake/bin", "machine", true)
            return true
        end
    }
})

-- neovim
tools.use_choco("neovim")

-- powertoys & co
tools.use_winget("Powertoys", "microsoft.powertoys")
tools.use_choco("everythingpowertoys")
tools.add_tool({
    name = "chatgptpowertoys",
    handler = {
        install = function(tool_config)
            print("installing powertoys plugin for " .. tool_config.name)

            local command =
            "$temp = New-TemporaryFile;Invoke-WebRequest -Uri \"https://github.com/ferraridavide/ChatGPTPowerToys/releases/download/v0.85.1/Community.PowerToys.Run.Plugin.ChatGPT.x64.zip\" -OutFile $temp;Invoke-Expression \"7z e $temp -o'$env:LOCALAPPDATA/Microsoft/PowerToys/PowerToys Run/Plugins/ChatGPT'\""
            return config.env.execute(command)
        end
    }
})

-- everything
tools.use_winget("Everything", "voidtools.Everything")

-- glazewm
tools.add_tool({
    name = "Glazewm",
    id = "glzr-io.glazewm",
    handler = tools.winget,
    after = {
        install = function(tool_config)
            tools.winget.uninstall({ name = "zebar", id = "glzr-io.zebar" })

            local path = config.env.get("USERPROFILE") .. "/.glzr"
            if lfs.exists(path) then
                config.env.execute("Remove-Item -Path \"" .. path .. "\" -Recurse -Force")
            end

            return true
        end
    },
    setup = function(tool_config)
        local userprofile = config.env.get("USERPROFILE")
        local glzr_dir = userprofile .. "/.glzr"
        if not lfs.exists(glzr_dir) and not lfs.mkdir(glzr_dir) then
            return false
        end

        local glazewm_dir = config.path.add_hostname_if_found(config.root_path .. "/glazewm")
        if not config.path.create_junction(glzr_dir .. "/glazewm", glazewm_dir) then
            return false
        end

        local shortcut_path = config.env.get("APPDATA")
            .. "/Microsoft/Windows/Start Menu/Programs/Startup/GlazeWM.lnk"
        local shortcut_target = config.env.get("PROGRAMFILES")
            .. "/glzr.io/GlazeWM/glazewm.exe"
        if not config.path.create_shortcut(shortcut_path, shortcut_target) then
            return false
        end

        return true
    end
})

tools.add_tool({
    name = "registry",
    handler = {
        install = function(tool_config)
            return config.env.execute("./registry/apply_regedits.ps1")
        end,
        uninstall = function(tool_config)
            return config.env.execute("./registry/remove_regedits.ps1")
        end
    }
})

-- some other Programs
tools.use_winget("7zip", "7zip.7zip")
tools.use_winget("Brave", "Brave.Brave")
tools.use_winget("Notepad++", "Notepad++.Notepad++")
tools.use_winget("BalenaEtcher", "Balena.Etcher")
tools.use_winget("Anydesk", "AnyDeskSoftwareGmbH.Anydesk")
tools.use_winget("WinToys", "9p8ltpgcbzxd")

tools.use_winget("Zen", "Zen-Team.Zen-Browser")
tools.use_winget("Rust", "Rustlang.Rustup")

-- tools.use_winget("Postman", "Postman.Postman")
-- tools.use_winget("Docker.DockerDesktop")
-- tools.use_winget("LocalSend.LocalSend")
