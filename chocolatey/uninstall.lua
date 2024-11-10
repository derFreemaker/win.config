if not config.env.is_windows then
    return
end

print("removing chocolatey...")
local success, _, output = config.env.execute_in_pwsh("./chocolatey/uninstall.ps1")
if not success then
    print(output)
end
