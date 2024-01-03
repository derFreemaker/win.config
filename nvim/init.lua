---@diagnostic disable-next-line: deprecated
table.unpack = table.unpack or unpack

---@param ... string
---@return boolean success
---@return any ...
function protectedRequire(...)
    local requires = { ... }
    for key, name in pairs(requires) do
        local success, result = pcall(require, name)
        if not success then
            return false
        end
        requires[key] = result
    end
    ---@diagnostic disable-next-line
    return true, table.unpack(requires)
end

MyR("plugin-setup")

MyR("core.options")
MyR("core.keymaps")
MyR("core.colorscheme")

MyR("plugins.comment")
MyR("plugins.nvim-tree")
MyR("plugins.lualine")
MyR("plugins.telescope")
MyR("plugins.nvim-cmp")

MyR("plugins.lsp.mason")
MyR("plugins.lsp.lspsaga")
MyR("plugins.lsp.lspconfig")
MyR("plugins.lsp.null-ls")

MyR("plugins.autopairs")
MyR("plugins.treesitter")
MyR("plugins.gitsigns")
