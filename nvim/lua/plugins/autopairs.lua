local setup, autopairs, cmp, cmp_autopairs = protectedRequire("nvim-autopairs", "cmp", "nvim-autopairs.completion.cmp")
if not setup then
    return
end

-- configure autopairs
autopairs.setup({
    check_ts = true,                        -- enable treesitter
    ts_config = {
        lua = { "string" },                 -- don't add pairs in lua string treesitter nodes
        javascript = { "template_string" }, -- don't add pairs in javscript template_string treesitter nodes
        java = false,                       -- don't check treesitter on java
    },
})

-- make autopairs and completion work together
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
