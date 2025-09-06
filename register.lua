local tools = require("tools.tools")
local utils = require("tools.utils")

-- environment variables
tools.add_tool({
    name = "env",
    handler = {
        install = function(_)
            if not config.env.set("USERCONFIG_FREEMAKER", config.root_path, "user") then
                return false, 1, "unable to set environment variable"
            end

            if not config.env.add("PATH", config.root_path .. "bin", "user", true, ";") then
                return false, 1, "unable to add '.../.config/bin' to PATH env var"
            end

            return true, 0, ""
        end,
        uninstall = function(_)
            if not config.env.unset("USERCONFIG_FREEMAKER", "user") then
                return false, 1, "unable to remove environment variable"
            end

            if not config.env.remove("PATH", config.root_path .. "bin;", "user") then
                return false, 1, "unable to remove '.../.config/bin' from PATH env var"
            end

            return true, 0, ""
        end
    }
})

-- chocolatey
tools.add_tool({
    name = "chocolatey",
    handler = {
        install = function(_)
            return config.env.execute("Set-ExecutionPolicy Bypass -Scope Process -Force;"
                .. "[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;"
                .. "Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))")
        end,
        uninstall = function(_)
            return config.env.execute("Remove-Item -Force -Recurse \"$env:ChocolateyInstall\" -ErrorAction Ignore")
        end,
        upgrade = function(_)
            return config.env.execute("choco upgrade chocolatey -y")
        end
    }
})

-- powershell
tools.add_tool({
    name = "powershell",
    setup = function(_)
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
        install = function(_)
            return config.env.execute("PowerShell -ExecutionPolicy Bypass;"
                .. "Import-Module PowerShellGet;"
                .. "Install-Module -Name Terminal-Icons -Force;"
                .. "Install-Module -Name PSReadLine -Force;")
        end
    }
})
tools.add_tool({
    name = "alacritty",
    handler = tools.chocolatey,
    setup = function(_)
        local config_folder_path = config.env.get("APPDATA") .. "/alacritty"
        if not config.path.create_junction(config_folder_path, config.root_path .. "/alacritty") then
            return false, "unable to create config junction"
        end

        return true
    end
})

-- Git & co
tools.use_winget("git", "Git.Git")
tools.use_winget("github-desktop", "GitHub.GitHubDesktop")
-- tools.use_winget("Axosoft.GitKraken")
tools.use_winget("github-cli", "GitHub.cli")

tools.use_choco("mingw")
tools.use_choco("make")
tools.use_choco("gsudo")

-- directory navigation
tools.use_choco("zoxide")

-- cmake
tools.add_tool({
    name = "cmake",
    id = "cmake.install",
    handler = tools.chocolatey,
    after = {
        install = function(_)
            config.env.add("PATH", config.env.get("PROGRAMFILES") .. "/CMake/bin", "machine", true)
            return true
        end
    }
})
tools.use_choco("ninja")

-- editor
tools.add_tool({
    name = "neovim",
    handler = tools.chocolatey,
    setup = function(_)
        local config_folder_path = config.env.get("LOCALAPPDATA") .. "/nvim"
        if not config.path.create_junction(config_folder_path, config.root_path .. "/editor/nvim") then
            return false, "unable to create config junction"
        end

        local success, _, output = utils.display_execute("git clone https://github.com/wbthomason/packer.nvim '" ..
            config.env.get("LOCALAPPDATA") .. "/nvim-data/site/pack/packer/start/packer.nvim'")
        return success, output
    end
})
-- tools.add_tool({
--     name = "Zed",
--     setup = function(_)
--         if not config.path.create_junction(config.env.get("APPDATA") .. "/Zed", config.root_path .. "editor/zed") then
--             return false, "unable to create config junction"
--         end
--         return true
--     end
-- })

-- powertoys & co
tools.use_winget("powertoys", "microsoft.powertoys")

-- everything
tools.use_winget("everything", "voidtools.Everything")

-- glazewm
tools.add_tool({
    name = "glazewm",
    id = "glzr-io.glazewm",
    handler = tools.winget,
    after = {
        install = function(_)
            tools.winget.uninstall({ name = "zebar", id = "glzr-io.zebar" })

            local path = config.env.get("USERPROFILE") .. "/.glzr"
            if lfs.exists(path) then
                config.env.execute("Remove-Item -Path \"" .. path .. "\" -Recurse -Force")
            end

            return true
        end
    },
    setup = function(_)
        local userprofile = config.env.get("USERPROFILE")
        local glzr_dir = userprofile .. "/.glzr"
        if not lfs.exists(glzr_dir) and not lfs.mkdir(glzr_dir) then
            return false, "unable to create ~/.glzr folder"
        end

        local glazewm_dir = config.path.add_hostname_if_found(config.root_path .. "/glazewm")
        if not config.path.create_junction(glzr_dir .. "/glazewm", glazewm_dir) then
            return false, "unable to create config folder junction"
        end

        local shortcut_path = config.env.get("APPDATA")
            .. "/Microsoft/Windows/Start Menu/Programs/Startup/GlazeWM.lnk"
        local shortcut_target = config.env.get("PROGRAMFILES")
            .. "/glzr.io/GlazeWM/glazewm.exe"
        if not config.path.create_shortcut(shortcut_path, shortcut_target) then
            return false, "unable to create glazewm shortcut for autostart"
        end

        return true
    end
})

tools.add_tool({
    name = "registry",
    handler = {
        install = function(_)
            return config.env.execute("./registry/apply_regedits.ps1")
        end,
        uninstall = function(_)
            return config.env.execute("./registry/remove_regedits.ps1")
        end
    }
})

-- some other Programs
tools.use_winget("7zip", "7zip.7zip")
tools.use_winget("brave", "Brave.Brave")
tools.use_winget("notepad++", "Notepad++.Notepad++")
tools.use_winget("balena-etcher", "Balena.Etcher")
tools.use_winget("anydesk", "AnyDeskSoftwareGmbH.Anydesk")
tools.use_winget("wintoys", "9p8ltpgcbzxd")

tools.use_winget("zen", "Zen-Team.Zen-Browser")
tools.use_winget("rust", "Rustlang.Rustup")

tools.use_winget("postman", "Postman.Postman")
-- tools.use_winget("docker", "Docker.DockerDesktop")

-- tools
tools.use_choco("wget", "wget")
