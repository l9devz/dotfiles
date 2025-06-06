local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
vim.diagnostic.config({
	virtual_text = {
		severity = {
			vim.diagnostic.severity.E,
			vim.diagnostic.severity.W,
		},
	},
	update_in_insert = true,
})

local ns = vim.api.nvim_create_namespace("l9")
local orig_signs_handler = vim.diagnostic.handlers.signs
vim.diagnostic.handlers.signs = {
	show = function(_, bufnr, _, opts)
		-- Get all diagnostics from the whole buffer rather than just the
		-- diagnostics passed to the handler
		local diagnostics = vim.diagnostic.get(bufnr)
		-- Find the "worst" diagnostic per line
		local max_severity_per_line = {}
		for _, d in pairs(diagnostics) do
			local m = max_severity_per_line[d.lnum]
			if not m or d.severity < m.severity then
				max_severity_per_line[d.lnum] = d
			end
		end
		-- Pass the filtered diagnostics (with our custom namespace) to
		-- the original handler
		local filtered_diagnostics = vim.tbl_values(max_severity_per_line)
		orig_signs_handler.show(ns, bufnr, filtered_diagnostics, opts)
	end,
	hide = function(_, bufnr)
		orig_signs_handler.hide(ns, bufnr)
	end,
}
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({ { import = "l9.plugins" }, { import = "l9.plugins.lsp" } }, {
	install = {
		colorscheme = { "vscode" },
	},
	checker = {
		enabled = true,
		notify = false,
	},
	change_detection = {
		notify = false,
	},
})
