return {
	"krivahtoo/silicon.nvim",
	build = "./install.sh",
	cmd = "Silicon",
	config = function()
		require("silicon").setup({
			theme = "Dracula",
			background = "#97D8FD",
			font = "CaskaydiaMono Nerd Font=34",
			pad_horiz = 50,
			pad_vert = 85,
			to_clipboard = true,
			language = function()
				return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()), ":e")
			end,
		})
	end,
}
