if not config.env.is_windows then
    return
end

print("installing chocolatey...")
local success, _, output = config.env.execute_in_pwsh("./chocolatey/install.ps1")
if not success then
    print(output)
end
