vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")
vim.g.mapleader = " "

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Open a window to the left (vertical split and move cursor to new split)
map("n", "<leader>wl", function()
	vim.cmd("vsplit")
	vim.cmd("wincmd H") -- Move split to the left
end, opts)

-- Open a window to the right (vertical split stays on the right)
map("n", "<leader>wr", ":vsplit<CR>", opts)

-- Close the current window
map("n", "<leader>dw", ":close<CR>", opts)

local ui = require("utils.ui")

map("n", "<leader>db", ui.bufremove, { desc = "Delete buffer" })
