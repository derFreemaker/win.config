if not config.env.is_windows then
    error("chocolatey.install is windows only")
end

print("installing chocolatey...")
local success, _, output = config.env.execute("./chocolatey/install.ps1")
if not success then
    print(output)
end
