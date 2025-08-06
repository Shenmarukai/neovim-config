-- Lsp

return {
    {
        "williamboman/mason.nvim",
        config = true,
        priority = 1000,
    },
    {
        "mfussenegger/nvim-lint",
        config = function()
            local lint = require("lint")

            lint.linters_by_ft = {
                rust = { "bacon" },
                cpp = { --[["cpplint",]] "cppcheck" },
                c = { --[["cpplint",]] "cppcheck" },
                javascript = { "biomejs" },
                typescript = { "biomejs" },
                javascriptreact = { "biomejs" },
                typescriptreact = { "biomejs" },
            }

            vim.api.nvim_create_autocmd({ "InsertLeave" }, {
                callback = function()
                    lint.try_lint()
                end,
            })
        end,
    },
    {
        "rshkarin/mason-nvim-lint",
        dependencies = {
            "williamboman/mason.nvim",
            "mfussenegger/nvim-lint",
        },
        config = function()
            require("mason-nvim-lint").setup({
                ensure_installed = {},
                automatic_installation = true,
            })
        end,
        priority = 800,
    },
}
