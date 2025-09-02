local lazypath = vim.fn.stdpath( "data" ) .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat( lazypath ) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend( lazypath )

require( "lazy" ).setup({
	spec = "shenmarukai.lazy",
	change_detection = { notify = false },
	git = {
		timeout = 600, -- increased from default 120 in order to allow larger build times for plugins like rustowl
	}
})
