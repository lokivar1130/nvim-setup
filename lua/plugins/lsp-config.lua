return {
    {
    "williamboman/mason.nvim",
    config = function()
        require("mason").setup()

    end
    },
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
                "gopls",
                "pylsp",
                "solidity_ls_nomicfoundation",
                "rust_analyzer"
                }
            })
        end

    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            local lspconfig = require("lspconfig")
            lspconfig.lua_ls.setup({})
            lspconfig.gopls.setup({})
            lspconfig.rust_analyzer.setup({})
            lspconfig.solidity_ls_nomicfoundation.setup({})
            lspconfig.pylsp.setup({
                 settings = {
                    pylsp = {
                      plugins = {
                        pycodestyle = {
                          ignore = {'W391'},
                          maxLineLength = 100
                        }
                      }
                    }
                  }
                })
            vim.keymap.set('n','<leader>sd',vim.lsp.buf.hover,{})
            vim.keymap.set('n','<leader>gd',vim.lsp.buf.definition,{})
            vim.keymap.set('n','<leader>ca',vim.lsp.buf.code_action,{})

        end
    }
}
