-- Rust Owl

-- ./lua/shenmarukai/lazy/rustowl.lua

return {
	--[[ 'cordx56/rustowl',
	version = '*', -- Latest stable version
	build = 'cargo binstall rustowl',
	lazy = false, -- This plugin is already lazy
	opts = {
		client = {
			on_attach = function( _, buffer )
				vim.keymap.set( 'n', '<leader>ro', function()
					require( 'rustowl' ).toggle( buffer )
				end, { buffer = buffer, desc = 'Toggle RustOwl' })

				vim.keymap.set( 'n', '<leader>re', function()
					require( 'rustowl' ).enable( buffer )
				end, { buffer = buffer, desc = 'Enable RustOwl' })

				vim.keymap.set( 'n', '<leader>rd', function()
					require( 'rustowl' ).disable( buffer )
				end, { buffer = buffer, desc = 'Disable RustOwl' })
      		end
		},
	}, ]]
}
