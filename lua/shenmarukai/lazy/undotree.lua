-- Undo Tree

-- ./lua/shenmarukai/lazy/undotree.lua

return {
	"mbbill/undotree",

	config = function()
		vim.keymap.set( "n", "<leader>u", vim.cmd.UndotreeToggle )
	end
}
