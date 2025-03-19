return {
    {
        "nvimtools/none-ls.nvim",
        dependencies = {
            "nvimtools/none-ls-extras.nvim",
            "jayp0521/mason-null-ls.nvim", -- Keep this as a dependency, NOT a separate plugin
        },
        config = function()
            local null_ls = require("null-ls")
            local mason_null_ls = require("mason-null-ls")

            -- 🔹 Ensure Mason installs the required formatters & linters
            mason_null_ls.setup({
                ensure_installed = {
                    "stylua",
                    "prettier",
                    "shfmt",
                    "solhint",
                    "goimports", -- ✅ Added this to match the null_ls source
                },
            })

            -- 🔹 Autoformatting on save
            local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

            null_ls.setup({
                sources = {
                    null_ls.builtins.formatting.stylua,
                    null_ls.builtins.formatting.prettier.with({
                        filetypes = { -- Define which filetypes Prettier should format
                            "javascript",
                            "javascriptreact",
                            "typescript",
                            "typescriptreact",
                            "vue",
                            "css",
                            "scss",
                            "less",
                            "html",
                            "json",
                            "jsonc",
                            "yaml",
                            "markdown",
                            "graphql",
                            "handlebars",
                        },
                        extra_args = { "--print-width", "100", "--tab-width", "4" }, -- Optional: Customize Prettier settings
                    }),
                    null_ls.builtins.formatting.goimports,
                },
                on_attach = function(client, bufnr)
                    if client.supports_method("textDocument/formatting") then
                        vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
                        vim.api.nvim_create_autocmd("BufWritePre", {
                            group = augroup,
                            buffer = bufnr,
                            callback = function()
                                vim.lsp.buf.format({ timeout_ms = 2000 }) -- ✅ Updated for Neovim 0.10+
                            end,
                        })
                    end
                end,
            })

            -- 🔹 Manual formatting keymap
            vim.keymap.set("n", "<leader>fmt", function()
                vim.lsp.buf.format({ timeout_ms = 2000 }) -- ✅ Updated function
            end, {})
        end,
    },
}
