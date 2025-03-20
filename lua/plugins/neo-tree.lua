return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	config = function()
		require("neo-tree").setup({
			window = {
				position = "left", -- set default position to right
			},
		}) -- Keymap for closing NeoTree explicitly

		vim.keymap.set("n", "<leader>ft", ":Neotree show<CR>", { silent = true })

		vim.keymap.set("n", "<leader>fT", ":Neotree close<CR>", { silent = true })
	end,
}
