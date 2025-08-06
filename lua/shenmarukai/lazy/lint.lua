-- Lsp

return {
    {
        "williamboman/mason.nvim",
        config = true,
        priority = 1000,
    },
    {
        "mfussenegger/nvim-lint",
        dependencies = {
            "nvim-lua/plenary.nvim"
        },
        config = function()
            local lint = require("lint")

            lint.linters.cppcheck.args = {
                "--enable=warning,style,performance,information",
                function()
                    if vim.bo.filetype == "cpp" then
                        return "--language=c++"
                    else
                        return "--language=c"
                    end
                end,
                "--inline-suppr",
                "--quiet",
                function()
                    if vim.fn.isdirectory("build") == 1 then
                        return "--cppcheck-build-dir=build"
                    else
                        return nil
                    end
                end,
                function()
                    -- Add suppressions-list if .cppcheck-suppress exists
                    if vim.fn.filereadable(".cppcheck-suppress") == 1 then
                        return "--suppressions-list=.cppcheck-suppress"
                    else
                        return nil
                    end
                end,
                "--template={file}:{line}:{column}: [{id}] {severity}: {message}",
            }

            lint.linters_by_ft = {
                make = { "checkmake" },
                rust = { "bacon" },
                cpp = { --[["cpplint",]] "cppcheck" },
                c = { --[["cpplint",]] "cppcheck" },
                javascript = { "biomejs" },
                typescript = { "biomejs" },
                javascriptreact = { "biomejs" },
                typescriptreact = { "biomejs" },
            }

            vim.api.nvim_create_autocmd({ "InsertLeave", "BufReadPost", "BufNewFile" }, {
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
