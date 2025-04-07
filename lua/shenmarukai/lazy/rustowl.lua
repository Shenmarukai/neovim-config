return {
    'cordx56/rustowl',
    dependencies = { "neovim/nvim-lspconfig" },
    build = 'cd rustowl && cargo install --path . --locked',
    lazy = false, -- This plugin is already lazy
    opts = {
        auto_attach = true, -- Auto attach the RustOwl LSP client when opening a Rust file
        auto_enable = false, -- Enable RustOwl immediately when attaching the LSP client
        idle_time = 500, -- Time in milliseconds to hover with the cursor before triggering RustOwl
        client = {
            on_attach = function(_, buffer)
                vim.keymap.set('n', '<leader>o', function()
                    require('rustowl').toggle(buffer)
                end, { buffer = buffer, desc = 'Toggle RustOwl' })
            end
        }, -- LSP client configuration that gets passed to `vim.lsp.start`
    },
}
