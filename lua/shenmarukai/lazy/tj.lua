-- TJ

-- ./lua/shenmarukai/lazy/tj.lua

return {
	"tjdevries/php.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter"
	},
	config = function()
		require( "php" ).setup( {} )
	end
}
