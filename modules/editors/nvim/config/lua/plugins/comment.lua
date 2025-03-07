return {
	{
		"numToStr/Comment.nvim",
		opts = {
			ignore = "^$",
			-- pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
		},
	},
	{ "mini.comment", enabled = false },
}
