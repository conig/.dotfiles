return {
  {
	"nvim-treesitter/playground",
	lazy = true,
  event = {"BufReadPost", "BufNewFile"},
},
	{
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"markdown",
					"html",
					"latex",
					"lua",
					"markdown",
					"markdown_inline",
					"yaml",
					"r",
					"regex",
					"yaml",
					"bash",
					"python",
					"julia",
          "vim",
          "regex",
          "bash",
				},
				highlight = { enable = true },
			})
		end,
	},
}
