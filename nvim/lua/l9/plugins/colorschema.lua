return {
	"folke/tokyonight.nvim",

	priority = 1000, -- make sure to load this before all the other start plugins
	config = function()
		require("tokyonight").setup({
			transparent_background = false,
			integrations = {
				nvimtree = true,
				treesitter = true,
				-- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
			},
		})
		-- load the colorscheme here
		vim.cmd([[colorscheme tokyonight-storm]])
	end,
}
