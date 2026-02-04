return {
    "stevearc/conform.nvim",
    config = function()
        require("conform").setup({
            format_on_save = {
                timeout_ms = 5000,
                lsp_format = "fallback",
            },
            formatters_by_ft = {
                c = { "clang-format" },
                cpp = { "clang-format" },
                lua = { "stylua" },
            },
            formatters = {
                prepend_args = { "-style=file", "-fallback-style=LLVM" },
            },
        })
    end,
    keys = {
        {
            "<leader>f", function()
                require("conform").format({ bufnr = 0 })
            end,
        },
    },
}
