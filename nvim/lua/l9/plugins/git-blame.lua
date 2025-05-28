return {
	"f-person/git-blame.nvim",
	config = function()
		local gitblame = require("gitblame")
		gitblame.setup({
			enabled = true,
			date_format = "%r",
			gitblame_delay = 1000,
		})
	end,
}
