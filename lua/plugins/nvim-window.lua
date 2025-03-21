return {

	"yorickpeterse/nvim-window",
	config = function()
		local nvim_window = require("nvim-window")
		nvim_window.setup({
			keys = {
				{ "<leader>wj", "<cmd>lua require('nvim-window').pick()<cr>", desc = "nvim-window: Jump to window" },
			},

			chars = {
				"1",
				"2",
				"3",
				"4",
				"5",
				"6",
				"7",
				"8",
				"9",
			},
			config = true,
		})
		vim.keymap.set("n", "<leader>wj", function()
			require("nvim-window").pick()
		end, { desc = "nvim-window: Jump to window", noremap = true, silent = true })
	end,
}
