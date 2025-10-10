require( "shenmarukai.set" )
require( "shenmarukai.remap" )
require( "shenmarukai.lazy_init" )

-- DO.not
-- DO NOT INCLUDE THIS

-- If i want to keep doing lsp debugging
-- function restart_htmx_lsp()
--	 require("lsp-debug-tools").restart({ expected = {}, name = "htmx-lsp", cmd = { "htmx-lsp", "--level", "DEBUG" }, root_dir = vim.loop.cwd(), });
-- end

-- DO NOT INCLUDE THIS
-- DO.not

local augroup = vim.api.nvim_create_augroup
local ShenmarukaiGroup = augroup( 'Shenmarukai', {} )

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup( 'HighlightYank', {} )

function R( name )
	require( "plenary.reload" ).reload_module( name )
end

function SmallTabLanguage( filetype )
	if filetype == "html"            or
	   filetype == "css"             or
	   filetype == "javascript"      or
	   filetype == "typescript"      or
	   filetype == "javascriptreact" or
	   filetype == "typescriptreact" or
	   filetype == "json"            or
	   filetype == "xml"             then
		return true
	end
end

function MediumTabLanguage( filetype )
	if filetype == "lua"      or
	   filetype == "python"   or
	   filetype == "c"        or
	   filetype == "c++"      or
	   filetype == "c#"       or
	   filetype == "rust"     or
	   filetype == "markdown" then
		return true
	end
end

function LargeTabLanguage( _filetype )
	return false
end

vim.filetype.add({
	extension = {
		templ = 'templ',
	}
})

autocmd( "VimEnter", {
	callback = function()
		require( "nvim-tree.api" ).tree.open()
		vim.cmd.colorscheme( "catppuccin" )
	end,
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
	group = ShenmarukaiGroup,
	pattern = "*",
	command = [[%s/\s\+$//e]],
})

autocmd( 'LspAttach', {
	group = ShenmarukaiGroup,
	callback = function( e )
		local filetype = vim.bo.filetype
		vim.diagnostic.config( { virtual_text = true } )
		vim.diagnostic.show()
		vim.lsp.inlay_hint.enable()
		if filetype ~= 'NvimTree' then
			vim.opt.list = true
			vim.opt.listchars = {
				tab            = '│ ',
				leadmultispace = '│   ',
				trail          = '·',
				extends        = '»',
				precedes       = '«',
				conceal        = '*',
			}
		else
			vim.opt.list = true
			vim.opt.listchars = {
				tab            = '│ ',
				leadmultispace = '│ ',
				extends        = '»',
				precedes       = '«',
				conceal        = '*',
			}
		end
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

autocmd( 'BufEnter', {
	group = ShenmarukaiGroup,
	callback = function()
		vim.cmd.colorscheme( "catppuccin" )
		-- local filetype = vim.bo.filetype
		vim.opt_local.expandtab = false
		vim.opt_local.tabstop = 4
		vim.opt_local.shiftwidth = 4
	end
})

autocmd( { 'ModeChanged', 'BufEnter' }, {
	group = ShenmarukaiGroup,
	callback = function ()
		local mode = vim.fn.mode( 1 )
		local filetype = vim.bo.filetype
		if filetype ~= 'NvimTree' then
			if mode == 'i'    or
			   mode == 'v'    or
			   mode == 'V'    or
			   mode == '\x16' then
				vim.opt_local.list = true
				vim.opt_local.listchars = {
					tab      = '┼─',
					space    = '·',
					lead     = '·',
					leadmultispace = '│···',
					trail    = '·',
					eol      = '↲',
					nbsp     = '␣',
					extends  = '»',
					precedes = '«',
					conceal  = '*',
				}
			elseif mode == 'n' then
				vim.opt_local.list = true
				vim.opt_local.listchars = {
					tab      = '│ ',
					leadmultispace = '│   ',
					trail    = '·',
					extends  = '»',
					precedes = '«',
					conceal  = '*',
				}
			end
		else
			if mode == 'i'    or
			   mode == 'n'     or
			   mode == 'v'    or
			   mode == 'V'    or
			   mode == '\x16' then
				vim.opt.list = true
				vim.opt.listchars = {
					tab            = '│ ',
					leadmultispace = '│ ',
					extends        = '»',
					precedes       = '«',
					conceal        = '*',
				}
			end
		end
	end
})

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
