return {
	"kevinhwang91/nvim-ufo",
	dependencies = { "kevinhwang91/promise-async" },
	opts = {
		filetype_exclude = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy", "mason" },
		provider_selector = function()
			return { "treesitter", "indent" }
		end,
	},
	config = function(_, opts)
		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("local_detach_ufo", { clear = true }),
			pattern = opts.filetype_exclude,
			callback = function()
				require("ufo").detach()
			end,
		})

		require("ufo").setup(opts)
	end,

	init = function()
		vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
		vim.o.foldcolumn = "1" -- '0' is not bad
		vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
		vim.o.foldlevelstart = 99
		vim.o.foldenable = true
		vim.keymap.set("n", "zP", function()
			local winid = require("ufo").peekFoldedLinesUnderCursor()
			if not winid then
				vim.lsp.buf.hover()
			end
		end)
	end,
}
