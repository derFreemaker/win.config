local setup, mason, mason_lspconfig, mason_null_ls = protectedRequire("mason", "mason-lspconfig", "mason-null-ls")
if not setup then
    return
end

mason.setup()

mason_lspconfig.setup({
    ensure_installed = {
        "emmet_ls",
        "html",
        "cssls",
        "lua_ls",
        "marksman",
        "rust_analyzer",
        "yamlls",
        "biome",
    },
    -- auto-install configured servers (with lspconfig)
    automatic_installation = true, -- not the same as ensure_installed
})

mason_null_ls.setup({
    -- list of formatters & linters for mason to install
    ensure_installed = {
        "prettier", -- ts/js formatter
        "stylua",   -- lua formatter
        "eslint_d", -- ts/js linter
    },
    -- auto-install configured formatters & linters (with null-ls)
    automatic_installation = true,
})
