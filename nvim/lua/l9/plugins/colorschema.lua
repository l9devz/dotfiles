return {
	"catppuccin/nvim",

	priority = 1000, -- make sure to load this before all the other start plugins
	opts = {
		transparent = true,
		styles = {
			sidebars = "transparent",
			floats = "transparent",
		},
	},
	config = function()
		require("catppuccin").setup({
			transparent = true,
			styles = {
				sidebars = "transparent",
				floats = "transparent",
			},
		})
		-- load the colorscheme here
		vim.cmd([[colorscheme catppuccin-mocha]])
	end,
}
