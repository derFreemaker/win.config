return { {
    "j-hui/fidget.nvim",
    lazy = false,
    opts = {
        notification = {
            window = {
                winblend = 0,        -- Background transparency (0-100)
                relative = "editor", -- Position relative to editor window
            },
        },
    },
    config = function(_, opts)
        require("fidget").setup(opts)

        vim.notify = require("fidget").notify
    end,
} }
