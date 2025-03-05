return {
	{
		"rebelot/kanagawa.nvim",
		opts = {
			commentStyle = { italic = false },
			keywordStyle = { italic = false },
			terminalColor = false,
		},
	},
	{
		"shaunsingh/nord.nvim",
		as = "custom",
		config = function(_, _)
			vim.g.nord_contrast = true
			vim.g.nord_borders = true
			vim.g.nord_italic = false
			vim.g.nord_uniform_diff_background = true
			vim.g.nord_bold = false
		end,
	},
	{ "folke/tokyonight.nvim" },

	{ "catppuccin/nvim", name = "catppuccin" },
	{ "ellisonleao/gruvbox.nvim" },
	{ "nyoom-engineering/oxocarbon.nvim" },
	{ "EdenEast/nightfox.nvim" },

	{ "rose-pine/neovim", name = "rose-pine" },
	{ "decaycs/decay.nvim", name = "decay" },
}
