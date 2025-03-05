return {
	{
		"lervag/vimtex",
		lazy = false,
		init = function()
			-- VimTeX configuration goes here, e.g.
			vim.g.vimtex_view_method = "skim"
			vim.g.vimtex_compiler_method = "latexmk"
			vim.g.vimtex_compiler_latexmk = {
				options = {
					"-shell-escape",
					"-verbose",
					"-file-line-error",
					"-interaction=nonstopmode",
					"-synctex=1",
					"-pdf",
				},
			}
		end,
	},
}
