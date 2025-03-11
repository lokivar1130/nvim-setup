return {
	"vhyrro/luarocks.nvim",
	config = function()
		local luarocks = require("luarocks-nvim")
		luarocks.setup({
			priority = 1000,
			config = true,
		})
	end,
}
