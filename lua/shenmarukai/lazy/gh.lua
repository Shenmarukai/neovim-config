-- GitHub CLI

-- ./lua/shenmarukai/lazy/gh.lua

return {
	"ldelossa/gh.nvim",
	dependencies = {
		{
		"ldelossa/litee.nvim",
		config = function()
			require("litee.lib").setup()
		end,
		},
	},
	config = function()
		require("litee.gh").setup()
	end,
}
