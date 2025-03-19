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
			ensure_installed = { "pyright", "ruff", "solidity_ls_nomicfoundation", "jsonls", "gopls" },
		},
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local lspconfig = require("lspconfig")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local utils = require("utils.solidity")
			capabilities.textDocument.completion.completionItem.snippetSupport = true

			local on_attach = require("cmp_nvim_lsp").on_attach
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
			})
			lspconfig.gopls.setup({
				capabilities = capabilities,
				cmd = { "gopls" },
				filetypes = { "go", "gomod", "gowork", "gotmpl" },
				root_dir = require("lspconfig.util").root_pattern("go.work", "go.mod", ".git"),
				settings = {
					gopls = {
						analyses = {
							unusedparams = true, -- Warns about unused parameters
							nilness = true, -- Detects nil issues
							shadow = true, -- Detects shadowed variables
							unusedwrite = true, -- Warns about unused writes
						},
						staticcheck = true, -- Enables Staticcheck (extra linting)
						gofumpt = true, -- Uses gofumpt for better formatting
						completeUnimported = true, -- Autocomplete unimported packages
						usePlaceholders = true, -- Adds placeholders in function signatures
					},
				},
			})
			lspconfig.rust_analyzer.setup({

				capabilities = capabilities,
			})
			lspconfig.jsonls.setup({
				capabilities = capabilities,
			})
			lspconfig.solidity_ls_nomicfoundation.setup({
				cmd = { "nomicfoundation-solidity-language-server", "--stdio" },
				filetypes = { "solidity" },
				root_dir = function(fname)
					return require("lspconfig.util").root_pattern("foundry.toml", ".git")(fname)
				end,
				single_file_support = true,
				settings = {
					solidity = {
						includePath = "lib",
						remappings = utils.get_foundry_remappings(),
						compiler = {
							executable = "solc",
							version = "latest",
							settings = {
								optimizer = { enabled = true, runs = 200 },
								outputSelection = {
									["*"] = { ["*"] = { "abi", "evm.bytecode", "evm.deployedBytecode" } },
								},
							},
						},
					},
				},
			})
			lspconfig.pyright.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				filetypes = { "python" }, -- ✅ Fixed: Changed `filetype` to `filetypes`
				settings = { -- ✅ Corrected way to disable Organize Imports
					pyright = {
						disableLanguageServices = false,
					},
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
			vim.keymap.set("n", "<leader>fr", vim.lsp.buf.references, {}) -- Find references
			vim.keymap.set("n", "<leader>fh", vim.lsp.buf.signature_help, {})
			vim.keymap.set("n", "<leader>gd", vim.lsp.buf.declaration, {})
			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
			vim.keymap.set("n", "<leader>gb", "<C-o>", { desc = "Go back to previous location" })
			vim.keymap.set("n", "<leader>gf", "<C-I>", { desc = "Go back to next location" })
		end,
	},
}
