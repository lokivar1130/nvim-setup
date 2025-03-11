return {
	{
		"williamboman/mason.nvim",
		lazy = false,
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = false,
		opts = {
			ensure_installed = { "pyright", "ruff", "solidity_ls", "jsonls" },

			autoinstall = true,
		},
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local lspconfig = require("lspconfig")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local on_attach = require("cmp_nvim_lsp").on_attach
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
			})
			lspconfig.gopls.setup({
				capabilities = capabilities,
			})
			lspconfig.rust_analyzer.setup({

				capabilities = capabilities,
			})
			lspconfig.jsonls.setup({
				capabilities = capabilities,
			})
			lspconfig.solidity_ls.setup({

				capabilities = capabilities,
				on_attach = on_attach,
				filetype = { "solidity" },
				root_dir = lspconfig.util.root_pattern(".git", "foundry.toml"),
			})
			lspconfig.pyright.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				filetypes = { "python" }, -- ✅ Fixed: Changed `filetype` to `filetypes`
				settings = { -- ✅ Corrected way to disable Organize Imports
					python = {
						analysis = {
							autoImportCompletions = true,
							typeCheckingMode = "basic",
							diagnosticMode = "workspace",
							useLibraryCodeForTypes = true,
							disableOrganizeImports = true, -- ✅ Corrected placement
						},
					},
				},
			})

			lspconfig.ruff.setup({
				init_options = {
					settings = {
						logLevel = "info",
					},
					configuration = {
						lint = {
							unfixable = { "F401" },
							["extend-select"] = { "TID251" },
							["flake8-tidy-imports"] = {
								["banned-api"] = {
									["typing.TypedDict"] = {
										msg = "Use `typing_extensions.TypedDict` instead",
									},
								},
							},
						},
						format = {
							["quote-style"] = "single",
						},
					},
				},
			})
			vim.keymap.set("n", "<leader>sh", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "<leader>gD", vim.lsp.buf.definition, {})
			vim.keymap.set("n", "<leader>sr", vim.lsp.buf.references, {}) -- Find references
			vim.keymap.set("n", "<leader>sh", vim.lsp.buf.signature_help, {})
			vim.keymap.set("n", "<leader>gd", vim.lsp.buf.declaration, {})
			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
			vim.keymap.set("n", "<leader>gb", "<C-o>", { desc = "Go back to previous location" })
			vim.keymap.set("n", "<leader>gf", "<C-I>", { desc = "Go back to next location" })
		end,
	},
}
