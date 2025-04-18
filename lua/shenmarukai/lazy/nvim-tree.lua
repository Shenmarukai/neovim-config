-- Nvim Tree

return {
    "nvim-tree/nvim-tree.lua",

    config = function()
        -- disable netrw at the very start of your init.lua
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1

        -- optionally enable 24-bit colour
        vim.opt.termguicolors = true

        -- OR setup with some options
        require("nvim-tree").setup({
            sort = {
                sorter = "case_sensitive",
            },
            view = {
                width = 30,
            },
            renderer = {
                group_empty = true,
            },
            filters = {
                dotfiles = true,
            },
        })

        -- Add a toggle hotkey using vim.keymap.set
        vim.keymap.set('n', '<leader><C>T', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
    end
}
