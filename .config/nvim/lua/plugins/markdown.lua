return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		ft = { "Avante", "rmd", "qmd", "md", "markdown" },
		enabled = true,
		opts = {
			file_types = { "Avante", "rmd", "md", "qmd", "markdown" },
		},
		config = function()
			require("render-markdown").setup({
				heading = {
					enabled = true,
					icons = { "# ", "## ", "### ", "#### ", "##### ", "###### " }, -- Standard markdown headings
					above = "",
					below = "󰼮",
				},
				code = {style = "normal", border = "thick"},
				win_options = {
					conceallevel = {
						default = vim.o.conceallevel,
						rendered = 0,
					},
				},
				bullet = {
					enabled = true,
					icons = { "●", "○", "◆", "◇" },
					ordered_icons = {},
					left_pad = 0,
					right_pad = 1,
					highlight = "RenderMarkdownBullet",
				},
			})
		end,
	},
}
