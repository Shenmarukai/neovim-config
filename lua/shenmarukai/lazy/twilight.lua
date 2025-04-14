-- Twilight

return {
    "folke/twilight.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    after = "nvim-treesitter", -- Ensure Twilight loads after Treesitter
    config = function()
        require('twilight').setup({
            dimming = {
                alpha = 0.25, -- amount of dimming
                -- we try to get the foreground from the highlight groups or fallback color
                color = { "Normal", "#ffffff" },
                term_bg = "#000000", -- if guibg=NONE, this will be used to calculate text color
                inactive = false, -- when true, other windows will be fully dimmed (unless they contain the same buffer)
            },
            context = 0, -- amount of lines we will try to show around the current line
            treesitter = true, -- use treesitter when available for the filetype
            -- treesitter is used to automatically expand the visible text,
            -- but you can further control the types of nodes that should always be fully expanded
            expand = { -- for treesitter, we we always try to expand to the top-most ancestor with these types
                "_declaration",
                "_definition",
                "_statement",
                "_constructor"
            },
            exclude = {}, -- exclude these filetypes
        })
        vim.keymap.set('n', '<leader>T', function()
            require('twilight').toggle()
        end, { desc = 'Toggle Twilight' })
    end
}
