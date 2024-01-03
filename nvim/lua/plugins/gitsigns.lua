local setup, gitsigns = protectedRequire("gitsigns")
if not setup then
    return
end

gitsigns.setup()
