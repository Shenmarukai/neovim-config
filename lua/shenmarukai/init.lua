require("shenmarukai.set")
require("shenmarukai.remap")
require("shenmarukai.lazy_init")

-- DO.not
-- DO NOT INCLUDE THIS

-- If i want to keep doing lsp debugging
-- function restart_htmx_lsp()
--     require("lsp-debug-tools").restart({ expected = {}, name = "htmx-lsp", cmd = { "htmx-lsp", "--level", "DEBUG" }, root_dir = vim.loop.cwd(), });
-- end

-- DO NOT INCLUDE THIS
-- DO.not

local augroup = vim.api.nvim_create_augroup
local ThePrimeagenGroup = augroup( 'ThePrimeagen', {} )

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup( 'HighlightYank', {} )

function R( name )
    require( "plenary.reload" ).reload_module( name )
end

function DoubleSpacedTabLanguage( filetype )
    if filetype == "html" or
       filetype == "css" or
       filetype == "javascript" or
       filetype == "typescript" or
       filetype == "javascriptreact" or
       filetype == "typescriptreact"
    then
        return true
    end
end

function QuadSpacedTabLanguage( filetype )
    if filetype == "lua" or
       filetype == "python" or
       filetype == "c" or
       filetype == "c++" or
       filetype == "c#" or
       filetype == "rust"
    then
        return true
    end
end

vim.filetype.add({
    extension = {
        templ = 'templ',
    }
})

autocmd( 'TextYankPost', {
    group = yank_group,
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch',
            timeout = 40,
        })
    end,
})

autocmd( { "BufWritePre" }, {
    group = ThePrimeagenGroup,
    pattern = "*",
    command = [[%s/\s\+$//e]],
})

autocmd( 'BufEnter', {
    group = ThePrimeagenGroup,
    callback = function()
        --vim.cmd.colorscheme("tokyonight-night")
        --vim.cmd.colorscheme("github_dark_default")
        vim.cmd.colorscheme( "catppuccin" )
        --local twilight = require( 'twilight' )
        --twilight.disable()
        --twilight.enable()
        local filetype = vim.bo.filetype
        if DoubleSpacedTabLanguage( filetype ) then
            vim.opt_local.tabstop = 2
            vim.opt_local.shiftwidth = 2
            vim.opt_local.expandtab = true
        elseif QuadSpacedTabLanguage( filetype ) then
            vim.opt_local.tabstop = 4
            vim.opt_local.shiftwidth = 4
            vim.opt_local.expandtab = true
        end
    end
})

autocmd( 'LspAttach', {
    group = ThePrimeagenGroup,
    callback = function( e )
        vim.diagnostic.config( { virtual_text = true } )
        vim.diagnostic.show()
        vim.lsp.inlay_hint.enable()
        local opts = { buffer = e.buf }
        vim.keymap.set( "n", "gd", function() vim.lsp.buf.definition() end, opts )
        vim.keymap.set( "n", "K", function() vim.lsp.buf.hover() end, opts )
        vim.keymap.set( "n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts )
        vim.keymap.set( "n", "<leader>vd", function() vim.diagnostic.open_float() end, opts )
        vim.keymap.set( "n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts )
        vim.keymap.set( "n", "<leader>vrr", function() vim.lsp.buf.references() end, opts )
        vim.keymap.set( "n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts )
        vim.keymap.set( "i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts )
        vim.keymap.set( "n", "[d", function() vim.diagnostic.goto_next() end, opts )
        vim.keymap.set( "n", "]d", function() vim.diagnostic.goto_prev() end, opts )
    end
})

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25




