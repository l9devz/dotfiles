return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
	},
	config = function()
		-- import lspconfig plugin
		local lspconfig = require("lspconfig")
		local util = require("lspconfig.util")

		-- import cmp-nvim-lsp plugin
		local cmp_nvim_lsp = require("cmp_nvim_lsp")

		local find_root_dir = function(matches)
			return vim.fs.dirname(vim.fs.find(matches, { upward = true })[1])
		end

		local keymap = vim.keymap -- for conciseness

		local opts = { noremap = true, silent = true }
		local on_attach = function(client, bufnr)
			if client.name == "ruff" then
				-- Disable hover in favor of Pyright
				client.server_capabilities.hoverProvider = false
			end

			opts.buffer = bufnr

			-- set keybinds
			opts.desc = "Show LSP references"
			keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

			opts.desc = "Go to declaration"
			keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

			opts.desc = "Show LSP definitions"
			keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

			opts.desc = "Show LSP implementations"
			keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

			opts.desc = "Show LSP type definitions"
			keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

			opts.desc = "See available code actions"
			keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

			opts.desc = "Smart rename"
			keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

			opts.desc = "Show buffer diagnostics"
			keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

			opts.desc = "Show line diagnostics"
			keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

			opts.desc = "Go to previous diagnostic"
			keymap.set("n", "[d", function()
				vim.diagnostic.jump({ count = -1 })
			end, opts) -- jump to previous diagnostic in buffer

			opts.desc = "Go to next diagnostic"
			keymap.set("n", "]d", function()
				vim.diagnostic.jump({ count = 1 })
			end, opts) -- jump to next diagnostic in buffer

			opts.desc = "Show documentation for what is under cursor"
			keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

			opts.desc = "Restart LSP"
			keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
		end

		-- used to enable autocompletion (assign to every lsp server config)
		local capabilities = vim.tbl_deep_extend(
			"force",
			vim.lsp.protocol.make_client_capabilities(),
			cmp_nvim_lsp.default_capabilities()
		)

		-- Change the Diagnostic symbols in the sign column (gutter)
		-- (not in youtube nvim video)
		local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.diagnostic.config({
				signs = {
					text = { [vim.diagnostic.severity[string.upper(type)]] = icon },
					texthl = { [vim.diagnostic.severity[string.upper(type)]] = hl },
				},
			})
		end

		local function organize_imports()
			local params = {
				command = "_typescript.organizeImports",
				arguments = { vim.api.nvim_buf_get_name(0) },
				title = "",
			}
			vim.lsp.buf_request_sync(0, "workspace/executeCommand", params)
		end

		-- configure lua server (with special settings)
		lspconfig["lua_ls"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			settings = { -- custom settings for lua
				Lua = {
					runtime = {
						version = "LuaJIT",
					},
					-- make the language server recognize "vim" global
					diagnostics = {
						globals = { "vim", "require" },
						disable = { "missing-fields" },
					},
					workspace = {
						checkThirdParty = false,
						-- make language server aware of runtime files
						library = {
							[vim.fn.expand("$VIMRUNTIME/lua")] = true,
							[vim.fn.stdpath("config") .. "/lua"] = true,
						},
					},
				},
			},
		})

		lspconfig["dartls"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
		})

		-- configure html server
		lspconfig["html"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
		})

		-- configure typescript server with plugin
		lspconfig["ts_ls"].setup({
			-- init_options = {
			-- 	preferences = {
			-- 		disableSuggestions = true,
			-- 	},
			-- },
			capabilities = capabilities,
			on_attach = on_attach,
			commands = {
				OrganizeImports = {
					organize_imports,
					description = "Organize Imports",
				},
			},
		})

		-- configure css server
		lspconfig["cssls"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			settings = {
				css = {
					lint = {
						unknownAtRules = "ignore",
					},
				},
			},
		})

		-- vim.lsp.config("cssls", {
		-- 	capabilities = capabilities,
		-- 	on_attach = on_attach,
		-- 	cmd = { "vscode-css-language-server", "--stdio" },
		-- 	settings = {
		-- 		css = {
		-- 			lint = {
		-- 				unknownAtRules = "ignore",
		-- 			},
		-- 			validate = true,
		-- 		},
		-- 		less = {
		-- 			validate = true,
		-- 		},
		-- 		scss = {
		-- 			validate = true,
		-- 		},
		-- 	},
		-- })

		-- configure tailwindcss server
		lspconfig["tailwindcss"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
		})

		-- configure svelte server
		lspconfig["svelte"].setup({
			capabilities = capabilities,
			on_attach = function(client, bufnr)
				on_attach(client, bufnr)

				vim.api.nvim_create_autocmd("BufWritePost", {
					pattern = { "*.js", "*.ts" },
					callback = function(ctx)
						if client.name == "svelte" then
							client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.file })
						end
					end,
				})
			end,
		})

		lspconfig["gopls"].setup({
			capabilities = capabilities,
			on_attach = function(client, bufnr)
				on_attach(client, bufnr)
				vim.api.nvim_create_autocmd("BufWritePost", {
					pattern = "*.go",
					callback = function()
						local params = vim.lsp.util.make_range_params(0, "utf-8")
						-- buf_request_sync defaults to a 1000ms timeout. Depending on your
						-- machine and codebase, you may want longer. Add an additional
						-- argument after params if you find that you have to write the file
						-- twice for changes to be saved.
						-- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
						local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
						for cid, res in pairs(result or {}) do
							for _, r in pairs(res.result or {}) do
								if r.edit then
									local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
									vim.lsp.util.apply_workspace_edit(r.edit, enc)
								end
							end
						end
						vim.lsp.buf.format({ async = false })
					end,
				})
			end,
			settings = {
				gopls = {
					analyses = {
						unusedparams = true,
					},
					staticcheck = true,
					gofumpt = true,
				},
			},
		})

		local python_root_files = {
			"requirements.txt",
			"pyproject.toml",
			".ropeproject",
			".git",
		}

		lspconfig["ruff"].setup({
			cmd = { "ruff", "server" },
			capabilities = capabilities,
			on_attach = on_attach,
			filetypes = { "python" },
			root_dir = find_root_dir(python_root_files),
			single_file_support = true,
			init_options = {
				settings = {
					lint = {
						args = {
							"--extend-select=W,COM,ICN",
							"--ignore=COM812,F821,F401",
						},
					},
					format = {
						args = {
							"--line-length=88",
						},
					},
					codeAction = {
						disableRuleComment = {
							enable = false,
						},
						fixViolation = {
							enable = true,
						},
					},
					organizeImports = true,
				},
			},
		})

		-- lspconfig["pyright"].setup({
		-- 	capabilities = capabilities,
		-- 	on_attach = on_attach,
		-- 	settings = {
		-- 		pyright = {
		-- 			disableOrganizeImports = true,
		-- 			disableTaggedHints = true,
		-- 		},
		-- 		python = {
		-- 			analystic = {
		-- 				ignore = { "*" },
		-- 			},
		-- 		},
		-- 	},
		-- })

		-- configure prisma orm server
		lspconfig["prismals"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
		})

		-- configure graphql language server
		lspconfig["graphql"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
		})

		-- configure emmet language server
		lspconfig["emmet_ls"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
		})
	end,
}
