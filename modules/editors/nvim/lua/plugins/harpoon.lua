return {
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		keys = function(_, _)
			local harpoon = require("harpoon")
			local keymaps = {
				{
					"<leader>ha",
					function()
						harpoon:list():append()
					end,
					desc = "Append to harpoon list",
				},
				{
					"<leader>hn",
					function()
						harpoon:list():next()
					end,
					desc = "Next in harpoon list",
				},
				{
					"<leader>hp",
					function()
						harpoon:list():prev()
					end,
					desc = "Prev in harpoon list",
				},
				{
					"<leader>he",
					function()
						harpoon.ui:toggle_quick_menu(harpoon:list())
					end,
					desc = "Show current list",
				},
			}
			for i = 1, 9 do
				keymaps[i + 4] = {
					"<leader>h" .. i,
					function()
						harpoon:list():select(i)
					end,
					desc = "Jump to element " .. i .. " in harpoon list",
				}
			end
			return keymaps
		end,
	},

	{
		"folke/which-key.nvim",
		opts = {
			spec = {
				{ "<leader>h", group = "harpoon" },
			},
		},
	},
}
