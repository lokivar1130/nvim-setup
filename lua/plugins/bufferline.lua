return {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        require("bufferline").setup({
            options = {
                numbers = "ordinal", -- Show buffer numbers
                diagnostics = "nvim_lsp", -- Optional: show LSP diagnostics in bufferline
                offsets = {
                    { filetype = "NvimTree", text = "File Explorer", highlight = "Directory", separator = true },
                },
                show_buffer_close_icons = false,
                show_close_icon = false,
                separator_style = "thin",
            },
        })

        -- Keybindings to jump to buffers 1-9
        for i = 1, 9 do
            vim.keymap.set("n", "<leader>" .. i, function()
                vim.cmd("BufferLineGoToBuffer " .. i)
            end, { noremap = true, silent = true, desc = "Go to buffer " .. i })
        end
    end,
}

