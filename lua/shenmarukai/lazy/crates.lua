-- Crates

-- ./lua/shenmarukai/lazy/crates.lua

return {
	'saecki/crates.nvim',
	tag = 'stable',
	config = function()
		require( 'crates' ).setup()
	end,
}
