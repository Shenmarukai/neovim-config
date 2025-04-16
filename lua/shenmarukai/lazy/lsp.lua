-- Lsp

return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "stevearc/conform.nvim",
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
    },
    opts = {
        diagnostics = {
            underline = true,
            update_in_insert = false,
            virtual_text = {
                spacing = 3,
                source = "if_many",
                prefix = "●",
                -- this will set set the prefix to a function that returns the diagnostics icon based on the severity
                -- this only works on a recent -1.10.0 build. Will be set to "●" when not supported
                -- prefix = "icons",
            },
            severity_sort = true,
            signs = {
                text = {
                    [vim.diagnostic.severity.ERROR] = "",
                    [vim.diagnostic.severity.WARN] = "",
                    [vim.diagnostic.severity.HINT] = "",
                    [vim.diagnostic.severity.INFO] = "",
                },
            },
        },
        inlay_hints = {
            enabled = true,
            exclude = {}, -- filetypes for which you don't want to enable inlay hints
        },
    },
    config = function()
        require("conform").setup({
            formatters_by_ft = {}
        })
        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities())
        require("fidget").setup({})
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
                "rust_analyzer",
                "gopls",
            },
            handlers = {
                function(server_name) -- default handler (optional)
                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities
                    }
                end,
                --[[
                ["lua_ls"] = function()
                    vim.lsp.config('lua_ls', {
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                runtime = { version = "Lua 5.1" },
                                diagnostics = {
                                    globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
                                },
                                workspace = {
                                    checkThirdParty = false,
                                },
                                codeLens = {
                                    enable = true,
                                },
                                completion = {
                                    callSnippet = "Replace",
                                },
                                doc = {
                                    privateName = { "^_" },
                                },
                                hint = {
                                    enable = true,
                                    paramType = true,
                                },
                            }
                        }
                    })
                end,
                ["rust_analyzer"] = function()
                    vim.lsp.config('rust_analyzer', {
                        capabilities = capabilities,
                        settings = {
                            ["rust-analyzer"] = {
                                checkOnSave = {
                                    command = "clippy",
                                },
                                cargo = {
                                    allFeatures = true,
                                },
                            }
                        }
                    })
                end,
                ["ts_ls"] = function()
                    vim.lsp.config('ts_ls', {
                        capabilities = capabilities,
                        init_options = {
                            plugins = {
                                {
                                    name = "@vue/typescript-plugin",
                                    location = "/usr/local/lib/node_modules/@vue/typescript-plugin",
                                    languages = {"javascript", "typescript", "vue"},
                                },
                            },
                        },
                        filetypes = {
                            "javascript",
                            "javascriptreact",
                            "javascript.jsx",
                            "typescript",
                            "typescriptreact",
                            "typescript.tsx"
                        },
                        root_markers = {
                            "tsconfig.json",
                            "jsconfig.json",
                            "package.json",
                            ".git"
                        },
                    })
                end,
                ]]
            },
        })

        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
                { name = "copilot", group_index = 2 },
                { name = 'nvim_lsp' },
                { name = 'luasnip' }, -- For luasnip users.
            }, {
                { name = 'buffer' },
            })
        })
    end
}
